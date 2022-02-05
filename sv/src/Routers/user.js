const express = require('express');

const router = express.Router();
const { register,
    login,
    otpVerify,
    sendOtpCodeAgain,
    confirmNewAccount,
    GetUncheckUser } = require('../Controllers/authController');

const { GetSupplier, GetManager, GetUsers } = require('../Controllers/userController');

//authentication
router.route('/login').post(login)
router.route('/register').post(register)
router.route('/register/otpVerify').post(otpVerify)
router.route('/register/sendOtpCodeAgain').post(sendOtpCodeAgain)
router.route('/register/confirmNewAccount').post(confirmNewAccount)
router.route('/register/getUncheckUser').get(GetUncheckUser)

//User data
router.route('/getSupplier').get(GetSupplier);
router.route('/getManager').get(GetManager);
router.route('/getusers').get(GetUsers);

module.exports = router;