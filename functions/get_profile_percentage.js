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

function is_there_aspiration(user_aspiration) {
  if (user_aspiration) return true;
  else return false;
}

function how_many_interests(interests) {
  if (interests.length === 0) return 0;
  else if (interests.length === 1) return 1;
  else if (interests.length === 2) return 2;
  else if (interests.length >= 3) return 3;
}

function is_there_a_name(name) {
  if (name) return true
  else return false;
}

function is_there_a_pp(image_index) {
  if (image_index != 0) return true;
  else return false;
}

const GetProfilePercentage = functions.region("asia-east2").https.onRequest(async (req, res) => {
  cors(corsOptions)(req, res, async () => {
    const user_uid = req.body.uid;

    // get the user's data first
    const user_data = await get_user_data(user_uid);

    let percentage = 0;
    let missing_stuff = [];

    // give a score if there is an aspiration
    let there_is_aspiration;
    there_is_aspiration = is_there_aspiration(user_data.aspiration, percentage);
    if(there_is_aspiration) percentage += 15;
    else missing_stuff.push("Aspiration");

    // give a score depending on how many interests
    let interests_count;
    interests_count = how_many_interests(user_data.interests);
    if (interests_count === 0){
      percentage += 0;
      missing_stuff.push("Interests");
    }
    else if (interests_count === 1) percentage +=15;
    else if (interests_count === 2) percentage +=30;
    else if (interests_count === 3) percentage +=50;

    // give a score if there is a name
    let there_is_name;
    there_is_name = is_there_a_name(user_data.name);
    if (there_is_name) percentage += 20;
    else missing_stuff.push("Name");

    let there_is_pp;
    there_is_pp = is_there_a_pp(user_data.image_index);
    if (there_is_pp != 0) percentage += 15;
    else missing_stuff.push("Avatar");

    // ToDo: add more fields as necessary

    console.log("Missing stuff: ", missing_stuff);
    // if success
    if (user_uid) {
      res.status(200).json({percentage: percentage , missing: missing_stuff});
    } else {
      res.status(500).send("Error");
    }
  });
});

module.exports = GetProfilePercentage;
