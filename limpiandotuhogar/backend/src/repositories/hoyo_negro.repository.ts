import { prisma } from "../config/prisma";
import { Prisma } from "../../generated/prisma/client";

export interface CreateHoyoNegroData {
  cliente_id: number;
  fecha?: string;
  seleccion: Prisma.InputJsonValue;
  total: number;
  id_galaxias: number;
}

const incluir = {
  galaxias: true,
  estrellas: {
    select: { id: true, name: true, email: true, phone_number: true },
  },
};

export const getAll = () => prisma.hoyo_negro.findMany({ include: incluir });

export const getById = (id: number) =>
  prisma.hoyo_negro.findUnique({ where: { id }, include: incluir });

export const getByCliente = (cliente_id: number) =>
  prisma.hoyo_negro.findMany({ where: { cliente_id }, include: incluir });

export const create = ({
  cliente_id,
  fecha,
  seleccion,
  total,
  id_galaxias,
}: CreateHoyoNegroData) =>
  prisma.hoyo_negro.create({
    data: {
      cliente_id,
      fecha: fecha ? new Date(fecha) : new Date(),
      seleccion,
      total,
      id_galaxias,
    },
  });
