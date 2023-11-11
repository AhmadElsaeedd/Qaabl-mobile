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

async function get_user_data(uid) {
  const user_doc = await (db.collection("Users").doc(uid)).get();

  const user_data = user_doc.data();

  return user_data;
}

function is_there_aspiration(user_aspiration, percentage) {
  if (user_aspiration) percentage += 15;

  return percentage;
}

function how_many_interests(interests, percentage) {
  if (interests.length === 0) percentage += 0;
  else if (interests.length === 1) percentage +=15;
  else if (interests.length === 2) percentage +=30;
  else if (interests.length >= 3) percentage +=50;
  
  return percentage;
}

function is_there_a_name(name, percentage) {
  if (name) percentage += 20;

  return percentage;
}

function is_there_a_pp(image_index, percentage) {
  if (image_index != 0) percentage += 15;
  return percentage;
}

const GetProfilePercentage = functions.region("asia-east2").https.onRequest(async (req, res) => {
  cors(corsOptions)(req, res, async () => {
    const user_uid = req.body.uid;

    // get the user's data first
    const user_data = await get_user_data(user_uid);

    let percentage = 0;

    // give a score if there is an aspiration
    percentage = is_there_aspiration(user_data.aspiration, percentage);

    // give a score depending on how many interests
    percentage = how_many_interests(user_data.interests, percentage);

    // give a score if there is a name
    percentage = is_there_a_name(user_data.name, percentage);

    percentage = is_there_a_pp(user_data.image_index, percentage);

    // ToDo: add more fields as necessary

    // if success
    if (user_uid) {
      res.status(200).json({percentage: percentage});
    } else {
      res.status(500).send("Error");
    }
  });
});

module.exports = GetProfilePercentage;
