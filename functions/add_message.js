const functions = require("firebase-functions");
const admin = require("firebase-admin");
const cors = require("cors");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

const db = admin.firestore();

const corsOptions = {
  origin: true,
};

exports.addMessage = functions.region("asia-east2").https.onCall((data, context) => {
  // Check for user authentication
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "The function must be called while authenticated.");
  }

  const {chatId, text} = data;
  if (!chatId || !text) {
    throw new functions.https.HttpsError("invalid-argument", "The function must be called with valid arguments.");
  }

  // Add the message to Firestore
  return admin.firestore().collection("chats").doc(chatId).collection("messages").add({
    senderId: context.auth.uid,
    text: text,
    timestamp: admin.firestore.FieldValue.serverTimestamp(),
  });
});

async function add_message_to_chat(chat_id, uid, content) {
  let done = false;
  const timestamp = new Date();
  await db.collection("Matches").doc(chat_id).collection("Messages").add({
    sentBy: uid,
    content: content,
    timestamp: timestamp,
  });
  done = true;
  return done;
}

const AddMessage = functions.region("asia-east2").https.onRequest(async (req, res) => {
  cors(corsOptions)(req, res, async () => {
    const user_uid = req.body.uid;
    const chat_id = req.body.chat_id;
    const content = req.body.content;

    const done = await add_message_to_chat(chat_id, user_uid, content);

    if (done) {
      res.status(200).send("Message sent");
    }
  });
});

module.exports = AddMessage;
