const express = require('express');
const {
  getResults,
  getResult,
  createResult,
  updateResult,
  deleteResult
} = require('../controllers/resultController');
const { protect, admin } = require('../middleware/auth');

const router = express.Router();

router.route('/')
  .get(protect, admin, getResults)
  .post(protect, admin, createResult);

router.route('/:id')
  .get(protect, admin, getResult)
  .put(protect, admin, updateResult)
  .delete(protect, admin, deleteResult);

module.exports = router;