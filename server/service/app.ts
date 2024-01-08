import server from "$/$server";
import { API_BASE_PATH, CORS_ORIGIN } from "$/service/envValues";
import cookie from "@fastify/cookie";
import cors from "@fastify/cors";
import helmet from "@fastify/helmet";
import type { FastifyServerFactory } from "fastify";
import Fastify from "fastify";

export const init = (serverFactory?: FastifyServerFactory) => {
  const app = Fastify({ serverFactory });
  app.register(helmet);
  app.register(cors, { origin: CORS_ORIGIN, credentials: true });
  app.register(cookie);
  server(app, { basePath: API_BASE_PATH });

  app.get("/path", async (request, reply) => {
    const { message } = request.query as { message: string };
    console.log(message); // "Hello Fastify" がコンソールに表示される
    // 応答メッセージを返す
    return { reply: `Received message: ${message}` };
  });

  app.post("/post", async (request, reply) => {
    const { text } = request.body as { text: string };
    console.log(text); // コンソールに表示

    const responseText = `response: ${text} 届きました`;
    return responseText;
  });

  app.listen({ port: 31577 }, (err, address) => {
    if (err) {
      console.error(err);
      process.exit(1);
    }
    console.log(`Server listening at ${address}`);
  });

  return app;
};
