import { prisma } from "../config/prisma";
import { Prisma } from "../../generated/prisma/client";

export const ESTADO = {
  DISPONIBLE: "DISPONIBLE",
  ACEPTADA: "ACEPTADA",
} as const;

export interface CreateHoyoNegroData {
  cliente_id: number;
  fecha?: string;
  seleccion: Prisma.InputJsonValue;
  total: number;
  id_galaxias: number;
}

// Nunca devolvemos el password del cliente
const incluir = {
  galaxias: true,
  estrellas: {
    select: { id: true, name: true, email: true, phone_number: true },
  },
};

export const getAll = () =>
  prisma.hoyo_negro.findMany({ include: incluir, orderBy: { id: "desc" } });

export const getById = (id: number) =>
  prisma.hoyo_negro.findUnique({ where: { id }, include: incluir });

export const getByCliente = (cliente_id: number) =>
  prisma.hoyo_negro.findMany({
    where: { cliente_id },
    include: incluir,
    orderBy: { id: "desc" },
  });

export const getByTrabajador = (trabajador_id: number) =>
  prisma.hoyo_negro.findMany({
    where: { trabajador_id },
    include: incluir,
    orderBy: { id: "desc" },
  });

// Lo que ve el trabajador: solicitudes que nadie ha tomado todavía
export const getDisponibles = () =>
  prisma.hoyo_negro.findMany({
    where: { estado: ESTADO.DISPONIBLE },
    include: incluir,
    orderBy: { id: "desc" },
  });

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
    include: incluir,
  });

export const esTrabajador = async (id: number) =>
  (await prisma.estrellas.count({ where: { id, rol: "TRABAJADOR" } })) > 0;

export const aceptar = async (id: number, trabajador_id: number) => {
  const { count } = await prisma.hoyo_negro.updateMany({
    where: { id, estado: ESTADO.DISPONIBLE },
    data: { estado: ESTADO.ACEPTADA, trabajador_id },
  });
  if (count === 0) return null;
  return getById(id);
};