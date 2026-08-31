package com.acme.bookshop;

/**
 * 图书 DTO：对应 BOOKSHOP.BOOKS 联表查询结果，直接序列化为 JSON
 * （Spring Boot 对 record 自动做 JSON 序列化，无需 getter）
 */
public record Book(
        int id,
        String title,
        String author,
        String genre,
        int stock,
        double price,
        String currency) {
}
