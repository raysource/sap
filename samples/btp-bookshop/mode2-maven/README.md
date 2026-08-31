# 模式二 · Maven 工程

用 `mvn archetype:generate` 生成骨架，覆盖 `pom.xml` / `App.java` 后
用 `mvn compile exec:java` 运行。

## 步骤

1. 生成骨架（交互式参数用 `-DinteractiveMode=false` 跳过提问）：

```bash
mvn archetype:generate \
  -DarchetypeGroupId=org.apache.maven.archetypes \
  -DarchetypeArtifactId=maven-archetype-quickstart \
  -DarchetypeVersion=1.4 \
  -DgroupId=com.acme.bookshop \
  -DartifactId=bookshop-maven \
  -DinteractiveMode=false
cd bookshop-maven
```

2. 用本目录文件覆盖：
   - `pom.xml` → 项目根目录（已加 ngdbc 依赖 + exec 插件）
   - `App.java` → `src/main/java/com/acme/bookshop/App.java`
     （archetype 生成的 Hello 类可删除）

3. 编辑 `App.java`：把 `HOST`、`PASSWORD` 换成 B3 章记录的值。

4. 运行：

```bash
mvn compile exec:java
```

期望输出 `共读取 10 本书（BOOKSHOP.BOOKS）` + 表头 + 10 行。

> 用 `mvn compile exec:java` 而不是 `mvn package`：archetype 骨架默认带一个
> 会失败的测试类，直接跑 main 更省事。

## 对应章节

B7（`cap/btp/step5-maven.html`）。
