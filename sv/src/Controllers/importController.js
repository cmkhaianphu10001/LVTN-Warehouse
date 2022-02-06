const JWT = require('jsonwebtoken');
const { User } = require('../Model/user');
const { QR } = require('../Model/QR');
const { Product } = require('../Model/product');
const multerHandle = require('./multerHandle');
const fs = require('fs');

//import product
// {
//     "supID":"615e8cf9204b5759d6f51eda",
//     "importDate":"2021-10-21",
//     "totalAmount":120,
//     "listItem":[
//         {
//         "productID":"616e8b27d5175d5edb59c8be",
//         "quantity":12,
//         "newPrice":200.0
//         },
//         {
//         "productID":"616e92f0c2888145259f7c2c",
//         "quantity":12,
//         "newPrice":24.0
//         }
//     ]
// }
module.exports.ImportProducts = async (req, res) => {
    var token = req.headers['authorization'];

    if (JWT.verify(token, process.env.JWTSecret)) {
        var decodeToken = JWT.decode(token, process.env.JWTSecret);

        var user = await User.findOne({
            email: decodeToken.email,
        });
        listQRres = []

        if (user != null && user.role == 'manager') {
            try {
                console.log('import product');
                console.log(req.body);
                for (const e of req.body.listItem) {
                    var product = await Product.findById(e.productID);
                    for (let index = 0; index < e.quantity; index++) {
                        const qr = new QR({
                            productID: e.productID,
                            importDate: new Date(req.body.importDate),
                            managerIDImport: user._id,
                            cusID: null,
                            exportDate: null,
                            managerIDExport: null,
                            exportPrice: null,
                            locationID: null,
                        });
                        qr.save();
                        listQRres.push({
                            "qrID": qr._id,
                            "productID": e.productID
                        });
                    }
                    product.quantity += e.quantity;
                    product.save();
                }
                console.log(listQRres)
                return res.status(200).json(listQRres);
            } catch (e) {
                console.log(e);
            }
        } else {
            return res.status(400).send('not permission!!')
        }
    } else {
        return res.status(400).send('Wrong token, please login');
    }
}


//

module.exports.GetQRs = async (req, res) => {
    console.log('getQRs')
    var token = req.headers['authorization'];
    var productID = req.headers['productid'];
    if (JWT.verify(token, process.env.JWTSecret)) {
        var decodeToken = JWT.decode(token, process.env.JWTSecret);
        var isfindByProductID = productID != null;
        var qrs;
        var user = await User.findOne({
            email: decodeToken.email,
        });
        if (user != null) {
            try {
                if (isfindByProductID) {
                    qrs = await QR.find({
                        productID: productID,
                    });
                } else {
                    qrs = await QR.find();
                }
                return res.status(200).json(qrs);
            } catch (e) {
                console.log(e);
            }
        } else {
            return res.status(400).send('not permission!!')
        }
    } else {
        return res.status(400).send('Wrong token, please login');
    }
}

module.exports.GetQRbyID = async (req, res) => {
    console.log('getQRbyid')
    var token = req.headers['authorization'];
    var qrID = req.headers['qrid'];
    if (JWT.verify(token, process.env.JWTSecret)) {
        var decodeToken = JWT.decode(token, process.env.JWTSecret);
        var user = await User.findOne({
            email: decodeToken.email,
        });
        if (user != null) {
            try {
                const qr = await QR.findById(qrID);
                return res.status(200).json(qr);
            } catch (e) {
                console.log(e);
            }
        } else {
            return res.status(400).send('not permission!!')
        }
    } else {
        return res.status(400).send('Wrong token, please login');
    }
}