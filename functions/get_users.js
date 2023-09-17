const { onRequest } = require("firebase-functions/v2/https");
const cors = require('cors');
const admin = require("firebase-admin");

const db = admin.firestore();

const corsOptions = {
    origin: true,
  };

//ToDo: make the function only available to my app
const GetUsers = onRequest((req, res) => {
    cors(corsOptions)(req, res, () => {
      
        
      //if success
          res.status(200).send(users);
          //if failed
          res.status(500).send("Error fetching users: ", error);
    });
  });

module.exports = GetUsers;