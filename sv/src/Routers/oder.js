const express = require('express');
// const { route } = require('../app');
const router = express.Router();

const {
    UpdateCart,
    AddOrder,
    ConfirmOrder,
    GetOrders,
    GetItemsOfOrder
} = require('../Controllers/orderController');

router.route('/updateCart').post(UpdateCart);
router.route('/addOrder').post(AddOrder);
router.route('/confirmOrder').post(ConfirmOrder);
router.route('/getOrders').get(GetOrders);
router.route('/getItemsOfOrder').get(GetItemsOfOrder);

module.exports = router;