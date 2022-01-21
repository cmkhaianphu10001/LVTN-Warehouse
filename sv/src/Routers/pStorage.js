const express = require('express');
// const { route } = require('../app');
const router = express.Router();

const {
    GetPosition,
    CreatePosition,
    DeletePosition,
    SetItem,
    RemoveItem,
} = require('../Controllers/pStorageController');

router.route('/getposition').get(GetPosition);
router.route('/createPosition').post(CreatePosition);
router.route('/deletePosition').post(DeletePosition);
router.route('/setItem').post(SetItem);
router.route('/removeItem').post(RemoveItem);


module.exports = router;