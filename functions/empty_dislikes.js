const functions = require("firebase-functions");
const cors = require("cors");
const admin = require("firebase-admin");
const { sendNotification } = require("./notifs_handler");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

const db = admin.firestore();

const corsOptions = {
  origin: true,
};


const EmptyDislikes = functions.region("asia-east2").pubsub.schedule('every 120 hours').onRun(async (context) => {
    // Fetch all user documents
    const usersSnapshot = await db.collection('Users').get();

    // Prepare batch for atomic updates
    const batch = db.batch();

    const notificationPromises = [];

    const notificationPayload = {
        notification: {
          title: 'Do not miss out!',
          body: 'new profiles are getting on Qaabl, come check them out!',
        },
    };

    usersSnapshot.forEach(doc => {
        const userRef = db.collection('Users').doc(doc.id);
        batch.update(userRef, { dislikes: [] });

        // Add the sendNotification promise to the array
        notificationPromises.push(sendNotification(doc.id, notificationPayload));
    });

    // Commit the batch and then send notifications
    await batch.commit();

    // Wait for all notifications to be sent
    await Promise.all(notificationPromises);

    console.log('Dislikes emptied and notifications sent to all users.');
    
    
});
  
  module.exports = EmptyDislikes;