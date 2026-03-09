const express = require('express');
const { v4: uuidv4 } = require('uuid');
const { FirestoreService } = require('../services/firestore');

const router = express.Router();
const COLLECTION = 'applications';

// POST /api/applications — Apply to a gig (student only)
router.post('/', async (req, res) => {
  try {
    const { gigId, coverNote } = req.body;
    if (!gigId) return res.status(400).json({ error: 'gigId is required' });

    // Check if already applied
    const existing = await FirestoreService.list(COLLECTION, {
      where: [
        ['gigId', '==', gigId],
        ['studentId', '==', req.user.uid],
      ],
    });
    if (existing.length > 0) {
      return res.status(409).json({ error: 'Already applied to this gig' });
    }

    const id = uuidv4();
    const application = {
      gigId,
      studentId: req.user.uid,
      studentName: req.user.name || 'Student',
      status: 'applied',
      coverNote: coverNote || '',
      appliedAt: new Date().toISOString(),
    };
    const result = await FirestoreService.create(COLLECTION, id, application);

    // Increment applicant count on the gig
    const gig = await FirestoreService.getDoc('gigs', gigId);
    if (gig) {
      await FirestoreService.update('gigs', gigId, {
        applicantCount: (gig.applicantCount || 0) + 1,
      });
    }

    res.status(201).json(result);
  } catch (error) {
    console.error('Error creating application:', error);
    res.status(500).json({ error: 'Failed to apply' });
  }
});

// GET /api/applications — List applications (filtered by user role)
router.get('/', async (req, res) => {
  try {
    const { gigId, studentId } = req.query;
    const filters = [];

    if (gigId) filters.push(['gigId', '==', gigId]);
    if (studentId) filters.push(['studentId', '==', studentId]);

    const applications = await FirestoreService.list(COLLECTION, {
      where: filters.length > 0 ? filters : undefined,
      orderBy: { field: 'createdAt', direction: 'desc' },
    });

    res.json({ applications, count: applications.length });
  } catch (error) {
    console.error('Error listing applications:', error);
    res.status(500).json({ error: 'Failed to list applications' });
  }
});

// PUT /api/applications/:id — Update application status (manager only)
router.put('/:id', async (req, res) => {
  try {
    const { status } = req.body;
    const validStatuses = ['applied', 'shortlisted', 'accepted', 'rejected'];
    if (!validStatuses.includes(status)) {
      return res.status(400).json({ error: `Invalid status. Must be one of: ${validStatuses.join(', ')}` });
    }

    const result = await FirestoreService.update(COLLECTION, req.params.id, { status });
    res.json(result);
  } catch (error) {
    console.error('Error updating application:', error);
    res.status(500).json({ error: 'Failed to update application' });
  }
});

module.exports = router;
