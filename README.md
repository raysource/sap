# SAP RAP × CAP 培训中心

面向 ABAP / 全栈开发者的 SAP 现代化应用开发培训网站（中文）。包含：

- **界面示意图**：ADT（Eclipse）、Fiori Elements、BTP Cockpit、终端、VS Code、POSTMAN 的高仿真 HTML/CSS Mockup（非真实截图）
- **操作手顺**：RAP 与 CAP（Node.js）各 4 个手顺 + CAP for Java（J1–J6）共 6 个章节 + BTP 与 HANA Cloud（B1–B8）共 8 个章节 + Fiori（F1–F6）共 6 个章节，逐步跟做
- **测试数据**：旅行社 Travel（RAP）与书店 Bookshop（CAP，Node/Java/HANA 共用）的完整示例数据与测试场景
- **素材包**：`samples/` 目录存放可直接运行 / 直接粘贴的源码（CAP Node.js 完整工程、**CAP + Fiori 整体工程**、CAP Java 业务源码、RAP 全套 ABAP 源码、BTP 的 HANA SQL + 三种 Java 构建模式源码、Fiori Elements 前端三件套），见 [downloads.html](downloads.html)

## 快速开始

无需构建，直接用浏览器打开即可（纯静态站点）：

```bash
# 方式一：直接打开
open index.html

# 方式二：本地 HTTP 服务（推荐，路径更稳定）
python3 -m http.server 8080 --directory .
# 然后浏览器访问 http://localhost:8080
```

## 目录结构

```
traning/
├── index.html              # 首页：课程总览、RAP/CAP 对比、学习路径
├── downloads.html          # 素材包下载页（samples/ 说明 + 使用操作手顺）
├── assets/
│   ├── css/main.css        # 设计系统 + mockup 组件
│   └── js/main.js          # 语法高亮 + 复制按钮 + 导航高亮
├── samples/                # 素材包：可运行 / 可粘贴的源码与测试数据
│   ├── cap-bookshop/       # CAP Node.js 完整工程（npm install && cds watch 即跑）
│   ├── cap-fiori-bookshop/ # CAP + Fiori 整体工程（后端 + app/books 前端打通，含状态徽标）
│   ├── fiori-bookshop/     # Fiori Elements 前端素材（app/books/ 三件套，配合 cap-bookshop）
│   ├── cap-java/           # CAP Java 业务源码（配合 cds init --java 脚手架）
│   ├── rap-travel/         # RAP 全套 ABAP 源码（粘贴进 ADT 使用）
│   └── btp-bookshop/       # BTP：HANA SQL（建库灌数）+ 三种 Java 构建模式源码
├── rap/                    # RAP 培训（S/4HANA on-premise）
│   ├── overview.html       # 1. RAP 概述
│   ├── prep.html           # 2. 环境准备
│   ├── step1-cds.html      # 3. 手顺1：CDS 数据模型
│   ├── step2-behavior.html # 4. 手顺2：行为定义与实现
│   ├── step3-service.html  # 5. 手顺3：服务定义与绑定
│   ├── step4-test.html     # 6. 手顺4：Fiori 预览与测试
│   └── testdata.html       # 7. 测试数据（Travel 场景）
├── cap/                    # CAP 培训（Node.js + CDS）
│   ├── overview.html       # 1. CAP 概述
│   ├── prep.html           # 2. 环境准备
│   ├── step1-init.html     # 3. 手顺1：项目初始化
│   ├── step2-model.html    # 4. 手顺2：数据模型与服务
│   ├── step3-implement.html# 5. 手顺3：业务逻辑实现
│   ├── step4-test.html     # 6. 手顺4：启动、测试与 Fiori
│   ├── testdata.html       # 7. 测试数据（Bookshop 场景）
│   └── java/               # CAP for Java（Java 运行时，J1–J6）
│       ├── overview.html   # J1. Java 概述
│       ├── prep.html       # J2. 环境准备
│       ├── step1-project.html # J3. 手顺1：建立 Java 项目
│       ├── step2-db.html   # J4. 手顺2：配置链接与建库建表
│       ├── step3-dto.html  # J5. 手顺3：DTO → 生成模型与服务
│       ├── step4-test.html # J6. 手顺4：运行与测试
│       └── btp/            # BTP 与 HANA Cloud（云环境 + BAS，B1–B8）
│           ├── overview.html   # B1. BTP 与 HANA Cloud 概述
│           ├── prep.html       # B2. 环境准备（BTP 账号）
│           ├── step1-hana.html # B3. 手顺1：创建 HANA Cloud 实例
│           ├── step2-sql.html  # B4. 手顺2：HANA SQL 建表与数据
│           ├── step3-bas.html  # B5. 手顺3：BAS 入门
│           ├── step4-dir.html  # B6. 手顺4：模式一 目录式
│           ├── step5-maven.html# B7. 手顺5：模式二 Maven
│           └── step6-spring.html# B8. 手顺6：模式三 Spring Boot
├── fiori/                  # Fiori 培训（UI 层，RAP × CAP 共用，F1–F6）
│   ├── overview.html       # F1. Fiori 概述
│   ├── step1-list.html     # F2. 手顺1：List Report（cds add fiori + 注解）
│   ├── step2-object.html   # F3. 手顺2：Object Page 与 Facets
│   ├── step3-action.html   # F4. 手顺3：Action 与双线集成（CAP Action + RAP CDS @UI/Draft）
│   ├── elements.html       # F5. 主要元素控件讲解（Smart Controls + sap.m 速查）
│   └── templates.html      # F6. 页面模板详解（List Report/Worklist/Object Page/Overview/ALP/Form Entry/Custom）
└── STYLE-GUIDE.md          # 页面编写规范（新增页面时参考）
```

## 内容概览

| Track | 目标环境 | 场景 | 核心手顺 |
|---|---|---|---|
| RAP | S/4HANA on-premise（ADT） | 旅行社 Travel 业务对象 | 数据模型 → BDEF 行为 → Service 定义/绑定 → Fiori 预览 |
| CAP (Node.js) | 本地 + SAP BTP Cloud Foundry | 书店 Bookshop | cds init → 模型/服务 → 业务逻辑 → cds watch 测试 + Fiori |
| CAP (Java) | 本地 + SAP BTP Cloud Foundry | 书店 Bookshop（同模型） | 环境 → 建 Java 项目 → 建库建表 → DTO/生成模型 → 测试 |
| BTP (HANA Cloud) | SAP BTP（Cloud Foundry）+ HANA Cloud + BAS | 书店 Bookshop（云端 HANA） | 注册/子账号 → 建 HANA Cloud 实例 → HANA SQL 建表灌数 → BAS 三种 Java 模式连库（目录式 / Maven / Spring Boot） |
| Fiori | 浏览器（本地 CAP 服务 + Fiori Elements） | 书店 Bookshop（复用 CAP OData） | cds add fiori 生成 List Report → Object Page Facets → Action 按钮与状态徽标 |

> CAP for Java 路线从「一个简单 Java DTO」出发，逐步到完整 CAP Java 项目：`cds init --java` 生成 Maven 多模块工程，`application.yaml` 配置 SQLite 数据源并自动建表，编译期由 `cds-maven-plugin` 把 CDS 模型生成成强类型 Java 类（`Books` / `CatalogService_`），业务逻辑写在 Spring `@ServiceName` 事件处理器里。
>
> BTP 路线（B1–B8）把手顺搬到云端：注册 SAP 账号 → 在 BTP 创建 HANA Cloud 实例 → Database Explorer 里用 HANA SQL 建 Bookshop 库并灌入与 CSV 一致的 10 本书 → 在 BAS（Business Application Studio）里用三种 Java 构建模式（① 目录式 javac ② Maven ③ Spring Boot）通过 JDBC（ngdbc 驱动）连上该库，验证读到同一份数据。
>
> Fiori 路线（F1–F4）是两条后端路线的 UI 收口：基于 Bookshop 的 OData 服务，用 `cds add fiori` 生成 List Report，用 `annotate.cds` 的 `@UI` 注解定制列、筛选、Object Page Facets 与 Action 按钮，最后对照 RAP 侧 CDS `@UI` 注解与 Draft 机制。F5 控件讲解为参考章：注解 → 控件装配对照、Smart Controls 与 sap.m 基础控件速查。F6 页面模板详解为参考章：List Report / Worklist / Object Page / Overview Page / Analytical List Page / Form Entry / Custom Page 全套模板 mockup + 选择与生成指南。

## 素材包（samples/）

教程页面里的代码以代码块形式嵌入，方便边看边敲；`samples/` 提供可直接使用的一手文件，[downloads.html](downloads.html) 有完整说明与下载链接：

| 素材包 | 内容 | 用法 |
|---|---|---|
| `samples/cap-bookshop/` | 完整 CAP Node.js 工程：`db/schema.cds`、`srv/cat-service.cds`、`srv/cat-service.js`、CSV 种子数据、`package.json`、`.cdsrc.json` | `npm install && npm start`（或 `cds watch`），端口 4004 |
| `samples/cap-fiori-bookshop/` | CAP + Fiori 整体工程：cap-bookshop 后端 + `app/books/` 前端 + 服务端 criticality（F4 徽标开箱即用） | `npm install && cds watch` → `http://localhost:4004/app/books/index.html` |
| `samples/fiori-bookshop/` | Fiori Elements 前端三件套：`app/books/` 的 `annotate.cds`、`manifest.json`、`index.html` | 复制 `app/` 进 CAP Bookshop 工程，`cds watch` 后访问 `/app/books/index.html` |
| `samples/cap-java/` | CAP Java 业务源码：模型、服务、`application.yaml`、`CatalogServiceHandler.java`、CSV 种子数据 | 先 `cds init bookshop --java`，再覆盖 / 放入对应文件，`mvn spring-boot:run` |
| `samples/rap-travel/` | RAP 全套 ABAP 源码：三个 `.ddls`、`ZI_TRAVEL.bdef`、`zbp_i_travel.clas.abap`、`ZUI_TRAVEL_O4.ddls`、`ZR_INSERT_TESTDATA.abap` | 粘贴进 ADT 按手顺顺序激活；运行测试数据程序写入 7+6 条 |
| `samples/btp-bookshop/` | BTP：HANA SQL 四件套（建 schema/建表/灌数据/验证）+ 三种 Java 构建模式源码（`mode1-dir` 目录式、`mode2-maven`、`mode3-spring`） | 先在 BTP 建 HANA Cloud 实例，填入连接信息后分别 `javac/java`、`mvn compile exec:java`、`mvn spring-boot:run` |

每个素材包内含自己的 `README.md`（使用操作手顺、测试命令、与教程页面的差异说明）。素材包与页面代码的差异已在下载页「使用注意」中列出（CAP Books 可写性、`submitOrder` 参数形式、RAP `rejecttravel` 补全实现；BTP 的占位符说明；Fiori 状态徽标需服务端 criticality）。

## 维护说明

- 所有「截图」均为 HTML/CSS 绘制的 Mockup，新增界面示意时复用 `assets/css/main.css` 中的组件（见 `STYLE-GUIDE.md` §6），无需图片文件。
- 代码块需标注 `language-cds / abap / js / java / xml / yaml / sql / json / bash / console / csv / properties`，由 `main.js` 自动高亮并提供复制按钮（Java 关键字、XML 标签名、SQL 关键字已支持）。
- 本培训为教学用途，Mockup 界面并非真实 SAP 系统截图。
# sap
