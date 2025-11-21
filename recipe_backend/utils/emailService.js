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
//     html: html,
//   });
// };

import nodemailer from 'nodemailer';

const sendEmail = async (options) => {
  try {
    const transporter = nodemailer.createTransporter({
      service: 'Gmail',
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS,
      },
    });

    const mailOptions = {
      from: process.env.EMAIL_USER,
      to: options.email,
      subject: options.subject,
      html: options.html,
    };

    await transporter.sendMail(mailOptions);
    console.log('✅ Email sent successfully to:', options.email);
  } catch (error) {
    console.error('❌ Email sending failed:', error);
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