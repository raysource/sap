import com.sap.gateway.ip.core.customdev.util.Message

// ==== 常用小片段（第 I6 章）====
// 全部片段都要求方法签名：def Message processData(Message message)

// —— 读 / 写 header 与 property ——
def hd = message.getHeaders()
def props = message.getProperties()
def trace = hd.get('X-TraceId')            // 读入站请求头
message.setProperty('sourceSystem', 'shop') // 写 exchange property（仅流内可见）
message.setHeader('X-Route', 'urgent')      // 写 header（会发给接收方）

// —— 把 XML 按 XPath 取文本（无命名空间版本）——
def xml = new XmlSlurper().parseText(message.getBody(java.lang.String) as String)
message.setProperty('orderType', xml.type.text())

// —— 读回自己前面步骤（Content Modifier 等）存的 property ——
def amount = props.get('computedAmount')
if (amount == null) {
    throw new RuntimeException('缺少 computedAmount，检查前序步骤')
}

return message
