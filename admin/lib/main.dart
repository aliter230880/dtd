import 'dart:developer';

import 'package:auto_deal_admin/backend/backend.dart';
import 'package:auto_deal_admin/flutter_flow/app_router.gr.dart';
import 'package:auto_deal_admin/flutter_flow/flutter_flow_theme.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
// ignore: depend_on_referenced_packages

import 'app_state.dart';
import 'auth/firebase_auth/firebase_user_provider.dart';
import 'auth/firebase_auth/auth_util.dart';

import 'backend/firebase/firebase_config.dart';
import 'backend/schema/enums/enums.dart';
import 'components/home_nav_bar_widget.dart';
import 'flutter_flow/app_router.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/nav/nav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // GoRouter.optionURLReflectsImperativeAPIs = true;
  // usePathUrlStrategy();
  await initFirebase();

  // ignore: unused_local_variable
  final appState = FFAppState();

  runApp(Phoenix(child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  // ignore: library_private_types_in_public_api
  static _MyAppState of(BuildContext context) => context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  late AppStateNotifier _appStateNotifier;
  // late GoRouter _router;

  late Stream<BaseAuthUser> userStream;

  final authUserSub = authenticatedUserStream.listen((_) {});

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    // _router = createRouter(_appStateNotifier);
    userStream = autoDealAdminFirebaseUserStream()
      ..listen((user) {
        _appStateNotifier.update(user);
      });
    jwtTokenStream.listen((_) {});
    Future.delayed(
      const Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  @override
  void dispose() {
    authUserSub.cancel();

    super.dispose();
  }

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
      });

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'DTD ADMIN',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _appRouter.config(
        navigatorObservers: () => [MyObserver()],
      ),
    );
  }
}

@RoutePage()
class SplashWidget extends StatefulWidget {
  const SplashWidget({super.key});

  @override
  State<SplashWidget> createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    final router = AutoRouter.of(context);
    await Future.delayed(const Duration(seconds: 1));

    bool hasReference = currentUserReference != null;

    if (!hasReference) {
      log('GO TO LOGIN: no reference');
      router.replace(const LoginPageWidgetRoute());
      return;
    }

    final admin = await getAdmin();

    if (admin == null) {
      log('GO TO LOGIN: Admin is null');
      router.replace(const LoginPageWidgetRoute());
      return;
    }

    if (admin.status != AdminStatus.accept) {
      log('GO TO Wait: no accepted');
      router.replace(const SignUpPageWidgetRoute());
      return;
    }

    log('GO TO Home: ');
    router.replace(const ProfilePageWidgetRoute());
  }

  Future<AdminsRecord?> getAdmin() async {
    final user = await AdminsRecord.getDocumentOnce(currentUserReference!);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      color: FlutterFlowTheme.of(context).primary,
      child: Center(
        child: Container(
          width: double.infinity,
          height: 180.0,
          decoration: const BoxDecoration(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              'assets/images/splash_logo.png',
              width: double.infinity,
              height: 180.0,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

@RoutePage()
class HomeNavigatorWidget extends StatefulWidget {
  const HomeNavigatorWidget({super.key});

  @override
  State<HomeNavigatorWidget> createState() => _HomeNavigatorWidgetState();
}

final destinations = [
  const AnalyticsClientStatisticsPageWidgetRoute(),
  const AnalyticsSummaryDataPageWidgetRoute(),
  const SupportPageWidgetRoute(),
  const ChatPageWidgetRoute(),
  const WorkersPageWidgetRoute(),
  const ProfilePageWidgetRoute(),
  const SettingPageWidgetRoute(),
];

class _HomeNavigatorWidgetState extends State<HomeNavigatorWidget> {
  @override
  Widget build(BuildContext context) {
    return AutoRouter(
      builder: (context, child) {
        var activeIndex = destinations.indexWhere(
          (d) => context.router.isRouteActive(d.routeName),
        );
        // there might be no active route until router is mounted
        // so we play safe
        if (activeIndex == -1) {
          activeIndex = 0;
        }

        return Material(
          child: Row(
            children: [
              HomeNavBarWidget(currentIndex: activeIndex),
              Expanded(child: child),
            ],
          ),
        );
      },
    );
    //  print(GoRouter.of(context).routerDelegate.currentConfiguration.matches.map((e) => e.matchedLocation));
    // print(GoRouter.of(context).canPop());
    // return AutoTabsRouter(
    //   routes: const [
    //     HomePageWidgetRoute(),
    //     ContentPageWidgetRoute(),
    //     UserPageWidgetRoute(),
    //     ConsultationPageWidgetRoute(),
    //     ChatPageWidgetRoute(),
    //     WithdrawPageWidgetRoute(),
    //     PromoCodePageWidgetRoute(),
    //     StaffPageWidgetRoute(),
    //     ProfilePageWidgetRoute(),
    //   ],
    //   builder: (context, child) {
    //     final tabsRouter = AutoTabsRouter.of(context);
    //     return Scaffold(
    //       backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
    //       body: SafeArea(
    //         top: true,
    //         child: Row(
    //           children: [
    //             HomeNavBarWidget(tabsRouter: tabsRouter),
    //             Expanded(child: child),
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );
  }
}
