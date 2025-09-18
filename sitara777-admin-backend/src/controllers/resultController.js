const Result = require('../models/Result');
const logger = require('../config/logger');

// @desc    Get all results
// @route   GET /api/results
// @access  Private/Admin
const getResults = async (req, res, next) => {
  try {
    // Pagination
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const startIndex = (page - 1) * limit;

    // Search filter
    let filter = {};
    if (req.query.gameId) {
      filter.gameId = req.query.gameId;
    }
    if (req.query.date) {
      filter.date = req.query.date;
    }

    const results = await Result.find(filter)
      .sort({ declaredAt: -1 })
      .limit(limit)
      .skip(startIndex);

    const total = await Result.countDocuments(filter);

    res.status(200).json({
      status: 'success',
      count: results.length,
      total,
      page,
      pages: Math.ceil(total / limit),
      data: results
    });
  } catch (error) {
    logger.error('Get results error:', error);
    next(error);
  }
};

// @desc    Get single result
// @route   GET /api/results/:id
// @access  Private/Admin
const getResult = async (req, res, next) => {
  try {
    const result = await Result.findOne({ resultId: req.params.id });

    if (!result) {
      return res.status(404).json({
        status: 'error',
        message: 'Result not found'
      });
    }

    res.status(200).json({
      status: 'success',
      data: result
    });
  } catch (error) {
    logger.error('Get result error:', error);
    next(error);
  }
};

// @desc    Create result
// @route   POST /api/results
// @access  Private/Admin
const createResult = async (req, res, next) => {
  try {
    const result = await Result.create(req.body);

    res.status(201).json({
      status: 'success',
      data: result
    });
  } catch (error) {
    logger.error('Create result error:', error);
    next(error);
  }
};

// @desc    Update result
// @route   PUT /api/results/:id
// @access  Private/Admin
const updateResult = async (req, res, next) => {
  try {
    let result = await Result.findOne({ resultId: req.params.id });

    if (!result) {
      return res.status(404).json({
        status: 'error',
        message: 'Result not found'
      });
    }

    result = await Result.findOneAndUpdate(
      { resultId: req.params.id },
      req.body,
      {
        new: true,
        runValidators: true
      }
    );

    res.status(200).json({
      status: 'success',
      data: result
    });
  } catch (error) {
    logger.error('Update result error:', error);
    next(error);
  }
};

// @desc    Delete result
// @route   DELETE /api/results/:id
// @access  Private/Admin
const deleteResult = async (req, res, next) => {
  try {
    const result = await Result.findOne({ resultId: req.params.id });

    if (!result) {
      return res.status(404).json({
        status: 'error',
        message: 'Result not found'
      });
    }

    await result.remove();

    res.status(200).json({
      status: 'success',
      message: 'Result removed successfully'
    });
  } catch (error) {
    logger.error('Delete result error:', error);
    next(error);
  }
};

module.exports = {
  getResults,
  getResult,
  createResult,
  updateResult,
  deleteResult
};