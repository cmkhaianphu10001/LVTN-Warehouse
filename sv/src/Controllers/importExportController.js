const JWT = require('jsonwebtoken');
const { User } = require('../Model/user');
const { QR } = require('../Model/QR');
const { Product } = require('../Model/product');
const { History } = require('../Model/history');
const { ItemOfHistory } = require('../Model/itemOfHistory');

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
                const historyImport = new History({
                    typeHistory: 'import',
                    date: new Date(req.body.importDate).toLocaleString("en-US", { timeZone: 'Asia/Jakarta' }),
                    userTargetID: req.body.supID,
                    managerID: user._id,
                    totalAmount: req.body.totalAmount,
                });
                historyImport.save();
                for (const e of req.body.listItem) {
                    var product = await Product.findById(e.productID);
                    const itemOfHistory = new ItemOfHistory({
                        parentID: historyImport._id,
                        productID: product._id,
                        count: e.quantity,
                    });
                    itemOfHistory.save();


                    for (let index = 0; index < e.quantity; index++) {
                        const qr = new QR({
                            productID: e.productID,
                            importDate: new Date(req.body.importDate).toLocaleString("en-US", { timeZone: 'Asia/Jakarta' }),
                            managerIDImport: user._id,
                            importIDhistory: historyImport._id,
                            cusID: null,
                            exportDate: null,
                            managerIDExport: null,
                            exportPrice: parseFloat((product.importPrice * product.ratePrice).toString()).toFixed(2),
                            exportIDhistory: null,
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



// {
//     cusID: '61e9430aee9fa3d1956f25e8',
//     exportDate: '2022-2-9',
//     totalAmount: 4320,
//     listItem: [
//       {
//         productID: '61f2a604ca5b3a43d4c5d479',
//         quantity: 2,
//         newPrice: 1440
//       },
//       {
//         productID: '61f2a63bca5b3a43d4c5d49f',
//         quantity: 1,
//         newPrice: 1440
//       }
//     ],
//     listQR: [
//       { qrID: '6203d47423d303b39171a84f' },
//       { qrID: '6203d47423d303b39171a850' },
//       { qrID: '6203dc4f23d303b39171a8a3' }
//     ]
//   }
module.exports.ExportProducts = async (req, res) => {
    var token = req.headers['authorization'];
    if (JWT.verify(token, process.env.JWTSecret)) {
        var decodeToken = JWT.decode(token, process.env.JWTSecret);

        var user = await User.findOne({
            email: decodeToken.email,
        });

        if (user != null && user.role == 'manager') {
            try {
                console.log('export product');
                console.log(req.body);
                const historyExport = new History({
                    typeHistory: 'export',
                    date: new Date(req.body.exportDate).toLocaleString("en-US", { timeZone: 'Asia/Jakarta' }),
                    userTargetID: req.body.cusID,
                    managerID: user._id,
                    totalAmount: req.body.totalAmount,
                });
                historyExport.save();
                for (const e of req.body.listItem) {
                    var product = await Product.findById(e.productID);
                    const itemOfHistory = new ItemOfHistory({
                        parentID: historyExport._id,
                        productID: product._id,
                        count: e.quantity,
                    });
                    itemOfHistory.save();
                    product.quantity -= e.quantity;
                    product.sold += e.quantity;
                    product.save();
                }
                for (const e of req.body.listQR) {
                    var qr = await QR.findByIdAndUpdate(e.qrID, {
                        cusID: req.body.cusID,
                        exportDate: new Date(req.body.exportDate).toLocaleString("en-US", { timeZone: 'Asia/Jakarta' }),
                        managerIDExport: user._id,
                        exportIDhistory: historyExport._id,
                    });
                    qr.save();
                }
                return res.status(200).send('Exported');
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

module.exports.GetHistories = async (req, res) => {
    console.log('GetHistories');
    var token = req.headers['authorization'];
    var userTargetID = req.headers['usertargetid']
    if (JWT.verify(token, process.env.JWTSecret)) {
        var decodeToken = JWT.decode(token, process.env.JWTSecret);
        var result;
        var user = await User.findOne({
            email: decodeToken.email,
        });
        if (user != null) {
            if (userTargetID != null) {
                result = await History.find({
                    userTargetID: userTargetID,
                });
            } else {
                result = await History.find({});
            }
            // console.log(result)
            return res.status(200).json(result);
        } else {
            return res.status(400).send('not permission!!')
        }
    } else {
        return res.status(400).send('Wrong token, please login');
    }
}

module.exports.GetItemOfHistory = async (req, res) => {
    console.log('GetItemOfHistory');
    var token = req.headers['authorization'];
    var parentID = req.headers['parentID']
    if (JWT.verify(token, process.env.JWTSecret)) {
        var decodeToken = JWT.decode(token, process.env.JWTSecret);
        var result;
        var user = await User.findOne({
            email: decodeToken.email,
        });
        if (user != null) {
            if (parentID != null) {
                result = await ItemOfHistory.find({
                    parentID: parentID,
                });
            } else {
                result = await ItemOfHistory.find({});
            }
            return res.status(200).json(result);
        } else {
            return res.status(400).send('not permission!!')
        }
    } else {
        return res.status(400).send('Wrong token, please login');
    }
}