const express = require('express');
const controller = require('../controllers/siswaController');

const router = express.Router();

router.get('/', controller.getAllSiswa);
router.get('/:id', controller.getSiswaById);
router.post('/', controller.createSiswa);
router.put('/:id', controller.updateSiswa);
router.delete('/:id', controller.deleteSiswa);

module.exports = router;