const { Schema, model } = require('mongoose');

const QRSchema = new Schema({
    productID: { type: String, },
    importDate: { type: Date, },
    managerIDImport: { type: String },
    importID: { type: String },
    //nullable
    cusID: { type: String, },
    exportID: { type: String },
    exportDate: { type: Date, },
    managerIDExport: { type: String },
    exportPrice: { type: String },
    locationID: { type: String, },
},
    {
        timestamps: true
    },
)

module.exports.QR = model('QR', QRSchema)