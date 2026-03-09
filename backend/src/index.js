require('dotenv').config();
const express = require('express');
const cors = require('cors');
const admin = require('firebase-admin');

// Initialize Firebase Admin SDK first
if (!admin.apps.length) {
  try {
    // In dev mode, we just use a demo project ID.
    // In prod, applicationDefault() will be used via ENV variables automatically.
    admin.initializeApp({ projectId: "demo-project" });
  } catch (err) {
    console.warn("Could not initialize Firebase Admin natively:", err.message);
  }
}

const gigRoutes = require('./routes/gigs');
const applicationRoutes = require('./routes/applications');
const userRoutes = require('./routes/users');
const notificationRoutes = require('./routes/notifications');
const { verifyToken } = require('./middleware/auth');


const app = express();
const PORT = process.env.PORT || 8080;

// ── Middleware ────────────────────────────────────────────────────────────
app.use(cors());
app.use(express.json());

// ── Health Check ─────────────────────────────────────────────────────────
app.get('/', (req, res) => {
  res.json({
    status: 'ok',
    service: 'CrewConnct API',
    version: '1.0.0',
    timestamp: new Date().toISOString(),
  });
});

app.get('/health', (req, res) => {
  res.json({ status: 'healthy' });
});

// ── Protected Routes ─────────────────────────────────────────────────────
app.use('/api/gigs', verifyToken, gigRoutes);
app.use('/api/applications', verifyToken, applicationRoutes);
app.use('/api/users', verifyToken, userRoutes);
app.use('/api/notifications', verifyToken, notificationRoutes);

// ── Error Handler ────────────────────────────────────────────────────────
app.use((err, req, res, next) => {
  console.error('Unhandled error:', err);
  res.status(500).json({
    error: 'Internal server error',
    message: process.env.NODE_ENV === 'development' ? err.message : undefined,
  });
});

// ── Start Server ─────────────────────────────────────────────────────────
app.listen(PORT, () => {
  console.log(`🚀 CrewConnct API running on port ${PORT}`);
});

module.exports = app;
