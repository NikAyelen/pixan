import { Request, Response } from "express";
import { Prisma } from "../../generated/prisma/client";
import * as hoyoNegroRepository from "../repositories/hoyo_negro.repository";

export const getAll = async (req: Request, res: Response) => {
  try {
    const { cliente_id } = req.query;

    const servicios = cliente_id
      ? await hoyoNegroRepository.getByCliente(Number(cliente_id))
      : await hoyoNegroRepository.getAll();

    res.json(servicios);
  } catch (error) {
    console.error(error);
    res
      .status(500)
      .json({ error: "Error al obtener los servicios de limpieza" });
  }
};

export const getById = async (req: Request, res: Response) => {
  try {
    const id = Number(req.params.id);
    if (!Number.isInteger(id)) {
      return res.status(400).json({ error: "id inválido" });
    }

    const servicio = await hoyoNegroRepository.getById(id);
    if (!servicio) {
      return res.status(404).json({ error: "Servicio no encontrado" });
    }
    res.json(servicio);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Error al obtener el servicio" });
  }
};

export const create = async (req: Request, res: Response) => {
  try {
    const { cliente_id, fecha, seleccion, total, id_galaxias } = req.body;

    if (!Number.isInteger(cliente_id) || !Number.isInteger(id_galaxias)) {
      return res
        .status(400)
        .json({ error: "cliente_id e id_galaxias son requeridos (enteros)" });
    }
    if (seleccion === undefined || seleccion === null) {
      return res.status(400).json({ error: "seleccion es requerida" });
    }
    if (typeof total !== "number" || total < 0) {
      return res
        .status(400)
        .json({ error: "total es requerido y debe ser >= 0" });
    }
    if (fecha && isNaN(new Date(fecha).getTime())) {
      return res.status(400).json({ error: "fecha inválida" });
    }

    const nuevo = await hoyoNegroRepository.create({
      cliente_id,
      fecha,
      seleccion,
      total,
      id_galaxias,
    });
    res.status(201).json(nuevo);
  } catch (error) {
    if (
      error instanceof Prisma.PrismaClientKnownRequestError &&
      error.code === "P2003"
    ) {
      return res.status(400).json({ error: "El cliente o la casa no existe" });
    }
    console.error(error);
    res.status(500).json({ error: "Error al crear el servicio" });
  }
};
