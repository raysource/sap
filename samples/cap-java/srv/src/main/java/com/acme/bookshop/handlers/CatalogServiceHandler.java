// srv/src/main/java/com/acme/bookshop/handlers/CatalogServiceHandler.java
// 与《CAP for Java》手顺3（J5.4）一致：整条 Java 路线唯一手写的业务代码。
// 依赖 cds init --java 脚手架；Books.java / CatalogService_.java 由 cds-maven-plugin 编译期生成。
package com.acme.bookshop.handlers;

import java.util.List;
import org.springframework.stereotype.Component;

import com.sap.capire.bookshop.Books;
import com.sap.capire.bookshop.CatalogService_;

import com.sap.cds.services.cds.CdsBeforeCreateContext;
import com.sap.cds.services.cds.CdsOnEventContext;
import com.sap.cds.services.cds.CdsService;
import com.sap.cds.services.handler.EventHandler;
import com.sap.cds.services.handler.annotations.After;
import com.sap.cds.services.handler.annotations.Before;
import com.sap.cds.services.handler.annotations.On;
import com.sap.cds.services.handler.annotations.ServiceName;
import com.sap.cds.ql.CqnSelect;
import com.sap.cds.ql.Select;
import com.sap.cds.ql.Update;
import com.sap.cds.services.ErrorStatuses;
import com.sap.cds.services.ServiceException;
import com.sap.cds.services.persistence.PersistenceService;

import io.vertx.core.json.JsonObject;

@Component
@ServiceName(CatalogService_.CDS_NAME)
public class CatalogServiceHandler implements EventHandler {

    private final PersistenceService db;

    public CatalogServiceHandler(PersistenceService db) {   // Spring 注入
        this.db = db;
    }

    @After(event = CdsService.EVENT_READ)
    public void markBestseller(List<Books> books) {
        books.forEach(b -> {
            if (b.getStock() != null && b.getStock() > 100) {
                b.setTitle(b.getTitle() + "（畅销）");
            }
        });
    }

    // @Before：写操作之前做参数校验（负库存新书 → 400，不会被写入）
    @Before(event = CdsService.EVENT_CREATE)
    public void validateNewBook(CdsBeforeCreateContext context) {
        JsonObject data = context.getData();
        Integer stock = data.getInteger("stock");
        if (stock != null && stock < 0) {
            throw new ServiceException(ErrorStatuses.BAD_REQUEST,
                "stock must not be negative, got: " + stock);
        }
    }

    @On(event = CatalogService_.EVENT_SUBMIT_ORDER)
    public void submitOrder(CdsOnEventContext context) {
        JsonObject data = context.getData();
        int bookId   = data.getInt("book");
        int quantity = data.getInt("quantity");

        CqnSelect sel = Select.from(Books.class).where(b -> b.ID().eq(bookId));
        Books book = db.run(sel).single(Books.class);

        if (book == null) {
            throw new ServiceException(ErrorStatuses.NOT_FOUND, "Book #" + bookId + " not found");
        }
        if (quantity > book.getStock()) {
            throw new ServiceException(ErrorStatuses.BAD_REQUEST,
                quantity + " exceeds stock for book #" + bookId);
        }
        db.run(Update.entity(Books.class)
            .data(Books.STOCK, book.getStock() - quantity)
            .where(b -> b.ID().eq(bookId)));
    }
}
