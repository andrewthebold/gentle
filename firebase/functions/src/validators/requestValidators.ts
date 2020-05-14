import { User, GentleRequest, PATHS } from "../models";
import {
  ValidationFailure,
  validationFailure,
  ValidationErrorType,
  validateMaxLength,
  validateWordCount,
  validateProfanity,
} from "./sharedValidators";
import { CONSTANTS } from "../constants";
import { validateMessagePII } from "./piiValidator";
import { validateMessageWithGoogleNLP } from "./nlpValidator";
import { firestore } from "firebase-admin";

export function validateRequesterID(
  field: string,
  requesterID: string,
  requestingUser: User | null
): ValidationFailure[] {
  const failures = [];
  if (requesterID == null || requestingUser == null) {
    failures.push(validationFailure(field, ValidationErrorType.NullData));
  }
  if (requesterID !== requestingUser?.id) {
    failures.push(validationFailure(field, ValidationErrorType.UserIDMismatch));
  }
  return failures;
}

export function validateRequestResponseCount(
  field: string,
  responseCount: number
): ValidationFailure[] {
  const failures = [];
  if (responseCount == null) {
    failures.push(validationFailure(field, ValidationErrorType.NullData));
  }
  if (responseCount !== 0) {
    failures.push(
      validationFailure(field, ValidationErrorType.NonZeroResponseCount)
    );
  }
  return failures;
}

export async function validateRequestMessage(
  field: string,
  message: string
): Promise<ValidationFailure[]> {
  const failures = [];
  if (message == null) {
    failures.push(validationFailure(field, ValidationErrorType.NullData));
  }
  const maxLengthFailures = validateMaxLength(
    field,
    message,
    CONSTANTS.MAX_REQUEST_LENGTH
  );
  const wordCountFailures = validateWordCount(field, message, 5);
  const profanityFailures = validateProfanity(field, message);
  const piiFailures = validateMessagePII(field, message);
  const nlpFailures = await validateMessageWithGoogleNLP(field, message);

  return [
    ...failures,
    ...maxLengthFailures,
    ...wordCountFailures,
    ...profanityFailures,
    ...piiFailures,
    ...nlpFailures,
  ];
}

export async function validateRequestSpam(
  field: string,
  request: GentleRequest,
  db: firestore.Firestore
): Promise<ValidationFailure[]> {
  const failures = [];
  if (request == null) {
    failures.push(validationFailure(field, ValidationErrorType.NullData));
  }

  // If they've made more than 3+ in the last 3 min, put to manual review
  const spamTimeAgo = new Date(
    firestore.Timestamp.now().toMillis() - 1000 * 60 * 3
  );
  const recentRequestsFromRequester = await db
    .collection(PATHS.REQUESTS_COLLECTION)
    .where("requesterID", "==", request.requesterID)
    .where("creationDate", ">", spamTimeAgo)
    .limit(4)
    .get();
  if (recentRequestsFromRequester.size > 3) {
    failures.push(
      validationFailure(
        "n/a",
        ValidationErrorType.SpammyBehavior,
        `Count: ${recentRequestsFromRequester.size}`
      )
    );
  }

  recentRequestsFromRequester.forEach((recentRequestDoc) => {
    if (!recentRequestDoc.exists) {
      return;
    }
    // We only care about requests that aren't the current one
    if (recentRequestDoc.id === request.id) {
      return;
    }
    const recentRequest = recentRequestDoc.data() as GentleRequest;
    if (recentRequest.requestMessage === request.requestMessage) {
      failures.push(
        validationFailure(
          "n/a",
          ValidationErrorType.SpammyBehavior,
          `Exact message recently sent: ${recentRequest.requestMessage}`
        )
      );
    }
  });

  return failures;
}
