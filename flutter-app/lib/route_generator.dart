import 'package:flutter/cupertino.dart';
import 'package:gentle/models/reaction_inbox_item_model.dart';
import 'package:gentle/models/request_item_model.dart';
import 'package:gentle/providers/auth_provider.dart';
import 'package:gentle/providers/global_provider.dart';
import 'package:gentle/routes/blur_overlay_route.dart';
import 'package:gentle/screens/home_screen.dart';
import 'package:gentle/screens/letter_compose_screen.dart';
import 'package:gentle/screens/letter_screen.dart';
import 'package:gentle/screens/login_screen.dart';
import 'package:gentle/screens/request_compose_screen.dart';
import 'package:gentle/screens/request_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class ScreenArguments {}

class LetterScreenArguments extends ScreenArguments {
  final List<String> letterIDs;
  final bool shouldAnimateHero;
  final List<ReactionType> letterReactions;
  final bool shouldShowRequest;

  LetterScreenArguments({
    @required this.letterIDs,
    @required this.shouldShowRequest,
    this.letterReactions,
    this.shouldAnimateHero = true,
  });
}

class RequestScreenArguments extends ScreenArguments {
  final String requestID;

  RequestScreenArguments({@required this.requestID});
}

class LetterComposeScreenArguments extends ScreenArguments {
  final RequestItemModel requestItem;

  LetterComposeScreenArguments({
    @required this.requestItem,
  });
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments as ScreenArguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute<dynamic>(
          builder: (_) => Consumer2<GlobalProvider, AuthProvider>(
              builder: (_, provider, authProvider, __) {
            return Tabs(
              // Swap the key when the user changes to restart all
              // subtree state
              key: ValueKey(authProvider?.firebaseUser?.uid),
              tabIndex: provider.currentTabIndex,
            );
          }),
        );
      case IntroScreen.routeName:
        return BlurOverlayRoute<dynamic>(
          builder: (_) => IntroScreen(),
        );
      case RequestComposeScreen.routeName:
        return BlurOverlayRoute<dynamic>(
            builder: (_) => RequestComposeScreen());
      case LetterComposeScreen.routeName:
        RequestItemModel requestItem;
        if (args is LetterComposeScreenArguments) {
          requestItem = args.requestItem;
        }

        return BlurOverlayRoute<dynamic>(
            builder: (_) => LetterComposeScreen(
                  requestItem: requestItem,
                ));
      case LetterScreen.routeName:
        List<String> letterIDs;
        List<ReactionType> letterReactions;
        bool shouldAnimateHero;
        bool shouldShowRequest;
        if (args is LetterScreenArguments) {
          letterIDs = args.letterIDs;
          letterReactions = args.letterReactions;
          shouldAnimateHero = args.shouldAnimateHero;
          shouldShowRequest = args.shouldShowRequest;
        }

        return BlurOverlayRoute<dynamic>(
          builder: (_) => LetterScreen(
            letterIDs: letterIDs,
            letterReactions: letterReactions,
            shouldAnimateHero: shouldAnimateHero,
            shouldShowRequest: shouldShowRequest,
          ),
        );
      case RequestScreen.routeName:
        String requestID;
        if (args is RequestScreenArguments) {
          requestID = args.requestID;
        }

        return BlurOverlayRoute<dynamic>(
          builder: (_) => RequestScreen(
            requestID: requestID,
          ),
        );
    }

    return null;
  }
}
