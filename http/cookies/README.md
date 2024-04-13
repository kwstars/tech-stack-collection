HTTP cookies 是服务器发送到用户浏览器并保存在本地的一小块数据，它们在浏览器下一次向同一服务器发出请求时会被携带并发送回去。这主要用于让服务器记住有关用户信息的一些细节。以下是一些关于 HTTP cookies 的主要知识点：

1. **创建和设置 Cookies**：服务器可以通过在 HTTP 响应中包含 `Set-Cookie` 头部来创建和设置 cookies。每个 `Set-Cookie` 头部包含一个 cookie 的名称和值，以及一些可选的属性，如 `Expires`、`Max-Age`、`Domain`、`Path`、`Secure` 和 `HttpOnly`。

2. **读取 Cookies**：当浏览器向服务器发送请求时，它会包含一个 `Cookie` 头部，其中包含服务器之前设置的所有 cookies。服务器可以读取这个头部来获取 cookies 的值。

3. **删除 Cookies**：要删除一个 cookie，服务器可以发送一个新的 `Set-Cookie` 头部，将 cookie 的 `Expires` 属性设置为过去的日期。

4. **Secure 和 HttpOnly 属性**：`Secure` 属性表示 cookie 只能通过 HTTPS 连接发送，这可以防止 cookie 被拦截。`HttpOnly` 属性表示 cookie 不能通过客户端 JavaScript 访问，这可以防止跨站脚本攻击（XSS）。

5. **SameSite 属性**：`SameSite` 属性可以防止跨站请求伪造攻击（CSRF）。它有三个可能的值：`Strict`、`Lax` 和 `None`。

6. **第三方 Cookies**：第三方 cookies 是由不是当前网页原始站点的域设置的 cookies。它们通常用于跟踪用户行为和在线广告。

7. **会话 Cookies 和持久性 Cookies**：会话 cookies 是临时的 cookies，当用户关闭浏览器时，它们会被删除。持久性 cookies 有一个特定的过期日期，即使用户关闭浏览器，它们也会保留在用户的设备上，直到达到过期日期。

8. **Cookies 的大小和数量限制**：每个域的 cookies 总大小通常限制为 4KB。大多数浏览器限制每个域可以设置的 cookies 数量为 50 个，但这个数字可能会根据浏览器的不同而变化。
