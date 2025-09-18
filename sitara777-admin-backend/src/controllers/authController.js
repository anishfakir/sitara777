// In-memory storage for demo purposes
const admins = [
  {
    id: '1',
    name: 'Admin User',
    email: 'admin@example.com',
    password: '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj/RK.PZvO.S', // password: admin123
    role: 'admin',
    isActive: true,
    lastLogin: new Date()
  }
];

const { generateToken, hashPassword, comparePassword } = require('../config/auth');
const logger = require('../config/logger');

// @desc    Register admin
// @route   POST /api/auth/register
// @access  Public
const registerAdmin = async (req, res, next) => {
  try {
    const { name, email, password, role } = req.body;

    // Check if admin exists
    const adminExists = admins.find(admin => admin.email === email);
    if (adminExists) {
      return res.status(400).json({
        status: 'error',
        message: 'Admin already exists with this email'
      });
    }

    // Hash password
    const hashedPassword = await hashPassword(password);

    // Create admin
    const admin = {
      id: (admins.length + 1).toString(),
      name,
      email,
      password: hashedPassword,
      role: role || 'admin',
      isActive: true,
      lastLogin: new Date()
    };
    
    admins.push(admin);

    // Generate token
    const token = generateToken({
      id: admin.id,
      name: admin.name,
      email: admin.email,
      role: admin.role
    });

    res.status(201).json({
      status: 'success',
      token,
      data: {
        id: admin.id,
        name: admin.name,
        email: admin.email,
        role: admin.role,
        isActive: admin.isActive
      }
    });
  } catch (error) {
    logger.error('Admin registration error:', error);
    next(error);
  }
};

// @desc    Authenticate admin & get token
// @route   POST /api/auth/login
// @access  Public
const loginAdmin = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    // Validate email & password
    if (!email || !password) {
      return res.status(400).json({
        status: 'error',
        message: 'Please provide an email and password'
      });
    }

    // Check for admin
    const admin = admins.find(admin => admin.email === email);
    if (!admin) {
      return res.status(401).json({
        status: 'error',
        message: 'Invalid credentials'
      });
    }

    // Check if admin is active
    if (!admin.isActive) {
      return res.status(401).json({
        status: 'error',
        message: 'Account is deactivated'
      });
    }

    // Check password
    const isMatch = await comparePassword(password, admin.password);
    if (!isMatch) {
      return res.status(401).json({
        status: 'error',
        message: 'Invalid credentials'
      });
    }

    // Update last login
    admin.lastLogin = new Date();

    // Generate token
    const token = generateToken({
      id: admin.id,
      name: admin.name,
      email: admin.email,
      role: admin.role
    });

    res.status(200).json({
      status: 'success',
      token,
      data: {
        id: admin.id,
        name: admin.name,
        email: admin.email,
        role: admin.role,
        isActive: admin.isActive,
        lastLogin: admin.lastLogin
      }
    });
  } catch (error) {
    logger.error('Admin login error:', error);
    next(error);
  }
};

// @desc    Get current admin
// @route   GET /api/auth/me
// @access  Private
const getMe = async (req, res, next) => {
  try {
    const admin = admins.find(admin => admin.id === req.user.id);

    res.status(200).json({
      status: 'success',
      data: admin
    });
  } catch (error) {
    logger.error('Get admin profile error:', error);
    next(error);
  }
};

// @desc    Logout admin
// @route   POST /api/auth/logout
// @access  Private
const logoutAdmin = async (req, res, next) => {
  try {
    res.status(200).json({
      status: 'success',
      message: 'Logged out successfully'
    });
  } catch (error) {
    logger.error('Admin logout error:', error);
    next(error);
  }
};

module.exports = {
  registerAdmin,
  loginAdmin,
  getMe,
  logoutAdmin
};