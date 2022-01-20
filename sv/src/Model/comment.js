const { Schema, model } = require('mongoose');

const commentSchema = new Schema({
    productID: { type: String },
    cusID: { type: String, },
    content: { type: String, },
    rateStar: { type: Number, }
},
    {
        timestamps: true
    },
)

module.exports.Comment = model('Comment', commentSchema)