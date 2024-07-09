import "./css/styles.css";
import text from "./text/sample.txt";
import imageUrl from "./images/image.png";
import fontUrl from "./fonts/font.woff2";

document.querySelector(".text").textContent = text;

// 动态创建 img 标签并设置 src 属性
const imgElement = document.createElement("img");
imgElement.src = imageUrl;
document.body.appendChild(imgElement);

// 动态创建 style 标签并设置 @font-face 规则
const styleElement = document.createElement("style");
styleElement.innerHTML = `
  @font-face {
    font-family: 'ExampleFont';
    src: url(${fontUrl}) format('woff2');
  }
  body {
    font-family: 'ExampleFont', sans-serif;
  }
`;
document.head.appendChild(styleElement);
