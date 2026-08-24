import 'dart:async';

import 'package:auto_deal_app/auth/firebase_auth/auth_util.dart';
import 'package:auto_deal_app/carrier/carrier_active_deals.dart';
import 'package:auto_deal_app/carrier/carrier_dispute_delas.dart';
import 'package:auto_deal_app/carrier/carrier_need_confirm_deals.dart';
import 'package:auto_deal_app/carrier/carrier_responded_deals.dart';
import 'package:auto_deal_app/chat_room_page/chat_room_page_widget.dart';
import 'package:auto_deal_app/diller/edit_deal/steps/edit_address_page.dart';
import 'package:auto_deal_app/diller/edit_deal/steps/edit_auction_page.dart';
import 'package:auto_deal_app/diller/edit_deal/steps/edit_deadline_page.dart';
import 'package:auto_deal_app/diller/edit_deal/steps/edit_desc_page.dart';
import 'package:auto_deal_app/diller/edit_deal/steps/edit_files_page.dart';
import 'package:auto_deal_app/diller/edit_deal/steps/edit_name_page.dart';
import 'package:auto_deal_app/diller/edit_deal/steps/edit_paytype_page.dart';
import 'package:auto_deal_app/diller/edit_deal/steps/edit_price_page.dart';
import 'package:auto_deal_app/pages/deal_detail_diller/deal_documents_widget.dart';
import 'package:auto_deal_app/pages/deal_detail_diller/deal_responses_widget.dart';
import 'package:auto_deal_app/pages/deal_detail_diller/deal_user_profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '/backend/backend.dart';
import '/backend/push_notifications/push_notifications_handler.dart' show PushNotificationsHandler;

import '/index.dart';
import '/main.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  BaseAuthUser? initialUser;
  BaseAuthUser? user;
  bool showSplashImage = true;
  String? _redirectLocation;

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched or
  /// on an unexpected logout. However, this must be turned off when we
  /// intend to sign in/out and then navigate or perform any actions after.
  /// Otherwise, this will trigger a refresh and interrupt the action(s).
  bool notifyOnAuthChange = true;

  bool get loading => user == null || showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  /// Mark as not needing to notify on a sign in / out when we intend
  /// to perform subsequent actions (such as navigation) afterwards.
  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(BaseAuthUser newUser) {
    final shouldUpdate = user?.uid == null || newUser.uid == null || user?.uid != newUser.uid;
    initialUser ??= newUser;
    user = newUser;
    // Refresh the app on auth change unless explicitly marked otherwise.
    // No need to update unless the user has changed.
    if (notifyOnAuthChange && shouldUpdate) {
      notifyListeners();
    }
    // Once again mark the notifier as needing to update on auth change
    // (in order to catch sign in / out events).
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      errorBuilder: (context, state) => appStateNotifier.loggedIn ? const NavBarPage() : const OnboardPageWidget(),
      routes: [
        GoRoute(
          name: 'EditDealName',
          path: '/editDealName',
          builder: (context, state) => EditDealNamePage(deal: state.extraMap['deal'] as DealsRecord?),
        ),
        GoRoute(
          name: 'EditDealDesc',
          path: '/editDealDesc',
          builder: (context, state) => EditDealDescPage(deal: state.extraMap['deal'] as DealsRecord?),
        ),
        GoRoute(
          name: 'EditDealAddress',
          path: '/editDealAddress',
          builder: (context, state) => EditDealAddressPage(deal: state.extraMap['deal'] as DealsRecord?),
        ),
        GoRoute(
          name: 'EditDealAuction',
          path: '/editDealAuction',
          builder: (context, state) => EditDealAuctionPage(deal: state.extraMap['deal'] as DealsRecord?),
        ),
        GoRoute(
          name: 'EditDealDeadline',
          path: '/editDealDeadline',
          builder: (context, state) => EditDealDeadlinePage(deal: state.extraMap['deal'] as DealsRecord?),
        ),
        GoRoute(
          name: 'EditDealPrice',
          path: '/editDealPrice',
          builder: (context, state) => EditDealPricePage(deal: state.extraMap['deal'] as DealsRecord?),
        ),
        GoRoute(
          name: 'EditDealPayType',
          path: '/editDealPayType',
          builder: (context, state) => EditDealPayTypePage(deal: state.extraMap['deal'] as DealsRecord?),
        ),
        GoRoute(
          name: 'EditDealFiles',
          path: '/editDealFiles',
          builder: (context, state) => EditDealFilesPage(deal: state.extraMap['deal'] as DealsRecord?),
        ),
        ...[
          FFRoute(
            name: '_initialize',
            path: '/',
            // builder: (context, _) =>
            //     appStateNotifier.loggedIn ? const NavBarPage() : const OnboardPageWidget(),
            builder: (context, _) {
              if (appStateNotifier.loggedIn) {
                // if (currentUserDocument?.profileFilled ?? false) {
                //   return const NavBarPage();
                // } else {
                //   return const FillProfileMainWidget();
                // }
                return const NavBarPage();
              } else {
                return const OnboardPageWidget();
              }
            },
          ),
          FFRoute(
            name: 'HomePage',
            path: '/homePage',
            builder: (context, params) =>
                params.isEmpty ? const NavBarPage(initialPage: 'HomePage') : const HomePageWidget(),
          ),
          FFRoute(
            name: 'onboardPage',
            path: '/onboardPage',
            builder: (context, params) => const OnboardPageWidget(),
          ),
          FFRoute(
            name: 'splash_page',
            path: '/splashPage',
            builder: (context, params) => const SplashPageWidget(),
          ),
          FFRoute(
            name: 'login_page',
            path: '/loginPage',
            builder: (context, params) => const LoginPageWidget(),
          ),
          FFRoute(
            name: 'forgot_password_page',
            path: '/forgotPasswordPage',
            builder: (context, params) => const ForgotPasswordPageWidget(),
          ),
          FFRoute(
            name: 'registration_page',
            path: '/registrationPage',
            builder: (context, params) => const RegistrationPageWidget(),
          ),
          FFRoute(
            name: 'fill_profile_main',
            path: '/fillProfileMain',
            builder: (context, params) => const FillProfileMainWidget(),
          ),
          FFRoute(
            name: 'fill_profile_type',
            path: '/fillProfileType',
            builder: (context, params) => const FillProfileTypeWidget(),
          ),
          FFRoute(
            name: 'fill_profile_carrier',
            path: '/fillProfileCarrier',
            builder: (context, params) => const FillProfileCarrierWidget(),
          ),
          FFRoute(
            name: 'fill_profile_diller',
            path: '/fillProfileDiller',
            builder: (context, params) => const FillProfileDillerWidget(),
          ),
          FFRoute(
            name: 'fill_profile_car_numbers',
            path: '/fillProfileCarNumbers',
            builder: (context, params) => const FillProfileCarNumbersWidget(),
          ),
          FFRoute(
            name: 'OrderTab',
            path: '/orderTab',
            builder: (context, params) =>
                params.isEmpty ? const NavBarPage(initialPage: 'OrderTab') : const OrderTabWidget(),
          ),
          FFRoute(
            name: 'ChatTab',
            path: '/chatTab',
            builder: (context, params) =>
                params.isEmpty ? const NavBarPage(initialPage: 'ChatTab') : const ChatTabWidget(),
          ),
          FFRoute(
            name: 'ProfileTab',
            path: '/profileTab',
            builder: (context, params) =>
                params.isEmpty ? const NavBarPage(initialPage: 'ProfileTab') : const ProfileTabWidget(),
          ),
          FFRoute(
            name: 'CreateDealPage',
            path: '/createDealPage',
            builder: (context, params) => const CreateDealPageWidget(),
          ),
          FFRoute(
            name: 'DillerActiveDeals',
            path: '/dillerActiveDeals',
            builder: (context, params) => const DillerActiveDealsWidget(),
          ),
          FFRoute(
            name: 'DillerDisputeDeals',
            path: '/dillerDisputeDeals',
            builder: (context, params) => const DillerDisputeDealsWidget(),
          ),
          FFRoute(
            name: 'EditDeal',
            path: '/editDeal',
            asyncParams: {
              'deal': getDoc(['deals'], DealsRecord.fromSnapshot),
            },
            builder: (context, params) => EditDealWidget(
              deal: params.getParam('deal', ParamType.Document),
            ),
          ),
          FFRoute(
            name: 'WalletPage',
            path: '/walletPage',
            builder: (context, params) => const WalletPageWidget(),
          ),
          FFRoute(
            name: 'HistoryPage',
            path: '/historyPage',
            builder: (context, params) => HistoryPageWidget(
              userRef: params.getParam(
                'userRef',
                ParamType.DocumentReference,
                isList: false,
                collectionNamePath: ['users'],
              ),
            ),
          ),
          FFRoute(
            name: 'ReviewsPage',
            path: '/reviewsPage',
            builder: (context, params) => ReviewsPageWidget(
              userRef: params.getParam(
                'userRef',
                ParamType.DocumentReference,
                isList: false,
                collectionNamePath: ['users'],
              ),
            ),
          ),
          FFRoute(
            name: 'TransactionsPage',
            path: '/transactionsPage',
            builder: (context, params) => const TransactionsPageWidget(),
          ),
          FFRoute(
            name: 'EditProfile',
            path: '/editProfile',
            builder: (context, params) => const EditProfileWidget(),
          ),
          FFRoute(
            name: 'EditDillerProfile1',
            path: '/editDillerProfile1',
            builder: (context, params) => const EditDillerProfile1Widget(),
          ),
          FFRoute(
            name: 'EditDillerProfile2',
            path: '/editDillerProfile2',
            builder: (context, params) => const EditDillerProfile2Widget(),
          ),
          FFRoute(
            name: 'EditCarrierProfile1',
            path: '/editCarrierProfile1',
            builder: (context, params) => const EditCarrierProfile1Widget(),
          ),
          FFRoute(
            name: 'UserBannedPage',
            path: '/userBannedPage',
            builder: (context, params) => const UserBannedPageWidget(),
          ),
          FFRoute(
            name: 'UserProfile',
            path: '/userProfile',
            builder: (context, params) => UserProfileWidget(
              user: params.getParam(
                'user',
                ParamType.DocumentReference,
                isList: false,
                collectionNamePath: ['users'],
              ),
            ),
          ),
          FFRoute(
            name: 'NotificationsPage',
            path: '/notificationsPage',
            builder: (context, params) => const NotificationsPageWidget(),
          ),
          FFRoute(
            name: 'FilterPage',
            path: '/filterPage',
            builder: (context, params) => const FilterPageWidget(),
          ),
          FFRoute(
            name: 'FilterLocationPage',
            path: '/filterLocationPage',
            builder: (context, params) => const FilterLocationPageWidget(),
          ),
          FFRoute(
            name: 'DealDetailDiller',
            path: '/dealDetailDiller',
            builder: (context, params) => DealDetailDillerWidget(
              dealRef: params.getParam(
                'dealRef',
                ParamType.DocumentReference,
                isList: false,
                collectionNamePath: ['deals'],
              ),
            ),
          ),
          FFRoute(
            name: 'DealDetailCarrier',
            path: '/dealDetailCarrier',
            builder: (context, params) => DealDetailCarrierWidget(
              dealRef: params.getParam(
                'dealRef',
                ParamType.DocumentReference,
                isList: false,
                collectionNamePath: ['deals'],
              ),
            ),
          ),
          FFRoute(
            name: 'ChatRoomPage',
            path: '/chatRoomPage',
            asyncParams: {
              'chat': getDoc(['chats'], ChatsRecord.fromSnapshot),
            },
            builder: (context, params) => ChatRoomPageWidget(
              chat: params.getParam(
                'chat',
                ParamType.Document,
              ),
            ),
          ),
          FFRoute(
            name: 'CarrierActiveDeals',
            path: '/carrierActiveDeals',
            builder: (context, params) => CarrierActiveDealsWidget(
              length: params.getParam('length', ParamType.int),
            ),
          ),
          FFRoute(
            name: 'CarrierNeedConfirmDeals',
            path: '/carrierNeedConfirmDeals',
            builder: (context, params) => CarrierNeedConfirmDealsWidget(
              length: params.getParam('length', ParamType.int),
            ),
          ),
          FFRoute(
            name: 'CarrierDisputeDeals',
            path: '/carrierDisputeDeals',
            builder: (context, params) => CarrierDisputeDealsWidget(
              length: params.getParam('length', ParamType.int),
            ),
          ),
          FFRoute(
            name: 'CarrierRespondedDeals',
            path: '/carrierRespondedDeals',
            builder: (context, params) => CarrierRespondedDealsWidget(
              length: params.getParam('length', ParamType.int),
            ),
          ),
          FFRoute(
            name: 'DealDocuments',
            path: '/dealDocuments',
            asyncParams: {
              'deal': getDoc(['deals'], DealsRecord.fromSnapshot),
            },
            builder: (context, params) => DealDocuments(
              deal: params.getParam('deal', ParamType.Document),
            ),
          ),
          FFRoute(
            name: 'DealResponses',
            path: '/dealResponses',
            asyncParams: {
              'deal': getDoc(['deals'], DealsRecord.fromSnapshot),
            },
            builder: (context, params) => DealResponsesWidget(
              deal: params.getParam('deal', ParamType.Document),
            ),
          ),
          FFRoute(
            name: 'DealUserProfile',
            path: '/dealUserProfile',
            asyncParams: {
              'deal': getDoc(['deals'], DealsRecord.fromSnapshot),
            },
            builder: (context, params) => DealUserProfileWidget(
              userRef: params.getParam(
                'userRef',
                ParamType.DocumentReference,
                isList: false,
                collectionNamePath: ['users'],
              ),
              deal: params.getParam('deal', ParamType.Document),
            ),
          ),
          FFRoute(
            name: 'CarrierVerificationPage',
            path: '/carrierVerificationPage',
            builder: (context, params) => const CarrierVerificationPageWidget(),
          ),
          // ignore: unnecessary_to_list_in_spreads
        ].map((r) => r.toRoute(appStateNotifier)).toList(),
      ],
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries.where((e) => e.value != null).map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : goNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : pushNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

void clearAndNavigate(BuildContext context, String path, {Map<String, dynamic>? queryParameters}) {
  while (context.canPop() == true) {
    context.pop();
  }
  if (queryParameters == null) {
    context.pushReplacementNamed(path);
  } else {
    context.pushReplacementNamed(path, queryParameters: queryParameters);
  }
}


extension GoRouterExtensions on GoRouter {
  AppStateNotifier get appState => AppStateNotifier.instance;
  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState.hasRedirect() && !ignoreRedirect ? null : appState.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) => !ignoreRedirect && appState.hasRedirect();
  void clearRedirectLocation() => appState.clearRedirectLocation();
  void setRedirectLocationIfUnset(String location) => appState.updateNotifyOnAuthChange(false);
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap => extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty || (state.allParams.length == 1 && state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) => asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value).onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
    List<String>? collectionNamePath,
    StructBuilder<T>? structBuilder,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
      collectionNamePath: collectionNamePath,
      structBuilder: structBuilder,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        redirect: (context, state) {
          if (appStateNotifier.shouldRedirect) {
            final redirectLocation = appStateNotifier.getRedirectLocation();
            appStateNotifier.clearRedirectLocation();
            return redirectLocation;
          }

          if (requireAuth && !appStateNotifier.loggedIn) {
            appStateNotifier.setRedirectLocationIfUnset(state.uri.toString());
            return '/onboardPage';
          }
          return null;
        },
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = appStateNotifier.loading
              ? Container(
                  color: FlutterFlowTheme.of(context).primaryText,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/logo.svg',
                      width: 158.0,
                      height: 158.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : PushNotificationsHandler(child: page);

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder: (context, animation, secondaryAnimation, child) => PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => const TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage && location != '/' && location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList =
        lastMatch is ImperativeRouteMatch ? lastMatch.matches : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
