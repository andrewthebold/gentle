class UIStrings {
  // TODO (LOW): Move all one-off strings into this file
  static const String title = 'Gentle';

  static const String mailbox = 'Mailbox';
  static const String reply = 'Reply';
  static const String help = 'Help';

  static const String history = 'History';

  static const String send = 'Send';
  static const String close = 'Close';
  static const String done = 'Done';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String continueStep = 'Continue';

  static const String tips = 'Tips';

  static const String createRequest = 'Create Request';
  static const String replyRequest = 'Reply to Request';

  static const String reportRequest = 'Report Request';
  static const String skipRequest = 'Skip Request';

  static const String activityLogStemOpenMail = 'Got mail from';
  static const String activityLogStemSentRequest = 'Sent request as';
  static const String activityLogStemSentReply = 'Sent reply to';

  static const String yesterday = 'Yesterday';

  static const String noMail = 'No new mail right now!';
  static const String waitingForMail = 'Waiting for Mail';

  static const String endOfStack = 'Thanks for caring!';
  static const String noMoreRequests = 'You looked at every message!';
  static const String getNewRequests = 'Get new messages';
  static const String startRequestsAgain = 'Start over';
  static const String restart = 'Restart';

  static const String tryAReply = 'Try a reply';
  static const String writeRequest = 'Ask for kindness';

  static const String endOfList = 'That\'s all!';
  static const String listEmpty = 'Nothing here yet!';

  static const String cardHowGentleWorks = 'How Gentle Works';
  static const String cardMentalHealth = 'Mental Health Resources';

  static const String helpWhatsNew = 'What\'s New?';
  static const String helpContact = 'Contact Gentle';
  static const String helpTip = 'Tip Gentle';
  static const String helpDelete = 'Delete Data';
  static const String about = 'About';

  static const String report = 'Report';
  static const String reportTitle = 'Something wrong?';
  static const String reportLabelSpam = 'Spam or off-topic';
  static const String reportLabelAbuse = 'Abuse or harassment';
  static const String reportLabelConcern = 'Concern for self-harm';
  static const String reportLabelPII = 'Reveals personal information';
  static const String reportLabelOther = 'Other';

  static const String reportSpamSublabel1 =
      'This content will be hidden for you';
  static const String reportSpamSublabel2 =
      'Hmm. We\'ll get to the bottom of this!';

  static const String reportAbuseSublabel1 =
      'This content will be hidden for you';
  static const String reportAbuseSublabel2 =
      'We\'ll take action within 24 hours';

  static const String reportConcernSublabel1 = 'We may reach out to the writer';
  static const String reportConcernSublabel2 =
      'We\'ll take action within 24 hours';

  // ===========================================================================
  // User Deletion
  // ===========================================================================
  static const String deleteAccountHeader = 'Delete all data?';
  static const String deleteAccountDescription =
      'Want to leave or start over? No worries!';
  static const String deleteAccountExplanation1 =
      'Your requests and letters will be deleted';
  static const String deleteAccountExplanation2 =
      'If somebody replied to one of your requests, they will keep a copy of it';
  static const String deleteAccountExplanation3 = 'You can\'t undo this';
}

class SharedPreferenceKeys {
  static const String requestDraft = 'request_draft';
  static const String replyDraftRequest = 'letter_draft_request_id';
  static const String replyDraft = 'letter_draft';
  static const String hasSeenMailboxHistory = 'has_seen_mailbox_history';
  static const String hasSeenReplyHistory = 'has_seen_reply_history';

  static const String hasOpenedReplyTip = 'has_opened_reply_tip';
  static const String hasOpenedLetterTip = 'has_opened_letter_tip';

  static const String recentLetterReactTimes = 'recent_letter_react_times';
}

class HeroTags {
  static const String composeRequest = 'compose-hero';
  static const String composeReply = 'compose-letter-hero';
}

class Constants {
  static const int sendDelayDuration = 0;
  static const Duration particleDuration = Duration(milliseconds: 7000);
  static const Duration loadShimmerDelayDuration = Duration(milliseconds: 500);

  static const Duration fastAnimDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimDuration = Duration(milliseconds: 400);
  static const Duration weightyAnimDuration = Duration(milliseconds: 600);
  static const Duration heaviestAnimDuration = Duration(milliseconds: 1000);
  static const Duration routeChangeDuration = Duration(milliseconds: 400);

  static const Duration envelopeAppearDuration = Duration(milliseconds: 200);
  static const Duration envelopeSwapDelayDuration = Duration(milliseconds: 400);

  static const int stampRotationMax = 6;

  static const int maxExcerptLength = 50;

  static const int maxRequestLength = 280;
  static const int maxLetterLength = 560;

  static const int requestStackSize = 10;
  static const int activityLogRequestSize = 20;

  static const int reactionStackMaxVisibleSize = 3;

  static const int reactionsPerDay = 3;

  // Dimensions
  static const double bottomBarHeight = 56.0;
  static const double requestCardHeight = 288.0;
  static const double sliverDividerHeight = 12.0;
  static const double floatingButtonDiameter = 88.0;
  static const double smallFloatingButtonDiameter = 64.0;
  static const double screenActionButtonAreaHeight = 120.0;

  static const double infiniteScrollThreshold = 200.0; // px

  // Links
  static const String urlHomepage = '<REDACTED';
  static const String urlTerms = '<REDACTED';
  static const String urlPrivacy = '<REDACTED>';
}
