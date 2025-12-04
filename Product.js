import mongoose from "mongoose";

const productSchema = new mongoose.Schema({
  name: String,
  barcode: String,
  expiryDate: Date,
  userId: { type: mongoose.Schema.Types.ObjectId, ref: "User" }
});

export default mongoose.model("Product", productSchema);
