import express from "express";
import Product from "../models/Product.js";

const router = express.Router();

// ---- ADD PRODUCT ----
router.post("/add", async (req, res) => {
  const { userId, name, barcode, expiryDate } = req.body;

  if (!userId || !name || !expiryDate) {
    return res.status(400).json({ error: "Missing fields" });
  }

  try {
    const product = new Product({
      userId,
      name,
      barcode,
      expiryDate: new Date(expiryDate),
    });
    await product.save();
    res.json({ message: "Product saved" });
  } catch (err) {
    console.error("Add product error:", err.message);
    res.status(500).json({ error: "Server error" });
  }
});

// ---- GET PRODUCTS FOR A USER ----
router.get("/list/:userId", async (req, res) => {
  try {
    const items = await Product.find({ userId: req.params.userId }).sort({ expiryDate: 1 });
    res.json(items);
  } catch (err) {
    console.error("List products error:", err.message);
    res.status(500).json({ error: "Server error" });
  }
});

export default router;
