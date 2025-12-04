import nodemailer from "nodemailer";

export const sendEmail = async (to, subject, message) => {
  try {
    const transporter = nodemailer.createTransport({
      service: "gmail",
      auth: {
        user: "kshirsagarsayali1@gmail.com",   // ⭐ Replace with your Gmail
        pass: "bjro kodt zrpg xrgc"      // ⭐ Use App Password, not Gmail password
      }
    });

    await transporter.sendMail({
      from: "Pantry App <yourgmail@gmail.com>",
      to,
      subject,
      text: message,
    });

    console.log("Email sent to", to);
  } catch (err) {
    console.log("Email error:", err.message);
  }
};
