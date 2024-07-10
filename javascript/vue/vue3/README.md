# [Vue.js](https://vuejs.org/)

## 版本历史

Vue.js 的版本历史主要包括以下几个重要的版本：

1. **Vue.js 0.1** - 发布于 2014 年 2 月，这是 Vue.js 的第一个公开版本。
2. **Vue.js 1.0** - 发布于 2015 年 10 月，标志着 Vue.js 的第一个主要版本发布，引入了许多新特性和改进。
3. **Vue.js 2.0** - 发布于 2016 年 9 月，带来了虚拟 DOM、服务器端渲染支持等重大更新。
4. **Vue.js 2.5** - 发布于 2017 年 10 月，增加了更好的 TypeScript 集成和错误处理功能。
5. **Vue.js 2.6** - 发布于 2019 年 2 月，引入了新的功能如动态指令参数和 `v-slot` 语法。
6. **Vue.js 3.0** - 发布于 2020 年 9 月，这是一个重大更新，引入了 Composition API、性能提升、更小的包体积等特性。
7. **Vue.js 3.1** - 增强了 Composition API 的功能，并改进了 TypeScript 支持。
8. **Vue.js 3.2** - 引入了 `<script setup>` 语法糖，简化了 Composition API 的使用，并提升了性能。
9. **Vue.js 3.3** - 增加了对 Vite 的默认支持，进一步优化了开发体验。
10. **Vue.js 3.4** - 引入了新的 API 和改进，继续优化了性能和开发体验。

每个版本都在不断地增加新功能、改进现有功能和修复错误，以提高开发效率和用户体验。Vue.js 社区也在不断成长，为 Vue.js 的发展贡献了许多力量。

## MVVM

MVVM 模式在 Vue.js 中是核心概念之一，它代表 Model-View-ViewModel。这种模式促进了 UI 组件（View）和业务逻辑/数据（Model）之间的清晰分离，通过 ViewModel 来实现。在 Vue.js 中，MVVM 模式的实现如下：

1. Model（模型）：代表数据的状态，业务逻辑和数据操作。在 Vue.js 中，Model 通常是纯 JavaScript 对象。
2. View（视图）：是用户界面的部分，展示数据（Model）给用户。在 Vue.js 中，View 是由 HTML 模板构成的。
3. ViewModel（视图模型）：Vue.js 的核心，是一个 Vue 实例。ViewModel 连接 View 和 Model，通过双向数据绑定机制自动将数据从 Model 同步到 View，并且将用户在 View 上的操作（如表单输入）同步回 Model。这意味着，当数据模型（Model）发生变化时，界面（View）会自动更新；同样，当用户在界面上进行操作时，数据模型也会相应地被更新。

![img](https://012.vuejs.org/images/mvvm.png)

## [Rendering Mechanism](https://vuejs.org/guide/extras/rendering-mechanism)

![img](https://vuejs.org/assets/render-pipeline.CwxnH_lZ.png)

1. **template（模板）**： Vue 的 `template` 是定义组件结构的声明式语法。它是 HTML 格式的字符串，可以包含数据绑定和指令（如 `v-for`、`v-if` 等），Vue 会将这些模板编译成渲染函数。

2. **VNode（虚拟节点）**： `VNode` 是 Vue 中的一个概念，代表虚拟 DOM 树上的一个节点。它是一个轻量级的对象，包含了节点的类型、数据、子节点等信息。渲染函数执行时，会返回 VNode 树。

3. **Virtual DOM（虚拟 DOM）**： 虚拟 DOM 是对实际 DOM 的抽象表示，它通过 JavaScript 对象来模拟 DOM 树。在 Vue 中，当组件状态变化时，Vue 会先更新虚拟 DOM，然后对比新旧虚拟 DOM 的差异，并计算出最小的更新操作，最后应用这些操作到实际的 DOM 上，这个过程称为 DOM diffing。

4. **Actual DOM（实际 DOM）**： 实际 DOM 是浏览器中的页面结构，由 HTML 元素构成。它比虚拟 DOM 更重，操作它也更慢，因为它涉及到浏览器的布局和重绘过程。Vue 通过智能地更新实际 DOM 来保证高效的性能，尽量减少对实际 DOM 的操作。

总的来说，Vue 通过将 `template` 编译成渲染函数，渲染函数生成 `VNode` 树，然后通过对比新旧 `VNode` 树来优化对 `Actual DOM` 的操作，从而提高应用的性能和响应速度。

## 为什么把 `<script>` 标签放在 HTML 文档的最后面？

将 `<script>` 标签放在 HTML 文档的最后面，紧接在 `</body>` 标签之前，是一种常见的最佳实践，原因包括：

1. **提高页面加载性能**：浏览器在解析 HTML 文档时，遇到 `<script>` 标签会暂停 HTML 的解析，转而加载和执行 JavaScript 代码。如果 `<script>` 标签位于文档顶部或中间，它会阻塞后续 HTML 内容的加载和渲染，导致用户可见内容的显示延迟。将 `<script>` 标签放在底部，可以确保在执行 JavaScript 之前，页面的主要内容已经被加载和渲染，从而提高用户体验。

2. **减少对 DOM 操作的依赖**：如果 JavaScript 代码需要操作 DOM 元素（例如，通过 `document.getElementById` 或 `document.querySelector` 获取元素），将 `<script>` 标签放在底部可以确保在执行这些操作时，相关的 DOM 元素已经存在于页面中。这样可以避免因为 DOM 元素尚未加载而导致的错误。

3. **简化脚本的编写**：当 `<script>` 标签位于页面底部时，通常不需要监听 `DOMContentLoaded` 事件来确保 DOM 完全加载。因为在脚本执行时，页面的 HTML 结构已经加载完毕，可以直接进行 DOM 操作和其他脚本逻辑。

综上所述，将 `<script>` 标签放在页面的最后面，有助于提高页面加载速度，改善用户体验，并简化 JavaScript 代码的编写。

## [SFC](https://vuejs.org/guide/scaling-up/sfc.html)

SFC（Single-File Components）是指单文件组件，这是 Vue.js 中的一个核心概念，允许开发者将一个 Vue 组件的模板、JavaScript 逻辑和 CSS 样式封装在同一个文件中。这种文件通常以`.vue`扩展名结尾。

单文件组件的结构大致如下：

```vue
<template>
  <!-- HTML模板内容 -->
</template>

<script>
export default {
  // JavaScript逻辑
};
</script>

<style>
/* CSS样式 */
</style>
```

**SFC 的优势包括：**

1. **模块化**：通过将模板、逻辑和样式封装在一个文件中，SFC 促进了代码的模块化和重用。
2. **易于维护**：相关的 HTML、JavaScript 和 CSS 集中在一个地方，使得组件更容易理解和维护。
3. **工具链支持**：Vue 提供了强大的构建工具（如 Vue CLI），这些工具可以编译`.vue`文件，使其能够在浏览器中运行。这包括将模板编译成渲染函数、处理 ES6 代码、编译 SCSS/SASS 等。
4. **热重载**：在开发过程中，当`.vue`文件中的内容被修改后，页面可以自动更新以反映这些更改，而无需手动刷新页面。

SFC 提供了一种高效、直观且组织良好的方式来构建 Vue 应用，是 Vue 项目中广泛采用的开发模式。

创建 Vue 单文件组件（SFC）的开发模式主要方法如下：

1. **Vue CLI**：官方命令行工具，提供项目脚手架、开发服务器、构建和打包等功能。
2. **Vite**：现代前端构建工具，特别优化了 Vue 项目的开发体验，提供快速的热重载和构建。
3. **Webpack**：强大的模块打包器，通过配置`vue-loader`插件来支持 Vue SFC。
4. **Parcel**：零配置 Web 应用程序打包器，自动处理 Vue SFC，适合追求简单的项目开发。
5. **Rollup**：轻量级的模块打包器，适用于库和应用程序，通过`rollup-plugin-vue`插件支持 Vue SFC。

## 组件通讯

您的描述基本正确，涵盖了 Vue 3 中常用的组件通讯方式。不过可以稍微调整一些细节使之更准确和清晰：

## 组件通讯

### 父子组件通信方式

1. **Props**：父组件通过 props 向子组件传递数据。
2. **自定义事件**（`$emit`）：子组件可以发射事件来传递数据给父组件。
3. **插槽**（Slots）：用于父组件向子组件传递模板内容。
4. **引用**（Refs）：通过引用（ref）直接访问子组件的实例或 DOM。
5. **依赖注入**（Provide/Inject）：祖先组件可以提供数据，后代组件可以注入这些数据。

### 非父子组件通信方式

1. **事件总线**（Event Bus）：创建一个事件中心，通过它来传递事件和数据。在 Vue 3 中，官方推荐使用 mitt 等第三方库来实现事件总线。
2. **Vuex**：状态管理库，用于管理组件间的状态。
3. **本地存储**（如：localStorage/sessionStorage）：通过本地存储来共享数据。注意，这种方式适用于跨组件和跨页面的持久化数据共享。
4. **全局变量**：在全局对象上设置属性来共享数据，这种方式需要谨慎使用以避免命名冲突和数据污染。
5. **$attrs和$listeners**：用于祖先和后代间的通信，$attrs包含传递下来的未被识别的属性，$listeners 包含传递下来的所有事件监听器。
6. **Composition API**：在 Vue 3 中，可以使用`provide`和`inject`函数在组件树中的任何位置共享数据。
7. **Vuex 或 Pinia 的模块**：可以使用状态管理库的模块来组织和共享特定功能的状态。

## 参考和引用

- https://vue3.chengpeiquan.com/engineering.html
- https://github.com/HcySunYang/code-for-vue-3-book
