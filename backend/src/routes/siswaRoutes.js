const router = require('express').Router();
const siswaController = require('../controllers/siswaController');

router.get('/', siswaController.getAll);
router.get('/:id', siswaController.getById);
router.post('/', siswaController.create);
router.put('/:id', siswaController.update);
router.delete('/:id', siswaController.remove);

module.exports = router;