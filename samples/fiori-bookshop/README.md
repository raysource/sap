# Fiori Elements 素材包（samples/fiori-bookshop）

与《Fiori 培训》F2–F4 **完全配套**的 Fiori Elements 前端素材：把 `app/` 目录放进
CAP Bookshop 工程（如 [samples/cap-bookshop](../cap-bookshop)）即可得到
「List Report + Object Page + Action 按钮」的完整页面。

## 目录

```
fiori-bookshop/
└── app/
    └── books/            # Fiori Elements List Report 应用（复制到 bookshop/app/ 下）
        ├── annotate.cds  # @UI 注解：列表定制（F2）+ 对象页 Facets（F3）
        ├── manifest.json # 应用配置：数据源 /odata/v4/catalog/ + 路由到 ListReport
        └── index.html    # 引导页（UI5 走 ui5.sap.com CDN）
```

## 使用

```bash
# 1) 复制到 Bookshop 工程（任选其一）
#    ① 复制本素材包 app/ 到 samples/cap-bookshop/ 下（最终结构：cap-bookshop/app/books/...）
#    ② 或在你自己的 cds 工程里：cp -r samples/fiori-bookshop/app <你的工程>/

# 2) 启动
cd cap-bookshop
npm install          # 首次
cds watch            # 端口 4004

# 3) 预览
#    浏览器打开 http://localhost:4004/app/books/index.html
#    List Report：筛选栏（书名/作者/价格）+ 表格 5 列
#    点击行 → Object Page：基本信息 / 订单 / 补充信息 三个 Facet 区块
#    （前提：srv/cat-service.cds 暴露了 Orders —— cap-bookshop 素材包已暴露）
```

## 章节对照

| 文件 | 对应章节 | 内容 |
|---|---|---|
| `annotate.cds` | F2（手顺1）+ F3（手顺2） | `HeaderInfo` / `SelectionFields` / `LineItem` / `Facets` / `FieldGroup` / `LineItem#orders` |
| `manifest.json` | F2 / CAP 手顺4 6.3 | 数据源、路由、`sap.fe.templates.ListReport` |
| `index.html` | F2 | UI5 引导页 |

## F4 可选：库存状态徽标（需要服务端 criticality）

`annotate.cds` 末尾注释掉的 `UI.DataPoint #stock` 依赖服务返回 `criticality`
（0–3）字段，cap-bookshop 素材包未内置。启用两步：

1) 在 `srv/cat-service.cds` 的 Books 投影加计算字段（用 `@cds.on` 表达式示例）：

```cds
entity Books as projection on my.Books {
  *,
  stock,                       // 保留原字段
  criticality: Integer = 0     // 占位，下面 handler 计算
};
```

2) 在 `srv/cat-service.js` 的 after READ 里计算（简洁版）：

```js
srv.after('READ', 'Books', (books) => {
  for (const b of books) b.criticality = b.stock <= 0 ? 3 : b.stock < 20 ? 2 : 1;
});
```

然后取消 `annotate.cds` 里 `UI.DataPoint #stock` 的注释，刷新页面即见
「售罄（红）/ 紧张（橙）/ 充足（绿）」徽标。

## 注意

- **Books 可写**：cap-bookshop 的 Books 非 `@readonly`，列表自动出现「创建」按钮。
- **Orders 需在服务内**：对象页「订单」子表依赖服务暴露 Orders（cap-bookshop 已含）。
- **UI5 CDN**：`index.html` 从 `ui5.sap.com` 加载 UI5，首次预览需联网；离线环境
  可用 BAS 的 UI5 资源或 ui5 tooling 替代。
- **改注解后**：保存 `annotate.cds` 即可，`cds watch` 自动重载，刷新浏览器生效。
