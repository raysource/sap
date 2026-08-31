# CAP Java 素材（配合 `cds init --java` 脚手架）

与《CAP for Java》手顺1–4（J3–J6）配套的**关键源码**。Maven 多模块工程结构本身由 `cds init --java` 生成（见手顺1），本目录提供业务所需的全部业务文件。

## 使用步骤

```bash
cds init bookshop --java      # 生成 Maven 多模块脚手架（手顺1）
cd bookshop
# 用本目录文件覆盖/放入：
#   db/schema.cds                        →  db/schema.cds
#   srv/cat-service.cds                  →  srv/cat-service.cds
#   db/data/*.csv                        →  db/data/            （自动建表 + 导数据）
#   srv/src/main/resources/application.yaml → srv/src/main/resources/application.yaml
#   srv/src/main/java/com/acme/bookshop/handlers/CatalogServiceHandler.java
#     → srv/src/main/java/com/acme/bookshop/handlers/CatalogServiceHandler.java

mvn clean install             # 编译模型 → 生成 Books.java / CatalogService_.java 等（手顺1）
cd srv
mvn spring-boot:run           # 启动（端口 8080，自动建表 + 导入 CSV，见手顺2）
```

## 依赖

`cds init --java` 的 `srv/pom.xml` 已带 `cds-starter-spring-boot-starter` 与 `cds-maven-plugin`；
本地 SQLite 需确认含 `org.xerial:sqlite-jdbc`（若脚手架没带，手动加上，见手顺1 J3.5）。

## 测试（端口 8080）

```bash
curl http://localhost:8080/odata/v4/catalog/Books                    # 读，库存>100 的书带「（畅销）」
curl "http://localhost:8080/odata/v4/catalog/Books?$top=3"
curl -X POST http://localhost:8080/odata/v4/catalog/Books \
  -H "Content-Type: application/json" \
  -d '{"ID":101,"title":"Test","author_ID":101,"genre_ID":201,"stock":5,"price":9.99,"currency":"EUR"}'
curl -i -X DELETE http://localhost:8080/odata/v4/catalog/Books(101)
curl -X POST http://localhost:8080/odata/v4/catalog/submitOrder \     # 未绑定 Action
  -H "Content-Type: application/json" \
  -d '{"book":1,"quantity":2}'                                       # 库存 12 → 10
curl -X POST http://localhost:8080/odata/v4/catalog/submitOrder \     # 库存不足 → 400
  -H "Content-Type: application/json" \
  -d '{"book":4,"quantity":1}'
```

`Books.java` / `CatalogService_.java` 是构建产物（`srv/target/generated-sources/cds`），**勿手改**；
`CatalogServiceHandler.java` 是你手写的业务代码（手顺3 J5.4）。

## 与教程章节的对应

| 文件 | 章节 |
|---|---|
| `db/schema.cds` | 手顺2（J4.2） |
| `srv/cat-service.cds` | 手顺2（J4.2） |
| `srv/src/main/resources/application.yaml` | 手顺2（J4.3） |
| `db/data/*.csv` | 手顺2（J4.2 种子数据） |
| `CatalogServiceHandler.java` | 手顺3（J5.4） |
