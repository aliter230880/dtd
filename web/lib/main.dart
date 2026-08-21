// ignore_for_file: deprecated_member_use

import 'package:auto_deal_app/backend/backend.dart';
import 'package:auto_deal_app/backend/schema/enums/enums.dart';
import 'package:auto_deal_app/components/create_deal_free_deal_alert_widget.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'flutter_flow/revenue_cat_util.dart' as revenue_cat;
import 'backend/push_notifications/push_notifications_util.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'auth/firebase_auth/firebase_user_provider.dart';
import 'auth/firebase_auth/auth_util.dart';

import 'backend/firebase/firebase_config.dart';
import 'components/take_login_alert_widget.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import 'index.dart';
//firebase deploy --only hosting:dtdweb
@pragma('vm:entry-point')
Future<void> fcmBackgroundHandler(RemoteMessage message) async {
  await initFirebase();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();
  await initFirebase();

  await FFLocalizations.initialize();

  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState();

  await revenue_cat.initialize(
    "",
    "goog_HqhAQOIvCqHaBsbPrvuIQuWasce",
    debugLogEnabled: true,
    loadDataAfterLaunch: true,
  );

  FirebaseMessaging.onBackgroundMessage(fcmBackgroundHandler);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(ChangeNotifierProvider(
      create: (context) => appState,
      child: const MyApp(),
    ));
  });
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
  Locale? _locale = FFLocalizations.getStoredLocale();
  ThemeMode _themeMode = ThemeMode.system;

  late Stream<BaseAuthUser> userStream;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  final authUserSub = authenticatedUserStream.listen((user) {
    revenue_cat.login(user?.uid);
  });
  final fcmTokenSub = fcmTokenUserStream.listen((_) {});

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
    userStream = autoDealAppFirebaseUserStream()..listen((user) => _appStateNotifier.update(user));
    jwtTokenStream.listen((_) {});
    Future.delayed(
      const Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  @override
  void dispose() {
    authUserSub.cancel();
    fcmTokenSub.cancel();
    super.dispose();
  }

  void setLocale(String language) {
    setState(() => _locale = createLocale(language));
    FFLocalizations.storeLocale(language);
  }

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
      });

  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();
    return MaterialApp.router(
      builder: (_, child) {
        child = botToastBuilder(context, child);
        final mediaQueryData = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQueryData.copyWith(textScaleFactor: 1.0),
          child: child,
        );
      },
      debugShowCheckedModeBanner: false,
      title: 'AutoDealApp',
      localizationsDelegates: const [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale,
      supportedLocales: const [
        Locale('ru'),
        Locale('en'),
      ],
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}

class NavBarPage extends StatefulWidget {
  const NavBarPage({super.key, this.initialPage, this.page});

  final String? initialPage;
  final Widget? page;

  @override
  // ignore: library_private_types_in_public_api
  _NavBarPageState createState() => _NavBarPageState();
}

/// This is the private State class that goes with NavBarPage.
class _NavBarPageState extends State<NavBarPage> {
  String _currentPageName = 'HomePage';
  late Widget? _currentPage;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _currentPageName = widget.initialPage ?? _currentPageName;
    _currentPage = widget.page;

    Future.delayed(const Duration(seconds: 1)).then(
      (value) {
        checkUserProfileStatus();
      },
    );
  }

  void checkUserProfileStatus() async {
     if (FFAppState().isAnonymEnter) {
      setState(() {
        loading = false;
      });
      return;
    }
    try {
      bool hasReference = currentUserReference != null;

      //если не найдена ссылка
      if (!hasReference) {
        setState(() {
          loading = false;
        });

        clearAndNavigate(context, 'login_page');

        return;
      }

      //если все таки все данные готовы, то проверяем на заполненность
      final user = await getUser();

      if (user == null) {
        if (mounted) clearAndNavigate(context, 'login_page');
      }

      final isBlocked = user!.banned;

      if (isBlocked) {
        if (mounted) {
          clearAndNavigate(context, 'UserBannedPage');
        }
      }

      final isFilled = user.profileFilled;

      if (!isFilled) {
        if (mounted) {
          clearAndNavigate(context, 'fill_profile_main');
        }
        return;
      }

      setState(() {
        loading = false;
      });
    } catch (e) {
      print('home user check error: $e');
      setState(() {
        loading = false;
      });
    }
  }

  Future<UsersRecord?> getUser() async {
    final user = await UsersRecord.getDocumentOnce(currentUserReference!);
    return user;
  }

  void takeAuth() async {
    String? confirm = await showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          elevation: 0,
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          alignment: const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
          child: const TakeLoginAlertWidget(),
        );
      },
    );

    if (confirm != null && mounted) {
      if (confirm == 'login') {
        context.pushNamed('login_page');
      } else {
        context.pushNamed('registration_page');
      }
    }
  }

  void onCreate() async {
    final int freeDealCount = currentUserDocument?.freeDealCount ?? 0;

    //если нет бесплатных публикаций, то проверяем баланс
    if (freeDealCount == 0) {
      final int balance = (currentUserDocument?.balance ?? 0).toInt();
      //если нет баланса, то переходим на пополнение
      if (balance == 0) {
        final confirm = await showDialog(
              context: context,
              builder: (dialogContext) {
                return Dialog(
                  elevation: 0,
                  insetPadding: const EdgeInsets.symmetric(horizontal: 32),
                  backgroundColor: Colors.transparent,
                  alignment: const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                  child: const NoBalanceForResponseAlert(isResponse: false),
                );
              },
            ) ??
            false;

        if (confirm && mounted) {
          context.pushNamed('WalletPage');
        }
      } else {
        final configRef = FirebaseFirestore.instance.collection('config').doc('configs');
        final configDoc = await configRef.get();
        final configData = configDoc.data() as Map<String, dynamic>;
        final int publicationCost = configData['publication_cost'] ?? 0;

        if (balance >= publicationCost) {
          if (mounted) context.pushNamed('CreateDealPage');
        } else {
          final confirm = await showDialog(
                context: context,
                builder: (dialogContext) {
                  return Dialog(
                    elevation: 0,
                    insetPadding: const EdgeInsets.symmetric(horizontal: 32),
                    backgroundColor: Colors.transparent,
                    alignment: const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                    child: const NoBalanceForResponseAlert(isResponse: false),
                  );
                },
              ) ??
              false;

          if (confirm && mounted) {
            context.pushNamed('WalletPage');
          }
        }
      }
    } else {
      final confirm = await showDialog(
            context: context,
            builder: (dialogContext) {
              return Dialog(
                elevation: 0,
                insetPadding: const EdgeInsets.symmetric(horizontal: 32),
                backgroundColor: Colors.transparent,
                alignment: const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
                child: const CreateDealFreeDealAlertWidget(),
              );
            },
          ) ??
          false;

      if (confirm && mounted) {
        context.pushNamed('CreateDealPage');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = {
      'HomePage': const HomePageWidget(),
      'OrderTab': const OrderTabWidget(),
      'ChatTab': const ChatTabWidget(),
      'ProfileTab': const ProfileTabWidget(),
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);

    return Scaffold(
      body: (loading) ? loadingWidget(context) : _currentPage ?? tabs[_currentPageName],
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 30),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            height: 84,
            color: FlutterFlowTheme.of(context).secondaryBackground,
            child: Row(
              children: [
                //logo
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/logo.svg',
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'DTD',
                      style: FlutterFlowTheme.of(context).titleSmall.override(
                            fontFamily: 'Inter',
                            color: FlutterFlowTheme.of(context).primaryText,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w700,
                            fontSize: 26,
                            useGoogleFonts: false,
                          ),
                    ),
                  ],
                ),
                //tabs
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(32),
                        hoverColor: FlutterFlowTheme.of(context).warning,
                        onTap: () {
                          setState(() {
                            _currentPage = null;
                            _currentPageName = tabs.keys.toList()[0];
                          });
                        },
                        child: Container(
                          width: currentIndex == 0 ? 134 : null,
                          height: 35,
                          padding: EdgeInsets.symmetric(horizontal: currentIndex != 0 ? 20 : 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            color: currentIndex == 0
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).secondaryBackground,
                          ),
                          child: Center(
                            child: Text(
                              FFLocalizations.of(context).getText('7slhpf6k'),
                              style: FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Inter',
                                    color: FlutterFlowTheme.of(context).primaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                    useGoogleFonts: false,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(32),
                        hoverColor: FlutterFlowTheme.of(context).warning,
                        onTap: () {
                          setState(() {
                            _currentPage = null;
                            _currentPageName = tabs.keys.toList()[1];
                          });
                        },
                        child: Container(
                          width: currentIndex == 1 ? 134 : null,
                          padding: EdgeInsets.symmetric(horizontal: currentIndex != 1 ? 20 : 0),
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            color: currentIndex == 1
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).secondaryBackground,
                          ),
                          child: Center(
                            child: Text(
                              FFLocalizations.of(context).getText('uk4nasyp'),
                              style: FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Inter',
                                    color: FlutterFlowTheme.of(context).primaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                    useGoogleFonts: false,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(32),
                        hoverColor: FlutterFlowTheme.of(context).warning,
                        onTap: () {
                          if (loggedIn) {
                            setState(() {
                              _currentPage = null;
                              _currentPageName = tabs.keys.toList()[2];
                            });
                          } else {
                            takeAuth();
                            return;
                          }
                        },
                        child: Container(
                          width: currentIndex == 2 ? 134 : null,
                          padding: EdgeInsets.symmetric(horizontal: currentIndex != 2 ? 20 : 0),
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            color: currentIndex == 2
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).secondaryBackground,
                          ),
                          child: Center(
                            child: Text(
                              FFLocalizations.of(context).getText('p4xzs9g2'),
                              style: FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Inter',
                                    color: FlutterFlowTheme.of(context).primaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                    useGoogleFonts: false,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(32),
                        hoverColor: FlutterFlowTheme.of(context).warning,
                        onTap: () {
                          if (loggedIn) {
                            setState(() {
                              _currentPage = null;
                              _currentPageName = tabs.keys.toList()[3];
                            });
                          } else {
                            takeAuth();
                            return;
                          }
                        },
                        child: Container(
                          width: currentIndex == 3 ? 134 : null,
                          padding: EdgeInsets.symmetric(horizontal: currentIndex != 3 ? 20 : 0),
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            color: currentIndex == 3
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context).secondaryBackground,
                          ),
                          child: Center(
                            child: Text(
                              FFLocalizations.of(context).getText('90k5qz14'),
                              style: FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Inter',
                                    color: FlutterFlowTheme.of(context).primaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                    useGoogleFonts: false,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Row(
                  children: [
                    if (currentUserDocument?.type == UserType.Diller)
                      InkWell(
                        borderRadius: BorderRadius.circular(32),
                        onTap: onCreate,
                        child: Container(
                          width: 192,
                          height: 44,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primary,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Icon(Icons.add, color: FlutterFlowTheme.of(context).primary),
                                ),
                              ),
                              Text(
                                FFLocalizations.of(context).getText('nfw5wib1'),
                                style: FlutterFlowTheme.of(context).titleSmall.override(
                                      fontFamily: 'Inter',
                                      color: FlutterFlowTheme.of(context).primaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      useGoogleFonts: false,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          context.pushNamed('NotificationsPage');
                        },
                        child: SvgPicture.asset(
                          'assets/images/mi_notification.svg',
                          width: 24.0,
                          height: 24.0,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    AuthUserStreamWidget(
                      builder: (context) => Container(
                        width: 64.0,
                        height: 64.0,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFFAE28C).withOpacity(0.2),
                        ),
                        child: CachedNetworkImage(
                          fadeInDuration: const Duration(milliseconds: 300),
                          fadeOutDuration: const Duration(milliseconds: 300),
                          imageUrl: currentUserPhoto,
                          fit: BoxFit.cover,
                          placeholder: (context, url) {
                            return const Center(child: CircularProgressIndicator());
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: Container(
      //   margin: const EdgeInsets.symmetric(horizontal: 24),
      //   child: GNav(
      //     selectedIndex: currentIndex,
      //     onTabChange: (i) {
      //       if (loggedIn) {
      //         setState(() {
      //           _currentPage = null;
      //           _currentPageName = tabs.keys.toList()[i];
      //         });
      //       } else {
      //         if (i == 2 || i == 3) {
      //           takeAuth();
      //           return;
      //         }
      //         setState(() {
      //           _currentPage = null;
      //           _currentPageName = tabs.keys.toList()[i];
      //         });
      //       }
      //     },
      //     backgroundColor: Colors.white,
      //     color: FlutterFlowTheme.of(context).secondary,
      //     activeColor: FlutterFlowTheme.of(context).primaryText,
      //     tabBackgroundColor: FlutterFlowTheme.of(context).primary,
      //     tabBorderRadius: 24.0,
      //     tabMargin: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
      //     padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
      //     gap: 8.0,
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     duration: const Duration(milliseconds: 300),
      //     haptic: false,
      //     textStyle: FlutterFlowTheme.of(context).titleSmall.override(
      //           fontFamily: 'Inter',
      //           color: FlutterFlowTheme.of(context).primaryText,
      //           letterSpacing: 0.0,
      //           fontWeight: FontWeight.normal,
      //           fontSize: 14,
      //           useGoogleFonts: false,
      //         ),
      //     tabs: [
      //       GButton(
      //         leading: SvgPicture.asset(
      //           'assets/images/main_tab.svg',
      //           width: 24,
      //           height: 24,
      //           color: currentIndex == 0 ? FlutterFlowTheme.of(context).primaryText : null,
      //         ),
      //         icon: currentIndex == 0 ? Icons.home : Icons.home_outlined,
      //         text: FFLocalizations.of(context).getText(
      //           '7slhpf6k' /* Главная */,
      //         ),
      //         iconSize: 24.0,
      //       ),
      //       GButton(
      //         leading: SvgPicture.asset(
      //           'assets/images/deal_tab.svg',
      //           width: 24,
      //           height: 24,
      //           color: currentIndex == 1 ? FlutterFlowTheme.of(context).primaryText : null,
      //         ),
      //         icon: currentIndex == 1 ? FontAwesomeIcons.carAlt : FontAwesomeIcons.car,
      //         text: FFLocalizations.of(context).getText(
      //           'uk4nasyp' /* Заказы */,
      //         ),
      //         iconSize: 24.0,
      //       ),
      //       GButton(
      //         leading: SvgPicture.asset(
      //           'assets/images/chat_tab.svg',
      //           width: 24,
      //           height: 24,
      //           color: currentIndex == 2 ? FlutterFlowTheme.of(context).primaryText : null,
      //         ),
      //         icon: currentIndex == 2 ? Icons.chat_bubble_rounded : Icons.chat_bubble_outline,
      //         text: FFLocalizations.of(context).getText(
      //           'p4xzs9g2' /* Чат */,
      //         ),
      //         iconSize: 24.0,
      //         active: loggedIn,
      //       ),
      //       GButton(
      //         leading: SvgPicture.asset(
      //           'assets/images/profile_tab.svg',
      //           width: 24,
      //           height: 24,
      //           color: currentIndex == 3 ? FlutterFlowTheme.of(context).primaryText : null,
      //         ),
      //         icon: currentIndex == 3 ? Icons.person : Icons.person_outlined,
      //         text: FFLocalizations.of(context).getText(
      //           '90k5qz14' /* Профиль */,
      //         ),
      //         iconSize: 24.0,
      //         active: loggedIn,
      //       )
      //     ],
      //   ),
      // ),
    );
  }

  Widget loadingWidget(BuildContext context, {double radius = 50}) {
    return Center(
      child: SizedBox(
          width: radius,
          height: radius,
          child: CircularProgressIndicator(
            color: FlutterFlowTheme.of(context).primary,
          )),
    );
  }
}
