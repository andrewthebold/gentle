type ID = string;

export enum AvatarName {
  CAT = "cat",
  FISH = "fish",
  GENTLE = "gentle",
  ICECREAM = "icecream",
  LEAF = "leaf",
  PIZZA = "pizza",
  UNKNOWN = "unknown",
}

export interface Letter {
  id: ID;
  published: boolean;
  creationDate: firebase.firestore.Timestamp;

  requestID?: ID;
  requestMessage?: string;
  requestCreatorID?: ID;
  requestCreatorAvatar?: AvatarName;

  letterSenderID: ID;
  letterSenderAvatar: AvatarName;
  letterMessage: string;

  recipientID: ID;

  publishFailures?: string[];
}

export interface InboxItem {
  id: ID;
  creationDate: firebase.firestore.Timestamp;
  linkedContentID: ID;
  linkedContentCreatorID: ID;
  linkedContentAvatar: AvatarName;
  linkedContentExcerpt: string;
}

export enum Rule {
  NO_UNINVITED_ADVICE = "no_uninvited_advice",
  NO_PII = "no_pii",
  NO_POLITICAL_DEBATE = "no_political_debate",
  NO_SELF_PROMOTION = "no_self_promotion",
  NO_LINKS = "no_links",
  NO_SELF_HARM = "no_self_harm",
}
