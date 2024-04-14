// 引入 express 和 body-parser 模块
const express = require("express");

// 创建 express 应用
const app = express();

let resource = {
  data: "Hello, world!",
  lastModified: new Date().toUTCString(),
  etag: "12345", // 假设的 ETag 值，实际应用中应该动态生成
};

app.get("/storage-validator", (req, res) => {
  // 检查 If-None-Match 请求头
  if (req.headers["if-none-match"] === resource.etag) {
    res.status(304).end();
  } else {
    res.set("ETag", resource.etag);
    res.send(resource.data);
  }
});

app.get("/weak-validator", (req, res) => {
  // 检查 If-Modified-Since 请求头
  if (req.headers["if-modified-since"] === resource.lastModified) {
    res.status(304).end();
  } else {
    res.set("Last-Modified", resource.lastModified);
    res.send(resource.data);
  }
});

// ------  Cache Update ------
// https://developer.mozilla.org/en-US/docs/Web/HTTP/Conditional_requests#cache_update
// 首次缓存
app.get("/first-time-cache", (req, res) => {
  // res.set("Cache-Control", "public, max-age=3600"); // 设置缓存控制头部
  res.set("ETag", resource.etag); // 设置 ETag
  res.set("Last-Modified", resource.lastModified); // 设置 Last-Modified
  res.send(resource.data);
});

// 验证缓存
app.get("/validate-cache", (req, res) => {
  let ifNoneMatch = req.headers["if-none-match"];
  try {
    ifNoneMatch = JSON.parse(ifNoneMatch);
  } catch (error) {
    console.error("Failed to parse If-None-Match header:", error);
  }

  console.log("ifNoneMatch", ifNoneMatch);
  console.log("resource.etag", resource.etag);

  // 检查 If-None-Match 和 If-Modified-Since 请求头
  if (ifNoneMatch === `${resource.etag}`) {
    res.status(304).end();
  } else {
    res.set("ETag", resource.etag);
    res.set("Last-Modified", resource.lastModified); // 设置 Last-Modified
    res.send(resource.data);
  }
});

// ------ Integrity of a partial download ------
// https://developer.mozilla.org/en-US/docs/Web/HTTP/Conditional_requests#integrity_of_a_partial_download
app.get("/partial", (req, res) => {
  const range = req.headers.range; // 获取 Range 请求头
  let ifRange = req.headers["if-range"];
  let ifNoneMatch = req.headers["if-none-match"];

  // 如果 If-Range 请求头存在
  if (ifRange) {
    // 如果 If-Range 请求头的值等于资源的 ETag
    if (ifRange === resource.etag) {
      // 返回状态码 206 和请求的资源部分
      const [start, end] = range.replace(/bytes=/, "").split("-");
      const part = resource.data.slice(Number(start), Number(end) + 1);
      res.status(206).send(part);
    } else {
      // 返回状态码 200 和整个资源
      res.status(200).send(resource.data);
    }
  } else if (ifNoneMatch) {
    // 如果 If-None-Match 请求头的值等于资源的 ETag
    if (ifNoneMatch === resource.etag) {
      // 返回状态码 304，表示资源没有改变
      res.status(304).end();
    } else {
      // 返回状态码 412
      res.status(412).end();
    }
  } else {
    // 如果 If-Range 和 If-None-Match 请求头都不存在
    if (range) {
      // 如果 Range 请求头存在，返回请求的资源部分
      const [start, end] = range.replace(/bytes=/, "").split("-");
      const part = resource.data.slice(Number(start), Number(end) + 1);
      res.status(206).send(part);
    } else {
      // 如果 Range 请求头不存在，返回整个资源
      res.status(200).send(resource.data);
    }
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
