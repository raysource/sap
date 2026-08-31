# 站点样式指南（生成页面时必须遵守）

本文件约束所有内容页的写法。**在写任何页面之前通读**，并对照示范页：
- `rap/overview.html`（RAP 模板）
- `cap/overview.html`（CAP 模板）
- `index.html`（首页）

## 1. 页面骨架（必须逐字保持一致）

```html
<!doctype html>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{章节名} | SAP RAP × CAP 培训</title>
<link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>📘</text></svg>">
<link rel="stylesheet" href="{相对路径}assets/css/main.css">
</head>
<body>
<header class="topbar">…</header>        <!-- 见 §2 -->
<div class="layout">
  <aside class="sidebar">…</aside>      <!-- 见 §3 -->
  <main class="content"><div class="page">…内容…</div>
    <footer class="sitefoot">…</footer>
  </main>
</div>
<script src="{相对路径}assets/js/main.js"></script>
</body>
</html>
```

- RAP 页相对路径前缀：`../assets/…`；CAP 页同是 `../assets/…`（都在二级目录）。
- 不要修改 title / favicon / 骨架结构。

## 2. 顶部栏（按 track 切换高亮）

RAP 页：`<a class="tab" href="../index.html">首页</a>`，`<a class="tab active" href="overview.html">RAP 培训</a>`，`<a class="tab" href="../cap/overview.html">CAP 培训</a>`。
CAP 页：首页 / `../rap/overview.html` / `active` 的 `overview.html`。
brand 始终指向 `../index.html`。

## 3. 侧边导航（RAP 页固定不变，只切换 active 项）

```html
<div class="side-head">RAP 培训</div>
<nav class="side-nav">
  <a class="snav" href="overview.html"><span class="num">1</span>RAP 概述</a>
  <a class="snav" href="prep.html"><span class="num">2</span>环境准备</a>
  <a class="snav" href="step1-cds.html"><span class="num">3</span>手顺1：CDS 数据模型</a>
  <a class="snav" href="step2-behavior.html"><span class="num">4</span>手顺2：行为定义与实现</a>
  <a class="snav" href="step3-service.html"><span class="num">5</span>手顺3：服务定义与绑定</a>
  <a class="snav" href="step4-test.html"><span class="num">6</span>手顺4：Fiori 预览与测试</a>
  <a class="snav" href="testdata.html"><span class="num">7</span>测试数据</a>
</nav>
<div class="snav-group">另一条路线</div>
<a class="snav" href="../cap/overview.html"><span class="num">C</span>CAP 培训</a>
```

当前页的 `<a>` 加 `class="active"`。CAP 页把「RAP 概述…」换成 CAP 章节，`另一条路线` 指向 `../rap/overview.html`，num 用 `R`。

## 4. 标题层级

- `<h1>` 章节标题 + `<p class="page-sub">` 副标题 + `<p class="lead">` 简介。
- 每节用 `<h2 id="…">`（带锚点），小节 `<h3>`。
- 页尾必须有 `.pagenav`：上一章 / 下一章链接。

## 5. 可用组件（样式已定义，直接用 class）

| 组件 | class | 说明 |
|---|---|---|
| 徽章 | `badge blue/teal/green/amber/red/gray` | 章节标签 |
| 卡片 | `card` + `grid cols-2/3` | 概念分组 |
| 提示框 | `note` / `note warn` / `note danger` / `note ok` + `.note-title` | 注意事项 |
| 步骤清单 | `ol.steps`（`li` 内可用 `.step-title`），CAP 加 `steps teal` | 操作手顺 |
| 文档表 | `table.doc` | 字段/数据表 |
| 对比表 | `table.cmp-table`（`td.dim` 为维度列） | 对比 |
| 折叠 | `details.box` + `summary` + `.box-body` | 可展开补充 |
| 代码块 | `<pre><code class="language-cds|abap|js|bash|json|console">` | 自动高亮+复制 |
| 上一页/下一页 | `.pagenav a` + `.next` | 章末 |

## 6. Mockup 截图组件（重点）

所有「界面截图」一律用 HTML/CSS mockup，不要贴图片。每个 mockup 用 `<figure class="mockup">` 包裹，内容放 `<div class="win">` 内，底部 `<div class="cap"><b>图 x-x</b> 说明</div>`。

可组合的部件（均在 CSS 中定义）：

- **窗口**：`.win-chrome`（内含 `.dots` 三个 `.dot r/y/g` + `.wtitle`）、`.menubar`、`.toolbar`、`.statusbar`
- **树/项目导航**：`.tree`，行 `.row`（选中 `.row.sel`），图标 `.i`，文件夹 `.folder`，文件 `.file`，缩进 `.pad`
- **代码编辑器**：`.editor`（内 `.ed-tabs` 的 `.on` 标签 + `.ed-body` 内 `<pre class="ed"><code>`，用 `language-*` 高亮）
- **终端**：`.term`，行内 span 用 `.p`（提示符）、`.path`、`.ok`、`.info`、`.warn`、`.err`
- **Fiori Elements**：`.fi`（整体）、`.fi-top`（`.ftitle` 标题 + `.fsearch` 搜索）、`.fi-nav`、`.fi-body`、`.fi-main`；内部用 `.fbar`（筛选栏，`.field` 内 `.fc`，下拉 `.fc.dd`）、`.fbtn`（按钮，`.primary/.teal/.green/.red/.sm/.ghost`）、`.tbl`（表格）、`.st`（状态徽章 `.st.a/.o/.n/.x`，A=已批准/O=新(Open)/N=新? 注意：O=Open 处理中，A=Approved，X=Rejected）、`.seg`（分段按钮）、`.obj-head`（对象页头，`.obj-title` + `.obj-fields` 的 `.of` + `.obj-actions`）、`.facet`（facet 区块，`.facet-head` + `.facet-body` + `.fform` 的 `.ff`）
- **对话框**：`.dialog`（半透明遮罩）+ `.dbox`（`.dhead` + `.dbody` + `.dform` 的 `.ff` + `.dfoot`），`dialog wide` 加宽；向导用 `.wizard`（`.wsteps` 步骤 + `.wbody`）
- **BTP Cockpit**：`.btp`（`.btp-head` 面包屑 + `.btp-sub` 的 `.stabs` + `.btp-cards` 的 `.btp-card`：`.t` 标题/`.s` 副文/`.b` 链接）
- **VS Code**：`.vscode`（`.vs-top` + `.vs-body` 内 `.vs-activity`/`.vs-explorer`/`.vs-editor` + `.vs-status`）
- **POSTMAN**：`.postman`（`.pm-tab` 内 `.pm-method get/post/delete` + `.pm-url` + `.pm-send`；`.pm-head`；`.pm-res`）

### 状态徽章约定
- `.st.a` = 已批准（绿）
- `.st.o` = 处理中/Open（琥珀）
- `.st.n` = 新（蓝）
- `.st.x` = 已拒绝（红）

## 7. 内容规范

- 语言：中文正文，技术名词保留英文（CDS、BDEF、OData、Entity、Action…）。全角标点。
- 代码块必须有 `language-*` class（cds/abap/js/bash/json/console），否则不高亮。
- 所有内部链接用**相对路径**，确保 `open file` 直接可用：RAP 页内互链 `step1-cds.html`，跨 track `../cap/…`，回首页 `../index.html`。
- 锚点链接 `href="#id"` 配 `<h2 id="id">`。
- 截图 mockup 图号：RAP 页用「图 2-x / 3-x…」（对应章节号），CAP 页同理；说明要能脱离图片独立看懂。
- 每章包含：概念讲解 → 界面示意图 → 操作手顺（steps）→ 验证/结果 → 注意点。测试数据页给出可直接复制的表结构与示例数据。
- 不要出现 TODO / lorem。数字、命令、路径必须真实可用。

## 8. 命名与文件

- RAP：`rap/prep.html`、`rap/step1-cds.html`、`rap/step2-behavior.html`、`rap/step3-service.html`、`rap/step4-test.html`、`rap/testdata.html`
- CAP：`cap/prep.html`、`cap/step1-init.html`、`cap/step2-model.html`、`cap/step3-implement.html`、`cap/step4-test.html`、`cap/testdata.html`
- 章节内部 pagenav 顺序见侧边导航顺序。
