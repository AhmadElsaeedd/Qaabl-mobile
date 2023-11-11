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


const GetProfileData = functions.region("asia-east2").https.onRequest(async (req, res) => {
  cors(corsOptions)(req, res, async () => {
    const user_uid = req.body.uid;

    // get the user's data first
    const user_data = await get_user_data(user_uid);

    // interests
    const user_interests = user_data.interests;

    // aspiration
    const user_aspiration = user_data.aspiration;

    // name
    const user_name = user_data.name;

    // image index
    const image_index = user_data.image_index;

    // ToDo: put them in an object together and send them back as JSON to the client
    const response_data = {
      name: user_name,
      interests: user_interests,
      aspiration: user_aspiration,
      image_index: image_index,
    };

    // if success
    if (user_uid) {
      res.status(200).json(response_data);
    } else {
      // if failed
      res.status(500).send("Error");
    }
  });
});

module.exports = GetProfileData;
