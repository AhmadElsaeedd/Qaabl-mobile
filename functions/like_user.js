const functions = require("firebase-functions");
const cors = require("cors");
const admin = require("firebase-admin");
const { sendNotification } = require("./notifs_handler");

if (admin.apps.length === 0) {
  admin.initializeApp();
}

const db = admin.firestore();

const corsOptions = {
  origin: true,
};

async function get_user_info(uid) {
  const user_doc = await db.collection("Users").doc(uid).get();
  const user_data = user_doc.data();

  return {
    user_likes: user_data.likes,
    user_dislikes: user_data.dislikes,
    user_super_likes: user_data.super_likes,
  };
}


function remove_from_dislikes(liked_user_uid, user_dislikes){
  if(user_dislikes.includes(liked_user_uid)) {
    user_dislikes = user_dislikes.filter(uid => uid !== liked_user_uid);
  }

  return user_dislikes;
}

function add_liked_user(liked_user_uid, user_likes) {
  user_likes.push(liked_user_uid);

  return user_likes;
}

function add_super_liked_user(liked_user_uid, user_super_likes){
  user_super_likes.push(liked_user_uid);

  return user_super_likes;
}

async function update_user(uid, user_likes_updated,user_dislikes_updated, user_super_likes_updated) {
  await db.collection("Users").doc(uid).update({
    likes: user_likes_updated,
    dislikes: user_dislikes_updated,
    super_likes: user_super_likes_updated,
  });
}

async function check_if_user_likes_them(uid, liked_user_uid) {
  const liked_user_doc = await (db.collection("Users").doc(liked_user_uid)).get();

  const liked_user_data = liked_user_doc.data();

  const liked_user_likes = liked_user_data.likes;
  const liked_user_super_likes = liked_user_data.super_likes;

  if (liked_user_likes.includes(uid) || liked_user_super_likes.includes(uid)) {
    return true;
  } else {
    return false;
  }
}

const LikeUser = functions.region("asia-east2").https.onRequest(async (req, res) => {
  cors(corsOptions)(req, res, async () => {
    const user_uid = req.body.user_uid;
    const liked_user_uid = req.body.liked_user_uid;
    const like_or_super_like = req.body.like_or_super_like;

    const user_likes_them = await check_if_user_likes_them(user_uid, liked_user_uid);

    if (user_likes_them) res.status(204).send("New match");

    //get the user's likes array
    const { user_likes, user_dislikes, user_super_likes } = await get_user_info(user_uid);
    
    //get the user's dislikes array
    const user_dislikes_updated = remove_from_dislikes(liked_user_uid,user_dislikes);

    // ToDo: Add liked_user_uid to the likes array of user_uid
    let user_likes_updated = user_likes;
    let user_super_likes_updated = user_super_likes;
    if(like_or_super_like === "like"){
      user_likes_updated = add_liked_user(liked_user_uid, user_likes);
    }
    else if (like_or_super_like === "super_like"){
      user_super_likes_updated = add_super_liked_user(liked_user_uid, user_super_likes);
    }
    

    //update the current user's document with the new array
    await update_user(user_uid, user_likes_updated,user_dislikes_updated, user_super_likes_updated);

    //send a notif to the liked user
    const payload = {
      notification: {
        title: '😍😍Someone likes you!',
        body: 'get on Qaabl and find out whooo',
      },
    };

    sendNotification(liked_user_uid, payload);

    res.status(200).send("User liked successfully");
  });
});

module.exports = LikeUser;
