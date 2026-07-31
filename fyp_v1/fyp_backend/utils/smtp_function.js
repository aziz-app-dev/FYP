const nodemailer = require("nodemailer");
const { PASSWORD, EMAIL } = require("../config/index");

async function sendEmail(userEmail, message) {
  const transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: EMAIL,
      pass: PASSWORD,
    },
  });

  const mailOptions = {
    from:EMAIL,
    to: userEmail,
    subject: "Home Town bites Verification Code",
    html: `<h1>Home Town bites Email Verification</h1>
            <p>Your verification code is:</p>
            <h2 style="color: blue;">${message}</h2>
            <p>Please enter this code on the verification page to complete your registration process.</p>
            <p>If you did not request this, please ignore this email.</p>`,
  };
  // Not awaited on purpose (fire-and-forget), but the rejection MUST be
  // handled — an unhandled promise rejection crashes the whole server on
  // modern Node versions.
  transporter.sendMail(mailOptions).catch((error) => {
    console.log("Email sending failed with an error: " + error);
  });
}

module.exports =sendEmail;