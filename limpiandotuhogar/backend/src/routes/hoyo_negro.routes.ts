import { Router } from "express";
import * as hoyoNegroController from "../controller/hoyo_negro.controller";

const router = Router();

router.get("/", hoyoNegroController.getAll); 
router.get("/:id", hoyoNegroController.getById);
router.post("/", hoyoNegroController.create);

export default router;