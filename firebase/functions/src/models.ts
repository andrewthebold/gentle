import { ID } from "./types";

export const PATHS = {
  USERS_COLLECTION: "users",
  USERS_COLLECTION_INBOX_SUBCOLLECTION: "inbox",
  USERS_COLLECTION_ACTIVITY_LOG_SUBCOLLECTION: "activityLog",
  USERS_COLLECTION_REACTION_INBOX_SUBCOLLECTION: "reactionInbox",
  USERS_COLLECTION_PRIVATE_SUBCOLLECTION: "private",

  LETTERS_COLLECTION: "letters",
  REQUESTS_COLLECTION: "requests",

  REPORTS_COLLECTION: "reports",
};

export interface MetaArchive {
  letterCount: number;
  reportCount: number;
  requestCount: number;
  userCount: number;
}

export interface Metric {
  creationDate: FirebaseFirestore.Timestamp;
  dailyActiveUserIDs: string[];
  monthlyActiveUserIDs: string[];
  dau: number;
  mau: number;
}

export enum AvatarName {
  CAT = "cat",
  FISH = "fish",
  GENTLE = "gentle",
  ICECREAM = "icecream",
  LEAF = "leaf",
  PIZZA = "pizza",
  UNKNOWN = "unknown",
}

export const UNAVAILABLE_AVATAR_NAMES = [AvatarName.GENTLE, AvatarName.UNKNOWN];

export function getStringFromAvatar(avatar: AvatarName): string {
  switch (avatar) {
    case AvatarName.CAT:
      return "Cat";
    case AvatarName.FISH:
      return "Fish";
    case AvatarName.GENTLE:
      return "Gentle";
    case AvatarName.ICECREAM:
      return "Ice cream";
    case AvatarName.LEAF:
      return "Leaf";
    case AvatarName.PIZZA:
      return "Pizza";
    default:
      return "Unknown";
  }
}

export function getEmojiFromAvatar(avatar: AvatarName): string {
  switch (avatar) {
    case AvatarName.CAT:
      return "😸";
    case AvatarName.FISH:
      return "🐠";
    case AvatarName.GENTLE:
      return "💌";
    case AvatarName.ICECREAM:
      return "🍦";
    case AvatarName.LEAF:
      return "🍃";
    case AvatarName.PIZZA:
      return "🍕";
    default:
      return "❔";
  }
}

export enum Reaction {
  LOVE = "love",
  INSPIRE = "inspire",
  THANKS = "thanks",
  UNKNOWN = "unknown",
}

export const UNAVAILABLE_REACTIONS = [Reaction.UNKNOWN];

export enum NotificationType {
  daily = "daily",
  all = "all",
  none = "none",
}

export interface User {
  id: ID;
  joinDate: FirebaseFirestore.Timestamp;
  // WIP; not live
  lastActive?: FirebaseFirestore.Timestamp;

  completedRequests: ID[];
  blockedUsers: ID[];
  hiddenRequests: ID[];
  hiddenLetters: ID[];

  // WIP; not live
  notifications?: {
    lastModified?: FirebaseFirestore.Timestamp;
    dailyTime?: FirebaseFirestore.Timestamp;
    type?: NotificationType;
    token?: string;
  };
}

// Private data that shouldn't be sent to a user (i.e., moderation info)
export interface PrivateUser {
  manualReview: boolean;
}

export interface InboxItem {
  id: ID;
  creationDate: FirebaseFirestore.Timestamp | FirebaseFirestore.FieldValue;
  linkedContentID: ID;
  linkedContentCreatorID: ID;
  linkedContentAvatar: AvatarName;
  linkedContentExcerpt: string;
}

export interface Letter {
  id: ID;
  published: boolean;
  creationDate: FirebaseFirestore.Timestamp;

  requestID?: ID;
  requestMessage?: string;
  requestCreatorID?: ID;
  requestCreatorAvatar?: AvatarName;

  letterSenderID: ID;
  letterSenderAvatar: AvatarName;
  letterMessage: string;

  recipientID: ID;

  reactionType?: Reaction;
  reactionTime?: FirebaseFirestore.Timestamp;
}

export interface GentleRequest {
  id: ID;
  published: boolean;
  creationDate: FirebaseFirestore.Timestamp;
  responseCount: number;

  requesterID: ID;
  requesterAvatar: AvatarName;

  requestMessage: string;
}

export enum ActivityLogItemType {
  SENT_REQUEST = "sentRequest",
  OPENED_MAIL = "openedMail",
  SENT_REPLAY = "sentReply",
  UNKNOWN = "unknown",
}

export interface ActivityLogItem {
  id: ID;
  creationDate: FirebaseFirestore.Timestamp;
  type: ActivityLogItemType;
  linkedContentID: ID;
  linkedContentCreatorID: ID;
  linkedContentAvatar: AvatarName;
  reactionType?: Reaction;
}

export type ActivityLogItemReactionPayload = Pick<
  ActivityLogItem,
  "reactionType"
>;

export interface ReactionInboxItem {
  id: ID;
  creationDate: FirebaseFirestore.Timestamp;
  type: Reaction;
  linkedContentID: ID;
  // WIP; not live
  linkedContentAvatar?: AvatarName;
}

export enum ReportContentType {
  REQUEST = "request",
  LETTER = "letter",
}

export enum ReportStatus {
  UNSOLVED = "unsolved",
  SOLVED = "solved",
}

export enum ReportOption {
  SPAM = "spam",
  ABUSE = "abuse",
  CONCERN = "concern",
  PII = "pii",
  OTHER = "other",
}

export interface Report {
  id: ID;
  creationDate: FirebaseFirestore.Timestamp;
  status: ReportStatus;
  contentID: ID;
  contentCreatorID: ID;
  contentType: ReportContentType;
  contentExcerpt: string;
  reportOption: ReportOption;
  reporterID: ID;
}
