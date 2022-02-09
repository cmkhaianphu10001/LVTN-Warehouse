const express = require('express');
// const { route } = require('../app');
const router = express.Router();

const {
    AddOrder,
    DeleteOrder,
    ChangeStateOrder,
    GetOrders,
    GetItemsOfOrder
} = require('../Controllers/orderController');

router.route('/addOrder').post(AddOrder);
router.route('/deleteOrder').post(DeleteOrder);
router.route('/changeStateOrder').post(ChangeStateOrder);
router.route('/getOrders').get(GetOrders);
router.route('/getItemsOfOrder').get(GetItemsOfOrder);

module.exports = router;