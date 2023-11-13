const functions = require("firebase-functions");
const cors = require("cors");
const admin = require("firebase-admin");
const axios = require("axios");

const {v4: uuidv4} = require("uuid");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

const db = admin.firestore();

const corsOptions = {
  origin: true,
};

async function get_my_data(){
    const user_snapshot = await db.collection("Users").where("email", "==", "ae2200@nyu.edu").get();
    if (user_snapshot.empty) {
        console.log('No matching documents.');
        return null;
    }

    let user_data = null;
    let my_uid = null;

    user_snapshot.forEach(doc => {
      console.log("I am here");
        user_data = doc.data();
        console.log("User data is: ", user_data);
        my_uid = user_data.id;
        console.log("My uid is: ", my_uid);
    });
    return {my_uid, user_data};
}

async function create_match(user1_uid, user2_uid) {
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


  function update_matches(user1_matches, user2_matches, match_id) {
    user1_matches.push(match_id);
    user2_matches.push(match_id);
  
    return {user1_matches, user2_matches};
  }


async function update_users( user1_matched_users, user2_matched_users, user1_matches, user2_matches, user1_uid, user2_uid) {
    const user1UpdatePromise = db.collection("Users").doc(user1_uid).update({
      matched_users: user1_matched_users,
      matches: user1_matches,
    });
  
    const user2UpdatePromise = db.collection("Users").doc(user2_uid).update({
      matched_users: user2_matched_users,
      matches: user2_matches,
    });
  
    await Promise.all([user1UpdatePromise, user2UpdatePromise]);
  
    return true;
  }

const CreateMatchWMe = functions.region("asia-east2").firestore
    .document('Users/{userId}')
    .onCreate(async (snap, context) => {
        const newUser = snap.data();

        const user_uid = newUser.id;

        const {my_uid,user_data} = await get_my_data();

        const match_id = await create_match(user_uid, my_uid);

        const {user1_matches, user2_matches} = update_matches(newUser.matches, user_data.matches, match_id);

        const done = await update_users( newUser.matched_users, user_data.matched_users, user1_matches, user2_matches, user_uid, my_uid);

        if(done) console.log("Match created for user:", user_uid);

        const intro_msg_content = "yo, im ahmad. im the one who developed this app, im a senior at nyuad. ask me anything, talk to me. im probably bored behind a screen. lets be friends!";
        const functionUrl = 'https://asia-east2-qaabl-mobile-dev.cloudfunctions.net/AddMessage';

        // Data to send, if any
        const data = {
          uid: my_uid,
          chat_id: match_id,
          content: intro_msg_content
        };

        try {
            const response = await axios.post(functionUrl, data);
            console.log('Response from target function:', response.data);
        } catch (error) {
            console.error('Error calling target function:', error);
        }
    });

module.exports = CreateMatchWMe;