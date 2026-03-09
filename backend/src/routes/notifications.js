const express = require('express');
const { v4: uuidv4 } = require('uuid');
const { FirestoreService } = require('../services/firestore');
const { sendNotification } = require('../services/notification');

const router = express.Router();
const COLLECTION = 'notifications';

// GET /api/notifications — Get user's notifications
router.get('/', async (req, res) => {
  try {
    const notifications = await FirestoreService.list(COLLECTION, {
      where: [['userId', '==', req.user.uid]],
      orderBy: { field: 'createdAt', direction: 'desc' },
      limit: 50,
    });
    res.json({
      notifications,
      unreadCount: notifications.filter(n => !n.read).length,
    });
  } catch (error) {
    console.error('Error listing notifications:', error);
    res.status(500).json({ error: 'Failed to list notifications' });
  }
});

// PUT /api/notifications/:id/read — Mark as read
router.put('/:id/read', async (req, res) => {
  try {
    await FirestoreService.update(COLLECTION, req.params.id, { read: true });
    res.json({ message: 'Marked as read' });
  } catch (error) {
    console.error('Error marking notification:', error);
    res.status(500).json({ error: 'Failed to update notification' });
  }
});

// POST /api/notifications/send — Send a notification (internal use)
router.post('/send', async (req, res) => {
  try {
    const { userId, title, body, type, data } = req.body;
    if (!userId || !title || !body) {
      return res.status(400).json({ error: 'userId, title, and body are required' });
    }

    // Save to Firestore
    const id = uuidv4();
    await FirestoreService.create(COLLECTION, id, {
      userId,
      title,
      body,
      type: type || 'general',
      read: false,
      data: data || {},
    });

    // Try to send push notification if user has FCM token
    const user = await FirestoreService.getDoc('users', userId);
    if (user && user.fcmToken) {
      await sendNotification({
        token: user.fcmToken,
        title,
        body,
        data: data || {},
      });
    }

    res.status(201).json({ message: 'Notification sent', id });
  } catch (error) {
    console.error('Error sending notification:', error);
    res.status(500).json({ error: 'Failed to send notification' });
  }
});

module.exports = router;
