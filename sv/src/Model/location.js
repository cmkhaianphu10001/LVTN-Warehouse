const { Schema, model } = require('mongoose');

const locationSchema = new Schema({
    area: { type: String },
    row: { type: String },
    shelf: { type: String },
    capacity: { type: Number },
    storage: { type: Number },
},
    {
        timestamps: true
    },
)

module.exports.Location = model('Location', locationSchema)