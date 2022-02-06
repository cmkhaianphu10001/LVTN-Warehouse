const express = require('express');
// const { route } = require('../app');
const router = express.Router();

const {
    AddComment,
    GetCommentsOfProduct,
} = require('../Controllers/commentController');

router.route('/addComment').post(AddComment);
router.route('/getCommentsOfProduct').get(GetCommentsOfProduct);
// router.route('/confirmOrder').post(ConfirmOrder);
// router.route('/getOrders').get(GetOrders);
// router.route('/getItemsOfOrder').get(GetItemsOfOrder);

module.exports = router;