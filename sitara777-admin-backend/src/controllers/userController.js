// In-memory storage for demo purposes
const users = [
  {
    uid: '1',
    profile: {
      name: 'John Doe',
      phone: '+1234567890',
      email: 'john@example.com',
      isActive: true,
      createdAt: new Date('2023-01-01'),
      lastLogin: new Date('2023-01-15')
    },
    wallet: {
      balance: 1000.00,
      totalDeposited: 2000.00,
      totalWithdrawn: 500.00,
      totalWinnings: 1000.00,
      totalLosses: 500.00,
      lastUpdated: new Date()
    }
  },
  {
    uid: '2',
    profile: {
      name: 'Jane Smith',
      phone: '+1234567891',
      email: 'jane@example.com',
      isActive: true,
      createdAt: new Date('2023-01-05'),
      lastLogin: new Date('2023-01-10')
    },
    wallet: {
      balance: 2500.00,
      totalDeposited: 3000.00,
      totalWithdrawn: 1000.00,
      totalWinnings: 1500.00,
      totalLosses: 1000.00,
      lastUpdated: new Date()
    }
  },
  {
    uid: '3',
    profile: {
      name: 'Bob Johnson',
      phone: '+1234567892',
      email: 'bob@example.com',
      isActive: false,
      createdAt: new Date('2023-01-10'),
      lastLogin: new Date('2023-01-12')
    },
    wallet: {
      balance: 500.00,
      totalDeposited: 1000.00,
      totalWithdrawn: 750.00,
      totalWinnings: 500.00,
      totalLosses: 750.00,
      lastUpdated: new Date()
    }
  }
];

const logger = require('../config/logger');

// @desc    Get all users
// @route   GET /api/users
// @access  Private/Admin
const getUsers = async (req, res, next) => {
  try {
    // Pagination
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const startIndex = (page - 1) * limit;

    // Search filter
    let filteredUsers = [...users];
    if (req.query.search) {
      const search = req.query.search.toLowerCase();
      filteredUsers = users.filter(user => 
        user.profile.name.toLowerCase().includes(search) ||
        user.profile.phone.includes(search) ||
        user.profile.email.toLowerCase().includes(search)
      );
    }

    // Status filter
    if (req.query.status) {
      const isActive = req.query.status === 'active';
      filteredUsers = filteredUsers.filter(user => user.profile.isActive === isActive);
    }

    const total = filteredUsers.length;
    const paginatedUsers = filteredUsers.slice(startIndex, startIndex + limit);

    res.status(200).json({
      status: 'success',
      count: paginatedUsers.length,
      total,
      page,
      pages: Math.ceil(total / limit),
      data: paginatedUsers
    });
  } catch (error) {
    logger.error('Get users error:', error);
    next(error);
  }
};

// @desc    Get single user
// @route   GET /api/users/:id
// @access  Private/Admin
const getUser = async (req, res, next) => {
  try {
    const user = users.find(u => u.uid === req.params.id);

    if (!user) {
      return res.status(404).json({
        status: 'error',
        message: 'User not found'
      });
    }

    res.status(200).json({
      status: 'success',
      data: user
    });
  } catch (error) {
    logger.error('Get user error:', error);
    next(error);
  }
};

// @desc    Update user
// @route   PUT /api/users/:id
// @access  Private/Admin
const updateUser = async (req, res, next) => {
  try {
    const userIndex = users.findIndex(u => u.uid === req.params.id);

    if (userIndex === -1) {
      return res.status(404).json({
        status: 'error',
        message: 'User not found'
      });
    }

    // Update user fields
    if (req.body.name) users[userIndex].profile.name = req.body.name;
    if (req.body.email) users[userIndex].profile.email = req.body.email;
    if (req.body.phone) users[userIndex].profile.phone = req.body.phone;
    if (req.body.isActive !== undefined) users[userIndex].profile.isActive = req.body.isActive;

    res.status(200).json({
      status: 'success',
      data: users[userIndex]
    });
  } catch (error) {
    logger.error('Update user error:', error);
    next(error);
  }
};

// @desc    Delete user
// @route   DELETE /api/users/:id
// @access  Private/Admin
const deleteUser = async (req, res, next) => {
  try {
    const userIndex = users.findIndex(u => u.uid === req.params.id);

    if (userIndex === -1) {
      return res.status(404).json({
        status: 'error',
        message: 'User not found'
      });
    }

    users.splice(userIndex, 1);

    res.status(200).json({
      status: 'success',
      message: 'User removed successfully'
    });
  } catch (error) {
    logger.error('Delete user error:', error);
    next(error);
  }
};

module.exports = {
  getUsers,
  getUser,
  updateUser,
  deleteUser
};