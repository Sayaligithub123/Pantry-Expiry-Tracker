import express from "express";
import mongoose from "mongoose";
import cors from "cors";

// Routes
import authRoutes from "./routes/authRoutes.js";
import productRoutes from "./routes/productRoutes.js";

// Cron Job (expiry alerts)
import "./cron/expiryChecker.js";

const app = express();

// ------------------- MIDDLEWARE -------------------
app.use(cors());
app.use(express.json());

// ------------------- MONGO CONNECTION -------------------
mongoose
  .connect(
    "mongodb+srv://sayalikshirsgagar_db_user:fhryoGIlrip3Fzal@cluster0.dkmpvoj.mongodb.net/?appName=Cluster0",
    {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    }
  )
  .then(() => console.log("MongoDB Connected"))
  .catch((err) => console.log("Mongo Error:", err.message));

// ------------------- ROUTES -------------------
app.use("/api/auth", authRoutes);
app.use("/api/products", productRoutes);

// ------------------- TEST ROUTES -------------------
app.get("/test", (req, res) => {
  res.send("Server OK");
});

app.get("/testdb", async (req, res) => {
  if (mongoose.connection.readyState !== 1) {
    return res.json({ error: "MongoDB NOT connected" });
  }
  try {
    const collections = await mongoose.connection.db.listCollections().toArray();
    res.json({ connected: true, collections });
  } catch (err) {
    res.json({ error: err.message });
  }
});

// ------------------- START SERVER -------------------
app.listen(5000, () => {
  console.log("Server running on port 5000");
});
