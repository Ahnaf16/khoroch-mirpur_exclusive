import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/View/Auth/login.dart';
import 'package:khoroch/View/Home/khoroch_view.dart';
import 'package:khoroch/routes/pages/splash.dart';
import 'package:khoroch/services/services.dart';
import 'package:routemaster/routemaster.dart';

class RouteName {
  static const String root = '/';
  static const String login = '/login';
  static const String home = '/home';
}

class RouteLogObserver extends RoutemasterObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    log('Popped a route', name: 'route');
  }

  @override
  void didChangeRoute(RouteData routeData, Page page) {
    log('New route: ${routeData.path}', name: 'route');
  }
}

final routesProvider = Provider<RoutemasterDelegate>((ref) {
  final authState = ref.watch(authStateProvider);

  log(authState.name);

  final canNavigate = authState == AuthState.authenticated;
  log(canNavigate.toString());

  // Page<dynamic> splashGuard({required Page page}) {
  //   return canNavigate ? page : const MaterialPage(child: SplashScreen());
  // }

  RouteMap routeMap() {
    if (authState == AuthState.unauthenticated) {
      return RouteMap(
        onUnknownRoute: (path) => const Redirect(RouteName.login),
        routes: {
          RouteName.root: (route) => const Redirect(RouteName.login),
          RouteName.login: (route) => const MaterialPage(child: LoginPage()),
        },
      );
    } else {
      return RouteMap(
        onUnknownRoute: (path) => const Redirect(RouteName.login),
        routes: {
          RouteName.root: (route) {
            return authState == AuthState.loading
                ? const MaterialPage(child: SplashScreen())
                : const MaterialPage(child: HomePage());
          },
          RouteName.login: (route) => const MaterialPage(child: LoginPage()),
          RouteName.home: (route) => const MaterialPage(child: HomePage()),
        },
      );
    }
  }

  final delegate = RoutemasterDelegate(
    routesBuilder: (context) => routeMap(),
    observers: [RouteLogObserver()],
  );
  return delegate;
});
