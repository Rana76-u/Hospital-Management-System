/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendCareSyncNotification = functions.https.onCall(async (data, context) => {
  const { token, title, body, screen } = data;

  const message = {
    token: token,
    notification: {
      title: title,
      body: body,
    },
    data: {
      screen: screen,
    },
    android: {
      notification: {
        channelId: 'stormymart',
      }
    }
  };

  try {
    const response = await admin.messaging().send(message);
    return { success: true, messageId: response };
  } catch (e) {
    console.error("Error sending notification", e);
    return { success: false, error: e.message };
  }
});

