const Transaction = require('../models/Transaction');
const logger = require('../config/logger');

// @desc    Get all transactions
// @route   GET /api/transactions
// @access  Private/Admin
const getTransactions = async (req, res, next) => {
  try {
    // Pagination
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const startIndex = (page - 1) * limit;

    // Search filter
    let filter = {};
    if (req.query.userId) {
      filter.userId = req.query.userId;
    }
    if (req.query.type) {
      filter.type = req.query.type;
    }
    if (req.query.status) {
      filter.status = req.query.status;
    }

    const transactions = await Transaction.find(filter)
      .sort({ createdAt: -1 })
      .limit(limit)
      .skip(startIndex);

    const total = await Transaction.countDocuments(filter);

    res.status(200).json({
      status: 'success',
      count: transactions.length,
      total,
      page,
      pages: Math.ceil(total / limit),
      data: transactions
    });
  } catch (error) {
    logger.error('Get transactions error:', error);
    next(error);
  }
};

// @desc    Get single transaction
// @route   GET /api/transactions/:id
// @access  Private/Admin
const getTransaction = async (req, res, next) => {
  try {
    const transaction = await Transaction.findOne({ id: req.params.id });

    if (!transaction) {
      return res.status(404).json({
        status: 'error',
        message: 'Transaction not found'
      });
    }

    res.status(200).json({
      status: 'success',
      data: transaction
    });
  } catch (error) {
    logger.error('Get transaction error:', error);
    next(error);
  }
};

module.exports = {
  getTransactions,
  getTransaction
};