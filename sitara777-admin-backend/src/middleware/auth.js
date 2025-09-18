const jwt = require('jsonwebtoken');
const { verifyToken } = require('../config/auth');
const logger = require('../config/logger');

const protect = async (req, res, next) => {
  let token;

  if (
    req.headers.authorization &&
    req.headers.authorization.startsWith('Bearer')
  ) {
    try {
      token = req.headers.authorization.split(' ')[1];
      
      // Verify token
      const decoded = verifyToken(token);
      
      // Add user to request object
      req.user = decoded;
      
      next();
    } catch (error) {
      logger.error('Token verification failed:', error);
      return res.status(401).json({
        status: 'error',
        message: 'Not authorized, token failed',
      });
    }
  }

  if (!token) {
    return res.status(401).json({
      status: 'error',
      message: 'Not authorized, no token',
    });
  }
};

// Admin middleware
const admin = (req, res, next) => {
  if (req.user && req.user.role === 'admin') {
    next();
  } else {
    return res.status(403).json({
      status: 'error',
      message: 'Not authorized as admin',
    });
  }
};

module.exports = {
  protect,
  admin,
};