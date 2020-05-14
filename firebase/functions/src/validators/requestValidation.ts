import { GentleRequest, User } from "../models";
import { firestore } from "firebase-admin";
import {
  validateID,
  validateIsUnpublished,
  validateCreationDate,
  validateAvatar,
  ValidationFailure,
} from "./sharedValidators";
import { validateUserUnderReview } from "./underReviewValidator";
import {
  validateRequestResponseCount,
  validateRequesterID,
  validateRequestSpam,
  validateRequestMessage,
} from "./requestValidators";

export async function dangerousValidateRequest(
  request: GentleRequest,
  requestingUser: User | null,
  db: firestore.Firestore
): Promise<ValidationFailure[]> {
  const failures = [
    ...validateID("id", request.id),
    ...validateIsUnpublished("published", request.published),
    ...validateCreationDate("creationDate", request.creationDate),
    ...validateRequestResponseCount("responseCount", request.responseCount),

    ...validateID("requesterID", request.requesterID),
    ...validateRequesterID("requesterID", request.requesterID, requestingUser),
    ...validateAvatar("requesterAvatar", request.requesterAvatar),
    ...(await validateRequestMessage("requestMessage", request.requestMessage)),

    ...(await validateRequestSpam("meta:spam", request, db)),
    ...(await validateUserUnderReview("meta:underReview", requestingUser, db)),
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
