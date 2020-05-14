import React, { useEffect, useState, useRef } from "react";
import "firebase/firestore";

import { firebaseFirestore } from "./firebase";
import firebase from "firebase";
import { Letter, InboxItem } from "./models";

function LettersTable() {
  const [letters, setLetters] = useState<Letter[]>([]);

  const lettersListener = useRef<Function>();

  useEffect(() => {
    lettersListener.current = firebaseFirestore
      .collection("letters")
      .where("published", "==", false)
      .orderBy("creationDate", "desc")
      .limit(50)
      .onSnapshot(_handleSnapshot);

    return () => {
      if (lettersListener.current != null) {
        lettersListener.current();
      }
    };
  }, []);

  const _handleSnapshot = (
    snapshot: firebase.firestore.QuerySnapshot
  ): void => {
    const docs = snapshot.docs;

    setLetters(docs.map((doc) => doc.data() as Letter));
  };

  const forcePublish = async (letter: Letter) => {
    if (letter.published) {
      return;
    }

    if (!window.confirm("Are you sure you want to publish this?")) {
      return;
    }

    if (!window.confirm("Are you REAAALLY sure you want to publish this?")) {
      return;
    }

    const batch = firebaseFirestore.batch();

    const letterDoc = firebaseFirestore.collection("letters").doc(letter.id);
    batch.update(letterDoc, {
      published: true,
    });

    const inboxItemDoc = firebaseFirestore
      .collection("users")
      .doc(letter.recipientID)
      .collection("inbox")
      .doc();
    const inboxItemData: InboxItem = {
      id: inboxItemDoc.id,
      creationDate: firebase.firestore.Timestamp.now(),
      linkedContentID: letter.id,
      linkedContentCreatorID: letter.letterSenderID,
      linkedContentAvatar: letter.letterSenderAvatar,
      linkedContentExcerpt: letter.letterMessage.slice(0, 50),
    };
    batch.set(inboxItemDoc, inboxItemData);

    await batch.commit();
  };

  return (
    <>
      <h1 className="title">Unpublished Letters</h1>
      <p className="subtitle is-6">Ordered by most recent. Limit 50.</p>
      {letters.length ? (
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
              {letters.map((letter, index) => (
                <tr key={letter.id}>
                  <td className="is-size-7">{index + 1}</td>
                  <td className="is-size-7">
                    <strong>
                      {letter.creationDate.toDate().toLocaleDateString()}
                    </strong>
                    <br />
                    <span className="has-text-grey">
                      {letter.creationDate.toDate().toLocaleTimeString()}
                    </span>
                    <br />
                    <a
                      href={`<REDACTED>`}
                      target="_blank"
                      rel="noopener noreferrer"
                    >
                      {letter.id}
                    </a>
                  </td>
                  <td className="is-size-7">
                    {letter.requestMessage}
                    <br />
                    <br />
                    <strong>{letter.letterMessage}</strong>
                  </td>
                  <td>
                    {letter.publishFailures != null ? (
                      <ol className="content is-small" type="1">
                        {letter.publishFailures.map((failure, index) => (
                          <li key={index}>{failure}</li>
                        ))}
                      </ol>
                    ) : (
                      "n/a"
                    )}
                  </td>
                  <td>
                    {letter.published ? (
                      <span className="tag is-warning">Published</span>
                    ) : (
                      <span className="tag">Unpublished</span>
                    )}{" "}
                  </td>
                  <td>
                    {letter.published ? (
                      <>n/a</>
                    ) : (
                      <button
                        className="button is-small is-danger"
                        onClick={() => forcePublish(letter)}
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

export default LettersTable;
