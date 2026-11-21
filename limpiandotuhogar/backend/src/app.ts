import "dotenv/config";

import express from "express";
import cors from "cors";

const origenesPermitidos = (process.env.CORS_ORIGINS ?? "http://localhost:5173" )
    .split(",")
    .map((o) => o.trim());

const app = express();

app.use(express.json());

app.use(
    cors({
        origin: origenesPermitidos,
        credentials: true,
    }),
);

export default app;