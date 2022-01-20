const { Schema, model } = require('mongoose')

const optSchema = new Schema({
    phone: { type: String },
    otp: { type: String },
    createAt: { type: Date, default: Date.now, index: { expires: 300 } } // delete after 5m
}, { timestamps: true })

module.exports.Otp = model('Otp', optSchema)