# RAP 素材（Travel 业务对象，S/4HANA on-premise）

与《RAP 手顺1–4 + 第7章测试数据》完全配套的**可直接粘贴源码**。
ABAP / CDS 对象在 ADT（Eclipse）里新建时用模板，再粘贴本目录对应文件内容即可。

## 文件清单与对应章节

| 文件 | ADT 新建方式 | 对应章节 |
|---|---|---|
| `ZTRAVEL` / `ZTRAVEL_BOOKING`（结构见下） | `New → Database Table`（GUI 编辑器） | 手顺1（3.2） |
| `ZI_TRAVEL.ddls` | `New → Data Definition`，模板 **Define View Entity** | 手顺1（3.3） |
| `ZC_TRAVEL.ddls` | `New → Data Definition`，模板 **Projection View** | 手顺1（3.4） |
| `ZI_TRAVEL_BOOKING.ddls` | `New → Data Definition`，模板 **Define View Entity** | 手顺1（3.5） |
| `ZI_TRAVEL.bdef` | `New → Behavior Definition`（选中 ZI_TRAVEL 后新建） | 手顺2（4.2） |
| `zbp_i_travel.clas.abap` | 双击 BDEF 第 1 行超链接 → `Create Class` | 手顺2（4.3 / 4.4） |
| `ZUI_TRAVEL_O4.ddls` | `New → Service Definition` | 手顺3（5.2） |
| 服务绑定 `ZUI_TRAVEL_O4` | `New → Service Binding`，Binding Type 选 **OData V4 – UI** | 手顺3（5.3，GUI 操作，无源码） |
| `ZR_INSERT_TESTDATA.abap` | `New → ABAP Program`，F8 运行 | 第7章（7.4 方式二） |

## 使用步骤（顺序即手顺顺序）

1. **建包**：右键项目 → `New → ABAP Package`，名称 `ZRAP_TRAINING`（本素材包用默认包名 `$TMP` 也行，建议建正式包）。
2. **建表**：按下方结构建 `ZTRAVEL` 与 `ZTRAVEL_BOOKING`。CURR 字段需在 **Reference Table/Field** 里指定 `CURRENCYCODE`（金额才能正确显示货币单位）。激活（Ctrl+F3）。
3. **视图栈**：依次新建 `ZI_TRAVEL`、`ZC_TRAVEL`、`ZI_TRAVEL_BOOKING`，粘贴对应 `.ddls` 内容，激活。可 `Open With → SQL Preview` 验证。
4. **行为**：选中 `ZI_TRAVEL` → `New → Behavior Definition`，粘贴 `ZI_TRAVEL.bdef`；双击第 1 行超链接生成类，粘贴 `zbp_i_travel.clas.abap` 全部内容，激活类与 BDEF。
5. **服务**：`New → Service Definition` 粘贴 `ZUI_TRAVEL_O4.ddls`；再右键 → `New → Service Binding`（OData V4 – UI）并激活。
6. **导数据**：新建程序 `ZR_INSERT_TESTDATA`，粘贴 `.abap` 文件，F8 运行，ALV/控制台输出「插入完成：7 条旅行，6 条预订」。
7. **验证**：`SE16N` 看表数据；或 `ZUI_TRAVEL_O4` 服务绑定的 `Open URL` 在浏览器预览 OData；手顺4 里用 Fiori 预览点「批准 / 拒绝」。

## 表结构（Database Table 编辑器字段清单）

**ZTRAVEL**（客户端相关，MANDT 自动添加）

| 字段 | 键 | 数据类型 | 长度 | 说明 |
|---|---|---|---|---|
| MANDT | ☑ | CLNT | 3 | 客户端（自动） |
| TRAVELID | ☑ | INT2 | 5 | 旅行编号 |
| AGENCYID | | INT2 | 5 | 旅行社 ID |
| CUSTOMERID | | INT2 | 5 | 客户 ID |
| BEGINDATE | | DATS | 8 | 开始日期 |
| ENDDATE | | DATS | 8 | 结束日期 |
| BOOKINGFEE | | CURR | 13,2 | 预订手续费 |
| TOTALPRICE | | CURR | 13,2 | 总价 |
| CURRENCYCODE | | CUKY | 5 | 货币码（参考字段） |
| STATUS | | CHAR | 1 | 状态 N/O/A/X |
| DESCRIPTION | | CHAR | 60 | 描述 |
| CREATEDBY | | CHAR | 12 | 创建人 |
| CREATEDAT | | DEC | 15 | 创建时间戳 |
| LASTCHANGEDBY | | CHAR | 12 | 最后修改人 |
| LASTCHANGEDAT | | DEC | 15 | 最后修改时间戳 |

**ZTRAVEL_BOOKING**（联合主键 TRAVELID + BOOKINGID）

| 字段 | 键 | 数据类型 | 长度 | 说明 |
|---|---|---|---|---|
| MANDT | ☑ | CLNT | 3 | 客户端（自动） |
| TRAVELID | ☑ | INT2 | 5 | 所属旅行 |
| BOOKINGID | ☑ | INT2 | 5 | 预订编号 |
| BOOKINGDATE | | DATS | 8 | 预订日期 |
| CUSTOMERID | | INT2 | 5 | 客户 ID |
| CARRIERID | | CHAR | 3 | 航空公司 |
| CONNECTIONID | | CHAR | 4 | 航班号 |
| FLIGHTDATE | | DATS | 8 | 航班日期 |
| FLIGHTPRICE | | CURR | 13,2 | 票价 |
| CURRENCYCODE | | CUKY | 5 | 货币码 |
| BOOKINGSTATUS | | CHAR | 1 | 预订状态 |

## 与教程的差异 / 注意

- `rejecttravel` 教程只声明未给实现；本素材按 `accepttravel` 的 EML 模式补全（状态改为 X，消息「已拒绝」），可直接使用。
- `validateCustomer` 依赖客户主数据表 `ZCUSTOMER`（含字段 `customerid`）。请按培训说明创建演示表并填入客户 1–4，或改用演示客户表；否则保存含新客户的行会报「客户不存在」。
- 服务绑定是 GUI 操作（无法给文本文件），记住选 **OData V4 – UI** 即可。
