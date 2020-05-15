import 'package:gentle/constants.dart';
import 'package:gentle/providers/global_provider.dart';
import 'package:gentle/providers/local_reaction_provider.dart';
import 'package:gentle/providers/user_provider.dart';
import 'package:gentle/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gentle/providers/auth_provider.dart';
import 'package:gentle/screens/login_screen.dart';
import 'package:gentle/theme.dart';
import 'package:provider/provider.dart';

final RouteObserver<Route> routeObserver = RouteObserver<Route>();

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarBrightness: Brightness.light));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<AuthProvider, GlobalProvider>(
          create: (_) => GlobalProvider(),
          update: (_, authProvider, userProvider) =>
              userProvider..handleAuthUpdate(authProvider: authProvider),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<AuthProvider, UserProvider>(
          create: (_) => UserProvider(),
          update: (_, authProvider, userProvider) => userProvider
            ..handleAuthUpdate(authProvider: authProvider, context: context),
          lazy: false,
        ),
        ChangeNotifierProvider<LocalReactionProvider>(
          create: (_) => LocalReactionProvider(),
          lazy: false,
        )
      ],
      child: Consumer<AuthProvider>(
        builder: (_, authProvider, __) {
          if (!authProvider.initialized) {
            return Container(
              color: Palette.white,
            );
          }

          String initialRoute = IntroScreen.routeName;

          if (authProvider.firebaseUser != null) {
            initialRoute = '/';
          }

          return MaterialApp(
            title: UIStrings.title,
            theme: gentleTheme,
            initialRoute: initialRoute,
            onGenerateRoute: RouteGenerator.generateRoute,
            navigatorObservers: [routeObserver],
          );
        },
      ),
    );
  }
}
