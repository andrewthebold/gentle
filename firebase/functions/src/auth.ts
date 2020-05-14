import * as functions from "firebase-functions";
import { firestore } from "firebase-admin";
import { PATHS, User, Letter, AvatarName, InboxItem } from "./models";
import { CONSTANTS } from "./constants";

/*
 * setupUserAccount()
 *
 * Creates a user in Firestore when a new Firebase auth user is created.
 *
 * firebase deploy --only functions:auth.setupUserAccount
 */
let isSetupUserAccountInitialized = false;

exports.setupUserAccount = functions.auth.user().onCreate(async (user) => {
  const admin = await import("firebase-admin");

  if (!isSetupUserAccountInitialized) {
    admin.initializeApp();
    isSetupUserAccountInitialized = true;
  }

  const db = admin.firestore();
  const batch = db.batch();

  // Create the new user in Firestore
  const userRef = db.collection(PATHS.USERS_COLLECTION).doc(user.uid);
  const userData: User = {
    id: userRef.id,
    joinDate: firestore.Timestamp.fromDate(
      new Date(user.metadata.creationTime)
    ),
    completedRequests: [],
    blockedUsers: [],
    hiddenRequests: [],
    hiddenLetters: [],
  };
  batch.set(userRef, userData);

  // Create a tutorial mail item for the user
  const introMailRef = db.collection(PATHS.LETTERS_COLLECTION).doc();
  const introMailData: Letter = {
    id: introMailRef.id,
    published: true,
    creationDate: firestore.Timestamp.now(),
    // NOTE: This letter does not have a request attached to it
    // requestID: null,
    // requestMessage: null,
    // requestCreatorID: null,
    // requestCreatorAvatar: null,
    letterSenderID: CONSTANTS.ADMIN_ID,
    letterSenderAvatar: AvatarName.GENTLE,
    letterMessage: `This is a cozy welcome from Andrew, the creator of this app. I hope you’re doing well.

I think people have such a capacity for kindness. It's the most breathtaking thing when you see someone be kind when they have every right to be mad. I made Gentle because I want to see more of that in our world.
  
Don't always feel like you need to solve someone's problems here — sometimes, it's all about sharing that you've listened to them and that you care.`,
    recipientID: user.uid,
  };
  batch.set(introMailRef, introMailData);

  const introMailInboxItemRef = userRef
    .collection(PATHS.USERS_COLLECTION_INBOX_SUBCOLLECTION)
    .doc();
  const introMailInboxItemData: InboxItem = {
    id: introMailInboxItemRef.id,
    creationDate: firestore.Timestamp.now(),
    linkedContentID: introMailRef.id,
    linkedContentCreatorID: CONSTANTS.ADMIN_ID,
    linkedContentAvatar: AvatarName.GENTLE,
    linkedContentExcerpt: "This is a cozy welcome from Andrew, the creator of",
  };
  batch.set(introMailInboxItemRef, introMailInboxItemData);

  await batch.commit();
});

/*
 * deleteUser()
 *
 * Deletes all user-owned data when a user deletes their Firebase Auth account.
 *
 * Sources:
 * - https://github.com/firebase/extensions/tree/master/delete-user-data
 * - https://firebase.google.com/docs/firestore/solutions/delete-collections
 */
exports.deleteUser = functions
  .runWith({
    timeoutSeconds: 540,
    memory: "1GB",
  })
  .auth.user()
  .onDelete(async (user) => {
    const firebaseTools = await import("firebase-tools");

    const { uid } = user;

    // Note: Paths should be highest-level possible as deletion is recursive
    // 1. Delete the user
    const pathsToDeleteRecursively = [`users/${uid}`];

    const admin = await import("firebase-admin");
    if (!isSetupUserAccountInitialized) {
      admin.initializeApp();
      isSetupUserAccountInitialized = true;
    }
    const db = admin.firestore();

    // 2. Delete requests that were created by this user
    const requests = await db
      .collection("requests")
      .where("requesterID", "==", uid)
      .get();
    pathsToDeleteRecursively.push(
      ...requests.docs.map((doc) => `requests/${doc.id}`)
    );

    // 3. Delete letters that were sent to this user
    const letters = await db
      .collection("letters")
      .where("recipientID", "==", uid)
      .get();
    pathsToDeleteRecursively.push(
      ...letters.docs.map((doc) => `letters/${doc.id}`)
    );

    const promises = pathsToDeleteRecursively.map(async (pathToDelete) => {
      try {
        await firebaseTools.firestore.delete(pathToDelete, {
          project: process.env.GCLOUD_PROJECT,
          recursive: true,
          yes: true,
        });
      } catch (err) {
        console.error(
          `Error when deleting: '${pathToDelete}' from Cloud Firestore`,
          err
        );
      }
    });

    await Promise.all(promises);
  });
