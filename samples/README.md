# 素材包 samples/

本站教程（RAP / CAP Node.js / CAP Java 三条路线）里的代码和测试数据，大多以代码块形式嵌在页面中，方便边看边敲。本目录把这些**可直接运行 / 直接粘贴**的源文件集中存放，并配了每条的「使用操作手顺」。在[素材下载页](../downloads.html)可看到说明；各子目录有自己的 `README.md`。

## 目录

| 目录 | 路线 | 内容 | 可运行？ |
|---|---|---|---|
| `cap-bookshop/` | CAP Node.js | 完整 `cds` 工程：`db/schema.cds`、`srv/cat-service.cds`、`srv/cat-service.js`、CSV 种子数据、`.cdsrc.json`、`package.json`、README | ✅ 是（`npm install && cds watch`，端口 4004） |
| `cap-java/` | CAP Java | 业务源码：`db/schema.cds`、`srv/cat-service.cds`、`application.yaml`、`CatalogServiceHandler.java`、CSV 种子数据、README | ⚠️ 配合 `cds init --java` 脚手架使用 |
| `rap-travel/` | RAP (ABAP) | `ZI_TRAVEL` / `ZC_TRAVEL` / `ZI_TRAVEL_BOOKING` 的 `.ddls`、`ZI_TRAVEL.bdef`、`zbp_i_travel.clas.abap`、`ZUI_TRAVEL_O4.ddls`、`ZR_INSERT_TESTDATA.abap`、README | ⚠️ 需粘贴进 ADT 后激活 |
| `btp-bookshop/` | BTP (HANA Cloud) | HANA SQL 四件套（建 schema/建表/灌数据/验证）+ 三种 Java 构建模式源码（`mode1-dir` / `mode2-maven` / `mode3-spring`）、README | ⚠️ 先在 BTP 建 HANA Cloud 实例，填连接信息后运行 |

## 快速开始

- **CAP Node.js**：进 `cap-bookshop/`，`npm install` → `npm start` → 打开 `http://localhost:4004`；README 里有完整 curl 测试。
- **CAP Java**：进 `cap-java/`，按 README 用 `cds init bookshop --java` 生成脚手架后覆盖/放入文件，`mvn spring-boot:run`。
- **RAP**：进 `rap-travel/`，按 README 顺序在 ADT 里依次新建对象并粘贴源码，最后运行 `ZR_INSERT_TESTDATA` 导入数据。
- **BTP**：进 `btp-bookshop/`，先在 BTP 创建 HANA Cloud 实例（B1–B3），按 README 依次执行 `sql/01→02→03→04` 建库灌数，再选一种 Java 模式填连接信息运行。
