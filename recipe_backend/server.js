import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import connectDB from "./config/database.js";
import authRoutes from "./routes/auth.js";
import recipeRoutes from "./routes/recipes.js";

dotenv.config();
connectDB();

const app = express();

// SUPER PERMISSIVE CORS FOR DEVELOPMENT
app.use(cors({
  origin: true, // Allow ALL origins during development
  credentials: true,
  methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"],
  allowedHeaders: ["Content-Type", "Authorization", "Accept", "Origin", "X-Requested-With", "X-Auth-Token"]
}));

// Handle preflight requests
app.options('*', cors());

app.use(express.json());

// Routes
app.use("/api/auth", authRoutes);
app.use("/api/recipes", recipeRoutes);

// Health check
app.get("/api/health", (req, res) => {
  res.json({ message: "Recipe API is running!" });
});

// Root endpoint
app.get("/", (req, res) => {
  res.json({ message: "Recipe App Backend API", version: "1.0" });
});

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`📡 API available at: http://localhost:${PORT}`);
  console.log(`🔧 CORS enabled for all origins`);
});