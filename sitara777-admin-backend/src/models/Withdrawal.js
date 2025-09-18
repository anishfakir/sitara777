const mongoose = require('mongoose');

const WithdrawalSchema = new mongoose.Schema({
  id: {
    type: String,
    required: true,
    unique: true
  },
  userId: {
    type: String,
    required: true
  },
  amount: {
    type: Number,
    required: true
  },
  withdrawalMethod: {
    type: String,
    required: true
  },
  accountDetails: {
    accountNumber: String,
    ifscCode: String,
    accountHolderName: String,
    upiId: String
  },
  status: {
    type: String,
    enum: ['pending', 'approved', 'rejected', 'processed'],
    default: 'pending'
  },
  requestedAt: {
    type: Date,
    default: Date.now
  },
  processedAt: Date,
  processedBy: String,
  adminNotes: String,
  transactionId: String,
  userName: String,
  userPhone: String
});

module.exports = mongoose.model('Withdrawal', WithdrawalSchema);