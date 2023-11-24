const functions = require("firebase-functions");
const admin = require("firebase-admin");

const CreateUserRecord = functions.region("asia-east2").auth.user().onCreate((user) => {
  return admin.firestore().collection("Users").doc(user.uid).set({
    id: user.uid,
    email: user.email,
    likes: [],
    dislikes: [],
    matches: [],
    matched_users: [],
    interests: [],
    aspiration: "",
    image_index: 0,
    super_likes: [],
  });
});

module.exports = CreateUserRecord;
