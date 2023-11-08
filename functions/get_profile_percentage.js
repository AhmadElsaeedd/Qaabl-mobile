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

function is_there_bio(user_bio, percentage) {
  console.log("at user bio function: ", percentage);
  if (user_bio) percentage += 10;

  return percentage;
}

function how_many_interests(interests, percentage) {
  console.log("at interests function: ", percentage);
  console.log("length of interests: ", interests.length);
  if (interests.length === 0) percentage += 0;
  else if (interests.length === 1) percentage +=10;
  else if (interests.length === 2) percentage +=20;
  else if (interests.length === 3) percentage +=30;
  else if (interests.length === 4) percentage +=35;
  else if (interests.length === 5) percentage +=40;
  else if (interests.length === 6) percentage +=45;
  else if (interests.length === 7) percentage +=50;

  return percentage;
}

function is_there_a_name(name, percentage) {
  console.log("at name function: ", name);
  if (name) percentage += 10;

  return percentage;
}

function is_there_a_pp(image_index, percentage) {
  if (image_index != 0) percentage += 10;
  return percentage;
}

const GetProfilePercentage = functions.region("asia-east2").https.onRequest(async (req, res) => {
  cors(corsOptions)(req, res, async () => {
    const user_uid = req.body.uid;

    // get the user's data first
    const user_data = await get_user_data(user_uid);

    let percentage = 0;

    // give a score if there is a bio
    percentage = is_there_bio(user_data.bio, percentage);

    // give a score depending on how many interests
    percentage = how_many_interests(user_data.interests, percentage);

    // ToDo: give a score if there is a profile pic
    // Still haven't figured how we'll store pps

    // give a score if there is a name
    percentage = is_there_a_name(user_data.name, percentage);

    percentage = is_there_a_pp(user_data.image_index, percentage);

    // ToDo: add more fields as necessary

    console.log("Percentage is: ", percentage);

    // if success
    if (user_uid) {
      console.log("I succeeded");
      res.status(200).json({percentage: percentage});
    } else {
      // if failed
      console.log("I failed");
      res.status(500).send("Error");
    }
  });
});

module.exports = GetProfilePercentage;
