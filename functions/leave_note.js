const functions = require("firebase-functions");
const admin = require("firebase-admin");
const cors = require("cors");
const { sendNotification } = require("./notifs_handler");
const { user } = require("firebase-functions/v1/auth");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

const db = admin.firestore();

const corsOptions = {
  origin: true,
};

async function get_user_notes(uid) {
    const user_doc = await db.collection("Users").doc(uid).get();
    const user_data = user_doc.data();

    return user_data.notes
}

async function update_user_notes(new_note, user_notes,uid) {
    user_notes.push(new_note);
    await db.collection("Users").doc(uid).update({
        notes:user_notes
      });
}

const LeaveNote = functions.region("asia-east2").https.onRequest(async (req, res) => {
  cors(corsOptions)(req, res, async () => {
    const liked_user_uid = req.body.liked_user_uid;
    const note = req.body.note;
    const uid = req.body.uid;

    const timestamp = new Date();

    const new_note = {
      sent_by: uid,
      content: note,
      timestamp: timestamp,
    };

    try {
        const user_notes = await get_user_notes(liked_user_uid);

        await update_user_notes(new_note,user_notes, liked_user_uid);

        const payload = {
            notification: {
            title: 'Someone left u a note!',
            body: 'get on Qaabl and swipe right to know who!',
            },
        };

      sendNotification(liked_user_uid, payload);

        res.status(200).send("Note left");
    } catch (error) {
      console.error("Error occurred:", error);
      res.status(500).send("Internal Server Error");
    }
  });
});


module.exports = LeaveNote;
