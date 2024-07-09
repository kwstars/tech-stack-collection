import { greet } from "./esm-module";
const cjsModule = require("./cjs-module");

console.log(greet("Webpack"));
console.log(cjsModule.sayHello("Webpack"));
