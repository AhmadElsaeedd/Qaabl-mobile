const functions = require("firebase-functions");
const admin = require("firebase-admin");

const CreateUserRecord = functions.auth.user().onCreate((user) => {
  console.log("Function triggered");
  return admin.firestore().collection("Users").doc(user.uid).set({
    email: user.email,
    likes: [],
    dislikes: [],
    matches: [],
    interests: [],
  });
});

module.exports = CreateUserRecord;
