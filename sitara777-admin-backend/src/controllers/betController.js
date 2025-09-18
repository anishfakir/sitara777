const Bet = require('../models/Bet');
const logger = require('../config/logger');

// @desc    Get all bets
// @route   GET /api/bets
// @access  Private/Admin
const getBets = async (req, res, next) => {
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
    if (req.query.gameId) {
      filter.gameId = req.query.gameId;
    }
    if (req.query.status) {
      filter.status = req.query.status;
    }
    if (req.query.dateFrom || req.query.dateTo) {
      filter.placedAt = {};
      if (req.query.dateFrom) {
        filter.placedAt.$gte = new Date(req.query.dateFrom);
      }
      if (req.query.dateTo) {
        filter.placedAt.$lte = new Date(req.query.dateTo);
      }
    }

    const bets = await Bet.find(filter)
      .sort({ placedAt: -1 })
      .limit(limit)
      .skip(startIndex);

    const total = await Bet.countDocuments(filter);

    res.status(200).json({
      status: 'success',
      count: bets.length,
      total,
      page,
      pages: Math.ceil(total / limit),
      data: bets
    });
  } catch (error) {
    logger.error('Get bets error:', error);
    next(error);
  }
};

// @desc    Get single bet
// @route   GET /api/bets/:id
// @access  Private/Admin
const getBet = async (req, res, next) => {
  try {
    const bet = await Bet.findOne({ id: req.params.id });

    if (!bet) {
      return res.status(404).json({
        status: 'error',
        message: 'Bet not found'
      });
    }

    res.status(200).json({
      status: 'success',
      data: bet
    });
  } catch (error) {
    logger.error('Get bet error:', error);
    next(error);
  }
};

// @desc    Update bet status
// @route   PUT /api/bets/:id/status
// @access  Private/Admin
const updateBetStatus = async (req, res, next) => {
  try {
    const { status, winAmount, result } = req.body;

    let bet = await Bet.findOne({ id: req.params.id });

    if (!bet) {
      return res.status(404).json({
        status: 'error',
        message: 'Bet not found'
      });
    }

    // Update bet status
    bet.status = status;
    if (winAmount !== undefined) bet.winAmount = winAmount;
    if (result !== undefined) bet.result = result;
    bet.updatedAt = Date.now();

    await bet.save();

    res.status(200).json({
      status: 'success',
      data: bet
    });
  } catch (error) {
    logger.error('Update bet status error:', error);
    next(error);
  }
};

module.exports = {
  getBets,
  getBet,
  updateBetStatus
};