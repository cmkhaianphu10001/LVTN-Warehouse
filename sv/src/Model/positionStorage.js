const { Schema, model } = require('mongoose');

const positionSchema = new Schema({

    description: { type: String },
    productID: { type: String, },

},
    {
        timestamps: true
    },
)

module.exports.PositionStorage = model('PositionStorage', positionSchema)