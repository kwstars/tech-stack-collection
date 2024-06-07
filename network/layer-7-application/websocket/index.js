const WebSocket = require("ws");
const { v4: uuidv4 } = require("uuid");

const wss = new WebSocket.Server({ port: 8080 });

let clients = [];

wss.on("connection", function connection(ws) {
  const clientId = uuidv4();
  console.log(`A new client connected with id: ${clientId}!`);
  clients.push({ id: clientId, ws: ws });
  printAllClients();

  ws.on("message", function incoming(message) {
    console.log("received: %s", message);
    broadcast(message);
  });

  ws.on("close", function () {
    console.log("A client disconnected!");
    clients = clients.filter((client) => client !== ws);
  });

  ws.on("error", console.error);
});

function broadcast(message) {
  clients.forEach((client) => {
    if (client.ws.readyState === WebSocket.OPEN) {
      client.ws.send(message);
    }
  });
}

function printAllClients() {
  console.log("All connected clients:");
  clients.forEach((client) => {
    console.log(`Client ID: ${client.id}`);
  });
}

console.log("WebSocket server is running on port 8080");
