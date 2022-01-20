const bcrypt = require('bcryptjs');
const _ = require('lodash');
const JWT = require('jsonwebtoken');
const nodeMailer = require('nodemailer');

const twilioSid = process.env.TWILIO_ACCOUNT_SID;
const twilioToken = process.env.TWILIO_AUTH_TOKEN;
const JWTsecret = process.env.JWTSecret;

const smsGe = require('twilio')(twilioSid, twilioToken)

const { User } = require('../Model/user');
const { unCheckUser } = require('../Model/unCheckUser');
const { Otp } = require('../Model/opt');
// const { rest } = require('lodash');
const otpGenerator = require('otp-generator');
// const { text } = require('body-parser');


const transporter = nodeMailer.createTransport({
    service: 'gmail',
    auth: {
        user: 'cmkhai.anphu10001@gmail.com',
        pass: '0395540052Aa'
    }
})


//sign In
// "email":"khai.cao.10001@hcmut.edu.vn",
// "password":"123123"
module.exports.login = async (req, res) => {
    const user = await User.findOne({
        email: req.body.email
    });
    const uncheckuser = await unCheckUser.findOne({
        email: req.body.email
    })
    if (user == null) {
        if (uncheckuser == null) {
            return res.status(404).send("Account doesn't exists...")
        } else {
            return res.status(404).send("Your account need confirmed by admin")
        }
    } else {
        if (await bcrypt.compare(req.body.password, user.password)) {

            const token = await JWT.sign(
                {
                    id: user._id,
                    email: user.email,
                    role: user.role,
                    isAdmin: user.isAdmin,
                },
                JWTsecret
            )


            return res.json({
                success: true,
                token: token,
                // id: user._id,
                // email: user.email,
                // role: user.role,
                // isAdmin: user.isAdmin,
            });
        } else {
            return res.status(404).send('Wrong password!')
        }
    }

}

// sign Up
// "image":"",
// "name":"Cao Minh Khai",
// "password":"123123",
// "email":"khai.cao.10001@hcmut.edu.vn",
// "phone": "+84395540052",
// "address":"239/2,khuongviet",
// "description":"test user for dev",
// "role":"supplier"
module.exports.register = async (req, res) => {
    console.log(req)
    //check exists in Users
    const user = await User.findOne({
        email: req.body.email
    })
    if (user) return res.status(400).send('User already registerd!')
    const usedPhone = await User.findOne({
        phone: req.body.phone
    })
    if (usedPhone) return res.status(400).send('Phone number already used!')

    //check exists in unCheckUsers
    const uncheckUser = await unCheckUser.findOne({
        email: req.body.email
    })
    if (uncheckUser) return res.status(400).send('User already registerd! pls wait admin confirm')
    const uncheckUserPhone = await unCheckUser.findOne({
        phone: req.body.phone
    })
    if (uncheckUserPhone) return res.status(400).send('Phone number already used!')


    //generate OTP
    const otpCode = otpGenerator.generate(6, {
        digits: true, alphabets: false, upperCase: false, specialChars: false
    })
    console.log(otpCode)

    const newOtp = new Otp({ phone: req.body.phone, otp: otpCode })

    await newOtp.save()
    await smsGe.messages.create({
        body: `Your otp code is ${newOtp.otp}`,
        from: '+18727135126',
        to: newOtp.phone
    }).then(message => console.log(message.sid));
    //has pass
    const hashpass = await bcrypt.hash(req.body.password, 10)

    // save new user
    try {
        const newUnCheckUser = new unCheckUser({
            image: req.body.image || null,
            name: req.body.name,
            password: hashpass,
            email: req.body.email,
            address: req.body.address,
            phone: req.body.phone,
            role: req.body.role,
            description: req.body.description || null,
            verify: false
        })
        await newUnCheckUser.save()
        return res.status(200).send('Please verify your phone number...');
    } catch (e) {
        console.log(JSON.stringify(e));
        return res.status(404).send(`something wrong! ${JSON.stringify(e)}`);
    }

}



// send sms code again
// "phone":"+84395540052"

module.exports.sendOtpCodeAgain = async (req, res) => {
    const uncheckuser = await unCheckUser.findOne({
        phone: req.body.phone
    })
    if (uncheckuser == null) return res.status(400).send(`phone number doesn't exist! `)
    const otpCode = otpGenerator.generate(6, {
        digits: true, alphabets: false, upperCase: false, specialChars: false
    })

    console.log(otpCode)

    const newOtp = new Otp({ phone: req.body.phone, otp: otpCode })

    await newOtp.save()
    await smsGe.messages.create({
        body: `Your otp code is ${newOtp.otp}`,
        from: '+18727135126',
        to: newOtp.phone
    }).then(message => console.log(message.sid));
    return res.status(200).send('otp code sent..')
}

//verify sms code
// "phone":"+84395540052",
// "otp":"627376"
module.exports.otpVerify = async (req, res) => {
    const uncheckuser = await unCheckUser.findOne({
        phone: req.body.phone
    })
    if (uncheckuser == null) return res.status(400).send(`phone number doesn't exist! `)


    const otpKeep = await Otp.find({
        phone: req.body.phone
    })
    if (otpKeep.length === 0) return res.status(400).send(`Your code expired!`)
    const rightOtpKeep = otpKeep[otpKeep.length - 1]

    console.log(rightOtpKeep.otp)
    console.log(req.body.otp)

    if (req.body.phone === rightOtpKeep.phone && rightOtpKeep.otp === req.body.otp) {

        const delOtp = await Otp.deleteMany({
            phone: rightOtpKeep.phone
        })

        uncheckuser.verify = true;
        uncheckuser.save();
        return res.status(200).send('verify successfully! Please wait admin confirm this account before login system')

    } else return res.status(400).send('Wrong OTP code!')


}


// // Confirm account req.body.
// req.body.targetEmail
// req.body.action = [0,1]
module.exports.confirmNewAccount = async (req, res) => {
    const { targetEmail, action } = req.body
    console.log(targetEmail, action)
    const user = await User.findOne({
        email: targetEmail
    })
    const uncheckuser = await unCheckUser.findOne({
        email: targetEmail
    })

    var mailoption = {
        from: 'cmkhai.anphu10001@gmail.com',
        to: targetEmail,
        subject: 'Confirm account Warehouse',
        text: `Your account was ${action ? 'Accepted, you can login system now' : 'Rejected'}`,
    }


    if (user == null) {
        if (uncheckuser == null) {
            return res.status(404).send("This account doesn't exist")
        } else {
            if (uncheckuser.verify) {
                await transporter.sendMail(mailoption, function (err, result) {
                    if (err) {
                        console.log(err);
                    } else {
                        console.log('Email sent:', result)
                    }
                })
                if (action) {
                    const newUser = new User({
                        image: uncheckuser.image || null,
                        name: uncheckuser.name,
                        password: uncheckuser.password,
                        email: uncheckuser.email,
                        address: uncheckuser.address,
                        phone: uncheckuser.phone,
                        role: uncheckuser.role,
                        description: uncheckuser.description || null,
                        isAdmin: false
                    })

                    await newUser.save()

                    const deluCUser = await unCheckUser.deleteMany({
                        email: targetEmail
                    })
                    return res.status(200).send('Accepted')
                } else {
                    const deluCUser = await unCheckUser.deleteMany({
                        email: targetEmail
                    })
                    return res.status(200).send('rejected')
                }
            } else {
                return res.status(403).send("This account didn't verify..")
            }
        }
    } else {
        return res.status(403).send("This account Alrealy exist")
    }
}



//Get uncheck user
module.exports.GetUncheckUser = async (req, res) => {
    console.log('GetUncheckUser')
    var token = req.headers['authorization'];
    if (JWT.verify(token, process.env.JWTSecret)) {
        var decodeToken = JWT.decode(token, process.env.JWTSecret);
        var user = await User.findOne({
            email: decodeToken.email,
        });
        if (user != null || user.role == 'manager') {
            var listUncheckUser = await unCheckUser.find();
            return res.status(200).json(listUncheckUser);
        } else {
            return res.status(400).send('Authentication failed!')
        }
    } else {
        return res.status(400).send('Wrong token, Please login')
    }

}