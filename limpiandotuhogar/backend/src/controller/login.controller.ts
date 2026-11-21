import { NextFunction, Request, Response } from "express";
import * as loginRepository from "../repositories/login.repository";
import { AppError } from "../errors/AppError";

export async function login(
  req: Request,
  res: Response,
  next: NextFunction,
) {
  try {
    const correo =
      typeof req.body?.correo === "string"
        ? req.body.correo.trim().toLowerCase()
        : "";

    const password =
      typeof req.body?.password === "string" ? req.body.password : "";

    if (!correo) {
      throw new AppError(400, "Hace falta el correo electronico");
    }

    if (!password) {
      throw new AppError(400, "Hace falta la contraseña");
    }

    const estrella = await loginRepository.buscarUsuario(correo);

    if (!estrella || estrella.password !== password) {
      throw new AppError(401, "Credenciales invalidas");
    }

    if (estrella.rol !== "CLIENTE") {
      throw new AppError(403, "No tienes permisos de administrador");
    }

    return res.status(200).json({
      mensaje: "Inicio de sesion exitoso",
      estrella: {
        id: estrella.id,
        nombre: estrella.name,
        correo: estrella.email,
        rol: estrella.rol,
      },
    });
  } catch (error) {
    next(error);
  }
}
