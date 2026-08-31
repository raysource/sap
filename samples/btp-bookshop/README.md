# BTP 素材包（HANA Cloud + BAS 三种 Java 构建模式）

配套《BTP 与 HANA Cloud / BAS Java 课程》（B1–B8），尤其 B4（HANA SQL 建库建表）
与 B6–B8（三种 Java 构建模式连 HANA 读 Books）。

> ⚠️ **本包不含任何真实连接信息**：HANA Cloud 实例的主机、DBADMIN 口令需要
> 你自己在 B1–B3 步骤注册并记录后填入（本包用 `xxxx.hana.trial-us10...` 占位）。

## 目录

| 路径 | 内容 | 对应章节 |
|---|---|---|
| `sql/01-create-schema.sql` | 建 schema `BOOKSHOP` | B4 |
| `sql/02-create-tables.sql` | 建 3 张表（GENRES / AUTHORS / BOOKS，含外键） | B4 |
| `sql/03-insert-data.sql` | 种子数据：5 分类 / 4 作者 / 10 本书 | B4 |
| `sql/04-verify.sql` | 联表查询 + 计数核对（期望 10 / 4 / 5） | B4 |
| `mode1-dir/` | 模式一·目录式（javac / java），纯 JDBC | B6 |
| `mode2-maven/` | 模式二·Maven（archetype + exec 插件） | B7 |
| `mode3-spring/` | 模式三·Spring Boot（web + jdbc + JdbcTemplate） | B8 |

## 使用顺序

1. **注册 / 创建**：B1–B3 在 BTP Cockpit 注册账号、创建 HANA Cloud 实例，
   拿到 **SQL End Point 主机** 与 **DBADMIN 口令**。
2. **建库**：Database Explorer → SQL Console，依次执行 `sql/01` → `02` → `03` → `04`。
3. **建 Java 工程**：三选一（模式一最简单；模式三最接近真实生产），按各子目录 README 操作。

## 三处占位符（每次连接前都要替换）

| 占位符 | 位置 | 替换为 |
|---|---|---|
| `xxxx.hana.trial-us10.hanacloud.ondemand.com` | 三个模式的 Java 源码 / properties | 你的实例「Copy SQL End Point」主机 |
| `你的数据库口令` | Java 源码 / properties | 创建实例时设置的 DBADMIN 口令 |
| ngdbc 版本号 `2.28.8` | mode2 / mode3 的 pom.xml | 以 Maven Central 当前版本为准 |

## 与教程页面的差异 / 注意

- 种子数据与站点 CAP（Node / Java）路线共用同一份 Bookshop 数据
  （5 分类 201–205、4 作者 101–104、10 本书，含库存 0 / 100 / 333 边界）。
- HANA Cloud **只支持** `encrypt=true&validateCertificate=true` 的连接方式，
  JDBC URL 里的 `validateCertificate` 请保持 `true`。
- 非 DBADMIN 用户执行 `CREATE SCHEMA` 可能报 `insufficient privilege`：
  `GRANT CREATE SCHEMA TO <user>`，或跳过 schema 直接用该用户默认 schema
  （此时 SQL 与 Java 中去掉 `BOOKSHOP.` 前缀）。
- trial 版 HANA Cloud 实例**每日自动停止**，连不上时先在 Cockpit 手动重启实例。
