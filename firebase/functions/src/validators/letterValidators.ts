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
import {
  GentleRequest,
  User,
  PATHS,
  Reaction,
  UNAVAILABLE_REACTIONS,
} from "../models";
import { ID } from "../types";
import { firestore } from "firebase-admin";

export async function validateLetterMessage(
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
    CONSTANTS.MAX_LETTER_LENGTH
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

export function validateExistingRequestMessage(
  field: string,
  message: string,
  existingRequest: GentleRequest | null
): ValidationFailure[] {
  const failures = [];
  if (message == null || existingRequest == null) {
    failures.push(validationFailure(field, ValidationErrorType.NullData));
  }
  if (existingRequest?.requestMessage !== message) {
    failures.push(
      validationFailure(field, ValidationErrorType.NonMatchingRequestMessage)
    );
  }
  return failures;
}

export function validateReactionType(
  field: string,
  type: Reaction
): ValidationFailure[] {
  const failures = [];
  if (type == null) {
    failures.push(validationFailure(field, ValidationErrorType.NullData));
  }

  const availableReactions: string[] = Object.values(Reaction).filter(
    (reaction) => {
      return !UNAVAILABLE_REACTIONS.includes(reaction);
    }
  );

  if (!availableReactions.includes(type)) {
    failures.push(
      validationFailure(field, ValidationErrorType.InvalidReaction)
    );
  }

  return failures;
}

export function validateRecipientDidNotBlockSender(
  field: string,
  sendingUser: User | null,
  receivingUser: User | null
): ValidationFailure[] {
  const failures = [];
  if (sendingUser == null) {
    failures.push(
      validationFailure(field, ValidationErrorType.NullData, "sendingUser")
    );
  }

  if (receivingUser == null) {
    failures.push(
      validationFailure(field, ValidationErrorType.NullData, "receivingUser")
    );
  }

  if (
    receivingUser != null &&
    sendingUser != null &&
    receivingUser.blockedUsers != null &&
    receivingUser.blockedUsers.includes(sendingUser.id)
  ) {
    failures.push(validationFailure(field, ValidationErrorType.BlockedSender));
  }

  return failures;
}

export async function validateRequestExists(
  field: string,
  requestID: ID,
  db: firestore.Firestore
): Promise<ValidationFailure[]> {
  const failures = [];
  if (requestID == null) {
    failures.push(validationFailure(field, ValidationErrorType.NullData));
  }

  const requestDoc = await db
    .collection(PATHS.REQUESTS_COLLECTION)
    .doc(requestID)
    .get();
  if (!requestDoc.exists) {
    failures.push(validationFailure(field, ValidationErrorType.InvalidRequest));
  }

  return failures;
}

export async function validateLetterSpam(
  field: string,
  senderID: ID,
  db: firestore.Firestore
): Promise<ValidationFailure[]> {
  const failures = [];
  if (senderID == null) {
    failures.push(validationFailure(field, ValidationErrorType.NullData));
  }

  // If they've made more than 5+ in the last 5 min, put to manual review
  const spamTimeAgo = new Date(
    firestore.Timestamp.now().toMillis() - 1000 * 60 * 5
  );
  const recentLettersFromSender = await db
    .collection(PATHS.LETTERS_COLLECTION)
    .where("letterSenderID", "==", senderID)
    .where("creationDate", ">", spamTimeAgo)
    .limit(6)
    .get();
  if (recentLettersFromSender.size > 5) {
    failures.push(
      validationFailure(
        "n/a",
        ValidationErrorType.SpammyBehavior,
        `Count: ${recentLettersFromSender.size}`
      )
    );
  }

  return failures;
}
