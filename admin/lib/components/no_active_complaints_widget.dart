import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'no_active_complaints_model.dart';
export 'no_active_complaints_model.dart';

class NoActiveComplaintsWidget extends StatefulWidget {
  const NoActiveComplaintsWidget({super.key});

  @override
  State<NoActiveComplaintsWidget> createState() =>
      _NoActiveComplaintsWidgetState();
}

class _NoActiveComplaintsWidgetState extends State<NoActiveComplaintsWidget> {
  late NoActiveComplaintsModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NoActiveComplaintsModel());
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8.0,
                height: 8.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).success2,
                  shape: BoxShape.circle,
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                child: Text(
                  'Нет активных жалоб',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        fontSize: 18.0,
                        letterSpacing: 0.0,
                      ),
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: 1.0,
          color: Color(0xFFE9E9E9),
        ),
      ],
    );
  }
}
