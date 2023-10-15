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


const DeleteAccount = functions.region("asia-east2").https.onRequest(async (req, res) => {
  cors(corsOptions)(req, res, async () => {
    try {
      const user_uid = req.body.user_uid;

      // remove the document from firestore
      await db.collection("Users").doc(user_uid).delete();

      // remove the user from auth
      await admin.auth().deleteUser(user_uid);

      res.status(200).send("Account deleted");
    } catch (error) {
      console.error("Error deleting user:", error);
      res.status(500).send(error);
    }
  });
});

module.exports = DeleteAccount;
