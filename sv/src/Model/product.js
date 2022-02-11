const { Schema, model } = require('mongoose');

const productSchema = new Schema({
    productName: { type: String },
    unit: { type: String, },
    quantity: { type: Number },
    supID: { type: String },//change
    importPrice: { type: String, },
    ratePrice: { type: Number },
    image: { type: String },
    description: { type: String, },
    // comment: [{ type: String }],
    stored: { type: String, },
    sold: { type: Number },
},
    {
        timestamps: true
    },
)

module.exports.Product = model('Product', productSchema)