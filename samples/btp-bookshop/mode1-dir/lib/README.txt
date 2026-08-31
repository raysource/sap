lib/ 目录需要放置 SAP HANA 的 JDBC 驱动 ngdbc.jar（二进制不随素材包提供）。

下载：
  1. 打开 Maven Central 的 ngdbc 页面
     https://central.sonatype.com/artifact/com.sap.cloud.db.jdbc/ngdbc
  2. 记下当前版本号（如 2.28.8）
  3. 下载对应 jar：https://repo1.maven.org/maven2/com/sap/cloud/db/jdbc/ngdbc/2.28.8/ngdbc-2.28.8.jar
  4. 放到本目录（lib/）并重命名为 ngdbc.jar

也可用 curl 直接下载（版本号以 Maven Central 为准，替换下面 URL 中的 2.28.8）：

  curl -L -o lib/ngdbc.jar \
    https://repo1.maven.org/maven2/com/sap/cloud/db/jdbc/ngdbc/2.28.8/ngdbc-2.28.8.jar
