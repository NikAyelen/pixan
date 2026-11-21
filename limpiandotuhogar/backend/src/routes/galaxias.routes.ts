const express = require('express');
const galaxiasController = require('./galaxias.controller');

const router = express.Router();

router.get('/', galaxiasController.getAll);
router.get('/:id', galaxiasController.getById);
router.post('/', galaxiasController.create);

module.exports = router;