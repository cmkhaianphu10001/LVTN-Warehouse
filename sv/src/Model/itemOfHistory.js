const { Schema, model } = require('mongoose');

const ItemOfHistorySchema = new Schema({
    parentID: { type: String },
    productID: { type: String },
    count: { type: Number },
},
    {
        timestamps: true
    },
)

module.exports.ItemOfHistory = model('ItemOfHistory', ItemOfHistorySchema)