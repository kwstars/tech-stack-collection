# [Webpack](https://github.com/webpack/webpack)

## 介绍

Webpack 是一个现代 JavaScript 应用程序的静态模块打包器。它将应用程序处理为一个依赖图，其中包含应用程序需要的每个模块，然后将这些模块打包成一个或多个 bundle。Webpack 可以处理 JavaScript 文件、CSS 文件、图片和字体等资源，通过加载器（loaders）和插件（plugins）提供了强大的扩展能力。

**核心概念包括：**

- **入口（Entry）**：定义了 Webpack 开始构建的起点。
- **输出（Output）**：指定 Webpack 打包后资源的输出位置和命名方式。
- **加载器（Loaders）**：Webpack 本身只理解 JavaScript，加载器可以让 Webpack 处理其他类型的文件，并将它们转换为有效的模块，以供应用程序使用以及添加到依赖图中。
- **插件（Plugins）**：插件可以用于执行范围更广的任务，如打包优化、资源管理和环境变量注入等。
- **模式（Mode）**：通过设置`development`、`production`或`none`之一，可以启用 Webpack 内置在相应环境下的优化。
- **代码分割（Code Splitting）**：允许将代码分割成不同的 bundle，可以按需加载或并行加载，以提高应用程序的性能。

Webpack 的配置高度可定制，通过`webpack.config.js`文件进行配置，这使得它可以适应各种项目需求。随着前端项目变得越来越复杂，Webpack 已成为前端开发中不可或缺的工具之一。

## 版本

- **Webpack 1.x**: 2012 - 基本模块打包功能、代码拆分、加载器和插件支持
- **Webpack 2.x**: 2017 - 支持 ES6 模块语法、动态 `import()`、Tree Shaking、改进配置和性能优化
- **Webpack 3.x**: 2017 - Scope Hoisting、模块间依赖关系优化
- **Webpack 4.x**: 2018 - 内置模式（development 和 production）、增强的性能和优化、新的插件和加载器接口、增强的 Tree Shaking
- **Webpack 5.x**: 2020 - 更好的缓存支持、持久缓存、WebAssembly 支持增强、模块联邦、改进的 Tree Shaking 和代码分割（code splitting）、更好的性能和内存使用

## [插件（Plugins）](https://webpack.js.org/plugins/)

Webpack 5 提供了大量的插件来扩展其功能，以下是一些常用的 Webpack 插件：

1. **HtmlWebpackPlugin**： 生成 HTML 文件，并自动注入打包后的资源。

   ```javascript
   const HtmlWebpackPlugin = require("html-webpack-plugin");
   new HtmlWebpackPlugin({
     template: "./src/index.html",
   });
   ```

2. **MiniCssExtractPlugin**： 将 CSS 提取到单独的文件中。

   ```javascript
   const MiniCssExtractPlugin = require("mini-css-extract-plugin");
   new MiniCssExtractPlugin({
     filename: "[name].[contenthash].css",
   });
   ```

3. **CleanWebpackPlugin**： 在每次构建前清理输出目录。

   ```javascript
   const { CleanWebpackPlugin } = require("clean-webpack-plugin");
   new CleanWebpackPlugin();
   ```

4. **TerserWebpackPlugin**： 用于压缩 JavaScript。

   ```javascript
   const TerserWebpackPlugin = require('terser-webpack-plugin');
   optimization: {
       minimize: true,
       minimizer: [new TerserWebpackPlugin()],
   }
   ```

5. **WebpackBundleAnalyzer**：分析和可视化打包内容。

   ```javascript
   const { BundleAnalyzerPlugin } = require("webpack-bundle-analyzer");
   new BundleAnalyzerPlugin();
   ```

6. **CopyWebpackPlugin**： 复制文件和目录。

   ```javascript
   const CopyWebpackPlugin = require("copy-webpack-plugin");
   new CopyWebpackPlugin({
     patterns: [{ from: "static", to: "static" }],
   });
   ```

7. **DefinePlugin**： 定义全局常量。

   ```javascript
   const webpack = require("webpack");
   new webpack.DefinePlugin({
     "process.env.NODE_ENV": JSON.stringify("production"),
   });
   ```

8. **HotModuleReplacementPlugin**： 模块热替换。

   ```javascript
   const webpack = require("webpack");
   new webpack.HotModuleReplacementPlugin();
   ```

9. **OptimizeCSSAssetsWebpackPlugin**： 压缩 CSS 资源。

   ```javascript
   const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
   optimization: {
       minimizer: [new OptimizeCSSAssetsPlugin({})],
   }
   ```

10. **CompressionWebpackPlugin**： 压缩输出文件（例如 gzip）。
    ```javascript
    const CompressionWebpackPlugin = require("compression-webpack-plugin");
    new CompressionWebpackPlugin({
      algorithm: "gzip",
    });
    ```

### 具名导出和具名导入

```javascript
const { CleanWebpackPlugin } = require("clean-webpack-plugin");
```

这种形式的导入称为“具名导入”，适用于从模块中导入一个或多个具名导出的成员。在 `clean-webpack-plugin` 模块中，导出是具名的：

```javascript
module.exports = {
  CleanWebpackPlugin: CleanWebpackPlugin,
};
```

### 默认导出和默认导入

```javascript
const TerserWebpackPlugin = require("terser-webpack-plugin");
```

这种形式的导入称为“默认导入”，适用于从模块中导入默认导出的成员。在 `terser-webpack-plugin` 模块中，导出是默认的：

```javascript
module.exports = TerserWebpackPlugin;
```

## [Babel](https://babeljs.io/docs)

Babel 是一个广泛使用的 JavaScript 编译器，用于将现代 JavaScript 代码转换为与旧版本浏览器和运行环境兼容的代码。通过 Babel，开发者可以使用最新的 JavaScript 语法和特性，而无需担心它们是否被所有目标环境所支持。下面是 Babel 的一些关键点和功能介绍：

### Babel 的关键功能

1. **语法转换**： Babel 可以将现代 JavaScript 语法（如 ES6、ES7 等）转换为较旧版本的 JavaScript 语法。这样，即使是运行在不支持新语法的环境中的代码，也能正常工作。
2. **Polyfill**：Babel 提供了对新 JavaScript 特性（如 Promise、Set、Map 等）的 polyfill 支持。使用 @babel/polyfill，可以确保这些新特性在旧环境中也能使用。
3. **插件和预设**：Babel 使用插件和预设来定义要转换的代码类型。插件是 Babel 的核心部分，用于转换特定的语法。预设是一组插件的集合，可以快速配置 Babel 以转换某种类型的代码。
4. **代码优化**：Babel 可以通过一些插件（如 minify 和 dead-code elimination）对代码进行优化，减少代码体积，提高运行效率。

### 常用的 Babel 插件和预设

- **@babel/preset-env**：自动确定需要哪些插件来转换你的代码，以支持目标环境。
- **@babel/plugin-transform-runtime**：减少重复的辅助代码，提高代码性能。
- **@babel/plugin-proposal-class-properties**：支持类属性语法。
- **@babel/plugin-proposal-object-rest-spread**：支持对象扩展和剩余属性语法。

## 参考和引用

- https://github.com/yuhaoju/webpack-config-handbook
- https://www.bilibili.com/video/BV1kP41177wp
- https://stackoverflow.com/questions/37452402/webpack-loaders-vs-plugins-whats-the-difference
- https://github.com/developit/optimize-plugin
- https://github.com/jamiebuilds/the-super-tiny-compiler
