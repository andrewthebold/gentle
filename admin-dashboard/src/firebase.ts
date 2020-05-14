import firebase from "firebase/app";
import "firebase/auth";

import firebaseConfig from "./firebaseConfig";

const firebaseApp = firebase.initializeApp(firebaseConfig);

export const firebaseAppAuth = firebaseApp.auth();
export const firebaseFirestore = firebaseApp.firestore();
