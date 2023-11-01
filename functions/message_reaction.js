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

async function react_to_message(chat_id,reaction,content) {
    let done = false;
    // Fetch the documents that match your query
    const snapshot = await db.collection("Matches").doc(chat_id).collection("Messages").where('content', "==", content).get();
    
    // If no documents match the query, return false
    if (snapshot.empty) {
        return done;
    }

    // Iterate through the matched documents and update them
    for (const doc of snapshot.docs) {
        await db.collection("Matches").doc(chat_id).collection("Messages").doc(doc.id).set({
            reaction: reaction
        }, { merge: true });
    }
    done = true;
    return done;
}


const MessageReaction = functions.region("asia-east2").https.onRequest(async (req, res) => {
    cors(corsOptions)(req, res, async () => {
      const reaction = req.body.reaction;
      const chat_id = req.body.chat_id;
      const content = req.body.content;
  
      try {
        let done = await react_to_message(chat_id,reaction,content);
  
        if (done) {
          res.status(200).send("Reaction added");
        }
      } catch (error) {
        console.error("Error occurred:", error);
        res.status(500).send("Internal Server Error");
      }
    });
  });
  
  
  module.exports = MessageReaction;