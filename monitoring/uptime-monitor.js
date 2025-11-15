// Uptime Monitor Configuration
// Use services like:
// - UptimeRobot (https://uptimerobot.com/)
// - Pingdom (https://www.pingdom.com/)
// - StatusPage.io (https://www.statuspage.io/)

// Example webhook endpoint to receive uptime notifications
const express = require("express");
const router = express.Router();

router.post("/webhook/uptime", (req, res) => {
  const { status, timestamp, service } = req.body;

  console.log(`Uptime Alert - Service: ${service}, Status: ${status}, Time: ${timestamp}`);

  // Log to monitoring service
  // Send notification (email, Slack, Discord, etc.)

  res.status(200).json({ received: true });
});

module.exports = router;

// Uptime Robot Configuration:
// 1. Go to https://uptimerobot.com/
// 2. Create new monitor for your backend health endpoint:
//    - URL: https://your-backend.com/api/health
//    - Type: HTTP(s)
//    - Interval: 5 minutes
// 3. Set up notifications for down alerts
