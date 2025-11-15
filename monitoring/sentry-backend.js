// Sentry Configuration for Backend
// Install: npm install @sentry/node @sentry/tracing

const Sentry = require("@sentry/node");
const Tracing = require("@sentry/tracing");

function initSentry(app) {
  // Initialize Sentry
  Sentry.init({
    dsn: process.env.SENTRY_DSN,
    environment: process.env.NODE_ENV,
    tracesSampleRate: process.env.NODE_ENV === "production" ? 0.1 : 1.0,
    integrations: [
      new Sentry.Integrations.Http({ tracing: true }),
      new Tracing.Integrations.Express({
        app: true,
        request: true,
      }),
    ],
  });

  // Attach Sentry to Express
  app.use(Sentry.Handlers.requestHandler());
  app.use(Sentry.Handlers.tracingHandler());

  // Error handler (must be last)
  app.use(Sentry.Handlers.errorHandler());
}

module.exports = { initSentry };
