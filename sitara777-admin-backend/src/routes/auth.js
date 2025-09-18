const express = require('express');
const {
  registerAdmin,
  loginAdmin,
  getMe,
  logoutAdmin
} = require('../controllers/authController');
const { protect } = require('../middleware/auth');

const router = express.Router();

router.post('/register', registerAdmin);
router.post('/login', loginAdmin);
router.get('/me', protect, getMe);
router.post('/logout', logoutAdmin);

module.exports = router;