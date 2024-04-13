// 引入 express 和 body-parser 模块
const express = require("express");
const bodyParser = require("body-parser");
const cookieParser = require("cookie-parser");

// 创建 express 应用
const app = express();

// 使用 body-parser 中间件来解析请求体
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

// 使用 cookie-parser 中间件来解析 cookie
app.use(cookieParser());

app.post("/login", (req, res) => {
  // 假设你已经验证了用户的身份，并且已经有了用户的信息
  const user = { id: 123, name: "Kira" };

  // 设置一个名为 'user' 的 cookie，值为用户的 ID
  res.cookie("user", user.id, {
    expires: new Date(Date.now() + 900000), // cookie 的过期时间
    maxAge: 900000, // cookie 会在 900000 毫秒后过期
    domain: "example.com", // cookie 的域名
    path: "/login", // cookie 的路径
    secure: true, // cookie 只能通过 HTTPS 连接发送
    httpOnly: true, // cookie 只能通过 HTTP(S) 访问，不能通过客户端 JavaScript 访问
    sameSite: "strict", // 启用 SameSite cookie
  });

  res.status(200).send(`User ${user.name} logged in`);
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
