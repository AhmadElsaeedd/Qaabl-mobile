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

async function update_users(match_id, user1_id, user2_id) {
  const user1_promise = (db.collection("Users").doc(user1_id)).get();
  const user2_promise = (db.collection("Users").doc(user2_id)).get();

  const [user1_doc, user2_doc] = await Promise.all([user1_promise, user2_promise]);


  const user1_data = user1_doc.data();
  const user2_data = user2_doc.data();


  const index1 = user1_data.matched_users.indexOf(user2_id);
  if (index1 !== -1) {
    user1_data.matched_users.splice(index1, 1);
  }

  const index2 = user2_data.matched_users.indexOf(user1_id);
  if (index2!==-1) {
    user2_data.matched_users.splice(index2, 1);
  }

  const index3 = user1_data.matches.indexOf(match_id);
  if (index3!==-1) {
    user1_data.matches.splice(index3, 1);
  }

  const index4 = user2_data.matches.indexOf(match_id);
  if (index4!==-1) {
    user2_data.matches.splice(index4, 1);
  }

  const user1_update_promise = db.collection("Users").doc(user1_id).update({
    matched_users: user1_data.matched_users,
    matches: user1_data.matches,
  });

  const user2_update_promise = db.collection("Users").doc(user2_id).update({
    matched_users: user2_data.matched_users,
    matches: user2_data.matches,
  });

  await Promise.all([user1_update_promise, user2_update_promise]);
}

async function delete_match(match_id) {
  await db.collection("Matches").doc(match_id).delete();
}

const DeleteMatch = functions.region("asia-east2").https.onRequest(async (req, res) => {
  cors(corsOptions)(req, res, async () => {
    try {
      const match_id = req.body.match_id;
      const user1_id = req.body.user1_id;
      const user2_id = req.body.user2_id;

      const update_users_promise = update_users(match_id, user1_id, user2_id);
      const delete_match_promise = delete_match(match_id);

      await Promise.all([update_users_promise, delete_match_promise]);

      res.status(200).send("Match deleted");
    } catch (error) {
      console.error("Error deleting match:", error);
      res.status(500).send(error);
    }
  });
});

module.exports = DeleteMatch;
