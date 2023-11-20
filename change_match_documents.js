const admin = require('firebase-admin');
const serviceAccount = require('./private_key.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function updateDocuments() {
  const matchesRef = db.collection('Matches');
  const snapshot = await matchesRef.where('has_message', '==', true).get();

  if (snapshot.empty) {
    console.log('No matching documents.');
    return;
  }  

  let batch = db.batch();

  snapshot.docs.forEach(doc => {
    const lastMessage = doc.data().last_message;
    if (lastMessage && lastMessage.timestamp) {
      const lastMessageTimestamp = lastMessage.timestamp;
      batch.set(doc.ref, { last_message_timestamp: lastMessageTimestamp }, { merge: true });
    }
  });

  await batch.commit();
  console.log('Batch update completed.');
}

updateDocuments().catch(console.error);
