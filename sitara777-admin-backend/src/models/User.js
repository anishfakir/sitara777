const mongoose = require('mongoose');

const UserWalletSchema = new mongoose.Schema({
  balance: {
    type: Number,
    default: 0.0
  },
  totalDeposited: {
    type: Number,
    default: 0.0
  },
  totalWithdrawn: {
    type: Number,
    default: 0.0
  },
  totalWinnings: {
    type: Number,
    default: 0.0
  },
  totalLosses: {
    type: Number,
    default: 0.0
  },
  lastUpdated: {
    type: Date,
    default: Date.now
  },
  updatedBy: String
});

const UserProfileSchema = new mongoose.Schema({
  uid: {
    type: String,
    required: true
  },
  name: {
    type: String,
    required: true
  },
  phone: {
    type: String,
    required: true
  },
  email: String,
  avatar: String,
  createdAt: {
    type: Date,
    default: Date.now
  },
  lastLogin: {
    type: Date,
    default: Date.now
  },
  isActive: {
    type: Boolean,
    default: true
  },
  deviceToken: String
});

const UserSchema = new mongoose.Schema({
  uid: {
    type: String,
    required: true,
    unique: true
  },
  profile: UserProfileSchema,
  wallet: UserWalletSchema,
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
UserSchema.pre('save', function(next) {
  this.updatedAt = Date.now();
  next();
});

module.exports = mongoose.model('User', UserSchema);