const multer = require('multer');
// storage image
var storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, 'public/upload/images')
    },
    filename: function (req, file, cb) {
        // cb(null, Date.now() + '-' + file.originalname.replace(/image_picker/g, ''));
        cb(null, Date.now() + '-' + file.originalname.replaceAll('image_picker', ''));
    }

})

module.exports.upload = multer({
    storage: storage,
    fileFilter: function (req, file, cb) {
        console.log(file);
        if (file.mimetype == 'image/jpg' ||
            file.mimetype == 'image/png' ||
            file.mimetype == 'image/jpeg' ||
            file.mimetype == 'application/octet-stream') {
            cb(null, true);
        } else {
            console.log(file)
            return cb(new Error('Only image are allowed'))
        }
    },

}).single('image');
