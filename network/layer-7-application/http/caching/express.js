// 引入 express 和 body-parser 模块
const express = require("express");

// 创建 express 应用
const app = express();

// 设置静态资源目录，并设置 Cache-Control 头部
// "Cache busting" 是一种通过改变文件的 URL（通常通过在文件名或查询参数中添加版本号或哈希值）来强制浏览器获取新版本文件，而不是使用缓存中的旧版本的技术。
// 例如，你可能会看到类似这样的 URL：/js/script.v2.js 或者 /js/script.js?version=2。这里的 v2 和 version=2 就是 "cache busting" 的一部分，它们确保了每次 script.js 文件更新时，用户都能获取到最新的版本。
app.use(
  "/assets",
  express.static("public", {
    setHeaders: (res, path) => {
      res.set("Cache-Control", "max-age=31536000, immutable"); // 设置 max-age 和 immutable
    },
  })
);

// 设置首页，并设置 Cache-Control 头部
app.get("/index.html", (req, res) => {
  res.set("Cache-Control", "no-cache"); // 设置 no-cache
  res.sendFile(__dirname + "/index.html");
});

// ------ Cache 优先级 ------
// s-maxage：这是一个 Cache-Control 指令，它优先级最高，用于共享缓存（例如 CDN）。
app.get("/s-maxage", (req, res) => {
  res.set("Cache-Control", "s-maxage=3600"); // 设置缓存有效期为 1 小时
  res.send("This is s-maxage cache control");
});

// max-age：这也是一个 Cache-Control 指令，它用于私有缓存（例如浏览器）。如果 s-maxage 和 max-age 同时存在，s-maxage 会被优先考虑。
app.get("/max-age", (req, res) => {
  res.set("Cache-Control", "max-age=3600"); // 设置缓存有效期为 1 小时
  res.send("This is max-age cache control");
});

// Expires：这是一个 HTTP/1.0 的特性，它设置一个绝对的过期时间。如果同时设置了 max-age 或 s-maxage，那么 max-age 或 s-maxage 会优先使用。
app.get("/expires", (req, res) => {
  res.set("Expires", new Date(Date.now() + 3600000).toUTCString()); // 设置缓存有效期为 1 小时
  res.send("This is Expires cache control");
});

// Last-Modified：如果没有设置以上任何一个头部，那么浏览器会根据最后修改时间（Last-Modified）和首次获取时间来预估一个过期时间。这通常是首次获取时间和最后修改时间的 10%【RFC7234：(DownloadTime-LastModified)*10%】。这是优先级最低的缓存策略。
app.get("/last-modified", (req, res) => {
  res.set("Last-Modified", new Date().toUTCString()); // 设置最后修改时间
  res.send("This is Last-Modified cache control");
});

// 测试优先级
app.get("/test-priority", (req, res) => {
  res.set("Cache-Control", "s-maxage=3600, max-age=1800"); // 设置 s-maxage 和 max-age
  res.set("Expires", new Date(Date.now() + 1200000).toUTCString()); // 设置 Expires
  res.set("Last-Modified", new Date().toUTCString()); // 设置 Last-Modified
  res.send("This is a test for cache control priority");
});

// ------ Cache-Control 使用案例 ------
// no-store：这是一个 Cache-Control 指令，它告诉浏览器不要缓存这个响应。这个响应不会被存储在缓存中，也不会被返回。
app.get("/no-store", (req, res) => {
  res.set("Cache-Control", "no-store"); // 设置 no-store
  res.send("This response should not be stored by any cache");
});

// Cache busting

// 设置动态生成的内容，大多数 HTTP/1.0 缓存不支持 no-cache 指令，因此历史上使用 max-age=0 作为解决方法。
app.get("/dynamic-must-revalidate", (req, res) => {
  res.set("Cache-Control", "max-age=0, must-revalidate"); // 设置 max-age=0, must-revalidate
  res.send("This is dynamically generated content");
});

// proxy-revalidate 指令告诉代理服务器，即使响应已经过期，只要源服务器验证了响应的新鲜度，代理服务器就可以使用它的缓存。
app.get("/proxy-revalidate", (req, res) => {
  res.set("Cache-Control", "proxy-revalidate"); // proxy-revalidate
  res.send("This response should be revalidated by proxy caches");
});

app.get("/clear-site-data", (req, res) => {
  res.set(
    "Clear-Site-Data",
    '"cache", "cookies", "storage", "executionContexts"'
  ); // 清除所有数据
  res.send("All site data has been cleared");
});

// public 指令告诉所有的缓存（包括私有缓存如浏览器和共享缓存如代理服务器）都可以缓存这个响应。
app.get("/public", (req, res) => {
  res.set("Cache-Control", "public, max-age=3600"); // 设置 public 和 max-age
  res.send(
    "This response is public and can be cached by both private and shared caches"
  );
});

// private 指令告诉代理服务器（共享缓存）不能缓存这个响应，只有客户端（私有缓存）可以缓存。这对于包含敏感信息的响应非常有用。
// 如果你想指定某些头部不能被缓存，你可以在 private 后面添加这些头部的名称，如 private="Set-Cookie"。这会告诉代理服务器不能缓存 Set-Cookie 头部，但可以缓存响应的其他部分。
app.get("/private", (req, res) => {
  res.set("Cache-Control", "private, max-age=3600"); // 设置 private 和 max-age
  res.send("This response is private and cannot be cached by shared caches");
});

// 缓存 404 响应
app.get("/not-found", (req, res) => {
  res.status(404); // 设置状态码为 404
  res.set("Cache-Control", "public, max-age=3600"); // 设置 public 和 max-age
  res.send("This 404 response is public and can be cached for 1 hour");
});

// 缓存 206 响应
app.get("/partial-content", (req, res) => {
  res.status(206); // 设置状态码为 206
  res.set("Cache-Control", "public, max-age=3600"); // 设置 public 和 max-age
  res.send("This 206 response is public and can be cached for 1 hour");
});

// 作用：Vary 响应头部用于告诉缓存服务器哪些请求头部会影响响应的内容。例如，如果一个响应的内容会根据 User-Agent 头部的不同而变化，那么服务器应该在响应中包含 Vary: User-Agent，这样缓存服务器就知道需要为每种 User-Agent 保存一个单独的缓存。
app.get("/user-agent", (req, res) => {
  res.set("Vary", "User-Agent");
  res.send("Response varies with User-Agent");
});

// 设置 Vary: Accept-Language
// https://www.keycdn.com/support/vary-header
// https://www.holisticseo.digital/pagespeed/vary-header/
app.get("/accept-language", (req, res) => {
  res.set("Vary", "Accept-Language");
  res.send("Response varies with Accept-Language");
});

// 多个值：Vary 可以包含多个值，例如 Vary: Accept-Language, User-Agent。这表示响应的内容可能会根据 Accept-Language 和 User-Agent 头部的不同而变化。
app.get("/multiple", (req, res) => {
  res.set("Vary", "User-Agent, Accept-Language");
  res.send("Response varies with User-Agent and Accept-Language");
});

// 使用 *：如果响应的内容可能会根据任何请求头部的不同而变化，可以使用 Vary: *。但是这会使缓存效果大大降低，因为缓存服务器必须为每个唯一的请求保存一个单独的缓存。
// 影响缓存：如果没有正确使用 Vary，可能会导致缓存问题。例如，如果服务器忘记包含 Vary: User-Agent，缓存服务器可能会将为一个 User-Agent 生成的响应错误地返回给另一个 User-Agent。
app.get("/all", (req, res) => {
  res.set("Vary", "*");
  res.send("Response varies with all headers");
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
