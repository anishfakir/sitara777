const mongoose = require('mongoose');

const BetSchema = new mongoose.Schema({
  id: {
    type: String,
    required: true,
    unique: true
  },
  userId: {
    type: String,
    required: true
  },
  gameId: {
    type: String,
    required: true
  },
  gameName: {
    type: String,
    required: true
  },
  betTypeId: {
    type: String,
    required: true
  },
  betTypeName: {
    type: String,
    required: true
  },
  amount: {
    type: Number,
    required: true
  },
  betNumber: {
    type: String,
    required: true
  },
  timestamp: {
    type: Number,
    default: () => Date.now()
  },
  placedAt: {
    type: Date,
    default: Date.now
  },
  status: {
    type: String,
    enum: ['pending', 'won', 'lost', 'cancelled'],
    default: 'pending'
  },
  winAmount: Number,
  result: String,
  createdAt: {
    type: Date,
    default: Date.now
  },
  updatedAt: {
    type: Date,
    default: Date.now
  }
});

// Update the updatedAt field before saving
BetSchema.pre('save', function(next) {
  this.updatedAt = Date.now();
  next();
});

module.exports = mongoose.model('Bet', BetSchema);