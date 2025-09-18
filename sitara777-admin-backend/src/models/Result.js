const mongoose = require('mongoose');

const ResultSchema = new mongoose.Schema({
  resultId: {
    type: String,
    required: true,
    unique: true
  },
  gameId: {
    type: String,
    required: true
  },
  gameName: {
    type: String,
    required: true
  },
  date: {
    type: String,
    required: true
  },
  session: {
    type: String,
    enum: ['open', 'close'],
    default: 'open'
  },
  result: {
    type: String,
    required: true
  },
  openPatti: String,
  closePatti: String,
  jodi: String,
  declaredAt: {
    type: Date,
    default: Date.now
  },
  declaredBy: {
    type: String,
    default: 'admin'
  },
  isVerified: {
    type: Boolean,
    default: false
  },
  winningBids: [String],
  totalWinAmount: {
    type: Number,
    default: 0.0
  },
  totalBidAmount: {
    type: Number,
    default: 0.0
  },
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
ResultSchema.pre('save', function(next) {
  this.updatedAt = Date.now();
  next();
});

module.exports = mongoose.model('Result', ResultSchema);