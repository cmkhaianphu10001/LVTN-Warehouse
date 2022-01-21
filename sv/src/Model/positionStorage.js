const { Schema, model } = require('mongoose');

const positionSchema = new Schema({

    description: { type: String },
    positionName: { type: String },
    productID: { type: String, },
    image: { type: String },
    productName: { type: String },
},
    {
        timestamps: true
    },
)

module.exports.PositionStorage = model('PositionStorage', positionSchema)