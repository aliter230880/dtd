import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'profile_type_comp_model.dart';
export 'profile_type_comp_model.dart';

class ProfileTypeCompWidget extends StatefulWidget {
  const ProfileTypeCompWidget({
    super.key,
    bool? selected,
    String? type,
  })  : selected = selected ?? false,
        type = type ?? 'diller';

  final bool selected;
  final String type;

  @override
  State<ProfileTypeCompWidget> createState() => _ProfileTypeCompWidgetState();
}

class _ProfileTypeCompWidgetState extends State<ProfileTypeCompWidget> {
  late ProfileTypeCompModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileTypeCompModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Container(
        width: double.infinity,
        height: 120.0,
        decoration: BoxDecoration(
          color:
              widget.selected ? FlutterFlowTheme.of(context).primary : FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(
            color: widget.selected ? FlutterFlowTheme.of(context).primary : FlutterFlowTheme.of(context).buttonDisabel,
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Builder(
                builder: (context) {
                  if (widget.type == 'diller') {
                    return Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 14.0, 0.0),
                      child: Image.asset(
                        'assets/images/diler.png',
                        width: 60.0,
                        height: 60.0,
                        fit: BoxFit.contain,
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 14.0, 0.0),
                      child: Image.asset(
                        'assets/images/carrier.png',
                        width: 60.0,
                        height: 60.0,
                        fit: BoxFit.contain,
                      ),
                    );
                  }
                },
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.type == 'diller' ? 'Дилер' : 'Перевозчик',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            color: const Color(0xFF424245),
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts: false,
                          ),
                    ),
                    Flexible(
                      child: Text(
                        widget.type == 'diller'
                            ? 'Продавайте и отправляйте автомобили, создавайте заказы и управляйте своим бизнесом'
                            : 'Получайте заказы на перевозку, расширяйте свою клиентскую базу и увеличивайте доходы',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              color: widget.selected ? const Color(0xFF424245) : const Color(0xFFA4A4AA),
                              letterSpacing: 0.0,
                              useGoogleFonts: false,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
