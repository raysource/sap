# CAP + Fiori 整体工程（samples/cap-fiori-bookshop）

**开箱即跑**的完整项目：CAP（Node.js）后端 + Fiori Elements 前端一步到位。
复制后 `npm install && cds watch`，浏览器即可看到带状态徽标的 List Report /
Object Page，并可用「下单」Action 验证前后端联动。

## 运行

```bash
cd cap-fiori-bookshop
npm install          # 安装 @sap/cds
cds watch            # 启动（端口 4004，文件改动自动重载）
```

| 地址 | 内容 |
|---|---|
| `http://localhost:4004/` | CAP 服务索引页 |
| `http://localhost:4004/odata/v4/catalog/Books` | OData V4 数据（含 criticality 字段） |
| `http://localhost:4004/app/books/index.html` | **Fiori Elements List Report**（本项目主入口） |

UI5 运行时来自 `ui5.sap.com` CDN，首次预览需联网。

## 项目结构

```
cap-fiori-bookshop/
├── app/books/            # Fiori Elements 前端（F2–F4 完整注解版）
│   ├── annotate.cds      # @UI 注解：列/筛选/Facets/状态徽标
│   ├── manifest.json     # 数据源 /odata/v4/catalog/ + ListReport 路由
│   └── index.html        # UI5 引导页
├── db/schema.cds         # 领域模型：Genres / Authors / Books / Orders
├── db/data/*.csv         # 种子数据：5 分类 / 4 作者 / 10 本书 / 2 订单
├── srv/cat-service.cds   # 服务定义：Books 投影 + criticality 计算字段 + submitOrder
├── srv/cat-service.js    # 业务逻辑：畅销标记 + criticality 计算 + 下单校验
├── package.json          # 依赖 @sap/cds ^8 + start/watch 脚本
└── .cdsrc.json           # 本地 SQLite
```

## 页面里能看到什么

1. **List Report**（F2）：筛选栏（书名/作者/价格）+ 5 列表格；库存列带状态颜色
   （<span style="color:#1e8f4c">充足</span> / <span style="color:#b57a00">紧张</span> /
   <span style="color:#d0021b">售罄</span>，来自 `criticality`）。
2. **Object Page**（F3）：点击行进详情；「基本信息 / 订单 / 补充信息」三个 Facet
   区块；补充信息里库存渲染为 DataPoint 徽标。
3. **Action 按钮**（F4）：对象页「下单」触发 `submitOrder`——库存扣减、Orders 新增
   一条；curl 验证见下。

## 与两个拆分素材包的关系

- `samples/cap-bookshop` = 本项目的后端（无 Fiori 前端），对应《CAP 培训》手顺1–4。
- `samples/fiori-bookshop` = 本项目的 `app/books/`（可覆盖进任意 Bookshop 工程），
  对应《Fiori 培训》F2–F4；其中 criticality 徽标需自行在服务端补（README 有示例）。
- 本包 = 两者**合并并打通**：criticality 已在服务端计算，注解已启用，直接可见完整效果。

## 测试命令

```bash
# 数据（注意 criticality 由 handler 计算返回）
curl http://localhost:4004/odata/v4/catalog/Books

# 下单 Action（对象页按钮等价操作）→ 返回 { updated: N }
curl -X POST http://localhost:4004/odata/v4/catalog/submitOrder \
  -H "Content-Type: application/json" \
  -d '{"book":1,"quantity":2}'

# 下单后确认：库存 12→10，Orders 多一条
curl "http://localhost:4004/odata/v4/catalog/Books(1)"
curl http://localhost:4004/odata/v4/catalog/Orders
```

## 改注解后

保存 `annotate.cds` 即生效（`cds watch` 自动重载），刷新浏览器即可；改 `srv/` 后
`cds watch` 会重启服务。
