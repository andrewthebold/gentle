import * as functions from "firebase-functions";
import {
  PATHS,
  User,
  AvatarName,
  InboxItem,
  ReactionInboxItem,
  getStringFromAvatar,
  getEmojiFromAvatar,
} from "./models";
import * as moment from "moment-timezone";
import { messaging } from "firebase-admin";

const NOTIFICATION_BATCH_SIZE = 500;

let isAdminInitialized = false;

function filterUser(user: User): boolean {
  const lastActive = user.lastActive;
  if (lastActive == null) {
    console.warn(
      `User ${user.id} with daily notifications scheduled has invalid lastActive when filtering users: ${lastActive}. Ignoring user.`
    );
    return false;
  }

  const token = user.notifications?.token;
  if (token == null || typeof token !== "string") {
    console.warn(
      `User ${user.id} with daily notifications scheduled has invalid token when filtering users: ${token}. Ignoring user.`
    );
    return false;
  }

  const dailyTime = moment.tz(
    user.notifications?.dailyTime,
    "America/Los_Angeles"
  );
  if (dailyTime == null || !dailyTime.isValid()) {
    console.warn(
      `User ${user.id} with daily notifications scheduled has invalid dailyTime: ${user.notifications?.dailyTime}. Ignoring user.`
    );
    return false;
  }

  if (dailyTime.minutes() != 0) {
    console.warn(
      `User ${user.id} with daily notifications scheduled has non-0 minutes: ${user.notifications?.dailyTime}. Continuing anyway.`
    );
  }

  const thisHour = moment().startOf("hour"); // Ideally equivalent to the exact hour this scheduled fn is called (e.g., "2020/4/5 12AM", "2020/4/6 6PM")
  const nextHour = thisHour.clone().add(1, "hour");

  // We only care about the hour/min/sec of the timestamp, so let's modify it to match the start of the hour's
  dailyTime.dayOfYear(thisHour.dayOfYear());
  dailyTime.year(thisHour.year());

  if (
    (dailyTime.isSame(thisHour) || dailyTime.isAfter(thisHour)) &&
    dailyTime.isBefore(nextHour)
  ) {
    return true;
  }

  return false;
}

async function createNotification(
  user: User,
  db: FirebaseFirestore.Firestore
): Promise<messaging.Message | null> {
  const lastActive = user.lastActive?.toDate();
  if (lastActive == null) {
    console.warn(
      `User ${user.id} with daily notifications scheduled has invalid lastActive when generating notification: ${lastActive}. Ignoring user.`
    );
    return null;
  }

  const relevantInboxItemDocs = await db
    .collection(PATHS.USERS_COLLECTION)
    .doc(user.id)
    .collection(PATHS.USERS_COLLECTION_INBOX_SUBCOLLECTION)
    .orderBy("creationDate")
    .where("creationDate", ">", lastActive)
    .get();

  const relevantReactionInboxItemDocs = await db
    .collection(PATHS.USERS_COLLECTION)
    .doc(user.id)
    .collection(PATHS.USERS_COLLECTION_REACTION_INBOX_SUBCOLLECTION)
    .orderBy("creationDate")
    .where("creationDate", ">", lastActive)
    .get();

  if (
    relevantInboxItemDocs.size <= 0 &&
    relevantReactionInboxItemDocs.size <= 0
  ) {
    // Nothing relevant, so ignore the user
    return null;
  }

  const relevantInboxItems = relevantInboxItemDocs.docs.map(
    (item) => item.data() as InboxItem
  );
  const relevantReactionInboxItems = relevantReactionInboxItemDocs.docs.map(
    (item) => item.data() as ReactionInboxItem
  );

  const avatarSet = new Set<AvatarName>();
  relevantInboxItems.forEach((item) => {
    if (item.linkedContentAvatar == null) {
      return;
    }
    avatarSet.add(item.linkedContentAvatar);
  });
  relevantReactionInboxItems.forEach((item) => {
    if (item.linkedContentAvatar == null) {
      return;
    }
    avatarSet.add(item.linkedContentAvatar);
  });

  const avatars = [...avatarSet];
  if (avatars.length <= 0) {
    console.error(
      `User ${user.id} with daily notifications scheduled unexpectedly has no avatars linked to content. Ignoring user.`
    );
    return null;
  }

  let header = "";
  // 1:  "Ice cream 🍦"
  if (avatars.length === 1) {
    const avatar = avatars[0];
    header = `${getStringFromAvatar(avatar)} ${getEmojiFromAvatar(avatar)}`;
  } else if (avatars.length === 2) {
    // 2:  "Ice cream and Pizza 🍦🍕"
    const avatar1 = avatars[0];
    const avatar2 = avatars[1];
    header = `${getStringFromAvatar(avatar1)} and ${getStringFromAvatar(
      avatar2
    )} ${getEmojiFromAvatar(avatar1)}${getEmojiFromAvatar(avatar2)}`;
  } else if (avatars.length === 3) {
    // 3:  "Ice cream, Pizza, and Cat 🍦🍕😸"
    const avatar1 = avatars[0];
    const avatar2 = avatars[1];
    const avatar3 = avatars[2];
    header = `${getStringFromAvatar(avatar1)}, ${getStringFromAvatar(
      avatar2
    )}, and ${getStringFromAvatar(avatar3)} ${getEmojiFromAvatar(
      avatar1
    )}${getEmojiFromAvatar(avatar2)}${getEmojiFromAvatar(avatar3)}`;
  } else if (avatars.length > 3) {
    // 4+: "Ice cream, Pizza, and 2 more 🍦🍕"
    const avatar1 = avatars[0];
    const avatar2 = avatars[1];
    const remainingCount = avatars.length - 2;
    header = `${getStringFromAvatar(avatar1)}, ${getStringFromAvatar(
      avatar2
    )}, and ${remainingCount} more ${getEmojiFromAvatar(
      avatar1
    )}${getEmojiFromAvatar(avatar2)}`;
  }

  if (!header.length) {
    console.error(
      `User ${user.id} with daily notifications scheduled failed to have notification header created with avatars length of ${avatars.length}. Ignoring user.`
    );
    return null;
  }

  let body = "";

  if (relevantInboxItems.length === 1 && !relevantReactionInboxItems.length) {
    body = "Today, you got a kind message!";
  } else if (
    relevantInboxItems.length > 1 &&
    !relevantReactionInboxItems.length
  ) {
    body = "Today, you got kind messages!";
  } else if (
    relevantInboxItems.length === 1 &&
    relevantReactionInboxItems.length === 1
  ) {
    body = "Today, you got a kind message and a reaction!";
  } else if (
    relevantInboxItems.length > 1 &&
    relevantReactionInboxItems.length === 1
  ) {
    body = "Today, you got kind messages and a reaction!";
  } else if (
    relevantInboxItems.length > 1 &&
    relevantReactionInboxItems.length > 1
  ) {
    body = "Today, you got kind messages and reactions!";
  } else if (
    !relevantInboxItems.length &&
    relevantReactionInboxItems.length === 1
  ) {
    body = "Today, you got a reaction to what you wrote!";
  } else if (
    !relevantInboxItems.length &&
    relevantReactionInboxItems.length > 1
  ) {
    body = "Today, you got reactions to what you wrote!";
  }

  if (!body.length) {
    console.error(
      `User ${user.id} with daily notifications scheduled failed to have notification body created with inboxItems length of ${relevantInboxItems.length} and reactionInboxItems length of ${relevantReactionInboxItems.length}. Ignoring user.`
    );
  }

  const token = user.notifications?.token;
  if (token == null || typeof token !== "string") {
    console.error(
      `User ${user.id} with daily notifications scheduled has invalid token when generating notification: ${token}. Ignoring user.`
    );
    return null;
  }

  return {
    notification: {
      title: header,
      body: body,
    },
    token: token,
  };
}

exports.scheduleDailyNotification = functions.pubsub
  .schedule("0 * * * *") // Every hour
  .timeZone("America/Los_Angeles")
  .onRun(async () => {
    try {
      const admin = await import("firebase-admin");

      if (!isAdminInitialized) {
        admin.initializeApp();
        isAdminInitialized = true;
      }

      const db = admin.firestore();

      // NOTE: In the future, we may want to add a check for lastActive (1 month?)
      // to reduce unnecessary notification sends.
      const userDocs = await db
        .collection(PATHS.USERS_COLLECTION)
        .where("notifications.type", "==", "daily")
        .get();

      const users = userDocs.docs.map((doc) => doc.data() as User);

      // We want users who have notifications enabled for anytime from this hour
      // to the next hour (exclusive).
      const filteredUsers = users.filter((user) => filterUser(user));

      if (!filteredUsers.length) {
        console.log(
          "There were no users with daily notifications to send. Skipping this hour."
        );
        return;
      }

      // Batch notifications into groups of 500
      console.log(
        `Preparing daily notifications for ${filteredUsers.length} users.`
      );

      // NOTE: We could improve performance by doing a rate-limited Promise.all()
      const notifications: messaging.Message[] = [];

      filteredUsers.forEach(async (user) => {
        const notification = await createNotification(user, db);
        if (notification != null) {
          notifications.push(notification);
        }
      });

      const notificationBatches: messaging.Message[][] = [];
      for (let i = 0; i < notifications.length; i += NOTIFICATION_BATCH_SIZE) {
        notificationBatches.push(
          notifications.slice(i, i + NOTIFICATION_BATCH_SIZE)
        );
      }

      notificationBatches.forEach(async (batch, batchIndex) => {
        const result = await admin.messaging().sendAll(batch);

        console.log(
          `Batch ${batchIndex}: Successfully sent ${result.successCount} notifications`
        );
        if (result.failureCount > 0) {
          console.error(
            `Batch ${batchIndex}: Failed to send ${result.failureCount} notifications`
          );

          // Aggregate errors and log them (could potentially be noisy, so max 10 messages per batch)
          const errors = result.responses
            .filter((response) => !response.success)
            .map((response) => response.error)
            .filter((error) => error != null);
          let errorStrings = [
            ...new Set(
              errors.map((error) => `${error?.code} ${error?.message}`)
            ),
          ];
          if (errorStrings.length > 10) {
            errorStrings = errorStrings.slice(0, 10);
          }
          errorStrings.forEach((errorString) => console.error(errorString));
        }
      });
    } catch (error) {
      console.error(`[Daily Notification Sender] ${error}`);
    }
  });
