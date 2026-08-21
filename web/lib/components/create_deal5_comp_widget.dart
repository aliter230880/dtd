import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'create_deal5_comp_model.dart';
export 'create_deal5_comp_model.dart';

class CreateDeal5CompWidget extends StatefulWidget {
  const CreateDeal5CompWidget({
    super.key,
    required this.onTap,
  });

  final Future Function()? onTap;

  @override
  State<CreateDeal5CompWidget> createState() => _CreateDeal5CompWidgetState();
}

class _CreateDeal5CompWidgetState extends State<CreateDeal5CompWidget> {
  late CreateDeal5CompModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreateDeal5CompModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 384),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
              child: Text(
                FFLocalizations.of(context).getText(
                  'gf191p0n' /* Дата доставки транспорта */,
                ),
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.of(context).primaryText,
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 180.0,
              child: custom_widgets.CreateDealTimePicker(
                width: double.infinity,
                height: 180.0,
                currentTime: FFAppState().createDealDate ?? getCurrentTimestamp,
                onChange: (time) async {
                  FFAppState().createDealDate = time;
                  setState(() {});
                },
              ),
            ),
            if (FFAppState().createDealDate != null)
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: FFButtonWidget(
                  onPressed: () async {
                    await widget.onTap?.call();
                  },
                  text: FFLocalizations.of(context).getText(
                    'xgd4lv6v' /* Далее */,
                  ),
                  options: FFButtonOptions(
                    width: double.infinity,
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
                    hoverColor: FlutterFlowTheme.of(context).warning,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
