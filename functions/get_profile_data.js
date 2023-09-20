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


const GetProfileData = functions.region("asia-east2").https.onRequest(async (req, res) => {
  cors(corsOptions)(req, res, async () => {
    const user_uid = req.body.uid;

    // get the user's data first
    const user_data = await get_user_data(user_uid);

    // if success
    if (user_uid) {
      res.status(200).send("Success");
    } else {
      // if failed
      res.status(500).send("Error");
    }
  });
});

module.exports = GetProfileData;
