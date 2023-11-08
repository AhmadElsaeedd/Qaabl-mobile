const functions = require("firebase-functions");
const cors = require("cors");
const admin = require("firebase-admin");
const { sendNotification } = require("./notifs_handler");
const {v4: uuidv4} = require("uuid");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

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

function update_matched_users(user1_matched_users, user2_matched_users, user1_uid, user2_uid) {
  user1_matched_users.push(user2_uid);
  user2_matched_users.push(user1_uid);

  return {user1_matched_users, user2_matched_users};
}

function update_matches(user1_matches, user2_matches, match_id) {
  user1_matches.push(match_id);
  user2_matches.push(match_id);

  return {user1_matches, user2_matches};
}

async function create_match(user1_uid, user2_uid) {
  // const timestamp = admin.firestore.FieldValue.serverTimestamp();
  const timestamp = new Date();

  const matchId = uuidv4();

  const matchData = {
    match_id: matchId,
    users: [user1_uid, user2_uid],
    timestamp: timestamp,
    last_message: {},
    has_message: false,
  };

  await db.collection("Matches").doc(matchId).set(matchData);

  console.log("New match created with ID: ", matchId);

  return matchId;
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


async function update_users(user1_likes, user2_likes, user1_matched_users, user2_matched_users, user1_matches, user2_matches, user1_uid, user2_uid) {
  const user1UpdatePromise = db.collection("Users").doc(user1_uid).update({
    matched_users: user1_matched_users,
    matches: user1_matches,
    likes: user1_likes,
  });

  const user2UpdatePromise = db.collection("Users").doc(user2_uid).update({
    matched_users: user2_matched_users,
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

    const {user1_data, user2_data} = await get_users(user1_uid, user2_uid);

    // add users to the matches array of each other
    const {user1_matched_users, user2_matched_users} = update_matched_users(user1_data.matched_users, user2_data.matched_users, user1_uid, user2_uid);

    // remove them from each other's likes, if they exist
    const {user1_likes, user2_likes} = remove_user_from_likes(user1_data.likes, user2_data.likes, user1_uid, user2_uid);

    // create match
    const match_id = await create_match(user1_uid, user2_uid);

    // add match id to both users
    const {user1_matches, user2_matches} = update_matches(user1_data.matches, user2_data.matches, match_id);

    // update both with new arrays
    const done = await update_users(user1_likes, user2_likes, user1_matched_users, user2_matched_users, user1_matches, user2_matches, user1_uid, user2_uid);

    const payload = {
      notification: {
        title: '😍😍You have a new match!',
        body: 'get on Qaabl and meet a new friend!',
      },
    };

    sendNotification(user1_uid, payload);
    sendNotification(user2_uid, payload);

    if (done) {
      res.status(200).send("Match created");
    }
  });
});

module.exports = CreateMatch;
