import { Letter, User, GentleRequest } from "../models";
import { firestore } from "firebase-admin";
import {
  validateID,
  validateIsUnpublished,
  validateCreationDate,
  validateAvatar,
  ValidationFailure,
  validateUserExists,
} from "./sharedValidators";
import { validateUserUnderReview } from "./underReviewValidator";
import {
  validateRequestExists,
  validateExistingRequestMessage,
  validateLetterMessage,
  validateRecipientDidNotBlockSender,
  validateLetterSpam,
  validateReactionType,
} from "./letterValidators";

export async function dangerousValidateLetter(
  letter: Letter,
  db: firestore.Firestore,
  sendingUser: User | null,
  receivingUser: User | null,
  request: GentleRequest | null
): Promise<ValidationFailure[]> {
  const failures = [
    ...validateID("id", letter.id),
    ...validateIsUnpublished("published", letter.published),
    ...validateCreationDate("creationDate", letter.creationDate),

    ...(letter.requestID != null
      ? validateID("requestID", letter.requestID)
      : []),
    ...(letter.requestID != null
      ? await validateRequestExists("requestID", letter.requestID, db)
      : []),
    ...(letter.requestMessage != null
      ? validateExistingRequestMessage(
          "requestMessage",
          letter.requestMessage,
          request
        )
      : []),
    ...(letter.requestCreatorID != null
      ? validateID("requestCreatorID", letter.requestCreatorID)
      : []),
    ...(letter.requestCreatorAvatar != null
      ? validateAvatar("requestCreatorAvatar", letter.requestCreatorAvatar)
      : []),

    ...validateID("letterSenderID", letter.letterSenderID),
    ...validateAvatar("letterSenderAvatar", letter.letterSenderAvatar),
    ...(await validateLetterMessage("letterMessage", letter.letterMessage)),

    ...validateID("recipientID", letter.recipientID),
    ...validateUserExists("recipientID", receivingUser),
    ...validateRecipientDidNotBlockSender(
      "recipientID",
      sendingUser,
      receivingUser
    ),

    ...(letter.reactionType != null
      ? validateReactionType("reactionType", letter.reactionType)
      : []),
    ...(letter.reactionTime != null
      ? validateCreationDate("reactionTime", letter.reactionTime)
      : []),

    ...(await validateLetterSpam("meta:spam", letter.letterSenderID, db)),
    ...(await validateUserUnderReview("meta:underReview", sendingUser, db)),
  ];

  // Remove duplicate failures
  const filteredFailures = failures.reduce(
    (acc: ValidationFailure[], current: ValidationFailure) => {
      const duplicate = acc.find(
        (item) =>
          item.field === current.field &&
          item.error === current.error &&
          item.message === current.message
      );
      if (!duplicate) {
        return acc.concat(current);
      } else {
        return acc;
      }
    },
    []
  );

  return filteredFailures;
}
