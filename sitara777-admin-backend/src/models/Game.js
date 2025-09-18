const mongoose = require('mongoose');

const BetTypeSchema = new mongoose.Schema({
  betTypeId: String,
  name: String,
  displayName: String,
  minBet: {
    type: Number,
    default: 10.0
  },
  maxBet: {
    type: Number,
    default: 10000.0
  },
  winMultiplier: {
    type: Number,
    default: 9.5
  },
  isActive: {
    type: Boolean,
    default: true
  }
});

const GameRatesSchema = new mongoose.Schema({
  single: {
    type: Number,
    default: 9.5
  },
  jodi: {
    type: Number,
    default: 95.0
  },
  patti: {
    type: Number,
    default: 950.0
  },
  halfSangam: {
    type: Number,
    default: 1000.0
  },
  fullSangam: {
    type: Number,
    default: 10000.0
  }
});

const GameSchema = new mongoose.Schema({
  gameId: {
    type: String,
    required: true,
    unique: true
  },
  name: {
    type: String,
    required: true
  },
  displayName: {
    type: String,
    required: true
  },
  description: String,
  type: {
    type: String,
    enum: ['matka', 'casino', 'lottery'],
    default: 'matka'
  },
  category: String,
  bazaarId: String,
  icon: String,
  banner: String,
  isActive: {
    type: Boolean,
    default: true
  },
  openTime: {
    type: String,
    default: '10:00'
  },
  closeTime: {
    type: String,
    default: '20:00'
  },
  resultTime: {
    type: String,
    default: '20:30'
  },
  betTypes: [BetTypeSchema],
  rates: GameRatesSchema,
  createdAt: {
    type: Date,
    default: Date.now
  },
  updatedAt: {
    type: Date,
    default: Date.now
  },
  createdBy: {
    type: String,
    default: 'admin'
  },
  result: String,
  resultDeclaredAt: Date
});

// Update the updatedAt field before saving
GameSchema.pre('save', function(next) {
  this.updatedAt = Date.now();
  next();
});

module.exports = mongoose.model('Game', GameSchema);