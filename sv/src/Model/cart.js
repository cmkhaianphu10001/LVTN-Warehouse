const { Schema, model } = require('mongoose');

const cartSchema = new Schema({
    cusID: { type: String },
},
    {
        timestamps: true
    },
)

module.exports.Cart = model('Cart', cartSchema)