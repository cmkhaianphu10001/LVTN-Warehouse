const JWT = require('jsonwebtoken');
const { User } = require('../Model/user');
const { UnDealProduct } = require('../Model/unDealProduct');
const { Product } = require('../Model/product');
const { QR } = require('../Model/QR');
const multerHandle = require('./multerHandle');
const fs = require('fs');


// post add new product
module.exports.addNewProduct = async (req, res) => {
    // console.log(req.headers['authorization']);
    var token = req.headers['authorization'];
    if (JWT.verify(token, process.env.JWTSecret)) {
        var decodeToken = JWT.decode(token, process.env.JWTSecret);

        var user = await User.findOne({
            email: decodeToken.email,
        });
        if (user == null) {
            return res.status(404).send('Authenticate failed!');
        } else if (user.role != 'supplier') {
            return res.status(400).send('Supplier role require!');
        } else {


            // need find by one. check exists
            console.log(req.body);
            const newUnDealProduct = new UnDealProduct({
                productName: req.body.productName,
                unit: req.body.unit,
                quantity: req.body.quantity,
                supID: user._id,
                importPrice: req.body.importPrice,// for compare
                ratePrice: req.body.ratePrice || 1,//nullable
                image: req.body.image || null,//nullable
                description: req.body.description || '',//nullable
                //check for deal
                supplierConfirm: req.body.supplierConfirm || 1,// = 1
                managerConfirm: req.body.managerConfirm || 0,// = 0
            });
            await newUnDealProduct.save();
            return res.status(200).send('Completed add new Product');
        }

    } else {
        return res.status(400).send("Wrong token, Please login")
    }
}

//get undeal product
module.exports.GetUndealProducts = async (req, res) => {
    console.log('getundealproducts')
    var token = req.headers['authorization'];
    var supID = req.headers['supid'];
    console.log(supID);
    if (JWT.verify(token, process.env.JWTSecret)) {
        var decodeToken = JWT.decode(token, process.env.JWTSecret);
        var user = await User.findOne({
            email: decodeToken.email,
        });
        if (user != null || user.role == 'supplier' || user.role == 'manager') {
            var listUndealProduct
            if (supID != null) {
                listUndealProduct = await UnDealProduct.find({
                    supID: supID,
                });
            } else {
                listUndealProduct = await UnDealProduct.find();
            }
            return res.status(200).json(listUndealProduct);


        } else {
            return res.status(400).send('Authentication failed!')
        }
    } else {
        return res.status(400).send('Wrong token, Please login')
    }

}

// get product ( with of without supId)
module.exports.GetProducts = async (req, res) => {
    console.log('getproducts')
    var token = req.headers['authorization'];
    var supID = req.headers['supid'];
    var qrID = req.headers['qrid'];
    var productID = req.headers['productid'];
    if (JWT.verify(token, process.env.JWTSecret)) {
        var decodeToken = JWT.decode(token, process.env.JWTSecret);
        var user = await User.findOne({
            email: decodeToken.email,
        });
        if (user != null || user.role == 'customer' || user.role == 'manager') {
            var listProduct;
            if (supID != null) {
                listProduct = await Product.find({
                    supID: supID,
                })
            } else if (productID != null) {
                listProduct = await Product.findById(productID);
            } else if (qrID != null) {
                var qrfound = await QR.findById(qrID);
                if (qrfound == null) {
                    return res.status(400).send("Can't found product.");
                }
                listProduct = await Product.findById(qrfound.productID);
            } else {
                listProduct = await Product.find({
                    // productName: { $regex: 'fl', $options: 'i' }
                });
            }
            return res.status(200).json(listProduct);


        } else {
            return res.status(400).send('Authentication failed!')
        }
    } else {
        return res.status(400).send('Wrong token, Please login')
    }

}


module.exports.ConfirmUndealProduct = async (req, res) => {
    var token = req.headers['authorization'];
    console.log(req.body);
    if (JWT.verify(token, process.env.JWTSecret)) {
        var decodeToken = JWT.decode(token, process.env.JWTSecret);
        // {
        //     undealProductID: '6160d6d0e36ee5123ebfaedd',
        //     newPrice: null,
        //     ratePrice: null,
        //     action: true
        //   }
        var user = await User.findOne({
            email: decodeToken.email,
        });
        var unDealProduct = await UnDealProduct.findById(req.body.undealProductID);
        if (user != null && unDealProduct != null) {

            if (req.body.action == true) {
                if (user.role == 'supplier') {
                    if (req.body.newPrice == unDealProduct.importPrice || req.body.newPrice == null) {
                        //unchange price
                        unDealProduct.supplierConfirm = true;
                        console.log('1')
                        await unDealProduct.save();
                    } else {
                        // change
                        unDealProduct.supplierConfirm = true;
                        unDealProduct.managerConfirm = false;
                        unDealProduct.importPrice = req.body.newPrice;
                        console.log('2')
                        await unDealProduct.save();
                    }
                } else {
                    //user.role == 'manager'
                    if (req.body.ratePrice != null) { unDealProduct.ratePrice = req.body.ratePrice; }
                    if (req.body.newPrice == unDealProduct.importPrice || req.body.newPrice == null) {
                        unDealProduct.managerConfirm = true;
                        console.log('3')
                        await unDealProduct.save();

                    } else {
                        unDealProduct.managerConfirm = true;
                        unDealProduct.supplierConfirm = false;
                        unDealProduct.importPrice = req.body.newPrice;
                        console.log('4')
                        await unDealProduct.save();

                    }
                }
                if (unDealProduct.supplierConfirm == unDealProduct.managerConfirm) {
                    const product = new Product({
                        productName: unDealProduct.productName,
                        unit: unDealProduct.unit,
                        quantity: unDealProduct.quantity,
                        supID: unDealProduct.supID,
                        importPrice: unDealProduct.importPrice,// for compare
                        ratePrice: unDealProduct.ratePrice || null,//nullable
                        image: unDealProduct.image || null,//nullable
                        description: unDealProduct.description || '',//nullable
                        stored: null,//nullable
                        sold: 0,
                    });
                    console.log('5')

                    await UnDealProduct.deleteOne({
                        _id: req.body.undealProductID,
                    })

                    product.save();
                    return res.status(200).send('Confirmed!');

                }
            } else {
                await UnDealProduct.deleteOne({
                    _id: req.body.undealProductID,
                })
                return res.status(200).send('Denied!');
            }

            return res.status(200).send('Done')


        } else {
            return res.status(400).send("Authentication failed or Can't find Product!")
        }
    } else {
        return res.status(400).send('Wrong token, Please login')
    }

}
