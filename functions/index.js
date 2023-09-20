/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */
// const {onRequest} = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");

admin.initializeApp();

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started


const CreateUserRecord = require("./create_user_document");
const GetUsers = require("./get_users");
const LikeUser = require("./like_user");
const DislikeUser = require("./dislike_user");
const CreateMatch = require("./create_match");
const GetProfilePercentage = require("./get_profile_percentage");
const GetProfileData = require("./get_profile_data");

exports.CreateUserRecord = CreateUserRecord;
exports.GetUsers = GetUsers;
exports.LikeUser = LikeUser;
exports.DislikeUser = DislikeUser;
exports.CreateMatch = CreateMatch;
exports.GetProfilePercentage = GetProfilePercentage;
exports.GetProfileData = GetProfileData;
