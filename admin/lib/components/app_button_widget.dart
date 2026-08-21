import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'app_button_model.dart';
export 'app_button_model.dart';

class AppButtonWidget extends StatefulWidget {
  const AppButtonWidget({
    super.key,
    String? label,
    int? width,
    bool? isActive,
    this.onPressed,
  })  : label = label ?? '-',
        width = width ?? 380,
        isActive = isActive ?? true;

  final String label;
  final int width;
  final bool isActive;
  final Function()? onPressed;

  @override
  State<AppButtonWidget> createState() => _AppButtonWidgetState();
}

class _AppButtonWidgetState extends State<AppButtonWidget> {
  late AppButtonModel _model;
  bool loading = false;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AppButtonModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget textWidget = loading
        ? const Center(
            child: SizedBox(
              width: 23,
              height: 23,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white,
                ),
              ),
            ),
          )
        : Text(
            widget.label,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 16.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.bold,
                ),
          );

    final onPressed = widget.onPressed != null
        ? () async {
            if (loading) {
              return;
            }
            setState(() => loading = true);
            try {
              await widget.onPressed!();
            } finally {
              if (mounted) {
                setState(() => loading = false);
              }
            }
          }
        : null;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: widget.width.toDouble(),
        height: 58.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              valueOrDefault<Color>(
                widget.isActive
                    ? FlutterFlowTheme.of(context).yellowGradient2
                    : FlutterFlowTheme.of(context).yellowGradient1,
                FlutterFlowTheme.of(context).yellowGradient2,
              ),
              FlutterFlowTheme.of(context).yellowGradient1
            ],
            stops: const [0.0, 1.0],
            begin: const AlignmentDirectional(0.03, -1.0),
            end: const AlignmentDirectional(-0.03, 1.0),
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        alignment: const AlignmentDirectional(0.0, 0.0),
        child: textWidget,
      ),
    );
  }
}
