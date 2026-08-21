import 'package:auto_deal_app/auth/firebase_auth/auth_util.dart';
import 'package:auto_deal_app/components/create_deal_free_deal_alert_widget.dart';
import 'package:auto_deal_app/flutter_flow/flutter_flow_widgets.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'no_deals_diller_comp_model.dart';
export 'no_deals_diller_comp_model.dart';

class NoDealsDillerCompWidget extends StatefulWidget {
  const NoDealsDillerCompWidget({super.key});

  @override
  State<NoDealsDillerCompWidget> createState() => _NoDealsDillerCompWidgetState();
}

class _NoDealsDillerCompWidgetState extends State<NoDealsDillerCompWidget> {
  late NoDealsDillerCompModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NoDealsDillerCompModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
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
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            context.pushNamed('DillerActiveDeals');
          },
          child: Container(
            width: double.infinity,
            height: 92.0,
            decoration: BoxDecoration(
              color: const Color(0xFFFEFEFE),
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: const Color(0xFFE9E9E9),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          FFLocalizations.of(context).getText(
                            'kiu4okb1' /* Активные заказы */,
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                                useGoogleFonts: false,
                              ),
                        ),
                        Text(
                          FFLocalizations.of(context).getText(
                            'l6n2fo2r' /* У вас нет активных заказов */,
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                letterSpacing: 0.0,
                                useGoogleFonts: false,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 32.0,
                    height: 32.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primary,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: SvgPicture.asset(
                      'assets/images/car.svg',
                      width: 300.0,
                      height: 200.0,
                      fit: BoxFit.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Image.asset(
              'assets/images/no_deals2.png',
              width: 400.0,
              height: 400.0,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 60.0),
              child: Text(
                FFLocalizations.of(context).getText(
                  '05lj71fe' /* Создавайте заказы и находите и... */,
                ),
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
              ),
            ),
          ],
        ),
        FFButtonWidget(
          onPressed: onCreate,
          text: FFLocalizations.of(context).getText(
            'nfw5wib1' /* Создать заказ */,
          ),
          options: FFButtonOptions(
            width: 380,
            height: 56.0,
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            color: FlutterFlowTheme.of(context).primary,
            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                  fontFamily: 'Inter',
                  color: FlutterFlowTheme.of(context).primaryText,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                  useGoogleFonts: false,
                ),
            elevation: 0.0,
            borderSide: const BorderSide(
              color: Colors.transparent,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ],
    );
  }
}
