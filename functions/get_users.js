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
      user_uid = req.body.uid;
      
      //if success
      if(user_uid){
        res.status(200).send();
      }
      else{
        //if failed
        res.status(500).send("Error");
      }
    });
  });

module.exports = GetUsers;