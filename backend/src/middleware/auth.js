const admin = require('firebase-admin');

/**
 * Middleware to verify Firebase Auth ID token from the Authorization header.
 * Attaches the decoded token to `req.user`.
 */
async function verifyToken(req, res, next) {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    // For development, allow unauthenticated requests
    if (process.env.NODE_ENV === 'development') {
      req.user = { uid: 'dev-user', email: 'dev@crewconnct.com' };
      return next();
    }
    return res.status(401).json({ error: 'No authorization token provided' });
  }

  const token = authHeader.split('Bearer ')[1];

  try {
    const decoded = await admin.auth().verifyIdToken(token);
    req.user = decoded;
    next();
  } catch (error) {
    console.error('Token verification failed:', error.message);
    return res.status(401).json({ error: 'Invalid or expired token' });
  }
}

module.exports = { verifyToken };
