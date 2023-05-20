import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/View/Auth/login.dart';
import 'package:khoroch/View/Home/home_view.dart';
import 'package:khoroch/routes/pages/splash.dart';
import 'package:khoroch/services/services.dart';
import 'package:routemaster/routemaster.dart';

class RouteName {
  static const String root = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String splash = '/splash';
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

  final canNavigate = authState == AuthState.authenticated;

  Page<dynamic> splashGuard({required Page page}) {
    return canNavigate ? page : const MaterialPage(child: SplashScreen());
  }

  RouteMap routeMap() {
    if (authState == AuthState.unauthenticated) {
      return RouteMap(
        onUnknownRoute: (path) => const Redirect(RouteName.login),
        routes: {
          RouteName.root: (route) => const MaterialPage(child: LoginPage()),
          RouteName.login: (route) => const MaterialPage(child: LoginPage()),
        },
      );
    } else {
      return RouteMap(
        onUnknownRoute: (path) {
          log('unknown : $path');
          return const Redirect(RouteName.login);
        },
        routes: {
          RouteName.root: (route) {
            return authState == AuthState.loading
                ? const MaterialPage(child: SplashScreen())
                : const MaterialPage(child: HomePage());
          },
          RouteName.splash: (route) =>
              splashGuard(page: const MaterialPage(child: SplashScreen())),
          RouteName.login: (route) =>
              splashGuard(page: const MaterialPage(child: LoginPage())),
          RouteName.home: (route) =>
              splashGuard(page: const MaterialPage(child: HomePage())),
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
