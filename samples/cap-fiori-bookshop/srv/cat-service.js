// srv/cat-service.js —— 业务逻辑（服务层）
// 与《CAP 培训》手顺3（第5章）一致；差异：after READ 里补充 criticality 计算（Fiori F4 状态徽标）。
// 涵盖：before（参数校验）、on（核心逻辑 + 事务）、function（GET 只读）、after（结果加工）。
const cds = require('@sap/cds')

module.exports = (srv) => {
  srv.on('READ', 'Books', (req) => {
    console.log('-> Reading books...')
  })

  // ① before：在 on 之前执行 —— 参数校验
  srv.before('submitOrder', (req) => {
    const { quantity } = req.data
    if (!Number.isInteger(quantity) || quantity <= 0) {
      return req.reject(400, `quantity must be a positive integer, got: ${quantity}`)
    }
  })

  // ② on：核心业务逻辑 —— 库存规则校验 + 多步写入（同一事务，任一步失败全部回滚）
  srv.on('submitOrder', async (req) => {
    const { book, quantity } = req.data
    const { Books, Orders } = cds.entities
    const bookRecord = await SELECT.one.from(Books).where({ ID: book })
    if (!bookRecord) return req.reject(404, `Book #${book} not found`)
    if (quantity > bookRecord.stock) {
      return req.reject(400, `${quantity} exceeds stock for book #${book}`)
    }
    await UPDATE(Books).set({ stock: bookRecord.stock - quantity }).where({ ID: book })
    await INSERT.into(Orders).entries({ book_ID: book, quantity, total: bookRecord.price * quantity })
    return { updated: quantity }
  })

  // ③ function：GET 语义的自定义函数 —— 只读、无副作用
  srv.on('stockOf', async (req) => {
    const { book } = req.data
    const bookRecord = await SELECT.one.from(cds.entities.Books).where({ ID: book })
    return bookRecord ? bookRecord.stock : 0
  })

  srv.after('READ', 'Books', (each) => {
    if (each.stock > 100) each.title += ' -- 畅销'
    // 状态徽标：0 → 售罄(3)，<20 → 紧张(2)，否则 → 充足(1)
    each.criticality = each.stock <= 0 ? 3 : each.stock < 20 ? 2 : 1
  })
}
