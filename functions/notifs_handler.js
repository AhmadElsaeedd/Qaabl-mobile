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

const sendNotification = async (user_uid, payload) => {
    try {
        //get the user's token
      const user_fcm_token = await get_fcm_token(user_uid);

      if (!user_fcm_token) {
        console.log(`No FCM token found for user: ${user_uid}`);
        return;
      }

      console.log("Payload is: ", payload);
      console.log("User FCM Token: ", user_fcm_token);

      const message = {
        token: user_fcm_token,
        ...payload,
      };
      //send them the message
      await admin.messaging().send(message);
      console.log('Notification sent successfully');
    } catch (error) {
      console.error('Error sending notification', error);
    }
  };
  
module.exports = { sendNotification };