import { prisma } from "../config/prisma";

export function buscarUsuario(email: string) {
  return prisma.estrellas.findUnique({
    where: { email },
  });
}
