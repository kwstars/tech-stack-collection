### CSS 预处理器

- **less**: LESS 是一种动态样式表语言，提供变量、嵌套规则、混合等功能，使 CSS 更加易于维护和扩展。
- **sass**: Sass 是一种成熟的、稳定的、强大的 CSS 扩展语言，提供嵌套规则、变量、混合、继承等功能。
- **stylus**: Stylus 是一种富有表现力、动态的、健壮的 CSS 预处理器语言，提供类似 LESS 和 Sass 的功能。

### 预处理器加载器

- **less-loader**: 用于在 Webpack 中编译 LESS 文件，将其转换为 CSS。需要 less 包。
- **sass-loader**: 用于在 Webpack 中编译 Sass/SCSS 文件，将其转换为 CSS。需要 sass 包。
- **stylus-loader**: 用于在 Webpack 中编译 Stylus 文件，将其转换为 CSS。需要 stylus 包。

### CSS 处理

- **css-loader**: 加载 CSS 文件，并解析 CSS 中的 @import 和 url() 语句，使你可以在 JavaScript 中 import CSS 文件。
- **style-loader**: 将 CSS 注入到 DOM 中的 style 标签中。在开发环境中很有用，因为它可以实现热更新。
- **mini-css-extract-plugin**: 将 CSS 从 JavaScript 文件中提取出来，生成独立的 CSS 文件。在生产环境中尤其有用，因为它可以更好地利用浏览器的缓存机制。

### PostCSS 相关

- **postcss-loader**: 一个 webpack 的加载器，它使得 webpack 能够在构建过程中利用 `postcss` 的处理能力。`postcss-loader` 需要 `postcss` 作为其核心处理引擎，可以配置使用包括 `autoprefixer` 在内的任何 `postcss` 插件。
- **postcss**: 是核心库，提供了一个用于处理 CSS 的 API，可以通过各种插件扩展其功能。这意味着 `postcss` 本身不进行任何转换，而是提供一个框架来应用这些转换。
- **autoprefixer**: 是 `postcss` 的一个插件，依赖于 `postcss` 来执行其功能。`autoprefixer` 使用 `postcss` 的 API 来解析 CSS 文件并自动添加浏览器前缀，这帮助开发者避免手动处理浏览器兼容性问题。
- **postcss-preset-env**: 一个智能预设，用于根据目标浏览器或运行时环境，将最新的 CSS 语法转换为目标环境可以理解的代码。它包含了 `autoprefixer` 和其他一些插件，可以根据配置自动添加浏览器前缀，同时支持新的 CSS 语法。
- **cssnano**: 一个用于优化和压缩 CSS 文件的插件，可以减小 CSS 文件的大小，提高加载速度。

```bash
npx postcss src/styles.css --use autoprefixer -o ./dist/demo.css
```
