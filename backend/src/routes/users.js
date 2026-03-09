const express = require('express');
const { FirestoreService } = require('../services/firestore');

const router = express.Router();
const COLLECTION = 'users';

// GET /api/users/me — Get current user profile
router.get('/me', async (req, res) => {
  try {
    const user = await FirestoreService.getDoc(COLLECTION, req.user.uid);
    if (!user) {
      return res.status(404).json({ error: 'User profile not found' });
    }
    res.json(user);
  } catch (error) {
    console.error('Error getting user:', error);
    res.status(500).json({ error: 'Failed to get user profile' });
  }
});

// PUT /api/users/me — Update current user profile
router.put('/me', async (req, res) => {
  try {
    const allowedFields = [
      'name', 'phone', 'photoUrl', 'bio', 'university',
      'skills', 'resumeUrl', 'availability',
      'designation', 'organizationId', 'onboardingComplete',
    ];

    const updates = {};
    for (const field of allowedFields) {
      if (req.body[field] !== undefined) {
        updates[field] = req.body[field];
      }
    }

    const result = await FirestoreService.update(COLLECTION, req.user.uid, updates);
    res.json(result);
  } catch (error) {
    console.error('Error updating user:', error);
    res.status(500).json({ error: 'Failed to update profile' });
  }
});

// POST /api/users — Create user profile (called after Firebase Auth signup)
router.post('/', async (req, res) => {
  try {
    const { userType, name, email } = req.body;
    const profile = {
      email: email || req.user.email,
      name: name || '',
      userType: userType || 'student',
      onboardingComplete: false,
    };
    const result = await FirestoreService.create(COLLECTION, req.user.uid, profile);
    res.status(201).json(result);
  } catch (error) {
    console.error('Error creating user profile:', error);
    res.status(500).json({ error: 'Failed to create profile' });
  }
});

module.exports = router;
