const express = require('express');
const {
  getBets,
  getBet,
  updateBetStatus
} = require('../controllers/betController');
const { protect, admin } = require('../middleware/auth');

const router = express.Router();

router.route('/')
  .get(protect, admin, getBets);

router.route('/:id')
  .get(protect, admin, getBet);

router.route('/:id/status')
  .put(protect, admin, updateBetStatus);

module.exports = router;