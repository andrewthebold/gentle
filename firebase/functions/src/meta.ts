import * as functions from "firebase-functions";
import { MetaArchive } from "./models";

let isAdminInitialized = false;

function formatDate(date: number): string {
  const d = new Date(date),
    year = d.getFullYear();

  let month = "" + (d.getMonth() + 1),
    day = "" + d.getDate();

  if (month.length < 2) month = "0" + month;
  if (day.length < 2) day = "0" + day;

  return [year, month, day].join("-");
}

// Creates a copy of the `meta` doc every day at midnight.
exports.scheduleArchiveMeta = functions.pubsub
  .schedule("0 0 * * *")
  .timeZone("America/Los_Angeles")
  .onRun(async (context: functions.EventContext) => {
    try {
      const admin = await import("firebase-admin");

      if (!isAdminInitialized) {
        admin.initializeApp();
        isAdminInitialized = true;
      }

      const db = admin.firestore();

      const metaDoc = await db.collection("meta").doc("meta").get();
      const meta = metaDoc.data() as MetaArchive;

      const archiveDocName = `meta-${formatDate(
        Date.parse(context.timestamp)
      )}`;

      await db.collection("meta").doc(archiveDocName).create(meta);
    } catch (error) {
      console.error(`[Daily Meta Archive] Failed to run meta backup: ${error}`);
    }
  });
