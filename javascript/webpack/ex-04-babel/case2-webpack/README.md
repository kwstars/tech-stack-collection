### Babel 相关

- **@babel/core**: Babel 的核心包，用于编译 JavaScript 代码。
- **@babel/preset-env**: 一个智能预设，用于根据目标环境转换最新的 JavaScript 代码。
- **babel-loader**: Webpack 的加载器，用于在构建过程中使用 Babel 转换 JavaScript 代码。

### Webpack 插件

- **clean-webpack-plugin**: 在每次构建前清理 `dist` 目录，保持输出目录干净。
- **html-webpack-plugin**: 自动生成 `index.html` 文件，并将生成的 JS 文件自动注入其中。

### Webpack 核心

- **webpack**: 一个用于打包 JavaScript 文件的工具，可以将各种资源（如 JavaScript、CSS、图像等）作为模块打包到一起。
- **webpack-cli**: 提供命令行界面，用于运行 Webpack 编译任务。
- **webpack-dev-server**: 提供开发服务器，支持热模块替换，方便开发过程中实时预览代码修改效果。

## webpack-dev-server

webpack-dev-server 提供了一个 HTTP 服务器，它将编译后的 Webpack 包提供给浏览器，同时支持实时重新加载和热模块替换（Hot Module Replacement，HMR），从而提高开发效率。

### 基本原理

`webpack-dev-server` 提供了一个 HTTP 服务器，它将编译后的 Webpack 包提供给浏览器，同时支持实时重新加载和热模块替换（Hot Module Replacement，HMR），从而提高开发效率。

### 主要功能

1. **提供静态文件服务**:`webpack-dev-server` 创建一个 HTTP 服务器，并在指定的端口上提供服务。默认情况下，它会服务于 Webpack 输出目录中的文件（通常是 `dist` 目录）。
2. **实时重新加载（Live Reload）**: 每当源文件发生变化时，Webpack 会重新编译这些文件，并通过 `webpack-dev-server` 提供的新版本的文件。在文件变化后，浏览器会自动刷新以加载最新的文件。
3. **热模块替换（Hot Module Replacement, HMR）**: HMR 是一种更高级的功能，它允许在不完全刷新浏览器的情况下，替换、添加或删除模块。这对保持应用程序状态非常有用，比如不刷新整个页面的情况下只更新某个模块。

### 工作机制

1. **启动服务器**:当运行 `webpack-dev-server` 时，它会启动一个 Express 服务器，并监听配置的端口。
2. **内存中的文件系统**: `webpack-dev-server` 使用 `memory-fs` 模块将编译后的文件存储在内存中，而不是写入到实际的文件系统。这提高了速度，因为不需要进行磁盘 I/O 操作。
3. **与 Webpack 通信**: `webpack-dev-server` 使用 Webpack 的编译器和观察者（watcher）功能来监视文件变化。每当源文件发生变化时，Webpack 会重新编译并生成新的包。
4. **提供文件和资源**:编译后的文件通过 `webpack-dev-server` 提供给浏览器。当浏览器请求这些文件时，服务器会从内存中读取并提供相应的文件。
5. **启用 HMR**:如果配置了 HMR，当源文件发生变化时，`webpack-dev-server` 会通过 WebSocket 向客户端发送更新信号。客户端会接收更新并应用新的模块，而无需刷新整个页面。
