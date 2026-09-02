# cpi-iflows — Integration Suite（Cloud Integration）素材包

配合《Integration Suite 培训》I3–I6 使用：测试载荷（入站消息）与 Groovy 脚本，全部为可直接粘贴 / 直接发送的文本文件。

> ⚠️ 本包<b>不含</b>任何 iFlow 导出包（.pkg/.jar）与租户信息。iFlow 本体需按教程章节在 Cloud Integration Web UI 里手工绘制（画布是可视化操作，无法用文本文件代替）；本包提供的是「画布里要用到的内容」。

## 目录

| 文件 | 内容 | 对应章节 |
|---|---|---|
| `payloads/order-book.json` | I4 下单 JSON（Bookshop《Wuthering Heights》） | I4 / I6 |
| `payloads/order-urgent.xml` | 加急订单（无命名空间） | I5 / I6 |
| `payloads/order-normal.xml` | 普通订单（无命名空间） | I5 / I6 |
| `payloads/order-ns-urgent.xml` | 带默认命名空间的加急订单（XPath 前缀练习） | I5.6 |
| `scripts/order-transform.groovy` | I4 的 Groovy 脚本完整版（算金额 + 重组 JSON） | I4.3 |
| `scripts/groovy-snippets.groovy` | header / property / XML 读取常用片段 | I6.3 |

## 三个 iFlow 速查

| iFlow（包 iflow_course） | Sender 地址 | 处理 | Receiver | 载荷 |
|---|---|---|---|---|
| `hello-echo` | HTTPS `/hello` | Content Modifier：body 替换 + Header X-Course | HTTP → `https://postman-echo.com/post` | 任意 JSON |
| `order-transform` | HTTPS `/order` | Groovy Script：算 amount、重组 JSON、设 header | HTTP → 同上 | `payloads/order-book.json` |
| `order-dispatch` | HTTPS `/dispatch` | Content Modifier 抽 property → CBR 分流 → 分支打标 | HTTP ×2 → 同上 | `payloads/order-*.xml` |

端点 URL = `https://<你的租户域名>/cxf/<地址>`（例：`https://xxxxx-tmn.eu10.hana.ondemand.com/cxf/order`）。租户域名见浏览器地址栏，或 Monitor → Manage Integration Content 点开 iFlow 复制。

## curl 测试命令

```bash
# I4 order-transform：JSON 订单
curl -s -X POST "https://<租户域名>/cxf/order" \
  -H 'Content-Type: application/json' \
  --data-binary @payloads/order-book.json | python3 -m json.tool

# I5 order-dispatch：两条 XML 各测一次（观察回显 headers.x-route）
curl -s -X POST "https://<租户域名>/cxf/dispatch" \
  -H 'Content-Type: text/xml' \
  --data-binary @payloads/order-urgent.xml | python3 -m json.tool
curl -s -X POST "https://<租户域名>/cxf/dispatch" \
  -H 'Content-Type: text/xml' \
  --data-binary @payloads/order-normal.xml | python3 -m json.tool
```

验证要点：回显 JSON 的 `data` 字段 = 接收方（回显服务）收到的 body；`headers` 字段里能看到 iFlow 设置的 `x-course` / `x-amount` / `x-route`。

## 注意

- **回显服务** `postman-echo.com` 为公网第三方，仅教学充当「目标系统镜子」；偶发不可达时重试或换 `https://httpbin.org/post`（Receiver 地址改一下即可，iFlow 逻辑不变）。
- **Sender 鉴权**：教学租户一般允许匿名调用；若返回 401，把 Sender → Security 的 Authentication 设为 None（仅限教学，生产需配证书/OAuth，见 I3.7）。
- **XML 命名空间**：`order-ns-urgent.xml` 带默认命名空间，若在 Content Modifier 里用 XPath 需先声明前缀（如 `ns1`），值写 `/ns1:order/ns1:type`。
- 每次改 iFlow 都要 Save 后重新 Deploy 才生效；运行结果一律在 Monitor → Message Processing Log 对答案。
