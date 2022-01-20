const { Schema, model } = require('mongoose');

const unDealProductSchema = new Schema({
    productName: { type: String },
    unit: { type: String, },
    quantity: { type: Number },
    supID: { type: String },
    importPrice: { type: Number, },// for compare
    ratePrice: { type: Number },//nullable
    image: { type: String },//nullable
    description: { type: String, },//nullable
    //check for deal
    supplierConfirm: { type: Boolean },// = 1
    managerConfirm: { type: Boolean },// = 0
},
    {
        timestamps: true
    },
)

module.exports.UnDealProduct = model('UnDealProduct', unDealProductSchema)