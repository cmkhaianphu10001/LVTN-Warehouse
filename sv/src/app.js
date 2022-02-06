const express = require('express')
const app = express()

const userRouter = require('./Routers/user')
const profileRouter = require('./Routers/profile')
const productRouter = require('./Routers/product')
const order = require('./Routers/oder')
const pStorage = require('./Routers/pStorage')
const comment = require('./Routers/comment')

const imageRoute = express.static('./public/upload/images')

app.use(express.json());

app.use('/public/upload/images', imageRoute);
app.use('/api/product', productRouter)
app.use('/api/user', userRouter);
app.use('/api/profile', profileRouter);
app.use('/api/order', order);
app.use('/api/positionStorage', pStorage);
app.use('/api/comment/', comment)

module.exports = app