const express = require('express');
const {
  getTransactions,
  getTransaction
} = require('../controllers/transactionController');
const { protect, admin } = require('../middleware/auth');

const router = express.Router();

router.route('/')
  .get(protect, admin, getTransactions);

router.route('/:id')
  .get(protect, admin, getTransaction);

module.exports = router;