const { Schema, model } = require('mongoose');

const orderSchema = new Schema({
    orderDate: { type: Date },
    cusID: { type: String },
    isConfirm: { type: Boolean },
    totalAmount: { type: Number },
    // items: [{ type: Array }]
},
    {
        timestamps: true
    },
)

module.exports.Order = model('Order', orderSchema)