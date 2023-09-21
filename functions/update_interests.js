const functions = require("firebase-functions");
const cors = require("cors");
const admin = require("firebase-admin");

const db = admin.firestore();

const corsOptions = {
  origin: true,
};

async function get_user_data(uid) {
  const user_doc = await (db.collection("Users").doc(uid)).get();

  const user_data = user_doc.data();

  return user_data;
}

const UpdateInterests = functions.region("asia-east2").https.onRequest(async (req, res) => {
  cors(corsOptions)(req, res, async () => {
    const user_uid = req.body.uid;
    const new_interests = req.body.selected_interests;

    console.log("user uid: ", user_uid);
    console.log("new interests are: ", new_interests);

    // get the user's data first
    const user_data = await get_user_data(user_uid);
    const old_interests = user_data.interests.map((interest) => interest.name);

    console.log("old interests are: ", old_interests);

    // if success
    if (user_data) {
      res.status(200).send("Success");
    } else {
      // if failed
      res.status(500).send("Error");
    }
  });
});

module.exports = UpdateInterests;

