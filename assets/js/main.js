/* SAP RAP × CAP 培训站点 — 共享脚本 */
(function () {
  "use strict";

  /* ---------- 1. 语法高亮 ---------- */
  var HIGHLIGHT = {
    /* 统一的词法分类 */
    tokenize: function (code) {
      // 依次匹配：注释 / 字符串 / 注解 / 数字 / 标识符 / 空白
      var re = /(\/\*[\s\S]*?\*\/|\/\/[^\n]*|"(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*'|@[\w.]+(?:\([^)]*\))?|\b\d+(?:\.\d+)?\b|\b[A-Za-z_][\w-]*\b|\s+)/g;
      var out = [], m, last = 0;
      while ((m = re.exec(code)) !== null) {
        if (m.index > last) out.push({ t: "x", v: code.slice(last, m.index) });
        var tok = m[0], cls = clsOf(tok, m.index, code);
        out.push({ t: cls, v: tok });
        last = m.index + tok.length;
      }
      if (last < code.length) out.push({ t: "x", v: code.slice(last) });
      return out;

      function clsOf(tok, idx, src) {
        if (/^\s+$/.test(tok)) return "x";
        if (tok.charCodeAt(0) === 47 && (tok[1] === "/" || tok[1] === "*")) return "c"; // 注释
        if (tok[0] === "@") return "a";                                                  // 注解
        if (tok[0] === '"' || tok[0] === "'") return "s";                                // 字符串
        if (/^\d/.test(tok)) return "n";                                                 // 数字
        if (tok[0] === "$" || tok[0] === "#") return "p";                                // 提示符
        return "x";
      }
    },

    /* 关键字集合 */
    apply: function (node) {
      var lang = (node.className || "").match(/language-([\w-]+)/);
      lang = lang ? lang[1] : "";
      var code = node.textContent;
      var lc = lang.toLowerCase();

      // XML / HTML：只给标签名上色（属性、文本保持默认色）
      if (lc === "xml" || lc === "html") {
        node.innerHTML = esc(code).replace(/&lt;(\/?)([a-zA-Z][\w-]*)/g, '&lt;$1<span class="k">$2</span>');
        return;
      }

      var toks = this.tokenize(code);
      var html = "", i, t;

      for (i = 0; i < toks.length; i++) {
        t = toks[i];
        var cls = t.t;
        if (cls === "x") {
          var v = t.v;
          // 纯标识符 → 按语言判定关键字
          if (/^[A-Za-z_][\w-]*$/.test(v)) {
            if (lc === "cds" && /^(define|entity|service|projection|abstract|type|enum|as|from|using|key|association|to|compositions|redirected|actions|action|function|event|constraint|annotate|extend|namespace|managed|strict|autoincrement|primary|on|db)$/i.test(v)) cls = "k";
            else if (lc === "abap" && /^(modify|read|create|update|delete|entities|entity|into|from|transporting|field|fields|with|adding|mapped|failed|reported|where|corresponding|values|for|save|commit|rollback|if|endif|else|elseif|loop|endloop|data|types|constant|begin|end|of|result|initial|is|not|return|new|me|super|class|method|endmethod|interface|endinterface|importing|exporting|changing|returning|by|value|reference|private|public|protected|section|name|object|in|import|export|module)$/i.test(v)) cls = "k";
            else if (lc === "js" && /^(const|let|var|function|return|if|else|for|of|in|new|require|module|exports|await|async|class|this|typeof|delete|try|catch|finally|throw|null|undefined|true|false)$/i.test(v)) cls = "k";
            else if (lc === "java" && /^(public|private|protected|class|interface|extends|implements|new|return|if|else|for|while|switch|case|break|continue|void|int|long|short|byte|float|double|boolean|char|package|import|static|final|this|super|try|catch|finally|throw|throws|abstract|enum|record|var|null|true|false|String|Integer|Long|Boolean|Double|BigDecimal|List|Map|Set|LocalDate|LocalDateTime|Optional)$/i.test(v)) cls = "k";
            else if (lc === "bash" || lc === "console" || lc === "shell") {
              if (v === "$" || v === "#") cls = "p";
              else if (/^(cd|npm|npx|node|mkdir|ls|curl|git|echo|code|export|java|mvn)$/i.test(v) && lc !== "console") cls = "p";
            } else if (lc === "sql" && /^(select|from|where|insert|into|values|create|table|column|schema|alter|drop|add|primary|key|foreign|references|constraint|not|null|default|int|integer|bigint|nvarchar|varchar|char|date|timestamp|decimal|numeric|real|boolean|and|or|in|exists|between|like|distinct|as|inner|left|right|join|on|group|by|order|having|limit|top|count|sum|avg|min|max|case|when|then|else|end|union|set|update|delete|grant|comment|show|use|for|with|view|index|unique|asc|desc)$/i.test(v)) cls = "k";
            else if (lc === "json") {
              // JSON：键在下一非空白字符为冒号时标记
              if (t.v === "true" || t.v === "false" || t.v === "null") cls = "k";
            }
          }
        } else if (cls === "s" && lc === "json") {
          // JSON 字符串后紧跟冒号 → 键
          var rest = code.slice(idxOf(toks, i));
          if (/^\s*:/.test(rest)) cls = "j";
        }
        html += cls === "x" ? esc(t.v) : '<span class="' + cls + '">' + esc(t.v) + "</span>";
      }
      node.innerHTML = html;

      function idxOf(toks, i) {
        var n = 0, k;
        for (k = 0; k < i; k++) n += toks[k].v.length;
        return n + toks[i].v.length;
      }
    }
  };

  function esc(s) {
    return s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
  }

  /* ---------- 2. 代码块：语法高亮 + 语言标签/复制按钮 ---------- */
  function decorateBlocks() {
    var blocks = document.querySelectorAll("pre > code");
    Array.prototype.forEach.call(blocks, function (code) {
      if (code.getAttribute("data-ready")) return;
      code.setAttribute("data-ready", "1");
      var p = code.parentNode;
      // 编辑器 mockup（pre.ed）只做高亮，不加头部工具条
      var isEditor = p.classList.contains("ed") || !!p.closest(".vscode");
      HIGHLIGHT.apply(code);
      if (isEditor) return;
      var lang = (code.className.match(/language-([\w-]+)/) || [])[1] || "text";
      var head = document.createElement("div");
      head.className = "pre-head";
      var label = document.createElement("span");
      label.textContent = lang;
      var btn = document.createElement("button");
      btn.type = "button"; btn.className = "copy-btn"; btn.textContent = "复制";
      btn.addEventListener("click", function () {
        var t = document.createElement("textarea");
        t.value = code.textContent; t.style.position = "fixed"; t.style.opacity = "0";
        document.body.appendChild(t); t.select();
        try { document.execCommand("copy"); btn.textContent = "已复制 ✓"; }
        catch (e) { btn.textContent = "复制失败"; }
        document.body.removeChild(t);
        setTimeout(function () { btn.textContent = "复制"; }, 1600);
      });
      head.appendChild(label); head.appendChild(btn);
      p.insertBefore(head, p.firstChild);
    });
  }

  /* ---------- 3. 侧边导航当前高亮 ---------- */
  function highlightNav() {
    var path = location.pathname.replace(/\/+$/, "") || "/index.html";
    function norm(p) { p = p.replace(/\/+$/, ""); return p === "" ? "/index.html" : p; }
    function isHome(p) { return /(^|\/)index\.html$/i.test(p); }
    var links = document.querySelectorAll(".side-nav a");
    Array.prototype.forEach.call(links, function (a) {
      var h = a.getAttribute("href") || "";
      if (h.charAt(0) === "#") return;                    // 页内锚点不参与高亮
      var aPath = a.pathname.replace(/\/+$/, "");
      if (norm(aPath) === norm(path) || (isHome(path) && isHome(aPath))) a.classList.add("active");
    });
    var tabs = document.querySelectorAll(".topbar .tab");
    Array.prototype.forEach.call(tabs, function (a) {
      var aPath = a.pathname;
      if (aPath.indexOf("/rap/") > -1 && path.indexOf("/rap/") > -1) a.classList.add("active");
      else if (aPath.indexOf("/cap/") > -1 && path.indexOf("/cap/") > -1) a.classList.add("active");
      else if (isHome(aPath) && isHome(path)) a.classList.add("active");
    });
  }

  document.addEventListener("DOMContentLoaded", function () {
    decorateBlocks();
    highlightNav();
  });
})();
