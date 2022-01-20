// const bcrypt = require('bcryptjs');
// const _ = require('lodash');
const JWT = require('jsonwebtoken');
// const { Profile } = require('../Model/profile')
const { User } = require('../Model/user');
// const { use } = require('../Routers/profile');

const multerHandle = require('./multerHandle');

const fs = require('fs')

// Get profile
module.exports.getProfile = async (req, res) => {
    // console.log(req.headers['authorization']);
    var token = req.headers['authorization'];
    var ID = req.headers['_id'];
    if (JWT.verify(token, process.env.JWTSecret)) {
        var decodeToken = JWT.decode(token, process.env.JWTSecret);
        var profile;
        if (ID != null) {
            profile = await User.findById(ID);
        } else {
            profile = await User.findById(decodeToken.id);
        }
        if (profile == null) {
            return res.status(404).send("Account doesn't exists!")
        } else {
            return res.json({
                image: profile.image,
                name: profile.name,
                email: profile.email,
                address: profile.address,
                phone: profile.phone,
                role: profile.role,
            })
        }

    } else {
        return res.status(400).send("Wrong token, Please login")
    }
}



// change Avatar
module.exports.changeAvatar = async (req, res) => {

    // console.log(req);
    // console.log(req.headers['authorization']);
    var token = req.headers['authorization'];
    if (JWT.verify(token, process.env.JWTSecret)) {
        var decodeToken = JWT.decode(token, process.env.JWTSecret);
        var user = await User.findOne({
            email: decodeToken.email,
        });
        if (user == null) {
            return res.status(404).send('Authenticate failed!')
        } else {

            //storage images
            multerHandle.upload(req, res, function (err) {
                if (err instanceof require('multer').MulterError) {
                    return res.status(400).send('A Multer error occurred when uploading..')
                } else if (err) {
                    return res.status(400).send('A unknown error occurred when uploading..' + err)
                } else {

                    if (user.image != null) {
                        fs.unlink('public/upload/images/' + user.image, function (err) {
                            console.log(err);
                        });
                    }
                    user.image = req.file.filename;
                    user.save();
                    return res.status(200).send('image updated')
                }
            });
        }
    } else {
        return res.status(400).send("Wrong token, Please login")
    }
}
