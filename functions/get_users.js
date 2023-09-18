const { onRequest } = require("firebase-functions/v2/https");
const cors = require('cors');
const admin = require("firebase-admin");

const db = admin.firestore();

const corsOptions = {
    origin: true,
  };

async function get_user_likes_dislikes(uid){
    // get the user document
    const user_doc = await (db.collection("Users").doc(uid)).get();
    
    // get the data of the user
    let user_data;
    user_data = user_doc.data();

    // get likes and dislikes arrays
    let likes = [];
    let dislikes = [];
    likes = user_data.likes;
    dislikes = user_data.dislikes;

    return {likes, dislikes};
}

async function get_other_users(uid, likes, dislikes){
    let filter_out_those = [...new Set([...likes, ...dislikes, uid])];

    let users_snapshot = await db.collection("Users")
    .where('id','not-in', filter_out_those)
    .limit(3)
    .get();

    let users = [];
    users_snapshot.forEach(doc => {
        users.push(doc.data());
      });

    return users;
}

async function structure_users(user_uid, users){
    console.log("user is:", user_uid);

    console.log("users are: ", users);

    let ready_users = users.map(user => {
    let { id, interests } = user;

    // check if the user is a potential match
    let potential_match = (user.likes || []).includes(user_uid);

        // return the transformed user object
        return {
            id,
            interests,
            potential_match
        };
    });

    return ready_users;
}

const GetUsers = onRequest(async (req, res) => {
    cors(corsOptions)(req, res, async () => {
    user_uid = req.body.uid;

    // get likes dislikes
    let { likes, dislikes } = await get_user_likes_dislikes(user_uid);

    // query to return 3 users
    let filtered_users = await get_other_users(user_uid,likes,dislikes);

    // structure the user with their interests and whether they're a potential match or not
    let ready_to_send_back_users = await structure_users(user_uid, filtered_users);

    //if success
    if(user_uid && likes && dislikes && filtered_users && ready_to_send_back_users){
    res.status(200).json(ready_to_send_back_users);
    }
    else{
    //if failed
    res.status(500).send("Error");
    }
    });
  });

module.exports = GetUsers;