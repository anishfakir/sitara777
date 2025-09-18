const express = require('express');
const {
  getDashboardStats
} = require('../controllers/dashboardController');
const { protect, admin } = require('../middleware/auth');

const router = express.Router();

router.route('/stats')
  .get(protect, admin, getDashboardStats);

module.exports = router;