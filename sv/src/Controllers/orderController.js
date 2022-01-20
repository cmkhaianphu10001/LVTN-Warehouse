const JWT = require('jsonwebtoken');
const { User } = require('../Model/user');
const { Product } = require('../Model/product');
const { Cart } = require('../Model/cart');
const { ItemOfOrder } = require('../Model/itemOfOrder');
const { Order } = require('../Model/order');

//Itemcart
// {
//     "cusId":"615e8cf9204b5759d6f51eda",//
//     "orderDate":"2021-10-21",//
//     "totalAmount":120,
//     "listItem":[
//         {
//         "productID":"617194d5cbcbf6b14bf37b95",
//         "quantity":2,
//         "newPrice":400.0
//         },
//         {
//         "productID":"6171953eb43a2e02a2ba7b5e",
//         "quantity":3,
//         "newPrice":2000.0
//         }
//     ]
// }
module.exports.UpdateCart = async (req, res) => {
    var token = req.headers['authorization'];

    if (JWT.verify(token, process.env.JWTSecret)) {
        var decodeToken = JWT.decode(token, process.env.JWTSecret);

        var customer = await User.findOne({
            email: decodeToken.email,
        });
        if (customer != null && customer.role == 'customer') {
            try {
                var cart = await Cart.findOne({
                    cusID: customer._id,
                });
                if (cart == null) {
                    cart = new Cart({
                        cusID: customer._id,
                    });
                    await cart.save();
                }

                var cartItems = await ItemOfOrder.find({
                    parentID: cart._id,
                });
                if (cartItems != null) {
                    for (const e of cartItems) {
                        await ItemOfOrder.findByIdAndRemove(e._id);
                    }
                }
                for (const e of req.body.listItem) {
                    const item = new ItemOfOrder({
                        parentID: cart._id,
                        productID: e.productID,
                        newPrice: e.newPrice,
                        quantity: e.quantity
                    });
                    await item.save();
                }
                return res.status(200).send('OK');

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


//addOrder
// {
//     "orderDate":"2021-10-21",
//     "totalAmount":120,
//     "listItem":[
//         {
//         "productID":"617194d5cbcbf6b14bf37b95",
//         "quantity":2,
//         "newPrice":400.0
//         },
//         {
//         "productID":"6171953eb43a2e02a2ba7b5e",
//         "quantity":3,
//         "newPrice":2000.0
//         }
//     ]
// }
module.exports.AddOrder = async (req, res) => {
    var token = req.headers['authorization'];

    if (JWT.verify(token, process.env.JWTSecret)) {
        var decodeToken = JWT.decode(token, process.env.JWTSecret);

        var customer = await User.findOne({
            email: decodeToken.email,
        });
        if (customer != null && customer.role == 'customer') {
            try {
                const order = await new Order({
                    orderDate: req.body.orderDate,
                    cusID: customer._id,
                    isConfirm: null,
                    totalAmount: req.body.totalAmount,
                });
                order.save();
                for (const e of req.body.listItem) {
                    const item = new ItemOfOrder({
                        parentID: order._id,
                        productID: e.productID,
                        newPrice: e.newPrice,
                        quantity: e.quantity
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

//confirm Order
// {
//     "orderTargetID":"6171c2cc4a276a4b45ea03b5",
//     "action":true
// }
module.exports.ConfirmOrder = async (req, res) => {
    var token = req.headers['authorization'];

    if (JWT.verify(token, process.env.JWTSecret)) {
        var decodeToken = JWT.decode(token, process.env.JWTSecret);

        var user = await User.findOne({
            email: decodeToken.email,
        });
        if (user != null && user.role == 'manager') {
            try {
                var order = await Order.findById(req.body.orderTargetID);
                if (order == null) {
                    return res.status(404).send("Order isn't exists!!");
                } else {
                    if (req.body.action) {
                        order.isConfirm = true;
                        await order.save();
                        return res.status(200).send('Accepted!');
                    } else {
                        order.isConfirm = false;
                        await order.save();
                        return res.status(200).send('Rejected!');
                    }
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
    var token = req.headers['authorization'];
    var cusID = req.headers['cusid'];
    var orderid = req.headers['orderid'];
    if (JWT.verify(token, process.env.JWTSecret)) {
        var decodeToken = JWT.decode(token, process.env.JWTSecret);
        var result;
        var user = await User.findOne({
            email: decodeToken.email,
        });
        if (user != null && user.role == 'manager') {

            if (cusID != null) {
                result = await Order.find({
                    cusID: cusID,
                });
            } else if (orderid != null) {
                result = await Order.findById(orderid);
            } else {
                result = await Order.find();
            }
            return res.status(200).json(result);
        } else if (user != null && user.role == 'customer') {
            result = await Order.find({
                cusID: cusID,
            });
            return res.status(200).json(result);
        } else {
            return res.status(400).send('not permission!!')
        }
    } else {
        return res.status(400).send('Wrong token, please login');
    }
}


module.exports.GetItemsOfOrder = async (req, res) => {
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

            if (orderid != null) {
                result = await Order.find({
                    parentID: orderid,
                });
            } else if (itemID != null) {
                result = await Order.findById(itemID);
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