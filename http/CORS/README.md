CORS (Cross-Origin Resource Sharing) 是一种安全机制，它允许一个网页的许多资源（例如字体、JavaScript 等）能够被其他源（协议、域名、端口必须相同）所访问。以下是一些关于 CORS 的主要知识点：

1. **简单请求与预检请求**：简单请求是指使用 GET、HEAD 或 POST 方法的请求，并且没有使用自定义头部，POST 请求的内容类型只能是 `text/plain`、`multipart/form-data` 或 `application/x-www-form-urlencoded`。所有其他类型的请求都被视为非简单请求，它们会先发送一个预检请求（OPTIONS 请求），以检查实际请求是否安全。

2. **Access-Control-Allow-Origin**：这个响应头部指定了哪些源可以访问资源。它可以设置为一个具体的源，或者 `*` 来允许所有源。

3. **Access-Control-Allow-Credentials**：这个响应头部指定了是否允许浏览器在跨源请求中携带凭证（例如 cookies 或 HTTP 认证信息）。默认情况下，跨源请求不会携带凭证。

4. **Access-Control-Allow-Methods**：这个响应头部指定了哪些 HTTP 方法可以用来访问资源。

5. **Access-Control-Allow-Headers**：这个响应头部指定了哪些 HTTP 头部可以用在实际的请求中。

6. **Access-Control-Max-Age**：这个响应头部指定了预检请求的结果可以被缓存多久。

7. **Access-Control-Expose-Headers**：这个响应头部指定了哪些头部可以被浏览器的 JavaScript 代码访问。

以上就是关于 CORS 的一些主要知识点。如果你想了解更多关于 CORS 的信息，你可以访问 [MDN 的 CORS 文档](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS)。
