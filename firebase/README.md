# Firebase Setup

This is the Firebase config and code that handles the "backend" of Gentle.

## Parts

1. Firestore rules (`.firestore.rules`)

   - Enforces read/write permissions

2. Firestore indexes (`firestore.indexes.json`)

   - Gentle uses a few composite indexes in order to fetch data

3. Firebase Cloud Functions (`functions/`)

   - Uses Firestore triggers to handle publishing user-generated content
   - Runs scheduled functions to calculate metrics and send notifications

## Folder structure

```
.
├── functions                 # Firebase Cloud Function code
│   └── src                   # Function code (see index.ts) for a starting point
│       └── validators        # Logic to determine whether or not to publish content
├── tests                     # Defunct testing code for Firestore rules
├── .firebaserc               # Used to help swap between prod/sandbox projects
├── firestore.indexes.json    # Firestore indexes
└── firestore.rules           # Firestore rules
```

## To run

Gentle's firebase setup uses:

- [Firebase Authentication](https://firebase.google.com/docs/auth)
  - Anonymous Sign-in should be enabled
- [Firestore](https://firebase.google.com/docs/firestore)
- [Firebase Cloud Functions](https://firebase.google.com/docs/functions)
- [Google Cloud NLP API](https://cloud.google.com/natural-language)

## Removed code

- Testing code (defunct and out-of-sync with Firestore rules)
- Various URL's, secrets, and ID's were redacted
- Bad words list

## Notes

- Because this is a copy of the master branch of Gentle:
  - Much of the validation logic is in a half-transitioned state. You will likely run into bugs or errors with message publishing.
  - There's some logic to send notifications, but it's not ready and likely broken.
