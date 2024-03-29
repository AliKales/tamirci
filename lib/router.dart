import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tamirci/core/firebase/f_auth.dart';
import 'package:tamirci/core/models/m_customer.dart';
import 'package:tamirci/core/models/m_service.dart';
import 'package:tamirci/core/models/m_vehicle.dart';
import 'package:tamirci/pages/auth/login_page_view.dart';
import 'package:tamirci/pages/auth/register_page_view.dart';
import 'package:tamirci/pages/create_shop_page/create_shop_page_view.dart';
import 'package:tamirci/pages/customer_page/customer_page_view.dart';
import 'package:tamirci/pages/iban_page/iban_page_view.dart';
import 'package:tamirci/pages/image_page/image_page_view.dart';
import 'package:tamirci/pages/loading_page/loading_page_view.dart';
import 'package:tamirci/pages/main_page/main_page_view.dart';
import 'package:tamirci/pages/pdf_service_page/pdf_service_page.dart';
import 'package:tamirci/pages/scanner_page/scanner_page_view.dart';
import 'package:tamirci/pages/search_page/search_page_view.dart';
import 'package:tamirci/pages/stats_page/stats_page_view.dart';
import 'package:tamirci/pages/vehicle_page/vehicle_page_view.dart';

import 'pages/service_page/service_page_view.dart';

abstract class PagePaths {
  PagePaths._();

  static String main = "/";
  static String login = "/login";
  static String register = "/register";
  static String loading = "/loading";
  static String service = "/service";
  static String scanner = "/scanner";
  static String createShop = "/create-shop";
  static String search = "/search";
  static String customer = "/customer";
  static String vehicle = "/vehicle";
  static String iban = "/iban";
  static String image = "/image";
  static String stats = "/stats";
  static String pdfService = "/pdf-service";
}

final appRouter = GoRouter(
  initialLocation: PagePaths.loading,
  redirect: (context, state) {
    if (!FAuth.isLoggedIn && state.fullPath != PagePaths.register) {
      return PagePaths.login;
    }
    return null;
  },
  routes: [
    AppRoute(PagePaths.main, (s) => const MainPageView()),
    AppRoute(
      PagePaths.service,
      (s) => ServicePageView(
        service: s.extra as MService?,
      ),
    ),
    AppRoute(PagePaths.login, (s) => const LoginPageView()),
    AppRoute(PagePaths.register, (s) => const RegisterPageView()),
    AppRoute(PagePaths.loading, (s) => const LoadingPageView()),
    AppRoute(PagePaths.createShop, (s) => const CreateShopPageView()),
    AppRoute(PagePaths.search, (s) => const SearchPageView()),
    AppRoute(PagePaths.iban, (s) => const IbanPageView()),
    AppRoute(PagePaths.stats, (s) => const StatsPageView()),
    AppRoute(
      PagePaths.pdfService,
      (s) => PdfServicePage(
        service: s.extra as MService,
      ),
    ),
    AppRoute(
      PagePaths.image,
      (s) => ImagePageView(
        m: s.extra as MImagePage,
      ),
    ),
    AppRoute(
      PagePaths.vehicle,
      (s) => VehiclePageView(
        data: s.extra as MapEntry<MCustomer, MVehicle>,
      ),
    ),
    AppRoute(
      PagePaths.customer,
      (s) => CustomerPageView(
        customer: s.extra as MCustomer,
      ),
    ),
    if (!kIsWeb)
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
            if (!kIsWeb && Platform.isIOS) {
              return CupertinoPage(child: child.call(state));
            }
            return MaterialPage(child: child.call(state));
          },
        );
}
