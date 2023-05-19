import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/View/Auth/login.dart';
import 'package:khoroch/View/Home/khoroch_view.dart';
import 'package:khoroch/services/services.dart';
import 'package:routemaster/routemaster.dart';

class RouteName {
  static const String root = '/';
  static const String login = '/login';
  static const String home = '/home';
}

final routesProvider = Provider<RoutemasterDelegate>((ref) {
  final routeMap = ref.watch(routeMapProvider);
  final delegate = RoutemasterDelegate(routesBuilder: (context) => routeMap);

  return delegate;
});

final routeMapProvider = Provider<RouteMap>((ref) {
  final authState = ref.watch(authCtrlProvider);

  RouteMap routeMapMain() {
    return RouteMap(
      onUnknownRoute: (path) => const Redirect(RouteName.login),
      routes: {
        RouteName.root: (route) => authState == AuthState.authenticated
            ? const Redirect(RouteName.home)
            : const Redirect(RouteName.login),
        RouteName.login: (route) => const MaterialPage(child: LoginPage()),
        RouteName.home: (route) => const MaterialPage(child: HomePage()),
      },
    );
  }

  return routeMapMain();
});
