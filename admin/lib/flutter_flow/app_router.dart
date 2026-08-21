import 'dart:developer';

import 'package:auto_deal_admin/auth/firebase_auth/auth_util.dart';
import 'package:auto_deal_admin/backend/schema/enums/enums.dart';
import 'package:auto_deal_admin/flutter_flow/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router)async {
    await Future.delayed(const Duration(seconds: 1));
    bool authenticated = currentUserReference != null;

    if (authenticated) {
      log('auth guard next');
      resolver.next(true);
    } else {
      log('auth guard redirect');
      resolver.redirect(const LoginPageWidgetRoute());
    }
  }
}

class AdminAccessGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    bool authenticated = currentUserDocument != null;

    if (authenticated) {
      if (currentUserDocument!.role != Role.superuser) {
        return;
      } else {
        resolver.next(true);
      }
    } else {
      return;
    }
  }
}

@AutoRouterConfig(replaceInRouteName: 'Widget')
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          initial: true,
          path: '/splash',
          page: SplashWidgetRoute.page,
        ),
        AutoRoute(
          path: '/login',
          page: LoginPageWidgetRoute.page,
        ),
        AutoRoute(
          path: '/status',
          page: RegistrationStatusPageWidgetRoute.page,
        ),
        AutoRoute(
          path: '/singup',
          page: SignUpPageWidgetRoute.page,
        ),
        AutoRoute(
          path: '/home',
          guards: [AuthGuard()],
          page: HomeNavigatorWidgetRoute.page,
          children: [
            // AutoRoute(
            //   page: GuideTab.page,
            //   children: [
            //     AutoRoute(
            //       initial: true,
            //       path: 'guide',
            //       page: HomePageWidgetRoute.page,
            //     ),
            //     AutoRoute(
            //       path: 'guide_detail',
            //       page: GuideDetailWidgetRoute.page,
            //     ),
            //   ],
            // ),
            // AutoRoute(
            //   initial: true,
            //   path: 'guide',
            //   page: HomePageWidgetRoute.page,
            // ),
            // AutoRoute(
            //   path: 'content',
            //   page: ContentPageWidgetRoute.page,
            // ),
            // AutoRoute(
            //   page: UsersTab.page,
            //   children: [
            //     AutoRoute(
            //       initial: true,
            //       path: 'user',
            //       page: UserPageWidgetRoute.page,
            //     ),
            //     AutoRoute(
            //       path: 'user_detail',
            //       page: UserDetail.page,
            //     ),
            //     AutoRoute(
            //       path: 'event_detail',
            //       page: ConsultationInfoWidgetRoute.page,
            //     ),
            //   ],
            // ),
            // AutoRoute(
            //   page: ConsultationsTab.page,
            //   children: [
            //     AutoRoute(
            //       initial: true,
            //       path: 'consultation',
            //       page: ConsultationPageWidgetRoute.page,
            //     ),
            //     AutoRoute(
            //       path: 'event_detail',
            //       page: ConsultationInfoWidgetRoute.page,
            //     ),
            //     AutoRoute(
            //       path: 'guide_detail',
            //       page: GuideDetailWidgetRoute.page,
            //     ),
            //   ],
            // ),
            AutoRoute(
              initial: true,
              path: 'analytics',
              page: AnalyticsTab.page,
              children: [
                AutoRoute(
                  path: 'analytics_summary',
                  page: AnalyticsSummaryDataPageWidgetRoute.page,
                ),
                AutoRoute(
                  initial: true,
                  path: 'analytics_clients',
                  page: AnalyticsClientStatisticsPageWidgetRoute.page,
                ),
                AutoRoute(
                  path: 'user_complain_detail',
                  page: ComplaintUserPageWidgetRoute.page,
                ),
              ],
            ),
            AutoRoute(
              page: SupportTab.page,
              children: [
                AutoRoute(
                  initial: true,
                  path: 'support',
                  page: SupportPageWidgetRoute.page,
                ),
                AutoRoute(
                  path: 'deal_complain_detail',
                  page: OrderComplaintsPageWidgetRoute.page,
                ),
                AutoRoute(
                  path: 'deal_complain2_detail',
                  page: ComplaintOrderPageWidgetRoute.page,
                ),
                AutoRoute(
                  path: 'user_complain_detail',
                  page: ComplaintUserPageWidgetRoute.page,
                ),
              ],
            ),
            AutoRoute(
              path: 'chat',
              page: ChatPageWidgetRoute.page,
            ),
            AutoRoute(
              guards: [AdminAccessGuard()],
              path: 'staff',
              page: WorkersPageWidgetRoute.page,
            ),
            AutoRoute(
              path: 'profile',
              page: ProfilePageWidgetRoute.page,
            ),
            AutoRoute(
              path: 'setting',
              page: SettingPageWidgetRoute.page,
            ),
          ],
        ),
      ];
}

@RoutePage(name: 'AnalyticsTab')
class AnalyticsTabPage extends AutoRouter {
  const AnalyticsTabPage({super.key});
}

@RoutePage(name: 'SupportTab')
class SupportTabPage extends AutoRouter {
  const SupportTabPage({super.key});
}

class MyObserver extends AutoRouterObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    print('New route pushed: ${route.settings.name}');
  }

  // only override to observer tab routes
  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    print('Tab route visited: ${route.name}');
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    print('Tab route re-visited: ${route.name}');
  }
}
