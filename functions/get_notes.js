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

async function get_user_notes(uid) {
    let user_doc;
    // get the user document
    while (true) {
      user_doc = await (db.collection("Users").doc(uid)).get();
  
      if (user_doc.exists) {
        // If the document exists, break out of the loop
        break;
      } else {
        // If the document doesn't exist, wait for 0.5 seconds before checking again
        await new Promise((resolve) => setTimeout(resolve, 500));
      }
    }
  
  
    // get the data of the user
    const user_data = user_doc.data();
  
    // get likes and dislikes and matches_users arrays
    const notes = user_data.notes;
  
    return notes;
  }


const GetNotes = functions.region("asia-east2").https.onRequest(async (req, res) => {
    cors(corsOptions)(req, res, async () => {
      const user_uid = req.body.uid;
  
      // get likes, dislikes, and matched users
      const user_notes = await get_user_notes(user_uid);
  
      // if success
      if (user_notes.length > 0) {
        res.status(200).json(user_notes);
      } else if (user_notes.length === 0){
        res.status(204).send("No notes bro");
      }
      else {
      // if failed
        res.status(500).send("Error");
      }
    });
  });
  
  module.exports = GetNotes;
  