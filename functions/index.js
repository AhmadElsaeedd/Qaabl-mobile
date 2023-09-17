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
const functions = require("firebase-functions");
admin.initializeApp();

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started


const {CreateUserRecord} = require("./create_user_document");
const {GetUsers} = require("./get_users");

exports.CreateUserRecord = CreateUserRecord;
exports.GetUsers = GetUsers;
