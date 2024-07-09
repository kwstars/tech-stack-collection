const { merge } = require("webpack-merge"); // 引入 webpack-merge 用于合并配置
const common = require("./webpack.common.js"); // 引入通用配置

module.exports = merge(common, {
  mode: "production", // 设置模式为生产环境
  // none：如果不需要源映射，这可以减少构建大小和构建时间。
  // source-map：如果需要源映射来进行错误追踪，这是一个好选项，因为它生成的源映射是独立的文件，不会增加bundle的大小。但是，它会稍微增加构建过程的时间。
  // hidden-source-map：与source-map相似，但是不会为bundle添加引用注释。这对于想生成源映射以用于错误追踪服务，但又不想在客户端暴露源映射的情况下很有用。
  devtool: "source-map", // 生成 source map，便于调试。
  optimization: {
    minimize: true, // 启用压缩以减小产出文件的大小
  },
});
