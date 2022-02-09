const express = require('express');
// const { route } = require('../app');
const router = express.Router();
const { addNewProduct,
    GetUndealProducts,
    GetProducts,
    ConfirmUndealProduct,
} = require('../Controllers/productController');

const {
    ImportProducts,
    ExportProducts,
    GetQRs,
    GetQRbyID
} = require('../Controllers/importExportController');

router.route('/addNewProduct').post(addNewProduct);
router.route('/getUndealProducts').get(GetUndealProducts);
router.route('/getProducts').get(GetProducts);
router.route('/confirmUndealProduct').post(ConfirmUndealProduct);
// router.route('/getQRsByProductID').get(GetQRsByProductID);


//import
router.route('/importProducts').post(ImportProducts);
router.route('/exportProducts').post(ExportProducts);
router.route('/getQRs').get(GetQRs);
router.route('/getQRByID').get(GetQRbyID);

module.exports = router;