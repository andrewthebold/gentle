import {
  ValidationFailure,
  validationFailure,
  ValidationErrorType,
} from "./sharedValidators";

/*
 * Use Google's Natural Language API to identify sentiment and potential PII.
 */
export async function validateMessageWithGoogleNLP(
  field: string,
  message: string
): Promise<ValidationFailure[]> {
  const failures = [];

  const language = await import("@google-cloud/language");
  const client = new language.LanguageServiceClient();
  const [result] = await client.annotateText({
    document: {
      content: message,
      type: "PLAIN_TEXT",
    },
    features: {
      extractEntities: true,
      extractDocumentSentiment: true,
    },
    encodingType: "UTF8",
  });

  if (result.language !== "en") {
    failures.push(validationFailure(field, ValidationErrorType.NonEnglish));
  }

  // Check for sentiment
  const sentiment = result.documentSentiment;
  if (
    sentiment != null &&
    sentiment.score != null &&
    sentiment.magnitude != null
  ) {
    if (sentiment.score >= 0.25) {
      // Cleary positive; pass
    } else if (sentiment.score >= 0 && sentiment.score < 0.25) {
      // Neutral
      if (sentiment.magnitude < 1.0) {
        // Actually neutral; pass
      } else {
        // Mixed; needs moderation
        failures.push(
          validationFailure(
            field,
            ValidationErrorType.SentimentMixed,
            `Score: ${sentiment.score}, Magnitude: ${sentiment.magnitude}`
          )
        );
      }
    } else if (sentiment.score < 0) {
      // Negative; needs moderation
      failures.push(
        validationFailure(
          field,
          ValidationErrorType.SentimentNegative,
          `Score: ${sentiment.score}, Magnitude: ${sentiment.magnitude}`
        )
      );
    }
  } else {
    failures.push(
      validationFailure(field, ValidationErrorType.NLPSentimentFailure)
    );
  }

  // Check if any PII-related entities are found
  const entities = result.entities;
  if (entities?.length) {
    entities.forEach((entity) => {
      switch (entity.type) {
        case "ADDRESS":
          failures.push(
            validationFailure(field, ValidationErrorType.PIIAddress)
          );
          break;
        case "PHONE_NUMBER":
          failures.push(
            validationFailure(field, ValidationErrorType.PIIPhoneNumber)
          );
          break;
        case "PRICE":
          failures.push(validationFailure(field, ValidationErrorType.PIIPrice));
          break;
      }
    });
  }

  return failures;
}
