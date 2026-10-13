// Adapter DAP via stdio para o Bun, usando o adapter oficial do repo oven-sh/bun
// (o mesmo que a extensão oven.bun-vscode embute). Ver build.sh para recompilar.
import { tmpdir } from "node:os";
import { WebSocketDebugAdapter, getRandomId } from "bun-debug-adapter-protocol";

// stdout é exclusivo do protocolo DAP; qualquer log do adapter vai para stderr
console.log = console.info = console.debug = console.error;

const adapter = new WebSocketDebugAdapter(`ws+unix://${tmpdir()}/${getRandomId()}.sock`);

let seq = 1;
function send(message: Record<string, unknown>) {
  const json = JSON.stringify({ ...message, seq: seq++ });
  process.stdout.write(`Content-Length: ${Buffer.byteLength(json)}\r\n\r\n${json}`);
}

adapter.on("Adapter.response", send);
adapter.on("Adapter.event", send);
adapter.on("Adapter.reverseRequest", send);
adapter.on("Adapter.error", error => process.stderr.write(`${error.stack ?? error}\n`));
adapter.on("Adapter.terminated", () => setTimeout(() => process.exit(0), 100));

let buffer = Buffer.alloc(0);
process.stdin.on("data", (chunk: Buffer) => {
  buffer = Buffer.concat([buffer, chunk]);
  while (true) {
    const headerEnd = buffer.indexOf("\r\n\r\n");
    if (headerEnd === -1) return;
    const length = Number(/Content-Length: (\d+)/i.exec(buffer.subarray(0, headerEnd).toString())?.[1]);
    const start = headerEnd + 4;
    if (buffer.length < start + length) return;
    const message = JSON.parse(buffer.subarray(start, start + length).toString());
    buffer = buffer.subarray(start + length);
    // Respostas a reverse requests (ex: runInTerminal) não precisam de tratamento
    if (message.type !== "request") continue;
    // Sem isso o adapter só espera o configurationDone se clientID === "vscode",
    // e o programa começa a rodar antes do nvim-dap registrar os breakpoints
    if (message.command === "initialize") {
      message.arguments = { ...message.arguments, supportsConfigurationDoneRequest: true };
    }
    adapter.emit("Adapter.request", message);
  }
});
process.stdin.on("end", () => {
  adapter.close();
  process.exit(0);
});
