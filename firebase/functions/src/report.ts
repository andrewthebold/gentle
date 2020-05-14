import * as functions from "firebase-functions";
import { DocumentSnapshot } from "firebase-functions/lib/providers/firestore";
import {
  Report,
  ReportContentType,
  ReportOption,
  PATHS,
  GentleRequest,
} from "./models";

let isAdminInitialized = false;

exports.handleNewReport = functions.firestore
  .document("reports/{reportID}")
  .onCreate(async (snapshot: DocumentSnapshot) => {
    const newReport = snapshot.data() as Report;
    const reportID = snapshot.id;

    if (newReport == null) {
      console.error(
        `[Report ID ${reportID}] newReport received from server is null. Given snapshot: ${snapshot}`
      );
      return;
    }

    // Setup firestore admin
    const admin = await import("firebase-admin");
    if (!isAdminInitialized) {
      admin.initializeApp();
      isAdminInitialized = true;
    }

    // We do nothing if the reported content is a letter
    // because it's a 1:1 interaction. The report should be handled
    // by a moderator.
    if (newReport.contentType == ReportContentType.LETTER) {
      return;
    }

    try {
      const db = admin.firestore();
      const relatedReportDocs = await db
        .collection(PATHS.REPORTS_COLLECTION)
        .where("contentID", "==", newReport.contentID)
        .get();
      const relatedReports = relatedReportDocs.docs.map(
        (report) => report.data() as Report
      );

      const requestDoc = await db
        .collection(PATHS.REQUESTS_COLLECTION)
        .doc(newReport.contentID)
        .get();
      const request = requestDoc.data() as GentleRequest;

      const batch = db.batch();
      const automatedActionLog: string[] = [];

      switch (newReport.reportOption) {
        // SPAM: Unpublish if there's been 2 or more spam reports
        case ReportOption.SPAM: {
          const relatedSpamReports = relatedReports.filter(
            (report) => report.reportOption == ReportOption.SPAM
          );
          if (request.published && relatedSpamReports.length >= 2) {
            batch.update(requestDoc.ref, {
              published: false,
            });
            automatedActionLog.push(
              "Unpublished request due to 2+ SPAM reports"
            );
          }
          break;
        }
        // ABUSE: Unpublish immediately
        case ReportOption.ABUSE: {
          if (request.published) {
            batch.update(requestDoc.ref, {
              published: false,
            });
            automatedActionLog.push("Unpublished request due to ABUSE");
          }
          break;
        }
        // CONCERN: Unpublish if there's been 2 or more concern reports
        case ReportOption.CONCERN: {
          const relatedConcernReports = relatedReports.filter(
            (report) => report.reportOption == ReportOption.CONCERN
          );
          if (request.published && relatedConcernReports.length >= 2) {
            batch.update(requestDoc.ref, {
              published: false,
            });
            automatedActionLog.push(
              "Unpublished request due to 2+ CONCERN reports"
            );
          }
          break;
        }
        // PII: Unpublish immediately
        case ReportOption.PII: {
          if (request.published) {
            batch.update(requestDoc.ref, {
              published: false,
            });
            automatedActionLog.push("Unpublished request due to PII");
          }
          break;
        }
        // OTHER: Unpublish if there's been 2 or more other reports
        case ReportOption.OTHER: {
          const relatedOtherReports = relatedReports.filter(
            (report) => report.reportOption == ReportOption.OTHER
          );
          if (request.published && relatedOtherReports.length >= 2) {
            batch.update(requestDoc.ref, {
              published: false,
            });
            automatedActionLog.push(
              "Unpublished request due to 2+ OTHER reports"
            );
          }
          break;
        }
      }

      if (automatedActionLog.length > 0) {
        batch.update(snapshot.ref, {
          automatedActionLog: automatedActionLog,
        });

        await batch.commit();
      }
    } catch (error) {
      console.error(
        `[Report ID ${reportID}] Failed to process report: ${error}`
      );
    }
  });
