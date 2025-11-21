import express from 'express';
import jwt from 'jsonwebtoken';
import { body, validationResult } from 'express-validator';
import User from '../models/User.js';
import { protect } from '../middleware/auth.js';
import { sendVerificationEmail, sendOtpEmail } from '../utils/emailService.js';
import crypto from 'crypto';

const router = express.Router();

// Test endpoint
router.get('/test', (req, res) => {
  res.json({ message: 'Auth routes are working!' });
});

const generateToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRE,
  });
};

// // Register route
// router.post('/register', [
//   body('name').notEmpty().withMessage('Name is required'),
//   body('email').isEmail().withMessage('Please include a valid email'),
//   body('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters')
// ], async (req, res) => {
//   try {
//     const errors = validationResult(req);
//     if (!errors.isEmpty()) {
//       return res.status(400).json({
//         success: false,
//         errors: errors.array()
//       });
//     }

//     const { name, email, password } = req.body;

//     const userExists = await User.findOne({ email });
//     if (userExists) {
//       return res.status(400).json({
//         success: false,
//         message: 'User already exists with this email'
//       });
//     }

//     const user = await User.create({
//       name,
//       email,
//       password
//     });

//     // ✅ ADDED: Generate email verification token
//     // const emailVerifyToken = crypto.randomBytes(32).toString('hex');
//     // const emailVerifyExpire = Date.now() + 60 * 60 * 1000; // 1 hour

//     // user.emailVerifyToken = crypto
//     //   .createHash('sha256')
//     //   .update(emailVerifyToken)
//     //   .digest('hex');
//     // user.emailVerifyExpire = emailVerifyExpire;
//     // await user.save();

//     // // ✅ ADDED: Send verification email
//     // await sendVerificationEmail(user, emailVerifyToken);

//     const token = generateToken(user._id);

//     res.status(201).json({
//       success: true,
//       token,
//       user: {
//         id: user._id,
//         name: user.name,
//         email: user.email,
//         bio: user.bio,
//         joinDate: user.joinDate
//       },
//       message: 'Registration successful! Please check your email to verify your account.'
//     });
//   } catch (error) {
//     console.error('Registration error:', error);
//     res.status(500).json({
//       success: false,
//       message: 'Server error during registration'
//     });
//   }
// });


// Register route
router.post('/register', [
  body('name').notEmpty().withMessage('Name is required'),
  body('email').isEmail().withMessage('Please include a valid email'),
  body('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters')
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        errors: errors.array()
      });
    }

    const { name, email, password } = req.body;
    const userExists = await User.findOne({ email });

    if (userExists) {
      return res.status(400).json({
        success: false,
        message: 'User already exists with this email'
      });
    }

    // Create the user
    const user = await User.create({
      name,
      email,
      password
    });

    // -------------------------------------------------------
    // ✅ NEW OTP VERIFICATION LOGIC
    // -------------------------------------------------------
    let otp = '';
    try {
      // Generate 6-digit OTP
      otp = Math.floor(100000 + Math.random() * 900000).toString();
      const otpExpire = Date.now() + 10 * 60 * 1000; // 10 minutes

      user.otp = otp;
      user.otpExpire = otpExpire;

      await user.save();

      // Try sending the email but DO NOT fail registration if email fails
      try {
        await sendOtpEmail(user, otp);
        console.log("✅ OTP email sent to:", user.email);
        console.log("🔐 OTP for testing:", otp);
      } catch (emailError) {
        console.error("❌ Email sending failed:", emailError.message);
      }

    } catch (emailSetupError) {
      console.error("❌ Email setup error:", emailSetupError.message);
    }
    // -------------------------------------------------------

    const token = generateToken(user._id);

    // Response stays the same
    res.status(201).json({
      success: true,
      token,
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        bio: user.bio,
        joinDate: user.joinDate
      },
      message: 'Registration successful! Check your email for OTP to verify your account.',
      otp: otp // Include OTP in response for testing (remove in production)
    });

  } catch (error) {
    console.error('Registration error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error during registration'
    });
  }
});


// Login route
router.post('/login', [
  body('email').isEmail().withMessage('Please include a valid email'),
  body('password').exists().withMessage('Password is required')
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        errors: errors.array()
      });
    }

    const { email, password } = req.body;

    const user = await User.findOne({ email }).select('+password');
    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'Invalid credentials'
      });
    }

    const isMatch = await user.matchPassword(password);
    if (!isMatch) {
      return res.status(401).json({
        success: false,
        message: 'Invalid credentials'
      });
    }

    // ✅ ADDED: Check if email is verified
    if (!user.emailVerified) {
      return res.status(401).json({
        success: false,
        message: 'Please verify your email before logging in'
      });
    }

    const token = generateToken(user._id);

    res.json({
      success: true,
      token,
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        bio: user.bio,
        joinDate: user.joinDate
      }
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error during login'
    });
  }
});

// ✅ ADDED: Verify Email Route
router.get('/verify-email', async (req, res) => {
  try {
    const { token } = req.query;

    if (!token) {
      return res.status(400).json({
        success: false,
        message: 'Invalid verification token'
      });
    }

    const hashedToken = crypto
      .createHash('sha256')
      .update(token)
      .digest('hex');

    const user = await User.findOne({
      emailVerifyToken: hashedToken,
      emailVerifyExpire: { $gt: Date.now() }
    });

    if (!user) {
      return res.status(400).json({
        success: false,
        message: 'Invalid or expired verification token'
      });
    }

    user.emailVerified = true;
    user.emailVerifyToken = undefined;
    user.emailVerifyExpire = undefined;
    await user.save();

    res.json({
      success: true,
      message: 'Email verified successfully! You can now login.'
    });
  } catch (error) {
    console.error('Email verification error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error during email verification'
    });
  }
});

// ✅ ADDED: Resend Verification Email
router.post('/resend-verification', async (req, res) => {
  try {
    const { email } = req.body;

    const user = await User.findOne({ email });

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found'
      });
    }

    if (user.emailVerified) {
      return res.status(400).json({
        success: false,
        message: 'Email is already verified'
      });
    }

    const emailVerifyToken = crypto.randomBytes(32).toString('hex');
    const emailVerifyExpire = Date.now() + 60 * 60 * 1000;

    user.emailVerifyToken = crypto
      .createHash('sha256')
      .update(emailVerifyToken)
      .digest('hex');
    user.emailVerifyExpire = emailVerifyExpire;
    await user.save();

    await sendVerificationEmail(user, emailVerifyToken);

    res.json({
      success: true,
      message: 'Verification email sent successfully'
    });
  } catch (error) {
    console.error('Resend verification error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error sending verification email'
    });
  }
});

// Forgot password route
router.post('/forgot-password', [
  body('email').isEmail().withMessage('Please include a valid email')
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        errors: errors.array()
      });
    }

    const { email } = req.body;
    const user = await User.findOne({ email });

    // Don't reveal if user exists for security
    return res.json({
      success: true,
      message: 'If the email exists, a reset link has been sent'
    });
  } catch (error) {
    console.error('Forgot password error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error'
    });
  }
});

// Update profile route
router.put('/profile', protect, [
  body('name').optional().notEmpty().withMessage('Name cannot be empty'),
  body('bio').optional().trim()
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        errors: errors.array()
      });
    }

    const { name, bio } = req.body;
    const updateData = {};
    
    if (name) updateData.name = name;
    if (bio !== undefined) updateData.bio = bio;

    const user = await User.findByIdAndUpdate(
      req.user.id,
      updateData,
      { new: true, runValidators: true }
    );

    res.json({
      success: true,
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        bio: user.bio,
        joinDate: user.joinDate
      }
    });
  } catch (error) {
    console.error('Profile update error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error during profile update'
    });
  }
});

// Temporary route to create test user
router.post('/create-test-user', async (req, res) => {
  try {
    // Check if test user already exists
    const existingUser = await User.findOne({ email: 'test@example.com' });
    if (existingUser) {
      return res.json({
        success: true,
        message: 'Test user already exists',
        user: existingUser
      });
    }

    // Create test user
    const testUser = await User.create({
      name: 'Test User',
      email: 'test@example.com',
      password: 'password123',
      bio: 'Food enthusiast who loves cooking!'
    });

    res.status(201).json({
      success: true,
      message: 'Test user created successfully',
      user: {
        id: testUser._id,
        name: testUser.name,
        email: testUser.email,
        bio: testUser.bio
      }
    });
  } catch (error) {
    console.error('Create test user error:', error);
    res.status(500).json({
      success: false,
      message: 'Error creating test user'
    });
  }
});

// Simple test login (temporary - remove in production)
router.post('/test-login', [
  body('email').isEmail().withMessage('Please include a valid email'),
  body('password').exists().withMessage('Password is required')
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        errors: errors.array()
      });
    }

    const { email, password } = req.body;

    // For testing, accept any credentials and return success
    const token = jwt.sign({ email }, process.env.JWT_SECRET, {
      expiresIn: process.env.JWT_EXPIRE,
    });

    res.json({
      success: true,
      token,
      user: {
        id: 'test-user-id',
        name: email.split('@')[0],
        email: email,
        bio: 'Food enthusiast',
        joinDate: new Date().toISOString()
      }
    });
  } catch (error) {
    console.error('Test login error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error during test login'
    });
  }
});

router.get('/me', protect, async (req, res) => {
  res.json({
    success: true,
    user: req.user
  });
});

export default router;