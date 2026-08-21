import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'diller_empty_active_deals_comp_model.dart';
export 'diller_empty_active_deals_comp_model.dart';

class DillerEmptyActiveDealsCompWidget extends StatefulWidget {
  const DillerEmptyActiveDealsCompWidget({super.key});

  @override
  State<DillerEmptyActiveDealsCompWidget> createState() =>
      _DillerEmptyActiveDealsCompWidgetState();
}

class _DillerEmptyActiveDealsCompWidgetState
    extends State<DillerEmptyActiveDealsCompWidget> {
  late DillerEmptyActiveDealsCompModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DillerEmptyActiveDealsCompModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/no_deals.png',
                width: 200.0,
                height: 200.0,
                fit: BoxFit.cover,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                    child: Text(
                      FFLocalizations.of(context).getText(
                        'z350nw0r' /* У вас нет активных заказов на ... */,
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
            ],
          ),
        ),
      ],
    );
  }
}
