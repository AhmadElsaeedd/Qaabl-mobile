// const onRequest = require("firebase-functions/v2/https");
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

// function that gets likes, dislikes, and matches of user
async function get_user_info(uid) {
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
  const likes = user_data.likes;
  const dislikes = user_data.dislikes;
  const matched_users = user_data.matched_users;
  const interests = user_data.interests;
  const super_likes = user_data.super_likes;

  return {likes, dislikes, matched_users, interests, super_likes};
}

function should_user_continue(likes,dislikes,super_likes,interests){
  const likes_and_dislikes = likes.length + dislikes.length + super_likes.length;
  if(likes_and_dislikes>0 && interests.length == 0) return false;
  else return true;
}

// function that gets filtered users
async function get_other_users(uid, likes, dislikes,super_likes, matched_users, users_in_queue) {
  let filter_out_those = [];
  if(users_in_queue) {
    filter_out_those = [...new Set([...likes, ...dislikes,...super_likes, ...matched_users, ...users_in_queue, uid])];
  }
  else{
    filter_out_those = [...new Set([...likes, ...dislikes,...super_likes ,...matched_users, uid])];
  }
  

  // there is a problem here, when this array has more than 10 values, the query stops supporting that
  const users = [];
  if (filter_out_those.length <= 10) {
    // If 10 or fewer items to filter out, use 'not-in'
    const users_snapshot = await db.collection("Users")
        .where("id", "not-in", filter_out_those)
        .limit(5)
        .get();

    users_snapshot.forEach((doc) => {
      // avoid users who don't have interests yet
      if (doc.data().interests.length > 0) users.push(doc.data());
    });
  } else {
    // If more than 10 items to filter out, use alternate approach
    // split filter_out_those into chunks of 10
    const chunks = [];
    for (let i = 0; i < filter_out_those.length; i += 10) {
      chunks.push(filter_out_those.slice(i, i + 10));
    }
    for (const chunk of chunks) {
      const users_snapshot = await db.collection("Users")
          .where("id", "not-in", chunk)
          .limit(10)
          .get();

      // filter out those in users_snapshot that are in the other chunks
      users_snapshot.forEach((doc) => {
        const userData = doc.data();
        if (!filter_out_those.includes(userData.id)) {
          // avoid the users who have no interests yet
          if (userData.interests.length > 0 ) users.push(userData);
        }
      });

      // when length of the users left is 1 or more, break out of the loop
      if (users.length >= 1) {
        break;
      }
    }
  }
  users.length;
  return users;
}

async function structure_users(user_uid, users) {
  const ready_users = users.map((user) => {
    const {id, interests} = user;

    // check if the user is a potential match
    const potential_match = (user.likes || []).includes(user_uid) || (user.super_likes || []).includes(user_uid);

    let image_index;
    if (user.image_index) image_index = user.image_index;
    else image_index = 0;

    let aspiration;
    if (user.aspiration) aspiration = user.aspiration;
    else aspiration = ""

    // return the transformed user object
    return {
      id,
      interests,
      aspiration,
      potential_match,
      image_index,
    };
  });

  return ready_users;
}

const GetUsers = functions.region("asia-east2").https.onRequest(async (req, res) => {
  cors(corsOptions)(req, res, async () => {
    const user_uid = req.body.uid;
    const users_in_queue = req.body.users_queue_uids;

    // get likes, dislikes, and matched users
    const {likes, dislikes, matched_users, interests, super_likes} = await get_user_info(user_uid);

    //check if the user can continue
    const user_continues = should_user_continue(likes,dislikes, super_likes,interests);

    if(user_continues == false) {
      return res.status(205).send("User can't continue");
    }

    // query to return 1 user (worst case) and up to 5 (best case)
    const filtered_users = await get_other_users(user_uid, likes, dislikes,super_likes, matched_users, users_in_queue);

    if (filtered_users.length === 0) {
      // No more users to send
      return res.status(204).send("No more users");
    }

    // structure the user with their interests and whether they're a potential match or not
    const ready_to_send_back_users = await structure_users(user_uid, filtered_users);

    // if success
    if (ready_to_send_back_users.length > 0) {
      res.status(200).json(ready_to_send_back_users);
    } else if (ready_to_send_back_users.length === 0){
      res.status(204).send("No more users");
    }
    else {
    // if failed
      res.status(500).send("Error");
    }
  });
});

module.exports = GetUsers;
