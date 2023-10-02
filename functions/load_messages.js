const functions = require("firebase-functions");
const cors = require("cors");
const admin = require("firebase-admin");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

const db = admin.firestore();

const corsOptions = {
  origin: true,
};


const LoadMessages = functions.region("asia-east2").https.onRequest(async (req, res) => {
  cors(corsOptions)(req, res, async () => {
    const match_id = req.body.match_id;
    const messagesRef = db.collection("Matches").doc(match_id).collection("Messages");
    const snapshot = await messagesRef
        .orderBy("timestamp", "desc")
        .limit(10)
        .get();

    if (snapshot.empty) {
      console.log("No messages.");
      return [];
    }

    const messages = [];
    snapshot.forEach((doc) => {
      const message = doc.data();
      messages.push(message);
    });

    console.log("messages are: ", messages);

    res.status(200).json(messages);
  });
});

module.exports = LoadMessages;
