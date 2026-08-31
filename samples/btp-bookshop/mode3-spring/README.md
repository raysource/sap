# 模式三 · Spring Boot

用 start.spring.io 生成工程（依赖 web + jdbc），加 ngdbc 驱动后
读取 HANA Cloud 的 BOOKSHOP 库，提供 `GET /api/books`。

## 步骤

1. 生成工程（B8 手顺，`curl` 或浏览器打开 start.spring.io 选 web + jdbc + Java 17）：

```bash
curl -G https://start.spring.io/starter.zip \
  -d dependencies=web,jdbc -d type=maven-project \
  -d language=java -d javaVersion=17 \
  -d groupId=com.acme -d artifactId=bookshop-spring \
  -o bookshop-spring.zip
unzip bookshop-spring.zip
cd bookshop-spring
```

2. 用本目录文件覆盖 / 放入：
   - `Application.java` → `src/main/java/com/acme/bookshop/Application.java`
   - `Book.java`、`BookController.java` → 同目录
   - `application.properties` → `src/main/resources/application.properties`
   - `pom.xml` 加 ngdbc 依赖（`参考 pom.xml` 的依赖块；Spring Boot 版本以
     start.spring.io 生成为准，无需改动）

3. 编辑 `application.properties`：把 URL 的主机、`password` 换成 B3 章记录的值。

4. 运行：

```bash
mvn spring-boot:run
```

看到 `Started Application` 后，另开终端测试：

```bash
curl http://localhost:8080/api/books
```

期望返回含 10 个对象的 JSON 数组，每个对象形如：

```json
{"id":1,"title":"Wuthering Heights","author":"Emily Brontë","genre":"Fiction","stock":12,"price":11.11,"currency":"EUR"}
```

## 对应章节

B8（`cap/btp/step6-spring.html`）。
