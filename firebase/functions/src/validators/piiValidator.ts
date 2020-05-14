import {
  ValidationFailure,
  validationFailure,
  ValidationErrorType,
} from "./sharedValidators";
import { SyncRedactor } from "redact-pii";
import { REGEX_STRINGS } from "../constants";

// Basic PII identifier based on redact-pii — first line of defense
export function validateMessagePII(
  field: string,
  message: string
): ValidationFailure[] {
  const failures = [];
  // Check for PII
  const redactor = new SyncRedactor({
    builtInRedactors: {
      names: {
        enabled: false,
      },
      digits: {
        enabled: false,
      },
    },
  });
  const redactedMessage = redactor.redact(message);
  if (message !== redactedMessage) {
    if (redactedMessage.includes("PHONE_NUMBER")) {
      failures.push(
        validationFailure(
          field,
          ValidationErrorType.PIIPhoneNumber,
          redactedMessage
        )
      );
    }
    if (
      redactedMessage.includes("ZIPCODE") ||
      redactedMessage.includes("STREET_ADDRESS")
    ) {
      failures.push(
        validationFailure(
          field,
          ValidationErrorType.PIIAddress,
          redactedMessage
        )
      );
    }
    if (redactedMessage.includes("CREDIT_CARD_NUMBER")) {
      failures.push(
        validationFailure(
          field,
          ValidationErrorType.PIICreditCard,
          redactedMessage
        )
      );
    }
    if (redactedMessage.includes("IP_ADDRESS")) {
      failures.push(
        validationFailure(
          field,
          ValidationErrorType.PIIIPAddress,
          redactedMessage
        )
      );
    }
    if (redactedMessage.includes("US_SOCIAL_SECURITY_NUMBER")) {
      failures.push(
        validationFailure(
          field,
          ValidationErrorType.PIISocialSecurity,
          redactedMessage
        )
      );
    }
    if (redactedMessage.includes("EMAIL_ADDRESS")) {
      failures.push(
        validationFailure(field, ValidationErrorType.PIIEmail, redactedMessage)
      );
    }
    if (
      redactedMessage.includes("USERNAME") ||
      redactedMessage.includes("PASSWORD") ||
      redactedMessage.includes("CREDENTIALS")
    ) {
      failures.push(
        validationFailure(
          field,
          ValidationErrorType.PIICredentials,
          redactedMessage
        )
      );
    }
    if (redactedMessage.includes("URL")) {
      failures.push(
        validationFailure(field, ValidationErrorType.PIIURL, redactedMessage)
      );
    }
  }

  // Check for hashtags
  if (REGEX_STRINGS.hashtags.test(message)) {
    failures.push(
      validationFailure(field, ValidationErrorType.HashTag, redactedMessage)
    );
  }

  // Check for @ names
  if (REGEX_STRINGS.atNames.test(message)) {
    failures.push(
      validationFailure(field, ValidationErrorType.UserHandle, redactedMessage)
    );
  }

  return failures;
}
