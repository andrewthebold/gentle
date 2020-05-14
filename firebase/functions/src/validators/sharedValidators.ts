import { firestore } from "firebase-admin";
import { AvatarName, User, UNAVAILABLE_AVATAR_NAMES } from "../models";
import { findProfanity } from "../filter";

export enum ValidationErrorType {
  NullData = "null_data",

  PrePublished = "pre_published",
  CreatedInFuture = "created_in_future",
  NonZeroResponseCount = "non_zero_response_count",
  NonMatchingRequestMessage = "non_matching_request_message",
  UserIDMismatch = "user_id_mismatch",

  TooLong = "too_long",
  TooShort = "too_short",
  Profanity = "profanity",
  PII = "pii",
  PIIPhoneNumber = "pii_phone_number",
  PIIAddress = "pii_address",
  PIIPrice = "pii_price",
  PIICreditCard = "pii_credit_card",
  PIIIPAddress = "pii_ip_address",
  PIISocialSecurity = "pii_social_security",
  PIIEmail = "pii_email",
  PIICredentials = "pii_credentials",
  PIIURL = "pii_url",

  InvalidAvatar = "invalid_avatar",
  InvalidReaction = "invalid_reaction",
  InvalidUser = "invalid_user",
  InvalidRequest = "invalid_request",

  BlockedSender = "blocked_sender",

  SpammyBehavior = "spammy_behavior",

  SentimentMixed = "sentiment_mixed",
  SentimentNegative = "sentiment_negative",
  NLPSentimentFailure = "nlp_sentiment_failure",

  NonEnglish = "non_english",
  HashTag = "hash_tag",
  UserHandle = "user_handle",

  UserUnderReview = "user_under_review",
}

export interface ValidationFailure {
  field: string;
  error: ValidationErrorType;
  message?: string;
}

export function validationFailure(
  field: string,
  error: ValidationErrorType,
  message?: string
): ValidationFailure {
  return {
    field: field,
    error: error,
    message: message,
  };
}

export function validateID(field: string, id: string): ValidationFailure[] {
  const failures = [];
  if (id == null) {
    failures.push(validationFailure(field, ValidationErrorType.NullData));
  }
  return failures;
}

export function validateIsUnpublished(
  field: string,
  published: boolean
): ValidationFailure[] {
  const failures = [];
  if (published == null) {
    failures.push(validationFailure(field, ValidationErrorType.NullData));
  }
  if (published === true) {
    failures.push(validationFailure(field, ValidationErrorType.PrePublished));
  }
  return failures;
}

export function validateCreationDate(
  field: string,
  creationDate: firestore.Timestamp
): ValidationFailure[] {
  const failures = [];
  if (creationDate == null) {
    failures.push(validationFailure(field, ValidationErrorType.NullData));
  }
  if (creationDate.toDate() > new Date()) {
    failures.push(
      validationFailure(field, ValidationErrorType.CreatedInFuture)
    );
  }
  return failures;
}

export function validateWordCount(
  field: string,
  message: string,
  minWords: number
): ValidationFailure[] {
  const failures = [];
  // Filter low-effort messages
  const wordCount = message.trim().split(/\s+/).length;
  if (wordCount < minWords) {
    failures.push(
      validationFailure(
        field,
        ValidationErrorType.TooShort,
        `Word count: ${wordCount}`
      )
    );
  }
  return failures;
}

export function validateMaxLength(
  field: string,
  message: string,
  maxLength: number
): ValidationFailure[] {
  const failures = [];
  // Invalid length
  if (message.length > maxLength) {
    failures.push(
      validationFailure(
        field,
        ValidationErrorType.TooLong,
        `Length: ${message.length}`
      )
    );
  }
  return failures;
}

export function validateProfanity(
  field: string,
  message: string
): ValidationFailure[] {
  const failures = [];
  const profanity = findProfanity(message);
  if (profanity.length) {
    failures.push(
      validationFailure(field, ValidationErrorType.Profanity, `${profanity}`)
    );
  }
  return failures;
}

export function validateAvatar(
  field: string,
  avatar: AvatarName
): ValidationFailure[] {
  const failures = [];
  if (avatar == null) {
    failures.push(validationFailure(field, ValidationErrorType.NullData));
  }

  const availableNames: string[] = Object.values(AvatarName).filter(
    (avatarName) => {
      return !UNAVAILABLE_AVATAR_NAMES.includes(avatarName);
    }
  );

  if (!availableNames.includes(avatar)) {
    failures.push(validationFailure(field, ValidationErrorType.InvalidAvatar));
  }
  return failures;
}

export function validateUserExists(
  field: string,
  user: User | null
): ValidationFailure[] {
  const failures = [];
  if (user == null) {
    failures.push(validationFailure(field, ValidationErrorType.InvalidUser));
  }
  return failures;
}
