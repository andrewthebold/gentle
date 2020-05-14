import * as functions from "firebase-functions";
import { DocumentSnapshot } from "firebase-functions/lib/providers/firestore";
import {
  Letter,
  InboxItem,
  PATHS,
  User,
  GentleRequest,
  NotificationType,
  getStringFromAvatar,
  getEmojiFromAvatar,
} from "./models";
import { firestore, messaging } from "firebase-admin";
import { CONSTANTS } from "./constants";
import { dangerousValidateLetter } from "./validators/letterValidation";

let isAdminInitialized = false;

exports.handleNewLetter = functions.firestore
  .document("letters/{letterID}")
  .onCreate(async (snapshot: DocumentSnapshot) => {
    const newLetter = snapshot.data() as Letter;
    const letterID = snapshot.id;

    if (newLetter == null) {
      console.error(
        `[Letter: ${letterID}] newLetter received from server is null. Given snapshot:`,
        snapshot
      );
      return;
    }

    // Do no extra processing for admin letters (should be done manually)
    if (newLetter.letterSenderID === CONSTANTS.ADMIN_ID) {
      return;
    }

    try {
      const admin = await import("firebase-admin");
      if (!isAdminInitialized) {
        admin.initializeApp();
        isAdminInitialized = true;
      }
      const db = admin.firestore();

      const sendingUserDoc = await db
        .collection(PATHS.USERS_COLLECTION)
        .doc(newLetter.letterSenderID)
        .get();
      const sendingUser = (sendingUserDoc.data() as User) ?? null;
      const receivingUserDoc = await db
        .collection(PATHS.USERS_COLLECTION)
        .doc(newLetter.recipientID)
        .get();
      const receivingUser = (receivingUserDoc.data() as User) ?? null;
      let request = null;
      if (newLetter.requestID != null) {
        const requestDoc = await db
          .collection(PATHS.REQUESTS_COLLECTION)
          .doc(newLetter.requestID)
          .get();
        request = requestDoc.data() as GentleRequest;
      }

      // On validation failures, do not publish and update doc with failures
      const validationFailures = await dangerousValidateLetter(
        newLetter,
        db,
        sendingUser,
        receivingUser,
        request
      );
      if (validationFailures.length) {
        await snapshot.ref.update({
          validationFailures: validationFailures,
        });
        return;
      }

      const batch = db.batch();

      // Create new inbox item for recipient
      const newInboxItemDoc = db
        .collection(PATHS.USERS_COLLECTION)
        .doc(newLetter.recipientID)
        .collection(PATHS.USERS_COLLECTION_INBOX_SUBCOLLECTION)
        .doc();

      const newInboxItemData: InboxItem = {
        id: newInboxItemDoc.id,
        creationDate: firestore.FieldValue.serverTimestamp(),
        linkedContentID: snapshot.id,
        linkedContentCreatorID: newLetter.letterSenderID,
        linkedContentAvatar: newLetter.letterSenderAvatar,
        linkedContentExcerpt: newLetter.letterMessage.slice(0, 50),
      };

      batch.create(newInboxItemDoc, newInboxItemData);

      // Update the response count to demote the request's priority
      if (newLetter.requestID != null) {
        const requestDoc = await db
          .collection(PATHS.REQUESTS_COLLECTION)
          .doc(newLetter.requestID)
          .get();

        if (requestDoc.exists) {
          batch.update(requestDoc.ref, {
            responseCount: firestore.FieldValue.increment(1),
          });
        }
      }

      // Publish the letter
      batch.update(snapshot.ref, {
        published: true,
      });

      await batch.commit();

      // Send notification
      if (
        receivingUser.notifications != null &&
        receivingUser.notifications.token != null &&
        receivingUser.notifications.type === NotificationType.all
      ) {
        const payload: messaging.Message = {
          notification: {
            title: `Message from a ${getStringFromAvatar(
              newLetter.letterSenderAvatar
            )} ${getEmojiFromAvatar(newLetter.letterSenderAvatar)}`,
            body: "You got a kind reply to your request!",
          },
          token: receivingUser.notifications.token,
        };

        await admin.messaging().send(payload);
      }
    } catch (error) {
      console.error(`[Letter: ${letterID}] Failed to publish letter: ${error}`);
    }
  });
