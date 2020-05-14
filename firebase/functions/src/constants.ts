export const CONSTANTS = {
  // The admin user was created manually via the firebase console
  ADMIN_ID: "<ADMIN USER ID REDACTED>",
  ADMIN_NAME: "Gentle",

  MAX_EXCERPT_LENGTH: 50,
  MAX_REQUEST_LENGTH: 280,
  MAX_LETTER_LENGTH: 560,
};

export const REGEX_STRINGS = {
  hashtags: /\B(#[a-zA-Z]+\b)(?!;)/,
  atNames: /\B(@[a-zA-Z]+\b)(?!;)/,
};
