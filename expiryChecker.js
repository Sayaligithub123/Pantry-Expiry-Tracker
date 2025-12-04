import cron from "node-cron";
import Product from "../models/Product.js";
import User from "../models/user.js";
import { sendEmail } from "../utils/sendEmail.js";

// Run every day at 8 AM
cron.schedule("0 8 * * *", async () => {
  console.log("Running expiry check...");

  const products = await Product.find().populate("userId");
  const today = new Date();

  for (let product of products) {
    const expiry = new Date(product.expiryDate);
    const daysLeft = Math.ceil((expiry - today) / (1000 * 60 * 60 * 24));

    if (daysLeft < 0) {
      // EXPIRED
      await sendEmail(
        product.userId.email,
        "⚠️ Product Expired",
        `Your product "${product.name}" has expired!`
      );
    } 
    else if (daysLeft <= 3) {
      // EXPIRING SOON
      await sendEmail(
        product.userId.email,
        "⏳ Product Expiring Soon",
        `Your product "${product.name}" will expire in ${daysLeft} days.`
      );
    }
  }
});
