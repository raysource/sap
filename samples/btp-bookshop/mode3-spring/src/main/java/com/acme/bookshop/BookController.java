package com.acme.bookshop;

import java.util.List;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * GET /api/books → 用 JdbcTemplate 读 HANA Cloud 的 BOOKSHOP.BOOKS，
 * 联表取出作者名 / 分类名，返回 JSON 数组（10 个对象）。
 */
@RestController
public class BookController {

    private final JdbcTemplate jdbc;

    public BookController(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    @GetMapping("/api/books")
    public List<Book> books() {
        String sql =
            "SELECT b.ID, b.TITLE, a.NAME AS AUTHOR, g.NAME AS GENRE, " +
            "       b.STOCK, b.PRICE, b.CURRENCY " +
            "  FROM BOOKSHOP.BOOKS b " +
            "  JOIN BOOKSHOP.AUTHORS a ON a.ID = b.AUTHOR_ID " +
            "  JOIN BOOKSHOP.GENRES  g ON g.ID = b.GENRE_ID " +
            " ORDER BY b.ID";
        return jdbc.query(sql, (rs, rowNum) -> new Book(
                rs.getInt("ID"), rs.getString("TITLE"), rs.getString("AUTHOR"),
                rs.getString("GENRE"), rs.getInt("STOCK"),
                rs.getDouble("PRICE"), rs.getString("CURRENCY")));
    }
}
