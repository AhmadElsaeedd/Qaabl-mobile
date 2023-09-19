const functions = require("firebase-functions");
const cors = require("cors");
const admin = require("firebase-admin");

const db = admin.firestore();

const corsOptions = {
  origin: true,
};

async function get_users(user1_uid, user2_uid) {
  const user1_doc = await (db.collection("Users").doc(user1_uid)).get();
  const user1_data = user1_doc.data();

  const user2_doc = await (db.collection("Users").doc(user2_uid)).get();
  const user2_data = user2_doc.data();

  return {user1_data, user2_data};
}

async function update_matches(user1_matches, user2_matches, user1_uid, user2_uid) {
  user1_matches.push(user2_uid);
  user2_matches.push(user1_uid);

  await db.collection("Users").doc(user1_uid).update({
    matches: user1_matches,
  });

  await db.collection("Users").doc(user2_uid).update({
    matches: user2_matches,
  });
}

// What do we need to do here?
// Add the uid of user1 to user2's matches
// Add the uid of user2 to user1's matches
// Remove the uid of user1 from user2's likes
// Remove the uid of user2 from user1's likes
const CreateMatch = functions.region("asia-east2").https.onRequest(async (req, res) => {
  cors(corsOptions)(req, res, async () => {
    const user1_uid = req.body.user1_uid;
    const user2_uid = req.body.user2_uid;

    console.log("user 1 is: ", user1_uid);
    console.log("user 2 is: ", user2_uid);

    const {user1_data, user2_data} = await get_users(user1_uid, user2_uid);

    // add users to the matches array of each other
    await update_matches(user1_data.matches, user2_data.matches, user1_uid, user2_uid);

    await create_match(user1_uid, user2_uid);


    res.status(200).send("User liked successfully");
  });
});

module.exports = CreateMatch;
