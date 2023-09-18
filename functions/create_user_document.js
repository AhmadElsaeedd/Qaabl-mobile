const functions = require("firebase-functions");
const admin = require("firebase-admin");

const CreateUserRecord = functions.auth.user().onCreate((user) => {
  return admin.firestore().collection("Users").doc(user.uid).set({
    id: user.uid,
    email: user.email,
    likes: [],
    dislikes: [],
    matches: [],
    interests: [],
  });
});

module.exports = CreateUserRecord;
