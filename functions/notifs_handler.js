const admin = require("firebase-admin");

if (admin.apps.length === 0) {
    admin.initializeApp();
  }
  
const db = admin.firestore();

async function get_fcm_token(uid) {
    const user_doc = await (db.collection("Users").doc(uid)).get();
  
    const user_data = user_doc.data();
  
    const user_fcm_token = user_data.fcm_token;
  
    return user_fcm_token;
  }
  const MAX_RETRIES = 5; // Maximum number of retries

  const sendNotification = async (user_uid, payload) => {
    let tryCount = 0;
    let sent = false;
  
    while (tryCount < MAX_RETRIES && !sent) {
      try {
        // Get the user's token
        const user_fcm_token = await get_fcm_token(user_uid);
  
        if (!user_fcm_token) {
          console.log(`No FCM token found for user: ${user_uid}`);
          break;
        }
  
        console.log("Payload is: ", payload);
        console.log("User FCM Token: ", user_fcm_token);
  
        const message = {
          token: user_fcm_token,
          ...payload,
        };
        // Send the message
        await admin.messaging().send(message);
        console.log('Notification sent successfully');
        sent = true; // Set to true if the message is sent without errors
      } catch (error) {
        console.error('Error sending notification', error);
        if (error.code === 'messaging/internal-error') {
          // Apply exponential backoff with a max wait of ~32 seconds
          const waitTime = Math.pow(2, tryCount) * 1000 + Math.random() * 1000;
          console.log(`Waiting ${waitTime} ms before retry...`);
          await new Promise((resolve) => setTimeout(resolve, waitTime));
          tryCount++;
        } else {
          // Break the loop if the error is not recoverable
          break;
        }
      }
    }
  
    if (!sent) {
      console.error('Failed to send notification after retries.');
    }
  };  
  
module.exports = { sendNotification };