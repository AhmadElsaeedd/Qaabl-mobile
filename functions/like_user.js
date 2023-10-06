const functions = require("firebase-functions");
const cors = require("cors");
const admin = require("firebase-admin");

const db = admin.firestore();

const corsOptions = {
  origin: true,
};

async function get_user_likes(uid) {
  const user_doc = await (db.collection("Users").doc(uid)).get();

  const user_data = user_doc.data();

  const user_likes = user_data.likes;

  return user_likes;
}

function add_liked_user(liked_user_uid, user_likes) {
  user_likes.push(liked_user_uid);

  return user_likes;
}

async function update_user(uid, user_likes_updated) {
  // Question: Should we get the user document again? Isn't that too many reads? How can we streamline this process?
  await db.collection("Users").doc(uid).update({
    likes: user_likes_updated,
  });
  console.log("done");
}

async function check_if_user_likes_them(uid,liked_user_uid){
  const liked_user_doc = await (db.collection("Users").doc(liked_user_uid)).get();

  const liked_user_data = liked_user_doc.data();

  const liked_user_likes = liked_user_data.likes;

  if (liked_user_likes.includes(uid)) {
    return true;
  } else {
    return false;
  }
}

const LikeUser = functions.region("asia-east2").https.onRequest(async (req, res) => {
  cors(corsOptions)(req, res, async () => {
    const user_uid = req.body.user_uid;
    //ToDo: notify this user that they've been liked
    const liked_user_uid = req.body.liked_user_uid;

    const user_likes_them = await check_if_user_likes_them(user_uid,liked_user_uid);

    if(user_likes_them) res.status(204).send("New match");

    // ToDo: get the user's likes array
    const user_likes = await get_user_likes(user_uid);

    // ToDo: Add liked_user_uid to the likes array of user_uid
    const user_likes_updated = add_liked_user(liked_user_uid, user_likes);

    // ToDo: update the current user's document with the new array
    await update_user(user_uid, user_likes_updated);

    res.status(200).send("User liked successfully");
  });
});

module.exports = LikeUser;
