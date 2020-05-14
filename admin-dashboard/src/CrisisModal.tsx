import React, { useState } from "react";
import { firebaseFirestore } from "./firebase";
import { Letter, AvatarName, InboxItem } from "./models";
import firebase from "firebase";

interface Props {
  isActive: boolean;
  closeModal: () => void;
}

const DEFAULT_MESSAGE = `<REDACTED>`;

const CrisisModal = (props: Props) => {
  const [recipientID, setRecipientID] = useState("");
  const [crisisMessage, setCrisisMessage] = useState(DEFAULT_MESSAGE);

  const _closeModal = () => {
    setRecipientID("");
    setCrisisMessage(DEFAULT_MESSAGE);
    props.closeModal();
  };

  const _sendCrisisLetter = async () => {
    if (recipientID.length <= 0 || crisisMessage.length <= 0) {
      return;
    }

    if (!window.confirm("Are you sure you want to send this?")) {
      return;
    }

    try {
      const batch = firebaseFirestore.batch();

      const crisisLetterDoc = firebaseFirestore.collection("letters").doc();
      const crisisLetterData: Letter = {
        id: crisisLetterDoc.id,
        published: true,
        creationDate: firebase.firestore.Timestamp.now(),

        letterSenderID: "<REDACTED>",
        letterSenderAvatar: AvatarName.GENTLE,
        letterMessage: crisisMessage,

        recipientID: recipientID,
      };
      batch.set(crisisLetterDoc, crisisLetterData);

      const inboxItemDoc = firebaseFirestore
        .collection("users")
        .doc(crisisLetterData.recipientID)
        .collection("inbox")
        .doc();
      const inboxItemData: InboxItem = {
        id: inboxItemDoc.id,
        creationDate: firebase.firestore.Timestamp.now(),
        linkedContentID: crisisLetterData.id,
        linkedContentCreatorID: crisisLetterData.letterSenderID,
        linkedContentAvatar: crisisLetterData.letterSenderAvatar,
        linkedContentExcerpt: crisisLetterData.letterMessage.slice(0, 50),
      };
      batch.set(inboxItemDoc, inboxItemData);

      await batch.commit();

      alert(`successfully sent letter to ${crisisLetterData.recipientID}`);
    } catch (error) {
      console.error(error);
      return;
    }
  };

  return (
    <div className={`modal${props.isActive ? " is-active" : ""}`}>
      <div className="modal-background" onClick={_closeModal}></div>
      <div className="modal-card">
        <header className="modal-card-head">
          <p className="modal-card-title">
            <span role="img" aria-label="Love icon">
              💌
            </span>{" "}
            Send a crisis letter?
          </p>
          <button
            className="delete"
            aria-label="close"
            onClick={_closeModal}
          ></button>
        </header>
        <section className="modal-card-body">
          <div className="field">
            <label className="label">recipientID</label>
            <div className="control">
              <input
                className="input"
                type="text"
                placeholder="recipientID"
                value={recipientID}
                onChange={(event) => setRecipientID(event.target.value)}
              />
            </div>
          </div>
          <div className="field">
            <label className="label">Message</label>
            <div className="control">
              <textarea
                className="textarea"
                placeholder="message"
                value={crisisMessage}
                onChange={(event) => setCrisisMessage(event.target.value)}
              />
            </div>
          </div>
        </section>
        <footer className="modal-card-foot">
          <button className="button" onClick={_closeModal}>
            Cancel
          </button>
          <button
            className="button is-primary"
            disabled={crisisMessage.length <= 0 || recipientID.length <= 0}
            onClick={_sendCrisisLetter}
          >
            Send
          </button>
        </footer>
      </div>
    </div>
  );
};

export default CrisisModal;
