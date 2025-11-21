// import nodemailer from 'nodemailer';

// const sendEmail = async (options) => {
//   const transporter = nodemailer.createTransporter({
//     service: 'Gmail',
//     auth: {
//       user: process.env.EMAIL_USER,
//       pass: process.env.EMAIL_PASS,
//     },
//   });

//   const mailOptions = {
//     from: process.env.EMAIL_USER,
//     to: options.email,
//     subject: options.subject,
//     html: options.html,
//   };

//   await transporter.sendMail(mailOptions);
// };

// export const sendVerificationEmail = async (user, token) => {
//   const verifyUrl = `${process.env.CLIENT_URL}/verify-email?token=${token}`;
  
//   const html = `
//     <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
//       <h2 style="color: #FF6B35;">Verify Your Email Address</h2>
//       <p>Hello ${user.name},</p>
//       <p>Thank you for registering with Recipe App! Please verify your email address by clicking the button below:</p>
//       <a href="${verifyUrl}" style="background-color: #FF6B35; color: white; padding: 12px 24px; text-decoration: none; border-radius: 8px; display: inline-block;">
//         Verify Email
//       </a>
//       <p>Or copy and paste this link in your browser:</p>
//       <p>${verifyUrl}</p>
//       <p>This link will expire in 1 hour.</p>
//       <p>If you didn't create an account, please ignore this email.</p>
//     </div>
//   `;

//   await sendEmail({
//     email: user.email,
//     subject: 'Verify Your Email - Recipe App',
import nodemailer from 'nodemailer';

const sendEmail = async (options) => {
  try {
    const transporter = nodemailer.createTransport({
      service: 'Gmail',
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS,
      },
      tls: {
        rejectUnauthorized: false
      }
    });

    const mailOptions = {
      from: process.env.EMAIL_USER,
      to: options.email,
      subject: options.subject,
      html: options.html,
    };

    const info = await transporter.sendMail(mailOptions);
    console.log('✅ Email sent successfully to:', options.email);
    console.log('📧 Message ID:', info.messageId);
    return info;
  } catch (error) {
    console.error('❌ Email sending failed:', error.message);
    console.error('Error details:', error);
    throw error;
  }
};

export const sendVerificationEmail = async (user, token) => {
  const verifyUrl = `${process.env.CLIENT_URL}/verify-email?token=${token}`;
  
  const html = `
    <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
      <h2 style="color: #FF6B35;">Verify Your Email Address</h2>
      <p>Hello ${user.name},</p>
      <p>Thank you for registering with Recipe App! Please verify your email address by clicking the button below:</p>
      <a href="${verifyUrl}" style="background-color: #FF6B35; color: white; padding: 12px 24px; text-decoration: none; border-radius: 8px; display: inline-block;">
        Verify Email
      </a>
      <p>Or copy and paste this link in your browser:</p>
      <p>${verifyUrl}</p>
      <p>This link will expire in 1 hour.</p>
      <p>If you didn't create an account, please ignore this email.</p>
    </div>
  `;

  await sendEmail({
    email: user.email,
    subject: 'Verify Your Email - Recipe App',
    html: html,
  });
};

export const sendOtpEmail = async (user, otp) => {
  const html = `
    <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; background-color: #f5f5f5; padding: 20px; border-radius: 10px;">
      <div style="background-color: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
        <h2 style="color: #FF6B35; text-align: center; margin-bottom: 20px;">Email Verification</h2>
        <p style="font-size: 16px; color: #333; margin-bottom: 20px;">Hello ${user.name},</p>
        <p style="font-size: 14px; color: #666; margin-bottom: 30px;">Thank you for registering with Recipe App! Use the OTP below to verify your email address:</p>
        
        <div style="background-color: #FF6B35; padding: 20px; border-radius: 8px; text-align: center; margin: 30px 0;">
          <p style="font-size: 12px; color: white; margin: 0; letter-spacing: 2px;">YOUR OTP</p>
          <p style="font-size: 48px; color: white; margin: 10px 0; font-weight: bold; letter-spacing: 8px;">${otp}</p>
        </div>
        
        <p style="font-size: 14px; color: #666; margin-bottom: 10px;">This OTP will expire in <strong>10 minutes</strong>.</p>
        <p style="font-size: 14px; color: #666; margin-bottom: 20px;">If you didn't create an account, please ignore this email.</p>
        
        <hr style="border: none; border-top: 1px solid #ddd; margin: 20px 0;">
        <p style="font-size: 12px; color: #999; text-align: center; margin: 0;">Recipe App - Your Cooking Companion</p>
      </div>
    </div>
  `;

  await sendEmail({
    email: user.email,
    subject: 'Your OTP for Email Verification - Recipe App',
    html: html,
  });
};