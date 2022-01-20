const express = require('express');
// const { route } = require('../app');
const router = express.Router();
const { getProfile, changeAvatar } = require('../Controllers/profileController');

router.route('/getProfile').get(getProfile);
router.route('/changeAvatar').post(changeAvatar);
// router.route('/register/otpVerify').post(otpVerify)
// router.route('/register/sendOtpCodeAgain').post(sendOtpCodeAgain)
// router.route('/register/confirmNewAccount').post(confirmNewAccount)


module.exports = router;