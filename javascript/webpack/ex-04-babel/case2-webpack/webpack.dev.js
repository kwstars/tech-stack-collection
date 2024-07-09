const { merge } = require("webpack-merge"); // 引入 webpack-merge 用于合并基础配置
const common = require("./webpack.common.js"); // 引入通用配置文件
const path = require("path"); // 引入 path 模块，用于处理文件路径

module.exports = merge(common, {
  mode: "development", // 设置模式为开发环境
  devtool: "inline-source-map", // 使用内联源映射，便于调试
  devServer: {
    static: path.join(__dirname, "dist"), // 指定托管的静态文件目录
    compress: true, // 启用 gzip 压缩
    port: 9000, // 设置开发服务器的端口号
    hot: true, // 启用模块热替换功能
    open: true, // 开发服务器启动时自动打开浏览器
  },
});
