const JWT = require('jsonwebtoken');
const { PositionStorage } = require('../Model/positionStorage');

module.exports.GetPosition = async (req, res) => {
    return res.status(400).send('Authenticate failed!!');
}