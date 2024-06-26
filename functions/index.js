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
const UpdateProfileData = require("./update_profile");
const AddMessage = require("./add_message");
const GetImageIndex = require("./get_image_index");
const GetOldMatches = require("./get_old_matches");
const GetNewMatches = require("./get_new_matches");
const LoadMessages = require("./load_messages");
const DeleteAccount = require("./delete_account");
const DeleteMatch = require("./delete_match");
const MessageReaction = require("./message_reaction");
const CreateMatchWMe = require("./create_match_w_me");
const LeaveNote = require("./leave_note");
const GetNotes = require("./get_notes");
const EmptyDislikes = require("./empty_dislikes");

exports.CreateUserRecord = CreateUserRecord;
exports.GetUsers = GetUsers;
exports.LikeUser = LikeUser;
exports.DislikeUser = DislikeUser;
exports.CreateMatch = CreateMatch;
exports.GetProfilePercentage = GetProfilePercentage;
exports.GetProfileData = GetProfileData;
exports.UpdateProfileData = UpdateProfileData;
exports.AddMessage = AddMessage;
exports.GetImageIndex = GetImageIndex;
exports.GetOldMatches = GetOldMatches;
exports.GetNewMatches = GetNewMatches;
exports.LoadMessages = LoadMessages;
exports.DeleteAccount = DeleteAccount;
exports.DeleteMatch = DeleteMatch;
exports.MessageReaction = MessageReaction;
exports.CreateMatchWMe = CreateMatchWMe;
exports.LeaveNote = LeaveNote;
exports.GetNotes = GetNotes;
exports.EmptyDislikes = EmptyDislikes;

