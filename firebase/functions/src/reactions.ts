import * as functions from "firebase-functions";
import {
  Letter,
  PATHS,
  ActivityLogItemReactionPayload,
  ReactionInboxItem,
} from "./models";

let isAdminInitialized = false;

// =============================================================================
// Handles a reaction added to a letter.
//
// - Updates related activity log items to include the reaction.
// - Creates a new reaction inbox item for the letter sender.
// =============================================================================
exports.handleLetterReactionUpdate = functions.firestore
  .document("letters/{letterID}")
  .onUpdate(async (change) => {
    const oldLetter = change.before.data() as Letter;
    const newLetter = change.after.data() as Letter;
    const letterID = oldLetter.id;

    // Do nothing if the letter doesn't exist
    if (!change.before.exists || !change.after.exists) {
      return;
    }

    // Do nothing if the original letter already has a reaction
    if (oldLetter.reactionType != null || oldLetter.reactionTime != null) {
      return;
    }

    // Do nothing if the new letter has no reaction
    if (newLetter.reactionType == null || newLetter.reactionTime == null) {
      return;
    }

    try {
      const admin = await import("firebase-admin");

      if (!isAdminInitialized) {
        admin.initializeApp();
        isAdminInitialized = true;
      }
      const db = admin.firestore();
      const batch = db.batch();

      // TODO: Add check to limit the # of reactions possible (with some leeway due to time zone contraints)

      // Find and update connected activity log items
      const reactionPayload: ActivityLogItemReactionPayload = {
        reactionType: newLetter.reactionType,
      };

      const recipientUID = oldLetter.recipientID;
      const recipientActivityLogItems = await db
        .collection(PATHS.USERS_COLLECTION)
        .doc(recipientUID)
        .collection(PATHS.USERS_COLLECTION_ACTIVITY_LOG_SUBCOLLECTION)
        .where("linkedContentID", "==", letterID)
        .get();
      if (recipientActivityLogItems.size > 1) {
        console.warn(
          `[Reaction: ${letterID}] User ${recipientUID} unexpectedly had more than one activity log item linked to a single item.`
        );
      }

      recipientActivityLogItems.forEach((doc) => {
        batch.update(doc.ref, reactionPayload);
      });

      const senderUID = oldLetter.letterSenderID;
      const senderActivityLogItems = await db
        .collection(PATHS.USERS_COLLECTION)
        .doc(senderUID)
        .collection(PATHS.USERS_COLLECTION_ACTIVITY_LOG_SUBCOLLECTION)
        .where("linkedContentID", "==", letterID)
        .get();
      if (senderActivityLogItems.size > 1) {
        console.warn(
          `[Reaction: ${letterID}] User ${senderUID} unexpectedly had more than one activity log item linked to a single item.`
        );
      }

      senderActivityLogItems.forEach((doc) => {
        batch.update(doc.ref, reactionPayload);
      });

      // Create a new reaction inbox item for the sender
      const reactionInboxItemDoc = db
        .collection(PATHS.USERS_COLLECTION)
        .doc(senderUID)
        .collection(PATHS.USERS_COLLECTION_REACTION_INBOX_SUBCOLLECTION)
        .doc();
      const reactionInboxItemData: ReactionInboxItem = {
        id: reactionInboxItemDoc.id,
        creationDate: newLetter.reactionTime,
        type: newLetter.reactionType,
        linkedContentID: letterID,
      };
      batch.set(reactionInboxItemDoc, reactionInboxItemData);

      await batch.commit();
    } catch (error) {
      console.error(
        `[Reaction: ${letterID}] Failed to do letter reaction post-processing: ${error}`
      );
    }
  });
