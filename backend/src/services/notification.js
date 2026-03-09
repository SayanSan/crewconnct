const admin = require('firebase-admin');

/**
 * Send a push notification via Firebase Cloud Messaging.
 */
async function sendNotification({ token, title, body, data = {} }) {
  try {
    const message = {
      notification: { title, body },
      data,
      token,
    };
    const response = await admin.messaging().send(message);
    console.log('Notification sent:', response);
    return response;
  } catch (error) {
    console.error('Error sending notification:', error);
    throw error;
  }
}

/**
 * Send notification to a topic (e.g., all students, all managers).
 */
async function sendTopicNotification({ topic, title, body, data = {} }) {
  try {
    const message = {
      notification: { title, body },
      data,
      topic,
    };
    const response = await admin.messaging().send(message);
    console.log('Topic notification sent:', response);
    return response;
  } catch (error) {
    console.error('Error sending topic notification:', error);
    throw error;
  }
}

module.exports = { sendNotification, sendTopicNotification };
