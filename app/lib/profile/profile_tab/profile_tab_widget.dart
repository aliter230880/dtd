import '/auth/firebase_auth/auth_util.dart';
import '/backend/schema/enums/enums.dart';
import '/components/carrier_profile_history_widget.dart';
import '/components/delete_account_alert_widget.dart';
import '/components/diller_profile_history_widget.dart';
import '/components/logout_alert_widget.dart';
import '/components/user_profile_raitings_widget.dart';
import '/components/user_profile_transactions_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'profile_tab_model.dart';
export 'profile_tab_model.dart';

class ProfileTabWidget extends StatefulWidget {
  const ProfileTabWidget({super.key});

  @override
  State<ProfileTabWidget> createState() => _ProfileTabWidgetState();
}

class _ProfileTabWidgetState extends State<ProfileTabWidget> {
  late ProfileTabModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileTabModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'ProfileTab'});
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> onExit() async {
    await Future.delayed(const Duration(milliseconds: 300));
    bool confirm = await showDialog(
          context: context,
          builder: (dialogContext) {
            return Dialog(
              elevation: 0,
              insetPadding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              alignment: const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
              child: const LogoutAlertWidget(),
            );
          },
        ) ??
        false;

    if (confirm) {
      GoRouter.of(context).prepareAuthEvent();
      await authManager.signOut();
      GoRouter.of(context).clearRedirectLocation();
      
      // Clear cached user document to prevent stale data
      currentUserDocument = null;

      context.goNamedAuth('login_page', context.mounted);
    }
  }

  Future<void> onDelete() async {
    await Future.delayed(const Duration(milliseconds: 300));
    bool confirm = await showDialog(
          context: context,
          builder: (dialogContext) {
            return Dialog(
              elevation: 0,
              insetPadding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              alignment: const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
              child: const DeleteAccountAlertWidget(),
            );
          },
        ) ??
        false;

    if (confirm) {
      await authManager.deleteUser(context);
      context.goNamedAuth('login_page', context.mounted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
           
            const SizedBox(width: 24),
            Expanded(
              child: Text(
                FFLocalizations.of(context).getText(
                  'd1dmyum3' /* Профиль */,
                ),
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.of(context).primaryText,
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
              ),
            ),
            Builder(
              builder: (_) => SizedBox(
                width: 24.0,
                height: 24.0,
                child: custom_widgets.ProfilePopupMenu(
                  width: 24.0,
                  height: 24.0,
                  onEditData: () async {
                    if (currentUserDocument?.type == UserType.Diller) {
                      context.pushNamed('EditDillerProfile1');

                      return;
                    } else {
                      context.pushNamed('EditCarrierProfile1');

                      return;
                    }
                  },
                  onEditCars: () async {
                    context.pushNamed('EditDillerProfile2');
                  },
                  onExit: () => onExit(),
                  onDeleteAccount: () => onDelete(),
                ),
              ),
            ),
          ],
        ),
        actions: const [],
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SafeArea(
        top: true,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AuthUserStreamWidget(
                      builder: (context) => Container(
                        width: 120.0,
                        height: 120.0,
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
                            return Container(
                              width: 120.0,
                              height: 120.0,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFFAE28C).withOpacity(0.2),
                              ),
                              child: const CircularProgressIndicator(),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 24.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 24.0,
                        height: 24.0,
                        decoration: const BoxDecoration(),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              AuthUserStreamWidget(
                                builder: (context) => Text(
                                  currentUserDisplayName,
                                  maxLines: 1,
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Inter',
                                        fontSize: 18.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        useGoogleFonts: false,
                                      ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                child: AuthUserStreamWidget(
                                  builder: (context) => Text(
                                    currentPhoneNumber,
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Inter',
                                          letterSpacing: 0.0,
                                          useGoogleFonts: false,
                                        ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                child: AuthUserStreamWidget(
                                  builder: (context) => Text(
                                    currentUserDocument?.type == UserType.Diller
                                        ? 'Дилер'
                                        : 'Перевозчик',
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Inter',
                                          fontSize: 14.0,
                                          letterSpacing: 0.0,
                                          color: FlutterFlowTheme.of(context).secondaryText,
                                          fontWeight: FontWeight.w500,
                                          useGoogleFonts: false,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          context.pushNamed('EditProfile');
                        },
                        child: SvgPicture.asset(
                          'assets/images/edit.svg',
                          width: 24.0,
                          height: 24.0,
                          fit: BoxFit.none,
                        ),
                      ),
                    ],
                  ),
                ),
                // КУС-верификация — только для перевозчиков
                if (currentUserDocument?.type == UserType.Carrier)
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 24.0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        context.pushNamed('CarrierVerificationPage');
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 1.5,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                (currentUserDocument?.verificationStatus ?? '') == 'verified'
                                    ? Icons.verified_user
                                    : Icons.gpp_maybe_outlined,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 24.0,
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Верификация перевозчика',
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Inter',
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts: false,
                                          ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      (currentUserDocument?.verificationStatus ?? '') == 'verified'
                                          ? 'Проверен'
                                          : 'Подтвердите DOT / MC номер',
                                      style: FlutterFlowTheme.of(context).bodySmall.override(
                                            fontFamily: 'Inter',
                                            letterSpacing: 0.0,
                                            useGoogleFonts: false,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 16.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 14.0),
                        child: Text(
                          FFLocalizations.of(context).getText(
                            'vxq4yoj9' /* Кошелёк */,
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                fontSize: 18.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                                useGoogleFonts: false,
                              ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 110.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primary,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      FFLocalizations.of(context).getText(
                                        'rr5t5e6d' /* Ваш баланс */,
                                      ),
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Inter',
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            useGoogleFonts: false,
                                          ),
                                    ),
                                    AuthUserStreamWidget(
                                      builder: (context) => Text(
                                        valueOrDefault<String>(
                                          formatNumber(
                                            valueOrDefault(currentUserDocument?.balance, 0.0),
                                            formatType: FormatType.custom,
                                            currency: '\$',
                                            format: '',
                                            locale: '',
                                          ),
                                          '0',
                                        ),
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Inter',
                                              fontSize: 32.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                              useGoogleFonts: false,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  context.pushNamed('WalletPage');
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/wallet-credit-card.svg',
                                      width: 58.0,
                                      height: 56.0,
                                      fit: BoxFit.contain,
                                    ),
                                    Text(
                                      FFLocalizations.of(context).getText(
                                        '7qmi50b2' /* Пополнить */,
                                      ),
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Inter',
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            useGoogleFonts: false,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                wrapWithModel(
                  model: _model.userProfileRaitingsModel,
                  updateCallback: () => setState(() {}),
                  child: UserProfileRaitingsWidget(
                    userRef: currentUserReference!,
                  ),
                ),
                Builder(
                  builder: (context) {
                    if (currentUserDocument?.type == UserType.Diller) {
                      return wrapWithModel(
                        model: _model.dillerProfileHistoryModel,
                        updateCallback: () => setState(() {}),
                        child: const DillerProfileHistoryWidget(),
                      );
                    } else {
                      return wrapWithModel(
                        model: _model.carrierProfileHistoryModel,
                        updateCallback: () => setState(() {}),
                        child: const CarrierProfileHistoryWidget(),
                      );
                    }
                  },
                ),
                wrapWithModel(
                  model: _model.userProfileTransactionsModel,
                  updateCallback: () => setState(() {}),
                  child: const UserProfileTransactionsWidget(),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
