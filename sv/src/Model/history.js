const { Schema, model } = require('mongoose');

const HistorySchema = new Schema({
    typeHistory: { type: String },
    date: { type: Date },
    userTargetID: { type: String },
    managerID: { type: String },
    totalAmount: { type: Number },
},
    {
        timestamps: true
    },
)

module.exports.History = model('History', HistorySchema)