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

function is_name_changed(old_name, submitted_name) {
  if (old_name != submitted_name) return true;
}

function is_profile_pic_changed(old_pp_index, new_pp_index) {
  if (old_pp_index != new_pp_index) return true;
}

function is_aspiration_changed(old_aspiration, new_aspiration){
  if(old_aspiration != new_aspiration) return true;
}

function is_interests_changed(old_interests, new_interests) {
  // Sort the arrays of interests by their 'name' property
  const sortInterests = (interests) => {
    return interests.sort((a, b) => a.name.localeCompare(b.name));
  };

  const sortedOld = sortInterests(old_interests);
  const sortedNew = sortInterests(new_interests);

  // Convert the sorted arrays to JSON strings
  const oldStr = JSON.stringify(sortedOld);
  const newStr = JSON.stringify(sortedNew);

  // Compare the JSON strings and return true if they are different
  return oldStr !== newStr;
}


async function update_user(name = null, interests = null, uid, pp = null, aspiration = null) {
  let updateData = {};
  if (name) updateData.name = name;
  if (interests) updateData.interests = interests;
  if (pp != null) updateData.image_index = pp;
  if (aspiration) updateData.aspiration = aspiration;

  await db.collection("Users").doc(uid).update(updateData);
}

const UpdateProfileData = functions.region("asia-east2").https.onRequest(async (req, res) => {
  cors(corsOptions)(req, res, async () => {
    const user_uid = req.body.uid;
    const name = req.body.name;
    const interests = req.body.interests;
    const aspiration = req.body.aspiration;
    const profile_pic_index = req.body.image_index;
    // ToDo: get more input from the view model code

    // get the user's data first
    const user_data = await get_user_data(user_uid);

    // function that checks that name has changed
    const name_changed = is_name_changed(user_data.name, name);

    const interests_changed = is_interests_changed(user_data.interests, interests);

    const profile_pic_changed = is_profile_pic_changed(user_data.image_index, profile_pic_index);

    const aspiration_changed = is_aspiration_changed(user_data.aspiration, aspiration);

    if (name_changed || interests_changed || profile_pic_changed || aspiration_changed) {
      update_user(
          name_changed ? name : null, 
          interests_changed ? interests : null, 
          user_uid, 
          profile_pic_changed ? profile_pic_index : null, 
          aspiration_changed ? aspiration : null
      );
  }

    // if success
    if (user_data) {
      res.status(200).send("Success");
    } else {
      // if failed
      res.status(500).send("Error");
    }
  });
});

module.exports = UpdateProfileData;
