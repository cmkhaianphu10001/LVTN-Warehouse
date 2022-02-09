const { Schema, model } = require('mongoose');

const itemOfOrderSchema = new Schema({
    parentID: { type: String }, //point to order or cart
    productID: { type: String },
    newPrice: { type: Number },
    count: { type: Number },
},
    {
        timestamps: true
    },
)

module.exports.ItemOfOrder = model('ItemOfOrder', itemOfOrderSchema)