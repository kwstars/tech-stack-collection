| 特性              | Axios                       | Fetch API                               | SuperAgent                       |
| ----------------- | --------------------------- | --------------------------------------- | -------------------------------- |
| **安装**          | `npm install axios`         | 原生支持（Node.js 需安装 `node-fetch`） | `npm install superagent`         |
| **请求方法**      | `axios.get/post/put/delete` | `fetch(url, options)`                   | `superagent.get/post/put/delete` |
| **返回数据类型**  | 自动解析为 JSON             | 需手动解析（如 `response.json()`）      | 自动解析为 JSON                  |
| **Promise 支持**  | 是                          | 是                                      | 是                               |
| **拦截器**        | 是                          | 否                                      | 是                               |
| **取消请求**      | 是（通过 `CancelToken`）    | 是（需 `AbortController`）              | 是                               |
| **文件上传**      | 是（通过 `FormData`）       | 是（通过 `FormData`）                   | 是                               |
| **进度监控**      | 是（上传和下载进度）        | 否                                      | 是（上传和下载进度）             |
| **客户端/服务端** | 客户端和 Node.js            | 客户端和 Node.js（需安装 `node-fetch`） | 客户端和 Node.js                 |
| **自动转换数据**  | 是                          | 否（需手动转换）                        | 是                               |
| **流处理**        | 否                          | 是                                      | 是                               |
| **插件支持**      | 否                          | 否                                      | 是（如 `superagent-proxy`）      |
