import * as functions from "firebase-functions";
import { Letter, GentleRequest, Metric } from "./models";
import { firestore } from "firebase-admin";

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

// Calculates and stores various metrics at midnight each day
exports.scheduleMetricsArchive = functions.pubsub
  .schedule("0 0 * * *")
  .timeZone("America/Los_Angeles")
  .onRun(async () => {
    try {
      const admin = await import("firebase-admin");

      if (!isAdminInitialized) {
        admin.initializeApp();
        isAdminInitialized = true;
      }

      const db = admin.firestore();

      const yesterdayMidnight = new Date();
      yesterdayMidnight.setDate(yesterdayMidnight.getDate() - 1);
      yesterdayMidnight.setHours(0, 0, 0, 0);
      const uniqueActors = new Set<string>();

      const yesterdaysLetterDocs = await db
        .collection("letters")
        .where("creationDate", ">=", yesterdayMidnight)
        .get();
      yesterdaysLetterDocs.forEach((doc) => {
        if (!doc.exists) return;
        const letter = doc.data() as Letter;
        uniqueActors.add(letter.letterSenderID);
      });

      const yesterdaysRequestDocs = await db
        .collection("requests")
        .where("creationDate", ">=", yesterdayMidnight)
        .get();
      yesterdaysRequestDocs.forEach((doc) => {
        if (!doc.exists) return;
        const request = doc.data() as GentleRequest;
        uniqueActors.add(request.requesterID);
      });

      const thirtyDaysAgo = new Date();
      thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
      thirtyDaysAgo.setHours(0, 0, 0, 0);

      const last30MetricDocs = await db
        .collection("metrics")
        .where("creationDate", ">=", thirtyDaysAgo)
        .limit(30)
        .get();

      const monthlyUniqueActors = new Set<string>(uniqueActors);

      last30MetricDocs.forEach((doc) => {
        if (!doc.exists) return;
        const metric = doc.data() as Metric;
        metric.dailyActiveUserIDs.forEach((user) =>
          monthlyUniqueActors.add(user)
        );
      });

      const archiveDocName = `metrics-${formatDate(
        Date.parse(yesterdayMidnight.toUTCString())
      )}`;

      const todayMidnight = new Date();
      todayMidnight.setHours(0, 0, 0, 0);

      const metricData: Metric = {
        creationDate: firestore.Timestamp.now(),
        dailyActiveUserIDs: Array.from(uniqueActors),
        monthlyActiveUserIDs: Array.from(monthlyUniqueActors),
        dau: uniqueActors.size,
        mau: monthlyUniqueActors.size,
      };

      await db.collection("metrics").doc(archiveDocName).create(metricData);
    } catch (error) {
      console.error(
        `[Daily Metrics Archive] Failed to run metrics archive: ${error}`
      );
    }
  });
