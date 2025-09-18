const User = require('../models/User');
const Game = require('../models/Game');
const Bet = require('../models/Bet');
const Transaction = require('../models/Transaction');
const Recharge = require('../models/Recharge');
const logger = require('../config/logger');

// @desc    Get dashboard statistics
// @route   GET /api/dashboard/stats
// @access  Private/Admin
const getDashboardStats = async (req, res, next) => {
  try {
    // Get total users
    const totalUsers = await User.countDocuments();

    // Get active users (last 30 days)
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
    
    const activeUsers = await User.countDocuments({
      'profile.lastLogin': { $gte: thirtyDaysAgo }
    });

    // Get total games
    const totalGames = await Game.countDocuments();

    // Get active games
    const activeGames = await Game.countDocuments({ isActive: true });

    // Get pending payments
    const pendingPayments = await Recharge.countDocuments({ status: 'pending' });

    // Get pending bets
    const pendingBets = await Bet.countDocuments({ status: 'pending' });

    // Get total wallet balance
    const walletStats = await User.aggregate([
      {
        $group: {
          _id: null,
          totalBalance: { $sum: '$wallet.balance' },
          totalDeposited: { $sum: '$wallet.totalDeposited' },
          totalWithdrawn: { $sum: '$wallet.totalWithdrawn' }
        }
      }
    ]);

    const totalBalance = walletStats.length > 0 ? walletStats[0].totalBalance : 0;
    const totalDeposited = walletStats.length > 0 ? walletStats[0].totalDeposited : 0;
    const totalWithdrawn = walletStats.length > 0 ? walletStats[0].totalWithdrawn : 0;

    res.status(200).json({
      status: 'success',
      data: {
        users: {
          total: totalUsers,
          active: activeUsers
        },
        games: {
          total: totalGames,
          active: activeGames
        },
        payments: {
          pending: pendingPayments
        },
        bets: {
          pending: pendingBets
        },
        wallet: {
          totalBalance,
          totalDeposited,
          totalWithdrawn
        }
      }
    });
  } catch (error) {
    logger.error('Get dashboard stats error:', error);
    next(error);
  }
};

module.exports = {
  getDashboardStats
};