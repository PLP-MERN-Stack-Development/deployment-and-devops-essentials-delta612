# 📊 Monitoring & Logging Guide

This guide covers setting up monitoring, logging, and error tracking for your MERN application.

## Table of Contents

1. [Health Checks](#health-checks)
2. [Error Tracking (Sentry)](#error-tracking-sentry)
3. [Uptime Monitoring](#uptime-monitoring)
4. [Performance Monitoring](#performance-monitoring)
5. [Logging Best Practices](#logging-best-practices)
6. [Alerting](#alerting)

## Health Checks

### Backend Health Endpoints

Your backend includes three health check endpoints:

**Basic Health Check**
```
GET /api/health

Response:
{
  "status": "UP",
  "timestamp": "2024-01-15T10:30:00.000Z",
  "uptime": 3600.5
}
```

**Detailed Health Check**
```
GET /api/health/detailed

Response:
{
  "status": "UP",
  "timestamp": "2024-01-15T10:30:00.000Z",
  "uptime": 3600.5,
  "services": {
    "database": "UP",
    "memory": {
      "heapUsed": "45MB",
      "heapTotal": "128MB"
    },
    "nodejs": "v20.10.0"
  }
}
```

**Readiness Probe**
```
GET /api/ready

Response (if ready):
{ "ready": true }

Response (if not ready):
HTTP 503 { "ready": false }
```

### Implementation

Add to your backend `routes/health.js`:

```javascript
const express = require('express');
const router = express.Router();

// Include the health check routes
// router.use(require('../monitoring/health-check'));

module.exports = router;
```

Register in your main app.js:

```javascript
const healthRoutes = require('./routes/health');
app.use('/api', healthRoutes);
```

## Error Tracking (Sentry)

### Setup

1. **Create Sentry Account**
   - Go to [Sentry.io](https://sentry.io/)
   - Sign up for free account
   - Create projects for:
     - Backend (Node.js)
     - Frontend (React)

2. **Get Your DSN**
   - Copy DSN from project settings
   - Add to `.env.production`:
     ```
     SENTRY_DSN=https://your-key@sentry.io/project-id
     ```

### Backend Integration

Install Sentry:
```bash
npm install @sentry/node @sentry/tracing
```

Add to top of `backend/app.js`:

```javascript
const Sentry = require("@sentry/node");
const Tracing = require("@sentry/tracing");

// Initialize Sentry (before other middleware)
Sentry.init({
  dsn: process.env.SENTRY_DSN,
  environment: process.env.NODE_ENV,
  tracesSampleRate: 1.0,
  integrations: [
    new Sentry.Integrations.Http({ tracing: true }),
    new Tracing.Integrations.Express({
      app: true,
      request: true,
    }),
  ],
});

// Attach Sentry middleware
app.use(Sentry.Handlers.requestHandler());
app.use(Sentry.Handlers.tracingHandler());

// ... other middleware ...

// Error handler (MUST be last)
app.use(Sentry.Handlers.errorHandler());
```

### Frontend Integration

Install Sentry:
```bash
npm install @sentry/react @sentry/tracing
```

Add to `frontend/src/index.js`:

```javascript
import * as Sentry from "@sentry/react";
import { BrowserTracing } from "@sentry/tracing";

Sentry.init({
  dsn: process.env.REACT_APP_SENTRY_DSN,
  environment: process.env.NODE_ENV,
  integrations: [new BrowserTracing()],
  tracesSampleRate: 1.0,
});
```

### Monitoring Errors

In Sentry Dashboard:
1. View error details
2. Check stack trace
3. See affected users
4. Check release information
5. Set up alerts

## Uptime Monitoring

### UptimeRobot Setup

1. **Sign up**
   - Go to [UptimeRobot](https://uptimerobot.com/)
   - Free account includes 50 monitors

2. **Add Monitor**
   - URL: `https://your-backend.com/api/health`
   - Type: HTTP(s)
   - Interval: 5 minutes
   - Name: "Backend Health Check"

3. **Set Notifications**
   - Email alerts
   - SMS alerts
   - Slack/Discord integration

### Pingdom Setup

1. **Sign up**
   - Go to [Pingdom](https://www.pingdom.com/)
   - Free tier available

2. **Create Check**
   - URL to monitor
   - Check interval
   - Notification rules

### StatusPage.io

Create a public status page:

```javascript
// Display deployment status
// Last deployment
// Maintenance windows
// Incident history
```

## Performance Monitoring

### Option 1: New Relic

1. **Sign up**
   - Go to [New Relic](https://newrelic.com/)
   - Create account

2. **Install Agent**
   ```bash
   npm install newrelic
   ```

3. **Configuration**
   - Add `require('newrelic')` as first line in app.js
   - Set license key in environment

4. **Monitor**
   - Response times
   - Error rates
   - Throughput
   - Resource usage

### Option 2: DataDog

1. **Install Agent**
   ```bash
   npm install dd-trace
   ```

2. **Initialize**
   ```javascript
   const tracer = require('dd-trace').init()
   ```

3. **Monitor**
   - Application performance
   - Infrastructure metrics
   - Log correlation

### Option 3: Prometheus + Grafana

Use provided `docker-compose-monitoring.yml`:

```bash
docker-compose -f monitoring/docker-compose-monitoring.yml up
```

**Services:**
- **Prometheus** (http://localhost:9090) - Metrics collection
- **Grafana** (http://localhost:3000) - Visualization

**Setup Grafana:**
1. Login: admin/admin
2. Add Prometheus data source
3. Create dashboards
4. Set up alerts

## Logging Best Practices

### 1. Structured Logging

Use Winston or Pino for structured logs:

```bash
npm install winston
```

```javascript
const winston = require('winston');

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.json(),
  transports: [
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' })
  ]
});

if (process.env.NODE_ENV !== 'production') {
  logger.add(new winston.transports.Console({
    format: winston.format.simple()
  }));
}

module.exports = logger;
```

### 2. Log Levels

```javascript
logger.error('Critical error');           // Level 0
logger.warn('Warning');                   // Level 1
logger.info('Information');               // Level 2
logger.debug('Debugging info');           // Level 3
```

### 3. Contextual Logging

```javascript
// Include request ID for tracing
logger.info('User logged in', {
  userId: user._id,
  requestId: req.id,
  timestamp: new Date(),
  ip: req.ip
});
```

### 4. Log Aggregation

For centralized logging:

- **ELK Stack** - Elasticsearch, Logstash, Kibana
- **Splunk** - Enterprise logging
- **Datadog** - Cloud logging
- **CloudWatch** - AWS logging

## Alerting

### Email Alerts

Configure email notifications for:
- Application errors
- High error rates
- Downtime
- Performance degradation

### Slack Integration

1. **Create Webhook**
   - Go to Slack Workspace Settings
   - Enable Incoming Webhooks
   - Create new webhook URL

2. **Configure in Sentry**
   - Settings → Integrations
   - Add Slack integration
   - Connect channel

3. **Send Alerts**
   ```javascript
   const axios = require('axios');

   async function sendSlackAlert(message) {
     await axios.post(process.env.SLACK_WEBHOOK_URL, {
       text: message
     });
   }
   ```

### Discord Integration

Similar to Slack using webhooks.

### PagerDuty Integration

For incident management and on-call scheduling.

## Dashboard Setup

### Key Metrics to Monitor

**Backend:**
- Response time (P95, P99)
- Error rate
- Request count
- Database query time
- Memory usage
- CPU usage
- Active connections

**Frontend:**
- Page load time
- Time to interactive
- Frontend errors
- User sessions
- Browser compatibility issues

**Infrastructure:**
- Uptime
- Disk usage
- Network bandwidth
- Container resource usage

### Example Dashboard Panels

```
┌─────────────────────────────────────┐
│  Backend Response Time (P95)        │
│  [Chart showing 200ms]              │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│  Error Rate                         │
│  [Chart showing 0.1%]               │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│  Uptime                             │
│  [Gauge showing 99.9%]              │
└─────────────────────────────────────┘
```

## Incident Response

### On-Call Schedule

Use PagerDuty or similar:
1. Define escalation policies
2. Set up on-call schedules
3. Configure notification channels

### Runbook Example

**Issue: High Error Rate**

**Detection:**
- Sentry alert (error rate > 5%)
- Slack notification

**Response:**
```
1. Check recent deployments
   $ git log --oneline -5

2. View error details in Sentry
   - Check error patterns
   - Identify affected endpoints

3. Check backend logs
   $ heroku logs --tail

4. Check database connection
   $ mongosh <connection_string>

5. If recent deployment caused issue:
   $ git revert HEAD
   $ git push

6. Otherwise, investigate root cause
```

**Escalation:**
- If unresolved in 10 minutes → notify team lead
- If unresolved in 30 minutes → war room call

## Monitoring Checklist

Daily:
- [ ] Check error tracking (Sentry)
- [ ] Review uptime reports
- [ ] Check error logs

Weekly:
- [ ] Review performance metrics
- [ ] Check resource usage trends
- [ ] Review slow query logs

Monthly:
- [ ] Analyze uptime statistics
- [ ] Review SLA compliance
- [ ] Plan capacity upgrades
- [ ] Security audit

## Resources

- [Sentry Documentation](https://docs.sentry.io/)
- [New Relic Documentation](https://docs.newrelic.com/)
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [UptimeRobot Guides](https://uptimerobot.com/documentation/)

---

**Setup Complete! You now have:**
- ✅ Health check endpoints
- ✅ Error tracking with Sentry
- ✅ Uptime monitoring
- ✅ Performance monitoring
- ✅ Logging strategy
- ✅ Alerting system
