const Game = require('../models/Game');
const logger = require('../config/logger');

// @desc    Get all games
// @route   GET /api/games
// @access  Private/Admin
const getGames = async (req, res, next) => {
  try {
    // Pagination
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const startIndex = (page - 1) * limit;

    // Search filter
    let filter = {};
    if (req.query.search) {
      filter = {
        $or: [
          { name: { $regex: req.query.search, $options: 'i' } },
          { displayName: { $regex: req.query.search, $options: 'i' } },
          { category: { $regex: req.query.search, $options: 'i' } }
        ]
      };
    }

    // Status filter
    if (req.query.status) {
      filter.isActive = req.query.status === 'active';
    }

    const games = await Game.find(filter)
      .sort({ createdAt: -1 })
      .limit(limit)
      .skip(startIndex);

    const total = await Game.countDocuments(filter);

    res.status(200).json({
      status: 'success',
      count: games.length,
      total,
      page,
      pages: Math.ceil(total / limit),
      data: games
    });
  } catch (error) {
    logger.error('Get games error:', error);
    next(error);
  }
};

// @desc    Get single game
// @route   GET /api/games/:id
// @access  Private/Admin
const getGame = async (req, res, next) => {
  try {
    const game = await Game.findOne({ gameId: req.params.id });

    if (!game) {
      return res.status(404).json({
        status: 'error',
        message: 'Game not found'
      });
    }

    res.status(200).json({
      status: 'success',
      data: game
    });
  } catch (error) {
    logger.error('Get game error:', error);
    next(error);
  }
};

// @desc    Create game
// @route   POST /api/games
// @access  Private/Admin
const createGame = async (req, res, next) => {
  try {
    const game = await Game.create(req.body);

    res.status(201).json({
      status: 'success',
      data: game
    });
  } catch (error) {
    logger.error('Create game error:', error);
    next(error);
  }
};

// @desc    Update game
// @route   PUT /api/games/:id
// @access  Private/Admin
const updateGame = async (req, res, next) => {
  try {
    let game = await Game.findOne({ gameId: req.params.id });

    if (!game) {
      return res.status(404).json({
        status: 'error',
        message: 'Game not found'
      });
    }

    game = await Game.findOneAndUpdate(
      { gameId: req.params.id },
      req.body,
      {
        new: true,
        runValidators: true
      }
    );

    res.status(200).json({
      status: 'success',
      data: game
    });
  } catch (error) {
    logger.error('Update game error:', error);
    next(error);
  }
};

// @desc    Delete game
// @route   DELETE /api/games/:id
// @access  Private/Admin
const deleteGame = async (req, res, next) => {
  try {
    const game = await Game.findOne({ gameId: req.params.id });

    if (!game) {
      return res.status(404).json({
        status: 'error',
        message: 'Game not found'
      });
    }

    await game.remove();

    res.status(200).json({
      status: 'success',
      message: 'Game removed successfully'
    });
  } catch (error) {
    logger.error('Delete game error:', error);
    next(error);
  }
};

module.exports = {
  getGames,
  getGame,
  createGame,
  updateGame,
  deleteGame
};