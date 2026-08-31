# CAP Node.js 可运行工程（Bookshop）

与《CAP 培训》手顺1–4 + 测试数据章节**完全配套**的完整工程，复制后即可运行。

## 运行

```bash
cd cap-bookshop
npm install          # 安装 @sap/cds
cds watch            # 启动（端口 4004，文件改动自动重载）
```

浏览器打开 `http://localhost:4004/odata/v4/catalog` 查看服务文档；
`http://localhost:4004/odata/v4/catalog/Books` 查看图书数据。

## 测试（可直接复制的命令）

```bash
# 读取与查询
curl http://localhost:4004/odata/v4/catalog/Books
curl "http://localhost:4004/odata/v4/catalog/Books?$filter=price%20lt%2030"
curl "http://localhost:4004/odata/v4/catalog/Books?$expand=author"

# 创建 → 修改 → 删除（以 ID 101 为例）
curl -X POST http://localhost:4004/odata/v4/catalog/Books \
  -H "Content-Type: application/json" \
  -d '{"ID":101,"title":"CAP in Action","descr":"新书","author_ID":104,"genre_ID":201,"stock":5,"price":19.99,"currency":"EUR"}'
curl -X PATCH http://localhost:4004/odata/v4/catalog/Books(101) \
  -H "Content-Type: application/json" \
  -d '{"price":25.50}'
curl -X DELETE http://localhost:4004/odata/v4/catalog/Books(101)

# 下单 Action（含 before 参数校验；库存充足 → {"updated":5}；库存不足 → 400）
curl -X POST http://localhost:4004/odata/v4/catalog/submitOrder \
  -H "Content-Type: application/json" \
  -d '{"book":1,"quantity":5}'
curl -X POST http://localhost:4004/odata/v4/catalog/submitOrder \
  -H "Content-Type: application/json" \
  -d '{"book":4,"quantity":1}'

# before 参数校验：数量非正整数 → 400
curl -X POST http://localhost:4004/odata/v4/catalog/submitOrder \
  -H "Content-Type: application/json" \
  -d '{"book":1,"quantity":0}'

# 自定义 Function（GET 只读）：查书 1 当前库存（下单后已减）
curl "http://localhost:4004/odata/v4/catalog/stockOf(book=1)"

# 事务：submitOrder 自动生成订单行，Orders 里可查到
curl "http://localhost:4004/odata/v4/catalog/Orders"
```

## 与教程章节的对应

| 文件 | 章节 |
|---|---|
| `db/schema.cds` | 手顺2（4.1）+ 手顺3（5.2 Orders） |
| `srv/cat-service.cds` | 手顺2（4.2）+ 手顺3（5.3） |
| `srv/cat-service.js` | 手顺3（5.4） |
| `db/data/*.csv` | 测试数据（7.2–7.5） |
| `package.json` / `.cdsrc.json` | 手顺1（3.5） |

## 两处为「可运行」做的微调（与页面示例的差异）

1. **`Books` 投影去掉了 `@readonly`**：测试数据章节的增删改场景需要可写的 Books；页面示例阶段性地用 `@readonly` 演示只读投影。
2. **`submitOrder` 参数声明为 `Integer`**：页面示例写 `book: Books`，但 curl 载荷是 `{"book":1}`（传 ID）。声明为 `Integer` 后两者完全一致、开箱即跑。若想用官方 `book: Books` 写法，把载荷改成 `{"book":{"ID":1},"quantity":5}` 即可。

## 重置数据

反复测试把库存改乱后，删除本地 `bookshop.db`（SQLite 文件）再 `cds watch`，数据会从 CSV 重新导入。
