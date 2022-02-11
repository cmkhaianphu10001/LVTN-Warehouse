const JWT = require('jsonwebtoken');
const { User } = require('../Model/user');
const { Product } = require('../Model/product');
const { ItemOfOrder } = require('../Model/itemOfOrder');
const { Order } = require('../Model/order');

//addOrder
// {
//     "orderDate":"2021-10-21",
//     "cusId": '61e9430aee9fa3d1956f25e8',
//     "totalAmount":120,
//     "listItem":[
//         {
//         "productID":"617194d5cbcbf6b14bf37b95",
//         "count":2,
//         "newPrice":400.0
//         },
//         {
//         "productID":"6171953eb43a2e02a2ba7b5e",
//         "count":3,
//         "newPrice":2000.0
//         }
//     ]
// }
module.exports.AddOrder = async (req, res) => {
    var token = req.headers['authorization'];
    console.log(req.body);

    if (JWT.verify(token, process.env.JWTSecret)) {
        var decodeToken = JWT.decode(token, process.env.JWTSecret);

        var customer = await User.findOne({
            email: decodeToken.email,
        });
        if (customer != null && customer.role == 'customer') {
            try {
                const order = await new Order({
                    orderDate: req.body.orderDate,
                    cusID: customer._id == req.body.cusId ? req.body.cusId : null,
                    process: 1,
                    totalAmount: req.body.totalAmount,
                });
                order.save();
                for (const e of req.body.listItem) {
                    const item = new ItemOfOrder({
                        parentID: order._id,
                        productID: e.productID,
                        newPrice: e.newPrice,
                        count: e.count
                    });
                    await item.save();
                }
                return res.status(200).send('Submit Order Complete!!');
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
//     "orderTargetID": "6171c2cc4a276a4b45ea03b5",
// }
module.exports.DeleteOrder = async (req, res) => {
    var token = req.headers['authorization'];
    console.log(req.body);

    if (JWT.verify(token, process.env.JWTSecret)) {
        var decodeToken = JWT.decode(token, process.env.JWTSecret);

        var customer = await User.findOne({
            email: decodeToken.email,
        });
        if (customer != null && customer.role == 'customer') {
            try {
                var listitemOfOrders = await ItemOfOrder.find({
                    parentID: req.body.orderTargetID,
                });
                for (const value in listitemOfOrders) {
                    await ItemOfOrder.findByIdAndDelete(value._id);
                }
                await Order.findByIdAndDelete(req.body.orderTargetID);

                return res.status(200).send('Delete Order Complete!!');
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
//change state
// {
//     "orderid":"6171c2cc4a276a4b45ea03b5",
//     "state":true
//     "description": ""
// }
module.exports.ChangeStateOrder = async (req, res) => {
    var token = req.headers['authorization'];
    console.log(req.body.state);
    if (JWT.verify(token, process.env.JWTSecret)) {
        var decodeToken = JWT.decode(token, process.env.JWTSecret);

        var user = await User.findOne({
            email: decodeToken.email,
        });
        if (user != null) {
            try {
                var order = await Order.findById(req.body.orderid);
                if (order == null) {
                    return res.status(404).send("Order isn't exists!!");
                } else {
                    await Order.findByIdAndUpdate(order._id, {
                        'process': req.body.state,
                        'description': req.body.description,
                    })
                    return res.status(200).send('State Changed.')
                }
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


module.exports.GetOrders = async (req, res) => {
    console.log('GetOrders')
    var token = req.headers['authorization'];
    var cusID = req.headers['cusid'];
    var orderid = req.headers['orderid'];
    if (JWT.verify(token, process.env.JWTSecret)) {
        var decodeToken = JWT.decode(token, process.env.JWTSecret);
        var result;
        var user = await User.findOne({
            email: decodeToken.email,
        });
        if (user != null) {

            if (orderid != null) {
                result = await Order.findById(orderid);
            } else if (cusID != null) {
                result = await Order.find({
                    cusID: cusID,
                });
            } else {
                result = await Order.find();
            }
            return res.status(200).json(result);

        } else {
            return res.status(400).send('not permission!!')
        }
    } else {
        return res.status(400).send('Wrong token, please login');
    }
}


module.exports.GetItemsOfOrder = async (req, res) => {
    console.log('GetItemOfOrder');
    var token = req.headers['authorization'];
    var itemID = req.headers['itemid'];
    var orderid = req.headers['orderid'];
    if (JWT.verify(token, process.env.JWTSecret)) {
        var decodeToken = JWT.decode(token, process.env.JWTSecret);
        var result;
        var user = await User.findOne({
            email: decodeToken.email,
        });
        if (user != null && (user.role == 'manager' || user.role == 'customer')) {

            if (itemID != null) {
                result = await ItemOfOrder.findById(itemID);
            } else if (orderid != null) {
                result = await ItemOfOrder.find({
                    parentID: orderid,
                });
            } else {
                result = await ItemOfOrder.find();
            }
            return res.status(200).json(result);
        } else {
            return res.status(400).send('not permission!!')
        }
    } else {
        return res.status(400).send('Wrong token, please login');
    }
}
