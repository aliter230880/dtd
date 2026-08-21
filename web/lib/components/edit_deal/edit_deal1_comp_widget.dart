
import 'package:auto_deal_app/backend/backend.dart';
import 'package:auto_deal_app/flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter/cupertino.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'edit_deal1_comp_model.dart';

class EditDeal1CompWidget extends StatefulWidget {
  const EditDeal1CompWidget({
    super.key,
    required this.onTap,
    required this.deal,
  });

  final Future Function()? onTap;
  final DealsRecord? deal;
  @override
  State<EditDeal1CompWidget> createState() => _EditDeal1CompWidgetState();
}

class _EditDeal1CompWidgetState extends State<EditDeal1CompWidget> {
  late EditDeal1CompModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditDeal1CompModel());

    _model.carNameTextController ??= TextEditingController(text: FFAppState().createDealCarName);
    _model.carNameFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  String formatDate(DateTime? d) {
    if (d == null) return '-';
    final locale = FFLocalizations.of(context).languageCode;
    return DateFormat('dd MMMM', locale).format(d);
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30.0,
          borderWidth: 1.0,
          buttonSize: 60.0,
          icon: Icon(
            CupertinoIcons.arrow_left,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 20.0,
          ),
          onPressed: () async {
            context.pop();
          },
        ),
        title: Text(
          FFLocalizations.of(context).getText('edit_deal_title'),
          style: FlutterFlowTheme.of(context).titleMedium.override(
                fontFamily: 'Inter',
                color: FlutterFlowTheme.of(context).primaryText,
                letterSpacing: 0.0,
                useGoogleFonts: false,
              ),
        ),
        actions: const [],
        centerTitle: true,
        elevation: 0.0,
      ),
      body: const Padding(
        padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [],
          ),
        ),
      ),
    );
  }
}
