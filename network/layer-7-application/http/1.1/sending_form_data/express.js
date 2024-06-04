// 引入 express 和 body-parser 模块
const express = require("express");
const bodyParser = require("body-parser");
const multer = require("multer");
const upload = multer();

// 创建 express 应用
const app = express();

// 使用 body-parser 中间件来解析请求体
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

// 定义 POST 路由处理 /sendhttpreq 请求
app.post("/sendhttpreq", (req, res) => {
  console.log("POST 请求数据：", req.body);
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

// 定义 GET 路由处理 /sendhttpreq 请求
app.get("/sendhttpreq", (req, res) => {
  console.log("GET 请求数据：", req.query);
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

// 定义 POST 路由处理 /upload 请求，使用 multer 中间件处理 multipart/form-data 编码的数据
app.post("/upload", upload.any(), (req, res) => {
  console.log("POST 请求数据（multipart/form-data）：", req.body);
  res.send(
    `<pre>${JSON.stringify(
      {
        url: req.url,
        method: req.method,
        headers: req.headers,
        body: req.body,
        files: req.files,
      },
      null,
      2
    )}</pre>`
  );
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
