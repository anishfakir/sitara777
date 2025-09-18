const mongoose = require('mongoose');

const TransactionSchema = new mongoose.Schema({
  id: {
    type: String,
    required: true,
    unique: true
  },
  userId: {
    type: String,
    required: true
  },
  type: {
    type: String,
    enum: ['recharge', 'withdrawal', 'bet_placed', 'bet_won', 'bet_lost', 'admin_credit', 'admin_debit'],
    required: true
  },
  amount: {
    type: Number,
    required: true
  },
  status: {
    type: String,
    enum: ['pending', 'approved', 'rejected', 'completed', 'failed'],
    default: 'pending'
  },
  createdAt: {
    type: Date,
    default: Date.now
  },
  processedAt: Date,
  description: String,
  adminNote: String,
  paymentMethod: String,
  referenceId: String,
  previousBalance: Number,
  newBalance: Number,
  userName: String,
  userPhone: String
});

module.exports = mongoose.model('Transaction', TransactionSchema);