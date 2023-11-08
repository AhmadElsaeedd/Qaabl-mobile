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

async function get_user_dislikes(uid) {
  const user_doc = await (db.collection("Users").doc(uid)).get();

  const user_data = user_doc.data();

  const user_dislikes = user_data.dislikes;

  return user_dislikes;
}

function add_disliked_user(disliked_user_uid, user_dislikes) {
  user_dislikes.push(disliked_user_uid);

  return user_dislikes;
}

async function update_user(uid, user_dislikes_updated) {
  // Question: Should we get the user document again? Isn't that too many reads? How can we streamline this process?
  await db.collection("Users").doc(uid).update({
    dislikes: user_dislikes_updated,
  });
  console.log("done");
}


const DislikeUser = functions.region("asia-east2").https.onRequest(async (req, res) => {
  cors(corsOptions)(req, res, async () => {
    const user_uid = req.body.user_uid;
    const disliked_user_uid = req.body.disliked_user_uid;

    // ToDo: get the user's dislikes array
    const user_dislikes = await get_user_dislikes(user_uid);

    // ToDo: Add liked_user_uid to the likes array of user_uid
    const user_dislikes_updated = add_disliked_user(disliked_user_uid, user_dislikes);

    // ToDo: update the current user's document with the new array
    await update_user(user_uid, user_dislikes_updated);

    res.status(200).send("User liked successfully");
  });
});

module.exports = DislikeUser;
