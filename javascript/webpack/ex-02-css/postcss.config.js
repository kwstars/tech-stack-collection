// module.exports = {
//   plugins: [require("autoprefixer")],
// };
module.exports = {
  plugins: [
    // 使用 postcss-preset-env 插件，允许使用未来的 CSS 特性
    require("postcss-preset-env")({
      stage: 3, // 使用 stage 3 的 CSS 特性，意味着这些特性已经较为稳定
      features: {
        "nesting-rules": true, // 启用嵌套规则特性，类似于 Sass/Less 的嵌套
      },
      autoprefixer: { grid: true }, // 启用自动前缀，并特别支持网格布局的前缀处理
    }),
    // 根据环境变量 NODE_ENV 判断是否在生产环境，如果是，则使用 cssnano 插件压缩 CSS
    ...(process.env.NODE_ENV === "production" ? [require("cssnano")] : []),
  ],
};
