const functions = require("firebase-functions");
const cors = require("cors");
const admin = require("firebase-admin");

const db = admin.firestore();

const corsOptions = {
  origin: true,
};

async function get_users(user1_uid, user2_uid) {
  const user1Promise = db.collection("Users").doc(user1_uid).get();
  const user2Promise = db.collection("Users").doc(user2_uid).get();

  const [user1_doc, user2_doc] = await Promise.all([user1Promise, user2Promise]);

  const user1_data = user1_doc.data();
  const user2_data = user2_doc.data();

  return {user1_data, user2_data};
}

function update_matches(user1_matches, user2_matches, user1_uid, user2_uid) {
  user1_matches.push(user2_uid);
  user2_matches.push(user1_uid);

  return {user1_matches, user2_matches};
}

async function create_match(user1_uid, user2_uid) {
  // ToDo: create the match according to the schema in my room
  // In the "Matches" collection, with fields user1 (user1_uid), user2 (user2_uid), timestamp_newchat (current timestamp), isNew (true)
  // ToDo: put the timestamp: const timestamp_newchat = admin.firestore.Timestamp.now();
  const isNew = true;

  const matchData = {
    user1: user1_uid,
    user2: user2_uid,
    // timestamp_newchat,
    isNew,
  };

  await db.collection("Matches").add(matchData);

  console.log("New match created.");

  return true;
}

function remove_user_from_likes(user1_likes, user2_likes, user1_uid, user2_uid) {
  // Remove user2_uid from user1_likes if it exists
  // find its index first
  const index1 = user1_likes.indexOf(user2_uid);
  if (index1 !== -1) {
    // delete it if it exists
    user1_likes.splice(index1, 1);
  }

  // Remove user1_uid from user2_likes if it exists
  const index2 = user2_likes.indexOf(user1_uid);
  if (index2 !== -1) {
    user2_likes.splice(index2, 1);
  }

  return {user1_likes, user2_likes};
}


async function update_users(user1_likes, user2_likes, user1_matches, user2_matches, user1_uid, user2_uid) {
  const user1UpdatePromise = db.collection("Users").doc(user1_uid).update({
    matches: user1_matches,
    likes: user1_likes,
  });

  const user2UpdatePromise = db.collection("Users").doc(user2_uid).update({
    matches: user2_matches,
    likes: user2_likes,
  });

  await Promise.all([user1UpdatePromise, user2UpdatePromise]);

  return true;
}

const CreateMatch = functions.region("asia-east2").https.onRequest(async (req, res) => {
  cors(corsOptions)(req, res, async () => {
    const user1_uid = req.body.user1_uid;
    const user2_uid = req.body.user2_uid;

    console.log("user 1 is: ", user1_uid);
    console.log("user 2 is: ", user2_uid);

    const {user1_data, user2_data} = await get_users(user1_uid, user2_uid);

    // add users to the matches array of each other
    const {user1_matches, user2_matches} = await update_matches(user1_data.matches, user2_data.matches, user1_uid, user2_uid);

    // remove them from each other's likes, if they exist
    const {user1_likes, user2_likes} = await remove_user_from_likes(user1_data.likes, user2_data.likes, user1_uid, user2_uid);

    // update both with new arrays
    const done1 = await update_users(user1_likes, user2_likes, user1_matches, user2_matches, user1_uid, user2_uid);

    // create match
    const done2 = await create_match(user1_uid, user2_uid);

    if (done1 && done2) {
      res.status(200).send("Match created");
    }
  });
});

module.exports = CreateMatch;
