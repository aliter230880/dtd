// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_deal_admin/analytics_client_statistics_page/analytics_client_statistics_page_widget.dart'
    as _i1;
import 'package:auto_deal_admin/analytics_summary_data_page/analytics_summary_data_page_widget.dart'
    as _i2;
import 'package:auto_deal_admin/backend/backend.dart' as _i21;
import 'package:auto_deal_admin/chat_page/chat_page_widget.dart' as _i4;
import 'package:auto_deal_admin/complaint_order_page/complaint_order_page_widget.dart'
    as _i5;
import 'package:auto_deal_admin/complaint_user_page/complaint_user_page_widget.dart'
    as _i6;
import 'package:auto_deal_admin/flutter_flow/app_router.dart' as _i3;
import 'package:auto_deal_admin/login_page/login_page_widget.dart' as _i8;
import 'package:auto_deal_admin/main.dart' as _i7;
import 'package:auto_deal_admin/order_complaints_page/order_complaints_page_widget.dart'
    as _i9;
import 'package:auto_deal_admin/profile_page/profile_page_widget.dart' as _i10;
import 'package:auto_deal_admin/registration_status_page/registration_status_page_widget.dart'
    as _i11;
import 'package:auto_deal_admin/setting_page/setting_page_widget.dart' as _i12;
import 'package:auto_deal_admin/sign_up_page/sign_up_page_widget.dart' as _i13;
import 'package:auto_deal_admin/support_page/support_page_widget.dart' as _i14;
import 'package:auto_deal_admin/user_complaints_page/user_complaints_page_widget.dart'
    as _i15;
import 'package:auto_deal_admin/user_orders_page/user_orders_page_widget.dart'
    as _i16;
import 'package:auto_deal_admin/user_reviews_page/user_reviews_page_widget.dart'
    as _i17;
import 'package:auto_deal_admin/workers_page/workers_page_widget.dart' as _i18;
import 'package:auto_route/auto_route.dart' as _i19;
import 'package:flutter/material.dart' as _i20;

abstract class $AppRouter extends _i19.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i19.PageFactory> pagesMap = {
    AnalyticsClientStatisticsPageWidgetRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.AnalyticsClientStatisticsPageWidget(),
      );
    },
    AnalyticsSummaryDataPageWidgetRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.AnalyticsSummaryDataPageWidget(),
      );
    },
    AnalyticsTab.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.AnalyticsTabPage(),
      );
    },
    ChatPageWidgetRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.ChatPageWidget(),
      );
    },
    ComplaintOrderPageWidgetRoute.name: (routeData) {
      final args = routeData.argsAs<ComplaintOrderPageWidgetRouteArgs>();
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.ComplaintOrderPageWidget(
          key: args.key,
          dealsRecord: args.dealsRecord,
          complains: args.complains,
        ),
      );
    },
    ComplaintUserPageWidgetRoute.name: (routeData) {
      final args = routeData.argsAs<ComplaintUserPageWidgetRouteArgs>();
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i6.ComplaintUserPageWidget(
          key: args.key,
          user: args.user,
          appBarText: args.appBarText,
          complainsRecord: args.complainsRecord,
        ),
      );
    },
    HomeNavigatorWidgetRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.HomeNavigatorWidget(),
      );
    },
    LoginPageWidgetRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.LoginPageWidget(),
      );
    },
    OrderComplaintsPageWidgetRoute.name: (routeData) {
      final args = routeData.argsAs<OrderComplaintsPageWidgetRouteArgs>();
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i9.OrderComplaintsPageWidget(
          key: args.key,
          dealsRecord: args.dealsRecord,
        ),
      );
    },
    ProfilePageWidgetRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.ProfilePageWidget(),
      );
    },
    RegistrationStatusPageWidgetRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.RegistrationStatusPageWidget(),
      );
    },
    SettingPageWidgetRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.SettingPageWidget(),
      );
    },
    SignUpPageWidgetRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.SignUpPageWidget(),
      );
    },
    SplashWidgetRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.SplashWidget(),
      );
    },
    SupportPageWidgetRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i14.SupportPageWidget(),
      );
    },
    SupportTab.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.SupportTabPage(),
      );
    },
    UserComplaintsPageWidgetRoute.name: (routeData) {
      final args = routeData.argsAs<UserComplaintsPageWidgetRouteArgs>();
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i15.UserComplaintsPageWidget(
          key: args.key,
          isCarrier: args.isCarrier,
          userReference: args.userReference,
        ),
      );
    },
    UserOrdersPageWidgetRoute.name: (routeData) {
      final args = routeData.argsAs<UserOrdersPageWidgetRouteArgs>();
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i16.UserOrdersPageWidget(
          key: args.key,
          isCarrier: args.isCarrier,
          userReference: args.userReference,
        ),
      );
    },
    UserReviewsPageWidgetRoute.name: (routeData) {
      final args = routeData.argsAs<UserReviewsPageWidgetRouteArgs>();
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i17.UserReviewsPageWidget(
          key: args.key,
          isCarrier: args.isCarrier,
          userReference: args.userReference,
        ),
      );
    },
    WorkersPageWidgetRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i18.WorkersPageWidget(),
      );
    },
  };
}

/// generated route for
/// [_i1.AnalyticsClientStatisticsPageWidget]
class AnalyticsClientStatisticsPageWidgetRoute
    extends _i19.PageRouteInfo<void> {
  const AnalyticsClientStatisticsPageWidgetRoute(
      {List<_i19.PageRouteInfo>? children})
      : super(
          AnalyticsClientStatisticsPageWidgetRoute.name,
          initialChildren: children,
        );

  static const String name = 'AnalyticsClientStatisticsPageWidgetRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i2.AnalyticsSummaryDataPageWidget]
class AnalyticsSummaryDataPageWidgetRoute extends _i19.PageRouteInfo<void> {
  const AnalyticsSummaryDataPageWidgetRoute(
      {List<_i19.PageRouteInfo>? children})
      : super(
          AnalyticsSummaryDataPageWidgetRoute.name,
          initialChildren: children,
        );

  static const String name = 'AnalyticsSummaryDataPageWidgetRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i3.AnalyticsTabPage]
class AnalyticsTab extends _i19.PageRouteInfo<void> {
  const AnalyticsTab({List<_i19.PageRouteInfo>? children})
      : super(
          AnalyticsTab.name,
          initialChildren: children,
        );

  static const String name = 'AnalyticsTab';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i4.ChatPageWidget]
class ChatPageWidgetRoute extends _i19.PageRouteInfo<void> {
  const ChatPageWidgetRoute({List<_i19.PageRouteInfo>? children})
      : super(
          ChatPageWidgetRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChatPageWidgetRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i5.ComplaintOrderPageWidget]
class ComplaintOrderPageWidgetRoute
    extends _i19.PageRouteInfo<ComplaintOrderPageWidgetRouteArgs> {
  ComplaintOrderPageWidgetRoute({
    _i20.Key? key,
    required _i21.DealsRecord dealsRecord,
    required _i21.ComplainsRecord? complains,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          ComplaintOrderPageWidgetRoute.name,
          args: ComplaintOrderPageWidgetRouteArgs(
            key: key,
            dealsRecord: dealsRecord,
            complains: complains,
          ),
          initialChildren: children,
        );

  static const String name = 'ComplaintOrderPageWidgetRoute';

  static const _i19.PageInfo<ComplaintOrderPageWidgetRouteArgs> page =
      _i19.PageInfo<ComplaintOrderPageWidgetRouteArgs>(name);
}

class ComplaintOrderPageWidgetRouteArgs {
  const ComplaintOrderPageWidgetRouteArgs({
    this.key,
    required this.dealsRecord,
    required this.complains,
  });

  final _i20.Key? key;

  final _i21.DealsRecord dealsRecord;

  final _i21.ComplainsRecord? complains;

  @override
  String toString() {
    return 'ComplaintOrderPageWidgetRouteArgs{key: $key, dealsRecord: $dealsRecord, complains: $complains}';
  }
}

/// generated route for
/// [_i6.ComplaintUserPageWidget]
class ComplaintUserPageWidgetRoute
    extends _i19.PageRouteInfo<ComplaintUserPageWidgetRouteArgs> {
  ComplaintUserPageWidgetRoute({
    _i20.Key? key,
    required _i21.UsersRecord user,
    required String appBarText,
    required _i21.ComplainsRecord? complainsRecord,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          ComplaintUserPageWidgetRoute.name,
          args: ComplaintUserPageWidgetRouteArgs(
            key: key,
            user: user,
            appBarText: appBarText,
            complainsRecord: complainsRecord,
          ),
          initialChildren: children,
        );

  static const String name = 'ComplaintUserPageWidgetRoute';

  static const _i19.PageInfo<ComplaintUserPageWidgetRouteArgs> page =
      _i19.PageInfo<ComplaintUserPageWidgetRouteArgs>(name);
}

class ComplaintUserPageWidgetRouteArgs {
  const ComplaintUserPageWidgetRouteArgs({
    this.key,
    required this.user,
    required this.appBarText,
    required this.complainsRecord,
  });

  final _i20.Key? key;

  final _i21.UsersRecord user;

  final String appBarText;

  final _i21.ComplainsRecord? complainsRecord;

  @override
  String toString() {
    return 'ComplaintUserPageWidgetRouteArgs{key: $key, user: $user, appBarText: $appBarText, complainsRecord: $complainsRecord}';
  }
}

/// generated route for
/// [_i7.HomeNavigatorWidget]
class HomeNavigatorWidgetRoute extends _i19.PageRouteInfo<void> {
  const HomeNavigatorWidgetRoute({List<_i19.PageRouteInfo>? children})
      : super(
          HomeNavigatorWidgetRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeNavigatorWidgetRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i8.LoginPageWidget]
class LoginPageWidgetRoute extends _i19.PageRouteInfo<void> {
  const LoginPageWidgetRoute({List<_i19.PageRouteInfo>? children})
      : super(
          LoginPageWidgetRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginPageWidgetRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i9.OrderComplaintsPageWidget]
class OrderComplaintsPageWidgetRoute
    extends _i19.PageRouteInfo<OrderComplaintsPageWidgetRouteArgs> {
  OrderComplaintsPageWidgetRoute({
    _i20.Key? key,
    required _i21.DealsRecord dealsRecord,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          OrderComplaintsPageWidgetRoute.name,
          args: OrderComplaintsPageWidgetRouteArgs(
            key: key,
            dealsRecord: dealsRecord,
          ),
          initialChildren: children,
        );

  static const String name = 'OrderComplaintsPageWidgetRoute';

  static const _i19.PageInfo<OrderComplaintsPageWidgetRouteArgs> page =
      _i19.PageInfo<OrderComplaintsPageWidgetRouteArgs>(name);
}

class OrderComplaintsPageWidgetRouteArgs {
  const OrderComplaintsPageWidgetRouteArgs({
    this.key,
    required this.dealsRecord,
  });

  final _i20.Key? key;

  final _i21.DealsRecord dealsRecord;

  @override
  String toString() {
    return 'OrderComplaintsPageWidgetRouteArgs{key: $key, dealsRecord: $dealsRecord}';
  }
}

/// generated route for
/// [_i10.ProfilePageWidget]
class ProfilePageWidgetRoute extends _i19.PageRouteInfo<void> {
  const ProfilePageWidgetRoute({List<_i19.PageRouteInfo>? children})
      : super(
          ProfilePageWidgetRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfilePageWidgetRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i11.RegistrationStatusPageWidget]
class RegistrationStatusPageWidgetRoute extends _i19.PageRouteInfo<void> {
  const RegistrationStatusPageWidgetRoute({List<_i19.PageRouteInfo>? children})
      : super(
          RegistrationStatusPageWidgetRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegistrationStatusPageWidgetRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i12.SettingPageWidget]
class SettingPageWidgetRoute extends _i19.PageRouteInfo<void> {
  const SettingPageWidgetRoute({List<_i19.PageRouteInfo>? children})
      : super(
          SettingPageWidgetRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingPageWidgetRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i13.SignUpPageWidget]
class SignUpPageWidgetRoute extends _i19.PageRouteInfo<void> {
  const SignUpPageWidgetRoute({List<_i19.PageRouteInfo>? children})
      : super(
          SignUpPageWidgetRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpPageWidgetRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i7.SplashWidget]
class SplashWidgetRoute extends _i19.PageRouteInfo<void> {
  const SplashWidgetRoute({List<_i19.PageRouteInfo>? children})
      : super(
          SplashWidgetRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashWidgetRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i14.SupportPageWidget]
class SupportPageWidgetRoute extends _i19.PageRouteInfo<void> {
  const SupportPageWidgetRoute({List<_i19.PageRouteInfo>? children})
      : super(
          SupportPageWidgetRoute.name,
          initialChildren: children,
        );

  static const String name = 'SupportPageWidgetRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i3.SupportTabPage]
class SupportTab extends _i19.PageRouteInfo<void> {
  const SupportTab({List<_i19.PageRouteInfo>? children})
      : super(
          SupportTab.name,
          initialChildren: children,
        );

  static const String name = 'SupportTab';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i15.UserComplaintsPageWidget]
class UserComplaintsPageWidgetRoute
    extends _i19.PageRouteInfo<UserComplaintsPageWidgetRouteArgs> {
  UserComplaintsPageWidgetRoute({
    _i20.Key? key,
    required bool? isCarrier,
    required _i21.DocumentReference<Object?>? userReference,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          UserComplaintsPageWidgetRoute.name,
          args: UserComplaintsPageWidgetRouteArgs(
            key: key,
            isCarrier: isCarrier,
            userReference: userReference,
          ),
          initialChildren: children,
        );

  static const String name = 'UserComplaintsPageWidgetRoute';

  static const _i19.PageInfo<UserComplaintsPageWidgetRouteArgs> page =
      _i19.PageInfo<UserComplaintsPageWidgetRouteArgs>(name);
}

class UserComplaintsPageWidgetRouteArgs {
  const UserComplaintsPageWidgetRouteArgs({
    this.key,
    required this.isCarrier,
    required this.userReference,
  });

  final _i20.Key? key;

  final bool? isCarrier;

  final _i21.DocumentReference<Object?>? userReference;

  @override
  String toString() {
    return 'UserComplaintsPageWidgetRouteArgs{key: $key, isCarrier: $isCarrier, userReference: $userReference}';
  }
}

/// generated route for
/// [_i16.UserOrdersPageWidget]
class UserOrdersPageWidgetRoute
    extends _i19.PageRouteInfo<UserOrdersPageWidgetRouteArgs> {
  UserOrdersPageWidgetRoute({
    _i20.Key? key,
    required bool? isCarrier,
    required _i21.DocumentReference<Object?>? userReference,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          UserOrdersPageWidgetRoute.name,
          args: UserOrdersPageWidgetRouteArgs(
            key: key,
            isCarrier: isCarrier,
            userReference: userReference,
          ),
          initialChildren: children,
        );

  static const String name = 'UserOrdersPageWidgetRoute';

  static const _i19.PageInfo<UserOrdersPageWidgetRouteArgs> page =
      _i19.PageInfo<UserOrdersPageWidgetRouteArgs>(name);
}

class UserOrdersPageWidgetRouteArgs {
  const UserOrdersPageWidgetRouteArgs({
    this.key,
    required this.isCarrier,
    required this.userReference,
  });

  final _i20.Key? key;

  final bool? isCarrier;

  final _i21.DocumentReference<Object?>? userReference;

  @override
  String toString() {
    return 'UserOrdersPageWidgetRouteArgs{key: $key, isCarrier: $isCarrier, userReference: $userReference}';
  }
}

/// generated route for
/// [_i17.UserReviewsPageWidget]
class UserReviewsPageWidgetRoute
    extends _i19.PageRouteInfo<UserReviewsPageWidgetRouteArgs> {
  UserReviewsPageWidgetRoute({
    _i20.Key? key,
    required bool? isCarrier,
    required _i21.DocumentReference<Object?>? userReference,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          UserReviewsPageWidgetRoute.name,
          args: UserReviewsPageWidgetRouteArgs(
            key: key,
            isCarrier: isCarrier,
            userReference: userReference,
          ),
          initialChildren: children,
        );

  static const String name = 'UserReviewsPageWidgetRoute';

  static const _i19.PageInfo<UserReviewsPageWidgetRouteArgs> page =
      _i19.PageInfo<UserReviewsPageWidgetRouteArgs>(name);
}

class UserReviewsPageWidgetRouteArgs {
  const UserReviewsPageWidgetRouteArgs({
    this.key,
    required this.isCarrier,
    required this.userReference,
  });

  final _i20.Key? key;

  final bool? isCarrier;

  final _i21.DocumentReference<Object?>? userReference;

  @override
  String toString() {
    return 'UserReviewsPageWidgetRouteArgs{key: $key, isCarrier: $isCarrier, userReference: $userReference}';
  }
}

/// generated route for
/// [_i18.WorkersPageWidget]
class WorkersPageWidgetRoute extends _i19.PageRouteInfo<void> {
  const WorkersPageWidgetRoute({List<_i19.PageRouteInfo>? children})
      : super(
          WorkersPageWidgetRoute.name,
          initialChildren: children,
        );

  static const String name = 'WorkersPageWidgetRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}
