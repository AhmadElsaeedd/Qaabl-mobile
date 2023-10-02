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


const GetNewMatches = functions.region("asia-east2").https.onRequest(async (req, res) => {
  cors(corsOptions)(req, res, async () => {
    const uid = req.body.uid;
    const matchesRef = db.collection("Matches");
    const snapshot = await matchesRef
        .where("users", "array-contains", uid)
        .where("has_message", "==", false)
        .orderBy("timestamp", "desc")
        .limit(5)
        .get();

    if (snapshot.empty) {
      console.log("No matching documents.");
      return [];
    }

    const matches = [];
    const promises = [];

    snapshot.docs.forEach((doc) => {
      const match = {...doc.data(), id: doc.id};

      // ToDo: the other user's id is the element in the match that is not uid
      const otherUserId = match.users.find((userId) => userId !== uid);

      console.log("other user id: ", otherUserId);
      const promise = db.collection("Users").doc(otherUserId).get().then((userDoc) => {
        if (!userDoc.exists) {
          console.log("User does not exist!");
          return;
        }
        match.other_user_name = userDoc.data().name;
        console.log("other user name: ", match.other_user_name);
      });

      promises.push(promise);
      matches.push(match);
    });

    console.log("matches are: ", matches);

    await Promise.all(promises);
    res.status(200).json(matches);
  });
});

module.exports = GetNewMatches;
