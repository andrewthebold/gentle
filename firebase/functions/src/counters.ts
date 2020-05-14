import * as functions from "firebase-functions";
import { firestore } from "firebase-admin";

let isAdminInitialized = false;

async function updateCount(key: string, change: number): Promise<void> {
  try {
    const admin = await import("firebase-admin");
    // Setup firestore admin
    if (!isAdminInitialized) {
      admin.initializeApp();
      isAdminInitialized = true;
    }

    const data: {
      [key: string]: FirebaseFirestore.FieldValue;
    } = {};
    data[key] = firestore.FieldValue.increment(change);

    await admin.firestore().collection("meta").doc("meta").update(data);
  } catch (error) {
    console.error(`Counter failed: ${error}`);
  }
}

// =============================================================================
// Requests
// =============================================================================
const REQUEST_COUNT_FIELD = "requestCount";

exports.countNewRequest = functions.firestore
  .document("requests/{requestID}")
  .onCreate(async () => await updateCount(REQUEST_COUNT_FIELD, 1));

exports.countDeletedRequest = functions.firestore
  .document("requests/{requestID}")
  .onDelete(async () => await updateCount(REQUEST_COUNT_FIELD, -1));

// =============================================================================
// Letters
// =============================================================================
const LETTER_COUNT_FIELD = "letterCount";

exports.countNewLetter = functions.firestore
  .document("letters/{letterID}")
  .onCreate(async () => await updateCount(LETTER_COUNT_FIELD, 1));

exports.countDeletedLetter = functions.firestore
  .document("letters/{letterID}")
  .onDelete(async () => await updateCount(LETTER_COUNT_FIELD, -1));

// =============================================================================
// Reactions
// =============================================================================
const REACTION_COUNT_FIELD = "reactionCount";

exports.countNewReaction = functions.firestore
  .document("users/{userID}/reactionInbox/{reactionID}")
  .onCreate(async () => await updateCount(REACTION_COUNT_FIELD, 1));

// =============================================================================
// Reports
// =============================================================================
const REPORT_COUNT_FIELD = "reportCount";

exports.countNewReport = functions.firestore
  .document("reports/{reportID}")
  .onCreate(async () => await updateCount(REPORT_COUNT_FIELD, 1));

exports.countDeletedReport = functions.firestore
  .document("reports/{reportID}")
  .onDelete(async () => await updateCount(REPORT_COUNT_FIELD, -1));

// =============================================================================
// Users
// =============================================================================
const USER_COUNT_FIELD = "userCount";

exports.countNewUser = functions.firestore
  .document("users/{userID}")
  .onCreate(async () => await updateCount(USER_COUNT_FIELD, 1));

exports.countDeletedUser = functions.firestore
  .document("users/{userID}")
  .onDelete(async () => await updateCount(USER_COUNT_FIELD, -1));
