// Performance Monitoring with New Relic (Optional)
// Install: npm install newrelic

// Add this as the VERY FIRST line of your app.js before any other requires
// require('newrelic');

// Configuration file: newrelic.js

exports.config = {
  app_name: ["MERN App"],
  license_key: process.env.NEW_RELIC_LICENSE_KEY,
  logging: {
    level: "info",
  },
  transaction_tracer: {
    enabled: true,
    transaction_threshold: "apdex_f",
  },
  error_collector: {
    enabled: true,
  },
  monitor_mode: process.env.NODE_ENV === "production",
};
