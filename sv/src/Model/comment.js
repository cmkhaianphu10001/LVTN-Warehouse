const { Schema, model } = require('mongoose');

const commentSchema = new Schema({
    productID: { type: String },
    userID: { type: String, },
    userName: { type: String },
    userImage: { type: String },
    content: { type: String, },
    replyTo: { type: String, }
},
    {
        timestamps: true
    },
)

module.exports.Comment = model('Comment', commentSchema)