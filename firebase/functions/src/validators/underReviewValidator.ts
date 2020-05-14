import {
  ValidationFailure,
  validationFailure,
  ValidationErrorType,
} from "./sharedValidators";
import { User, PATHS, PrivateUser } from "../models";

// Used when manually putting someone's account under manual review
// (meaning all content is flagged for moderation).
export async function validateUserUnderReview(
  field: string,
  user: User | null,
  db: FirebaseFirestore.Firestore
): Promise<ValidationFailure[]> {
  const failures = [];
  if (user == null) {
    failures.push(validationFailure(field, ValidationErrorType.NullData));
  } else {
    const privateUserDoc = await db
      .collection(PATHS.USERS_COLLECTION)
      .doc(user.id)
      .collection(PATHS.USERS_COLLECTION_PRIVATE_SUBCOLLECTION)
      .doc("private")
      .get();

    if (privateUserDoc.exists) {
      const privateUser = privateUserDoc.data() as PrivateUser;
      if (privateUser != null && privateUser.manualReview === true) {
        failures.push(
          validationFailure(field, ValidationErrorType.UserUnderReview)
        );
      }
    }
  }

  return failures;
}
