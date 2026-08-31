package com.acme.bookshop;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * 模式一 · 目录式构建（纯 javac / java）
 * 直接 JDBC 连接 HANA Cloud 的 BOOKSHOP 库，联表读取 Books 打印。
 *
 * 运行前：按 lib/README.txt 下载 ngdbc.jar 放到 lib/ 目录；
 *         把下面 HOST / PASSWORD 换成你实例的记录（B3 章）。
 */
public class BookshopApp {

    // TODO: 换成你 HANA Cloud 实例的 SQL End Point 主机（B3 章「Copy SQL End Point」）
    static final String HOST = "xxxx.hana.trial-us10.hanacloud.ondemand.com";
    static final String URL =
        "jdbc:sap://" + HOST + ":443?encrypt=true&validateCertificate=true";
    static final String USER = "DBADMIN";
    static final String PASSWORD = "你的数据库口令";   // TODO: 替换为 DBADMIN 口令

    static final String SQL =
        "SELECT b.ID, b.TITLE, a.NAME AS AUTHOR, g.NAME AS GENRE, " +
        "       b.STOCK, b.PRICE, b.CURRENCY " +
        "  FROM BOOKSHOP.BOOKS b " +
        "  JOIN BOOKSHOP.AUTHORS a ON a.ID = b.AUTHOR_ID " +
        "  JOIN BOOKSHOP.GENRES  g ON g.ID = b.GENRE_ID " +
        " ORDER BY b.ID";

    public static void main(String[] args) throws Exception {
        Class.forName("com.sap.db.jdbc.Driver");
        List<Book> books = new ArrayList<>();
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement ps = conn.prepareStatement(SQL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                books.add(new Book(
                    rs.getInt("ID"),
                    rs.getString("TITLE"),
                    rs.getString("AUTHOR"),
                    rs.getString("GENRE"),
                    rs.getInt("STOCK"),
                    rs.getDouble("PRICE"),
                    rs.getString("CURRENCY")));
            }
        }
        System.out.println("共读取 " + books.size() + " 本书（BOOKSHOP.BOOKS）");
        System.out.println(Book.header());
        for (Book b : books) System.out.println(b.line());
    }
}
