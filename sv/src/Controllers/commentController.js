const JWT = require('jsonwebtoken');
const { User } = require('../Model/user');
const { Product } = require('../Model/product');
const { Comment } = require('../Model/comment');

module.exports.AddComment = async (req, res) => {
    console.log('add comment');
    console.log(req.body.id);
    var token = req.headers['authorization'];
    if (JWT.verify(token, process.env.JWTSecret)) {
        var decodeToken = JWT.decode(token, process.env.JWTSecret);

        var user = await User.findOne({
            email: decodeToken.email,
        });


        if (user != null) {
            if (req.body.replyTo != null) {
                var findParentreplyTo = await Comment.find({
                    replyTo: req.body.replyTo,
                });
                if (findParentreplyTo == null) {
                    return res.status(400).send("replyTo to doesn't exists comment.")
                }
            }
            try {
                console.log(req.body);
                var newComment = new Comment({
                    productID: req.body.productID,
                    userID: user._id,
                    userName: user.name,
                    userImage: user.image,
                    content: req.body.content,
                    replyTo: req.body.replyTo ?? null,
                });

                newComment.save();
                return res.status(200).send('Success');


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



module.exports.GetCommentsOfProduct = async (req, res) => {
    console.log('get comments productif');
    var token = req.headers['authorization'];
    var productID = req.headers['productid'];
    if (JWT.verify(token, process.env.JWTSecret)) {
        var decodeToken = JWT.decode(token, process.env.JWTSecret);

        var user = await User.findOne({
            email: decodeToken.email,
        });


        if (user != null) {

            try {
                var comments = await Comment.find({
                    productID: productID,
                })
                return res.status(200).json(comments);


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