# 模式一 · 目录式构建（纯 javac / java）

不依赖任何构建工具，直接把两个 `.java` 编译后运行。目录结构：

```
bookshop-dir/
├── lib/
│   └── ngdbc.jar            # SAP HANA JDBC 驱动（见 lib/README.txt）
├── src/com/acme/bookshop/
│   ├── Book.java            # 书的 DTO（一行格式化输出）
│   └── BookshopApp.java     # 入口：JDBC 读 BOOKSHOP 库打印
└── out/                     # 编译输出（javac 生成）
```

## 步骤

1. 把本目录 `src/` 拷到工作目录（如 `bookshop-dir/`）。
2. 按 `lib/README.txt` 下载 ngdbc.jar 放到 `lib/`。
3. 编辑 `BookshopApp.java`：把 `HOST`、`PASSWORD` 换成 B3 章记录的值。
4. 编译（`-encoding UTF-8` 保证中文注释/输出不乱码）：

```bash
javac -encoding UTF-8 -cp lib/ngdbc.jar -d out \
  src/com/acme/bookshop/Book.java \
  src/com/acme/bookshop/BookshopApp.java
```

5. 运行（Linux / macOS 的 classpath 分隔符是 `:`）：

```bash
java -cp "out:lib/ngdbc.jar" com.acme.bookshop.BookshopApp
```

期望输出：

```
共读取 10 本书（BOOKSHOP.BOOKS）
ID  TITLE                   AUTHOR             GENRE             STOCK    PRICE  CURR
1   Wuthering Heights       Emily Brontë       Fiction             12     11.11  EUR
...
10  Norwegian Wood          Haruki Murakami    Romance            150     35.50  EUR
```

## 对应章节

B6（`cap/btp/step4-dir.html`）。连接信息占位符说明见总 README。
