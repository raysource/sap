import com.sap.gateway.ip.core.customdev.util.Message
import groovy.json.JsonSlurper
import groovy.json.JsonOutput
import java.math.RoundingMode

/**
 * iFlow order-transform 的处理脚本（第 I4 章手顺2）
 * 输入 JSON 订单：{"book":1,"title":"Wuthering Heights","qty":2,"price":11.11}
 * 输出：原字段 + 计算的 amount（单价×数量，BigDecimal 四舍五入到分）
 * 并顺手写入 exchange property computedAmount 与 header X-Amount
 */
def Message processData(Message message) {
    // ① 读入站消息体（按 String 读，再解析成 JSON）
    def body = message.getBody(java.lang.String) as String
    def order = new JsonSlurper().parseText(body)

    // ② 业务计算：金额 = 单价 × 数量（BigDecimal 避免浮点误差）
    def amount = (order.price as BigDecimal)
        .multiply(new BigDecimal(order.qty as Integer))
        .setScale(2, RoundingMode.HALF_UP)

    // ③ 组装出站 body（JSON）
    def out = [
        book: order.book as Integer,
        title: order.title as String,
        qty: order.qty as Integer,
        amount: amount,
        status: 'OK'
    ]
    message.setBody(JsonOutput.toJson(out))

    // ④ 存 property / header，供后续步骤或接收方使用
    message.setProperty('computedAmount', amount.toString())
    message.setHeader('X-Amount', amount.toString())
    return message
}
