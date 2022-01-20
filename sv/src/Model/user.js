const { Schema, model } = require('mongoose');

const userSchema = new Schema({
    image: { type: String },
    name: { type: String, },
    password: { type: String, },
    address: { type: String, },
    phone: { type: String, },
    email: { type: String, },
    description: { type: String, },
    role: { type: String },
    isAdmin: { type: Boolean }
},
    {
        timestamps: true
    },
)

module.exports.User = model('User', userSchema)


// {
//     "name":"KhaiCao",
//     "password":"asdf1234",
//     "email":"khai.cao.10001@hcmut.edu.vn",
//     "phone": "+84395540052",
//     "address":"239/2,khuongviet",
//     "description":"something",
//     "role":"customer"
// }