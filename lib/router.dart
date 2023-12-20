import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tamirci/pages/new_service_page/new_service_page_view.dart';
import 'package:tamirci/pages/scanner_page/scanner_page_view.dart';

abstract class PagePaths {
  PagePaths._();

  static String login = "/login";
  static String register = "/register";
  static String loading = "/loading";
  static String newService = "/new-service";
  static String scanner = "/scanner";
}

final appRouter = GoRouter(
  initialLocation: PagePaths.newService,
  redirect: (context, state) {
    return null;
  },
  routes: [
    AppRoute(PagePaths.newService, (s) => const NewServicePageView()),
    AppRoute(
      PagePaths.scanner,
      (s) => ScannerPageView(
        servicePage: s.extra as ServicePages?,
      ),
    ),
  ],
);

class AppRoute extends GoRoute {
  AppRoute(
    String path,
    Widget Function(GoRouterState s) child,
  ) : super(
          path: path,
          pageBuilder: (context, state) {
            if (Platform.isIOS) {
              return CupertinoPage(child: child.call(state));
            }
            return MaterialPage(child: child.call(state));
          },
        );
}
