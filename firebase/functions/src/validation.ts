import { SyncRedactor } from "redact-pii";
import { CONSTANTS } from "./constants";
import { findProfanity } from "./filter";

export function validateExcerpt(excerpt: string): string[] {
  const validationFailures = [];
  if (excerpt.length > CONSTANTS.MAX_EXCERPT_LENGTH) {
    validationFailures.push(
      `excerpt length ${excerpt.length} exceeds max request length ${CONSTANTS.MAX_EXCERPT_LENGTH}`
    );
  }

  const profanity = findProfanity(excerpt);
  if (profanity.length) {
    validationFailures.push(`excerpt contains profanity: ${profanity}`);
  }

  const redactor = new SyncRedactor({
    builtInRedactors: {
      names: {
        // TODO: Revisit this decision!
        enabled: false,
      },
    },
  });
  const redactedExcerpt = redactor.redact(excerpt);
  if (excerpt !== redactedExcerpt) {
    validationFailures.push(`excerpt contains PII: ${redactedExcerpt}`);
  }

  return validationFailures;
}
