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

async function add_message_to_chat(chat_id, new_message) {
  let done = false;
  await db.collection("Matches").doc(chat_id).collection("Messages").add(new_message);
  done = true;
  return done;
}

async function get_match_data(match_id) {
  const match_doc = await (db.collection("Matches").doc(match_id)).get();
  return match_doc.data();
}

async function update_match_doc(match_data, chat_id, new_message) {
  let done2 = false;
  if (match_data.has_message === true) {
    // make has_message true and update the last message
    await db.collection("Matches").doc(chat_id).update({
      last_message: new_message,
    });
  } else {
    // has_message is already true, update the last message
    await db.collection("Matches").doc(chat_id).update({
      has_message: true,
      last_message: new_message,
    });
  }
  done2 = true;
  return done2;
}

const AddMessage = functions.region("asia-east2").https.onRequest(async (req, res) => {
  cors(corsOptions)(req, res, async () => {
    const user_uid = req.body.uid;
    const chat_id = req.body.chat_id;
    const content = req.body.content;

    const timestamp = new Date();

    const new_message = {
      sent_by: user_uid,
      content: content,
      timestamp: timestamp,
    };

    // Start Process 2: add_message_to_chat
    const process1 = add_message_to_chat(chat_id, new_message);

    // Start Process 1: get_match_data => update_match_doc
    const process2 = get_match_data(chat_id)
        .then((match_data) => update_match_doc(match_data, chat_id, new_message))
        .catch((error) => console.error("Error in Process 1:", error));

    try {
      // Wait for both processes to complete
      const [done, done2] = await Promise.all([process1, process2]);

      if (done && done2) {
        res.status(200).send("Message sent");
      }
    } catch (error) {
      console.error("Error occurred:", error);
      res.status(500).send("Internal Server Error");
    }
  });
});


module.exports = AddMessage;
