const JWT = require('jsonwebtoken');
const { User } = require('../Model/user');
const fs = require('fs')

module.exports.GetSupplier = async (req, res) => {

    var token = req.headers['authorization'];
    if (JWT.verify(token, process.env.JWTSecret)) {
        var decodeToken = JWT.decode(token, process.env.JWTSecret);
        console.log('Getsupplier');
        var user = await User.findOne({
            email: decodeToken.email,
        });
        if (user != null) {
            var Suppliers = await User.find({
                role: 'supplier'
            });
            return res.status(200).json(Suppliers);
        } else {
            return res.status(400).send('Authenticate failed!!');
        }
    } else {
        return res.status(400).send('Wrong token, Please login');
    }
}