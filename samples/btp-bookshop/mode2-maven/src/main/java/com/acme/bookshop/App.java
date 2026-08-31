package com.acme.bookshop;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * 模式二 · Maven 工程（archetype 骨架 + exec 插件）
 * JDBC 连接 HANA Cloud 的 BOOKSHOP 库，联表读取 Books 打印。
 *
 * 运行前：把下面 HOST / PASSWORD 换成你实例的记录（B3 章）。
 */
public class App {

    // TODO: 换成你 HANA Cloud 实例的 SQL End Point 主机（B3 章「Copy SQL End Point」）
    static final String HOST = "xxxx.hana.trial-us10.hanacloud.ondemand.com";
    static final String URL =
        "jdbc:sap://" + HOST + ":443?encrypt=true&validateCertificate=true";
    static final String USER = "DBADMIN";
    static final String PASSWORD = "你的数据库口令";   // TODO: 替换为 DBADMIN 口令

    static final String COUNT_SQL = "SELECT COUNT(*) AS CNT FROM BOOKSHOP.BOOKS";

    static final String SQL =
        "SELECT b.ID, b.TITLE, a.NAME AS AUTHOR, g.NAME AS GENRE, " +
        "       b.STOCK, b.PRICE, b.CURRENCY " +
        "  FROM BOOKSHOP.BOOKS b " +
        "  JOIN BOOKSHOP.AUTHORS a ON a.ID = b.AUTHOR_ID " +
        "  JOIN BOOKSHOP.GENRES  g ON g.ID = b.GENRE_ID " +
        " ORDER BY b.ID";

    public static void main(String[] args) throws Exception {
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD)) {
            int total;
            try (PreparedStatement ps = conn.prepareStatement(COUNT_SQL);
                 ResultSet rs = ps.executeQuery()) {
                rs.next();
                total = rs.getInt("CNT");
            }
            System.out.println("共读取 " + total + " 本书（BOOKSHOP.BOOKS）");
            System.out.printf("%-2s  %-22s  %-18s  %-16s  %4s  %8s  %s%n",
                    "ID", "TITLE", "AUTHOR", "GENRE", "STOCK", "PRICE", "CURR");
            try (PreparedStatement ps = conn.prepareStatement(SQL);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    System.out.printf("%-2d  %-22s  %-18s  %-16s  %4d  %8.2f  %s%n",
                            rs.getInt("ID"), rs.getString("TITLE"), rs.getString("AUTHOR"),
                            rs.getString("GENRE"), rs.getInt("STOCK"),
                            rs.getDouble("PRICE"), rs.getString("CURRENCY"));
                }
            }
        }
    }
}
