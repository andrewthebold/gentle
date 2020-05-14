import React, { useEffect, useState, useRef } from "react";
import "firebase/firestore";

import { firebaseFirestore } from "./firebase";

type ID = string;

export interface Meta {
  letterCount: number;
  requestCount: number;
  userCount: number;
  reportCount: number;
}

function Statistics() {
  const [meta, setMeta] = useState<Meta>();

  const metaListener = useRef<Function>();

  useEffect(() => {
    metaListener.current = firebaseFirestore
      .collection("meta")
      .doc("meta")
      .onSnapshot(_handleSnapshot);

    return () => {
      if (metaListener.current != null) {
        metaListener.current();
      }
    };
  }, []);

  const _handleSnapshot = (
    snapshot: firebase.firestore.DocumentSnapshot
  ): void => {
    setMeta(snapshot.data() as Meta);
  };

  return (
    <div className="navbar is-light">
      <div className="navbar-item">
        <strong>Users</strong>:&nbsp;
        <p>{meta?.userCount}</p>
      </div>
      <div className="navbar-item">
        <strong>Requests</strong>:&nbsp;
        <p>{meta?.requestCount}</p>
      </div>
      <div className="navbar-item">
        <strong>Letters</strong>:&nbsp;
        <p>{meta?.letterCount}</p>
      </div>
      <div className="navbar-item">
        <strong>Reports</strong>:&nbsp;
        <p>{meta?.reportCount}</p>
      </div>
    </div>
  );
}

export default Statistics;
