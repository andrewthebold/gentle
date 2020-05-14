import React, { useEffect, useState, useRef } from "react";
import "firebase/firestore";

import { firebaseFirestore } from "./firebase";

type ID = string;

export interface GentleRequest {
  id: ID;
  published: boolean;
  creationDate: firebase.firestore.Timestamp;
  responseCount: number;

  requesterID: ID;

  requestMessage: string;

  publishFailures?: string[];
}

function RecentRequestTable() {
  const [requests, setReports] = useState<GentleRequest[]>([]);

  const requestsListener = useRef<Function>();

  useEffect(() => {
    requestsListener.current = firebaseFirestore
      .collection("requests")
      .orderBy("creationDate", "desc")
      .limit(50)
      .onSnapshot(_handleSnapshot);

    return () => {
      if (requestsListener.current != null) {
        requestsListener.current();
      }
    };
  }, []);

  const _handleSnapshot = (
    snapshot: firebase.firestore.QuerySnapshot
  ): void => {
    const docs = snapshot.docs;

    setReports(docs.map((doc) => doc.data() as GentleRequest));
  };

  const togglePublished = async (requestID: ID, published: boolean) => {
    if (
      published &&
      !window.confirm("Are you sure you want to publish this?")
    ) {
      return;
    }

    await firebaseFirestore.collection("requests").doc(requestID).update({
      published: published,
    });
  };

  return (
    <>
      <h1 className="title">Recent Requests</h1>
      <p className="subtitle is-6">Ordered by most recent. Limit 20.</p>
      {requests.length ? (
        <>
          <table className="table is-striped is-hoverable is-fullwidth">
            <thead>
              <tr>
                <th></th>
                <th>Meta</th>
                <th>Message</th>
                <th>Failures</th>
                <th>Status</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {requests.map((request, index) => (
                <tr key={request.id}>
                  <td className="is-size-7">{index + 1}</td>
                  <td className="is-size-7">
                    <strong>
                      {request.creationDate.toDate().toLocaleDateString()}
                    </strong>
                    <br />
                    <span className="has-text-grey">
                      {request.creationDate.toDate().toLocaleTimeString()}
                    </span>
                    <br />
                    <a
                      href={`<REDACTED>`}
                      target="_blank"
                      rel="noopener noreferrer"
                    >
                      {request.id}
                    </a>
                  </td>
                  <td className="is-size-7">
                    <strong>{request.requestMessage}</strong>
                  </td>
                  <td>
                    {request.publishFailures != null ? (
                      <ol className="content is-small" type="1">
                        {request.publishFailures.map((failure, index) => (
                          <li key={index}>{failure}</li>
                        ))}
                      </ol>
                    ) : (
                      "n/a"
                    )}
                  </td>
                  <td>
                    {request.published ? (
                      <span className="tag is-warning">Published</span>
                    ) : (
                      <span className="tag">Unpublished</span>
                    )}{" "}
                  </td>
                  <td>
                    {request.published ? (
                      <button
                        className="button is-small"
                        onClick={() => togglePublished(request.id, false)}
                      >
                        Unpublish
                      </button>
                    ) : (
                      <button
                        className="button is-small is-danger"
                        onClick={() => togglePublished(request.id, true)}
                      >
                        Publish
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

export default RecentRequestTable;
