import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'chat_empty_comp_model.dart';
export 'chat_empty_comp_model.dart';

class ChatEmptyCompWidget extends StatefulWidget {
  const ChatEmptyCompWidget({super.key});

  @override
  State<ChatEmptyCompWidget> createState() => _ChatEmptyCompWidgetState();
}

class _ChatEmptyCompWidgetState extends State<ChatEmptyCompWidget> {
  late ChatEmptyCompModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatEmptyCompModel());
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/no_messages.png',
          width: 200.0,
          height: 200.0,
          fit: BoxFit.contain,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
              child: Text(
                FFLocalizations.of(context).getText(
                  'o4xbt6fu' /* Сообщений пока нет */,
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.of(context).hintColor,
                      fontSize: 16.0,
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}