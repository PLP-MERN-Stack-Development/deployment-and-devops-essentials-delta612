// Health Check Endpoint for Backend
// Add this route to your Express application

const express = require("express");
const router = express.Router();
const mongoose = require("mongoose");

// Basic health check
router.get("/health", (req, res) => {
  res.status(200).json({
    status: "UP",
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
  });
});

// Detailed health check
router.get("/health/detailed", async (req, res) => {
  try {
    const mongoStatus = mongoose.connection.readyState === 1 ? "UP" : "DOWN";
    const memoryUsage = process.memoryUsage();

    res.status(200).json({
      status: "UP",
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      services: {
        database: mongoStatus,
        memory: {
          heapUsed: `${Math.round(memoryUsage.heapUsed / 1024 / 1024)}MB`,
          heapTotal: `${Math.round(memoryUsage.heapTotal / 1024 / 1024)}MB`,
        },
        nodejs: process.version,
      },
    });
  } catch (error) {
    res.status(503).json({
      status: "DOWN",
      timestamp: new Date().toISOString(),
      error: error.message,
    });
  }
});

// Readiness check (for Kubernetes-style deployments)
router.get("/ready", async (req, res) => {
  if (mongoose.connection.readyState === 1) {
    res.status(200).json({ ready: true });
  } else {
    res.status(503).json({ ready: false });
  }
});

module.exports = router;
