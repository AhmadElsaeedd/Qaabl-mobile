const admin = require('firebase-admin');
const serviceAccount = require('./private_key.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function updateDocuments() {
  const usersRef = db.collection('Users');
  const batch = db.batch();

  // Fetch all user documents
  const snapshot = await usersRef.get();
  
  snapshot.forEach(doc => {
    // Add 'super_likes' and 'notes' arrays to each user
    batch.update(doc.ref, { 
      super_likes: [],  // Initialize 'super_likes' as an empty array
      notes: []  // Initialize 'notes' as an empty array
    });
  });

  // Commit the batch
  await batch.commit();
  console.log('Batch update completed.');
}

updateDocuments().catch(console.error);
