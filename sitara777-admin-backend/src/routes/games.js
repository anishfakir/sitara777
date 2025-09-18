const express = require('express');
const {
  getGames,
  getGame,
  createGame,
  updateGame,
  deleteGame
} = require('../controllers/gameController');
const { protect, admin } = require('../middleware/auth');

const router = express.Router();

router.route('/')
  .get(protect, admin, getGames)
  .post(protect, admin, createGame);

router.route('/:id')
  .get(protect, admin, getGame)
  .put(protect, admin, updateGame)
  .delete(protect, admin, deleteGame);

module.exports = router;