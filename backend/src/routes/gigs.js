const express = require('express');
const { v4: uuidv4 } = require('uuid');
const { FirestoreService } = require('../services/firestore');

const router = express.Router();
const COLLECTION = 'gigs';

// POST /api/gigs — Create a new gig
router.post('/', async (req, res) => {
  try {
    const id = uuidv4();
    const gig = {
      ...req.body,
      managerId: req.user.uid,
      status: req.body.status || 'draft',
      applicantCount: 0,
    };
    const result = await FirestoreService.create(COLLECTION, id, gig);
    res.status(201).json(result);
  } catch (error) {
    console.error('Error creating gig:', error);
    res.status(500).json({ error: 'Failed to create gig' });
  }
});

// GET /api/gigs — List all published gigs (with filters)
router.get('/', async (req, res) => {
  try {
    const { status = 'published', limit = 20, skill } = req.query;
    const options = {
      where: [['status', '==', status]],
      orderBy: { field: 'createdAt', direction: 'desc' },
      limit: parseInt(limit),
    };
    let gigs = await FirestoreService.list(COLLECTION, options);

    // Filter by skill if specified
    if (skill) {
      gigs = gigs.filter(g =>
        g.requiredSkills && g.requiredSkills.includes(skill)
      );
    }

    res.json({ gigs, count: gigs.length });
  } catch (error) {
    console.error('Error listing gigs:', error);
    res.status(500).json({ error: 'Failed to list gigs' });
  }
});

// GET /api/gigs/:id — Get gig detail
router.get('/:id', async (req, res) => {
  try {
    const gig = await FirestoreService.getDoc(COLLECTION, req.params.id);
    if (!gig) return res.status(404).json({ error: 'Gig not found' });
    res.json(gig);
  } catch (error) {
    console.error('Error getting gig:', error);
    res.status(500).json({ error: 'Failed to get gig' });
  }
});

// PUT /api/gigs/:id — Update a gig (owner only)
router.put('/:id', async (req, res) => {
  try {
    const existing = await FirestoreService.getDoc(COLLECTION, req.params.id);
    if (!existing) return res.status(404).json({ error: 'Gig not found' });
    if (existing.managerId !== req.user.uid) {
      return res.status(403).json({ error: 'Not authorized' });
    }
    const result = await FirestoreService.update(COLLECTION, req.params.id, req.body);
    res.json(result);
  } catch (error) {
    console.error('Error updating gig:', error);
    res.status(500).json({ error: 'Failed to update gig' });
  }
});

// DELETE /api/gigs/:id — Delete a gig (owner only)
router.delete('/:id', async (req, res) => {
  try {
    const existing = await FirestoreService.getDoc(COLLECTION, req.params.id);
    if (!existing) return res.status(404).json({ error: 'Gig not found' });
    if (existing.managerId !== req.user.uid) {
      return res.status(403).json({ error: 'Not authorized' });
    }
    await FirestoreService.remove(COLLECTION, req.params.id);
    res.json({ message: 'Gig deleted' });
  } catch (error) {
    console.error('Error deleting gig:', error);
    res.status(500).json({ error: 'Failed to delete gig' });
  }
});

module.exports = router;
