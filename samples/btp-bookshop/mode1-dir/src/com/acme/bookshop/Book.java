package com.acme.bookshop;

/**
 * 一本书的简单 DTO：字段对应 BOOKSHOP.BOOKS 联表查询结果
 * （ID、TITLE、作者名、分类名、STOCK、PRICE、CURRENCY）
 */
public class Book {
    public int id;
    public String title;
    public String author;
    public String genre;
    public int stock;
    public double price;
    public String currency;

    public Book(int id, String title, String author, String genre,
                int stock, double price, String currency) {
        this.id = id;
        this.title = title;
        this.author = author;
        this.genre = genre;
        this.stock = stock;
        this.price = price;
        this.currency = currency;
    }

    /** 一行格式化输出（对齐示例输出） */
    public String line() {
        return String.format("%-2d  %-22s  %-18s  %-16s  %4d  %8.2f  %s",
                id, title, author, genre, stock, price, currency);
    }

    /** 表头 */
    public static String header() {
        return String.format("%-2s  %-22s  %-18s  %-16s  %4s  %8s  %s",
                "ID", "TITLE", "AUTHOR", "GENRE", "STOCK", "PRICE", "CURR");
    }
}
