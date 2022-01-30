const JWT = require('jsonwebtoken');
const { PositionStorage } = require('../Model/positionStorage');
const { Product } = require('../Model/product');
const { User } = require('../Model/user');


//     description: { type: String },
//     positionName: { type: String },
//     productID: { type: String, },
//     image: { type: String },
//     productName: { type: String },
module.exports.GetPosition = async (req, res) => {
    console.log('GetPosition')
    var token = req.headers['authorization'];
    if (JWT.verify(token, process.env.JWTSecret)) {
        var decodeToken = JWT.decode(token, process.env.JWTSecret);
        var user = await User.findOne({
            email: decodeToken.email,
        });
        if (user != null || user.role == 'manager') {
            try {
                var listPosition = await PositionStorage.find();
                return res.status(200).json(listPosition);
            } catch (error) {
                return res.status(400).send(error);
            }
        } else {
            return res.status(400).send('Authentication failed!')
        }
    } else {
        return res.status(400).send('Wrong token, Please login')
    }

}

// description: req.body.description,
// positionName:req.body.positionName,
// productID: req.body.productID,
// image: req.body.image,
// productName:req.body.productName,
// {
//     "description": "req.body.description",
//     "positionName":"Position 1"
// }
module.exports.CreatePosition = async (req, res) => {
    console.log('createPosition');
    var token = req.headers['authorization']
    if (JWT.verify(token, process.env.JWTSecret)) {
        var decodeToken = JWT.decode(token, process.env.JWTSecret);
        var user = await User.findOne({
            email: decodeToken.email,
        });
        if (user != null || user.role == 'manager') {
            try {
                var dupPosition = await PositionStorage.findOne({
                    positionName: req.body.positionName
                });
                if (dupPosition == null) {
                    var newPosition = await new PositionStorage({
                        description: req.body.description,
                        positionName: req.body.positionName,
                        productID: null,
                        image: null,
                        productName: null,
                    });
                    newPosition.save()
                    return res.status(200).send('Create position successfull!');
                } else {
                    console.log('dupPosition.toString()')
                    return res.status(400).send('Create failed, Position created!')
                }
            } catch (error) {
                return res.status(400).send(error);
            }
        } else {
            return res.status(400).send('Authentication failed!')
        }
    } else {
        return res.status(400).send('Wrong token, Please login')
    }
}

// description: req.body.description,
// positionName:req.body.positionName,
// productID: req.body.productID,
// image: req.body.image,
// productName:req.body.productName,
// {
//     "positionName":"Position 1"
// }
module.exports.DeletePosition = async (req, res) => {
    console.log('DeletePosition');
    var token = req.headers['authorization']
    if (JWT.verify(token, process.env.JWTSecret)) {
        var decodeToken = JWT.decode(token, process.env.JWTSecret);
        var user = await User.findOne({
            email: decodeToken.email,
        });
        if (user != null || user.role == 'manager') {
            try {
                var findPosition = await PositionStorage.findOne({ positionName: req.body.positionName });
                if (findPosition != null) {
                    await PositionStorage.findOneAndRemove({
                        positionName: req.body.positionName,
                    });
                    return res.status(200).send('Delete position successfull!');
                } else {
                    return res.status(400).send(req.body.positionName + " doesn't exists")
                }
            } catch (error) {
                return res.status(400).send(error);
            }
        } else {
            return res.status(400).send('Authentication failed!')
        }
    } else {
        return res.status(400).send('Wrong token, Please login')
    }
}


// description: req.body.description,
// positionName:req.body.positionName,
// productID: req.body.productID,
// image: req.body.image,
// productName:req.body.productName,
// {
//     "positionName":"Position 1"
//     "productID":"61e943f7ee9fa3d1956f262e"
// }
module.exports.SetItem = async (req, res) => {
    console.log('SetItem');
    var token = req.headers['authorization']
    if (JWT.verify(token, process.env.JWTSecret)) {
        var decodeToken = JWT.decode(token, process.env.JWTSecret);
        var user = await User.findOne({
            email: decodeToken.email,
        });
        if (user != null || user.role == 'manager') {
            try {
                var findProduct = await Product.findById(req.body.productID);
                var findPosition = await PositionStorage.findOne({
                    positionName: req.body.positionName,
                });
                if (findProduct != null && findPosition != null) {
                    // console.log(findPosition.positionName);
                    if (findProduct.stored != null) {
                        return res.status(400).send('Stored failed, this product was stored')
                    } else if (findPosition.productID != null) {
                        return res.status(400).send("Stored failed, this storage wasn't empty")
                    } else {
                        findPosition.productID = findProduct._id;
                        findPosition.image = findProduct.image;
                        findPosition.productName = findProduct.productName;

                        findProduct.stored = findPosition.positionName;

                        findPosition.save();
                        findProduct.save();
                        return res.status(200).send('Set Product to position successful!')
                    }

                } else {
                    return res.status(400).send('Product or position wrong!')
                }
            } catch (error) {
                return res.status(400).send(error);
            }
        } else {
            return res.status(400).send('Authentication failed!')
        }
    } else {
        return res.status(400).send('Wrong token, Please login')
    }
}

module.exports.RemoveItem = async (req, res) => {
    console.log('RemoveItem');
    var token = req.headers['authorization']
    if (JWT.verify(token, process.env.JWTSecret)) {
        var decodeToken = JWT.decode(token, process.env.JWTSecret);
        var user = await User.findOne({
            email: decodeToken.email,
        });
        if (user != null || user.role == 'manager') {
            try {
                var findPosition = await PositionStorage.findOne({
                    positionName: req.body.positionName,
                });

                if (findPosition != null) {
                    // console.log(findPosition.positionName);
                    var findProduct = await Product.findById(findPosition.productID);
                    findPosition.productID = null;
                    findPosition.image = null;
                    findPosition.productName = null;

                    findProduct.stored = null;


                    findPosition.save();
                    findProduct.save();
                    return res.status(200).send('Remove Product to position successful!')
                } else {
                    return res.status(400).send('Position wrong!')
                }
            } catch (error) {
                return res.status(400).send(error);
            }
        } else {
            return res.status(400).send('Authentication failed!')
        }
    } else {
        return res.status(400).send('Wrong token, Please login')
    }
}