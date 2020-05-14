import React, { useEffect, useState, useRef } from "react";
import "firebase/firestore";

import { firebaseFirestore } from "./firebase";

type ID = string;

export enum ReportContentType {
  REQUEST = "request",
  LETTER = "letter",
}

export enum ReportStatus {
  UNSOLVED = "unsolved",
  SOLVED = "solved",
}

export enum ReportOption {
  SPAM = "spam",
  ABUSE = "abuse",
  CONCERN = "concern",
  PII = "pii",
  OTHER = "other",
}

export interface Report {
  id: ID;
  creationDate: firebase.firestore.Timestamp;
  status: ReportStatus;
  contentID: ID;
  contentCreatorID: ID;
  contentType: ReportContentType;
  contentExcerpt: string;
  reportOption: ReportOption;
  reporterID: ID;
  automatedActionLog?: string[];
}

function ReportTable() {
  const [reports, setReports] = useState<Report[]>([]);

  const reportListener = useRef<Function>();

  useEffect(() => {
    reportListener.current = firebaseFirestore
      .collection("reports")
      .orderBy("creationDate", "desc")
      .limit(50)
      .onSnapshot(_handleSnapshot);

    return () => {
      if (reportListener.current != null) {
        reportListener.current();
      }
    };
  }, []);

  const _handleSnapshot = (
    snapshot: firebase.firestore.QuerySnapshot
  ): void => {
    const docs = snapshot.docs;

    setReports(docs.map((doc) => doc.data() as Report));
  };

  const toggleSolved = async (reportID: ID, solved: boolean) => {
    await firebaseFirestore
      .collection("reports")
      .doc(reportID)
      .update({
        status: solved ? "solved" : "unsolved",
      });
  };

  const unresolvedCount = reports.filter(
    (report) => report.status === "unsolved"
  ).length;

  return (
    <>
      <h1 className="title">
        Reports &nbsp;
        {unresolvedCount > 0 ? (
          <div className="tag is-danger">{unresolvedCount}</div>
        ) : null}
      </h1>
      <p className="subtitle is-6">Ordered by most recent. Limit 50.</p>
      {reports.length ? (
        <>
          <table className="table is-striped is-hoverable">
            <thead>
              <tr>
                <th></th>
                <th>Meta</th>
                <th>Type</th>
                <th>Reason</th>
                <th>Excerpt</th>
                <th>Automations</th>
                <th>Status</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {reports.map((report, index) => (
                <tr key={report.id}>
                  <td className="is-size-7">{index + 1}</td>
                  <td className="is-size-7">
                    <strong>
                      {report.creationDate.toDate().toLocaleDateString()}
                    </strong>
                    <br />
                    <span className="has-text-grey">
                      {report.creationDate.toDate().toLocaleTimeString()}
                    </span>
                    <br />
                    <a
                      href={`<REDACTED>`}
                      target="_blank"
                      rel="noopener noreferrer"
                    >
                      {report.id}
                    </a>
                  </td>
                  <td className="is-size-7">{report.contentType}</td>
                  <td className="is-size-7">{report.reportOption}</td>
                  <td className="is-size-7">
                    {report.contentExcerpt}
                    <br />
                    {report.contentType === "request" ? (
                      <a
                        href={`<REDACTED>`}
                        target="_blank"
                        rel="noopener noreferrer"
                      >
                        {report.contentID}
                      </a>
                    ) : (
                      <a
                        href={`<REDACTED>`}
                        target="_blank"
                        rel="noopener noreferrer"
                      >
                        {report.contentID}
                      </a>
                    )}
                  </td>
                  <td className="is-size-7">
                    {report.automatedActionLog != null
                      ? report.automatedActionLog.join("\n")
                      : "n/a"}
                  </td>
                  <td>
                    {report.status === "solved" ? (
                      <span className="tag is-success">Solved</span>
                    ) : (
                      <span className="tag is-danger">Unsolved</span>
                    )}
                  </td>
                  <td>
                    {report.status === "solved" ? (
                      <button
                        className="button is-small"
                        onClick={() => toggleSolved(report.id, false)}
                      >
                        Mark Unsolved
                      </button>
                    ) : (
                      <button
                        className="button is-small"
                        onClick={() => toggleSolved(report.id, true)}
                      >
                        Mark Solved
                      </button>
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
          <nav className="pagination is-small">
            <button className="pagination-previous" disabled>
              Previous
            </button>
            <button className="pagination-next" disabled>
              Next
            </button>
          </nav>
        </>
      ) : (
        <div>Loading...</div>
      )}
    </>
  );
}

export default ReportTable;
