import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khoroch/View/Auth/login.dart';
import 'package:khoroch/View/groups/create_group.dart';
import 'package:khoroch/View/groups/group_expend_view.dart';
import 'package:khoroch/View/home/home_view.dart';
import 'package:khoroch/View/trash/trash_view.dart';
import 'package:khoroch/View/user/user_view.dart';
import 'package:khoroch/routes/pages/splash.dart';
import 'package:khoroch/services/controllers/controllers.dart';
import 'package:khoroch/services/providers/providers.dart';
import 'package:routemaster/routemaster.dart';

class RouteName {
  static const String root = '/';
  static const String login = '/login';
  static const String home = '/home';
  static String group(String gid) => '$home/group/$gid';
  static String userFromGroup(gid, uid) => '${group(gid)}/$uid';
  static const String createGroup = '$home/create_group';
  static const String splash = '/splash';
  static String trash(gid) => '${group(gid)}/trash';
}

class RouteLogObserver extends RoutemasterObserver {
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

  log('auth : ${authState.name}');

  RouteMap routeMap() {
    if (authState == AuthState.unauthenticated) {
      return RouteMap(
        onUnknownRoute: (path) {
          log('unknown : $path');
          return const Redirect(RouteName.login);
        },
        routes: {
          RouteName.root: (route) => const MaterialPage(child: LoginPage()),
          RouteName.login: (route) => const MaterialPage(child: LoginPage()),
        },
      );
    } else if (authState == AuthState.loading) {
      return RouteMap(
        routes: {
          RouteName.root: (route) => const MaterialPage(child: SplashScreen()),
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
                : const MaterialPage(child: HomeView());
          },
          RouteName.splash: (route) =>
              splashGuard(page: const MaterialPage(child: SplashScreen())),
          RouteName.login: (route) =>
              splashGuard(page: const MaterialPage(child: LoginPage())),
          RouteName.home: (route) =>
              splashGuard(page: const MaterialPage(child: HomeView())),
          RouteName.group(':gid'): (route) {
            final id = route.pathParameters['gid'];
            return splashGuard(
                page: MaterialPage(child: GroupExpanseView(id!)));
          },
          RouteName.createGroup: (route) =>
              splashGuard(page: const MaterialPage(child: CreateGroup())),
          RouteName.userFromGroup(':gid', ':uid'): (route) {
            final uid = route.pathParameters['uid'];
            final gId = route.pathParameters['gid'];
            return splashGuard(
              page: MaterialPage(
                fullscreenDialog: true,
                child: UserDetails(uid: uid!, groupId: gId!),
              ),
            );
          },
          RouteName.trash(':gid'): (route) {
            final gid = route.pathParameters['gid'];
            final owner = route.queryParameters['owner'];
            return splashGuard(
                page: MaterialPage(child: TrashView(gid!, owner!)));
          },
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
