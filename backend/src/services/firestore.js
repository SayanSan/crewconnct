const admin = require('firebase-admin');
const db = admin.firestore();

class FirestoreService {
  /**
   * Get a document by collection and ID.
   */
  static async getDoc(collection, id) {
    const doc = await db.collection(collection).doc(id).get();
    if (!doc.exists) return null;
    return { id: doc.id, ...doc.data() };
  }

  /**
   * List documents from a collection with optional filters.
   * @param {string} collection
   * @param {Object} options - { where: [[field, op, value]], orderBy, limit, startAfter }
   */
  static async list(collection, options = {}) {
    let query = db.collection(collection);

    if (options.where) {
      for (const [field, op, value] of options.where) {
        query = query.where(field, op, value);
      }
    }
    if (options.orderBy) {
      query = query.orderBy(options.orderBy.field, options.orderBy.direction || 'desc');
    }
    if (options.limit) {
      query = query.limit(options.limit);
    }
    if (options.startAfter) {
      query = query.startAfter(options.startAfter);
    }

    const snapshot = await query.get();
    return snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
  }

  /**
   * Create a document.
   */
  static async create(collection, id, data) {
    await db.collection(collection).doc(id).set({
      ...data,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    return { id, ...data };
  }

  /**
   * Update a document.
   */
  static async update(collection, id, data) {
    await db.collection(collection).doc(id).update({
      ...data,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    return { id, ...data };
  }

  /**
   * Delete a document.
   */
  static async remove(collection, id) {
    await db.collection(collection).doc(id).delete();
  }
}

module.exports = { FirestoreService, db };
