// 引入 express 和 body-parser 模块
const express = require("express");
const cors = require("cors");

// 创建 express 应用
const app = express();

// 允许 http://www.test.com:80 的跨域请求。协议，域名，端口都必须匹配
app.get(
  "/allow-cors",
  cors({ origin: "http://www.test.com:80" }),
  (req, res) => {
    res.json({
      message: "This route allows CORS for http://www.test.com:80",
      cors: "allowed",
      origin: "http://www.test.com:80",
    });
  }
);

// 不允许跨域的请求
app.get("/disallow-cors", (req, res) => {
  res.json({
    message: "This route does not allow CORS",
    cors: "disallowed",
  });
});

// 预检请求的响应
app.options(
  "/preflight",
  cors({
    origin: ["https://www.yourdomain.com", "https://api.yourdomain.com"], // 允许的域
    methods: ["GET", "POST"], // 允许的方法
    allowedHeaders: ["Content-Type", "Authorization"], // 允许的头部
    maxAge: 3600, // 预检请求的结果可以被缓存多久（秒）
    exposedHeaders: ["Content-Length"], // 可供客户端使用的响应头部
    credentials: true, // 是否可以将 Credentials 暴露给客户端使用
  })
);

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
