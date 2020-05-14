import * as functions from "firebase-functions";
import { DocumentSnapshot } from "firebase-functions/lib/providers/firestore";
import { GentleRequest, PATHS, User } from "./models";
import { dangerousValidateRequest } from "./validators/requestValidation";

let isAdminInitialized = false;

// firebase deploy --only functions:request.handleNewRequest
exports.handleNewRequest = functions.firestore
  .document("requests/{requestID}")
  .onCreate(async (snapshot: DocumentSnapshot) => {
    const admin = await import("firebase-admin");

    const newRequest = snapshot.data() as GentleRequest;
    const requestID = snapshot.id;

    if (newRequest == null) {
      console.error(
        `[Request ID ${requestID}] newRequest received from server is null. Given snapshot: ${snapshot}`
      );
      return;
    }

    try {
      // Setup firestore admin
      if (!isAdminInitialized) {
        admin.initializeApp();
        isAdminInitialized = true;
      }

      const db = admin.firestore();

      const requestingUserDoc = await db
        .collection(PATHS.USERS_COLLECTION)
        .doc(newRequest.requesterID)
        .get();
      const requestingUser = (requestingUserDoc.data() as User) ?? null;

      const validationFailures = await dangerousValidateRequest(
        newRequest,
        requestingUser,
        db
      );
      if (validationFailures.length) {
        await snapshot.ref.update({
          validationFailures: validationFailures,
        });
        return;
      }

      // Publish the request
      await snapshot.ref.update({
        published: true,
      });
    } catch (error) {
      console.error(
        `[Request ID ${requestID}] Failed to publish request: ${error}`
      );
    }
  });
