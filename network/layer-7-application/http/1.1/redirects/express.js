// 引入 express 和 body-parser 模块
const express = require("express");
const bodyParser = require("body-parser");

// 创建 express 应用
const app = express();

// 使用 body-parser 中间件来解析请求体
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

// 创建一个测试接口，响应 "Hello, World!"
app.get("/", domainAliasMiddleware, (req, res) => {
  res.send("Hello, World!");
});

// 域名别名中间件
function domainAliasMiddleware(req, res, next) {
  // 如果访问的是 example.com，重定向到 www.example.com
  if (req.hostname === "example.com") {
    return res.redirect(301, "http://www.example.com" + req.originalUrl);
  }

  // 如果访问的是 old-example.com，重定向到 new-example.com
  if (req.hostname === "old-example.com") {
    return res.redirect(301, "http://new-example.com" + req.originalUrl);
  }

  // 如果访问的是 http 版本的网站，重定向到 https 版本
  // if (req.protocol === "http") {
  //   return res.redirect(301, "https://" + req.hostname + req.originalUrl);
  // }

  // 如果不需要重定向，继续处理后续的请求
  next();
}

// 使用域名别名中间件
// app.use(domainAliasMiddleware);

app.get("/new-url", (req, res) => {
  console.log("GET 请求数据 /new-url", req.query);
  res.send(
    `<pre>${JSON.stringify(
      {
        url: req.url,
        method: req.method,
        headers: req.headers,
        query: req.query,
      },
      null,
      2
    )}</pre>`
  );
});

app.post("/new-url", (req, res) => {
  console.log("POST 请求数据 /new-url：", req.body);
  res.send(
    `<pre>${JSON.stringify(
      {
        url: req.url,
        method: req.method,
        headers: req.headers,
        body: req.body,
      },
      null,
      2
    )}</pre>`
  );
});

// ------ Permanent Redirects 游览器会缓存 ------
app.post("/old-url-301", (req, res) => {
  console.log("old-url-301");
  // 301（HTTP/1.0）：这种类型的重定向通常会将原始请求转换为 GET 方法，无论原始请求使用的是什么方法。这是由于历史原因，一些浏览器在处理 301 重定向时会将 POST 请求改为 GET 请求。
  res.redirect(301, "/new-url");
});

app.post("/old-url-308", (req, res) => {
  console.log("old-url-308");
  // 308（HTTP/1.1）：这种类型的重定向要求必须使用原始请求的方法和包体来发起新的请求。换句话说，如果原始请求是 POST 方法，那么重定向后的请求也必须是 POST 方法，并且包体内容保持不变。
  res.redirect(308, "/new-url");
});

// ------ Temporary Redirects 游览器不会缓存------
app.post("/old-url-302", (req, res) => {
  console.log("old-url-302");
  // 302 (HTTP/1.0)：通常情况下，重定向请求会使用 GET 方法，而不论原始请求使用了何种方法。这是由于历史原因，一些浏览器在处理 302 重定向时会将 POST 请求改为 GET 请求。
  res.redirect(302, "/new-url");
});

app.post("/old-url-303", (req, res) => {
  console.log("old-url-303");
  // 303 (HTTP/1.1)：它并不表示资源已移动，而是为了响应原始请求而使用新的 URI 进行服务。重定向请求通常会使用 GET 方法，例如表单提交后向用户返回新内容（同时也能防止重复提交）。
  res.redirect(303, "/new-url");
});

app.post("/old-url-307", (req, res) => {
  console.log("old-url-307");
  // 307 (HTTP/1.1)：重定向请求必须使用原请求的方法和请求体发起访问。换句话说，如果原始请求是 POST 方法，那么重定向后的请求也必须是 POST 方法，并且请求体内容保持不变。
  res.redirect(307, "/new-url");
});

// ------ Special Redirects ------
// 300 Multiple Choices
app.get("/old-url-300", (req, res) => {
  // 假设我们有两种资源表述，HTML 和 JSON
  const accept = req.headers.accept;
  if (accept.includes("application/json")) {
    res.redirect(300, "/new-url-json");
  } else if (accept.includes("text/html")) {
    res.redirect(300, "/new-url-html");
  } else {
    res.status(300).send("Multiple Choices");
  }
});

// 304 Not Modified
app.get("/old-url-304", (req, res) => {
  // 假设我们有一个 ETag 或 Last-Modified 头部用于缓存验证
  const ifNoneMatch = req.headers["if-none-match"];
  const ifModifiedSince = req.headers["if-modified-since"];
  if (ifNoneMatch === "your-etag" || ifModifiedSince === "your-last-modified") {
    res.status(304).end();
  } else {
    res.send("Your content");
  }
});

// 创建一个服务器
const server = app.listen(3000, () => {
  console.log("服务器已启动，监听 3000 端口");
});

// 监听SIGTERM信号
process.on("SIGTERM", () => {
  console.log("收到SIGTERM信号，开始关闭服务器");

  server.close(() => {
    console.log("服务器已关闭");
    // 退出进程
    process.exit(0);
  });
});
