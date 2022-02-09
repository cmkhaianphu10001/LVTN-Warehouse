const { Schema, model } = require('mongoose');

const orderSchema = new Schema({
    orderDate: { type: Date },
    cusID: { type: String },
    process: { type: Number },// 1:order, 0:rejected, 2:accepted, 3:exported, 4:completed
    totalAmount: { type: Number },
    description: { type: String },
},
    {
        timestamps: true
    },
)

module.exports.Order = model('Order', orderSchema)