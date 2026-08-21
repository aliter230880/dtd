import 'package:auto_deal_app/auth/firebase_auth/auth_util.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'success_createdeal_custom_alert_model.dart';
export 'success_createdeal_custom_alert_model.dart';

class SuccessCreatedealCustomAlertWidget extends StatefulWidget {
  const SuccessCreatedealCustomAlertWidget({
    super.key,
    this.isFreePublication = false,
    this.isDiller = true,
  });
  final bool isFreePublication;
  final bool isDiller;

  @override
  State<SuccessCreatedealCustomAlertWidget> createState() => _SuccessCreatedealCustomAlertWidgetState();
}

class _SuccessCreatedealCustomAlertWidgetState extends State<SuccessCreatedealCustomAlertWidget> {
  late SuccessCreatedealCustomAlertModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SuccessCreatedealCustomAlertModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 440,
      child: Material(
        color: Colors.transparent,
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFFEFEFE),
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(32.0, 40.0, 32.0, 32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 32.0),
                  child: SvgPicture.asset(
                    'assets/images/success.svg',
                    width: 185.0,
                    height: 180.0,
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                  child: Text(
                    FFLocalizations.of(context).getText(
                      '81ngjs9e' /* Ваш заказ опубликован */,
                    ),
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          fontSize: 24.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                          useGoogleFonts: false,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 32.0),
                  child: Builder(builder: (context) {
                    if (widget.isFreePublication) {
                      return Text(
                        // '${FFLocalizations.of(context).getText('min20r031')} ${currentUserDocument?.freeDealCount ?? 0} ${FFLocalizations.of(context).getText('min20r0312')}',
                           getFreeDealsCounterText(context, currentUserDocument?.freeDealCount ?? 0),
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.normal,
                              useGoogleFonts: false,
                            ),
                      );
                    } else {
                      return FutureBuilder(
                          future: FirebaseFirestore.instance.collection('config').doc('configs').get(),
                          builder: (context, snapshot) {
                            final configData = snapshot.data?.data();
                            final int? dealCost = configData?['publication_cost'];
                            return Text(
                              '${FFLocalizations.of(context).getText('jvwl13og')} ${dealCost ?? '...'} ${FFLocalizations.of(context).getText('jvwl13og2')}',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                    useGoogleFonts: false,
                                  ),
                            );
                          });
                    }
                  }),
                ),
                FFButtonWidget(
                  onPressed: () async {
                    context.safePop();
                  },
                  text: FFLocalizations.of(context).getText(
                    'sc89sgil' /* Далее */,
                  ),
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 56.0,
                    padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                    iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Inter',
                          color: FlutterFlowTheme.of(context).primaryText,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                          useGoogleFonts: false,
                        ),
                    elevation: 0.0,
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 0.0,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
