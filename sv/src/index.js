require('dotenv').config();
const mongoose = require('mongoose')
const app = require('./app')


mongoose.connect(process.env.MONGO_URL, {
    useNewUrlParser: true,
    useUnifiedtopology: true,
}).then(() => console.log('Connected to mongodb!'))
    .catch((err) => console.log(`Error:${err}`))

const port = process.env.PORT || 4000

var server = app.listen(port, () => {
    console.log(`Server running on port ${port}`)
})
