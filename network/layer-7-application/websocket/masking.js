// const crypto = require("crypto");

function websocketMask(maskKey, payload) {
  let maskedPayload = Buffer.alloc(payload.length);
  for (let i = 0; i < payload.length; i++) {
    maskedPayload[i] = payload[i] ^ maskKey[i % 4];
  }
  return maskedPayload;
}

let maskKey = Buffer.from([0x37, 0xfa, 0x21, 0x3d]);
// let maskKey = crypto.randomBytes(4);
let payload = Buffer.from("Hello");

let maskedPayload = websocketMask(maskKey, payload);
console.log(maskedPayload);
