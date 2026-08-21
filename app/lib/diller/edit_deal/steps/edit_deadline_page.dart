import 'package:auto_deal_app/backend/backend.dart';
import 'package:auto_deal_app/flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter/cupertino.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class EditDealDeadlinePage extends StatefulWidget {
  const EditDealDeadlinePage({super.key, required this.deal});

  final DealsRecord? deal;
  @override
  State<EditDealDeadlinePage> createState() => _EditDealDeadlinePageState();
}

class _EditDealDeadlinePageState extends State<EditDealDeadlinePage> {
  DateTime? selectedDate;

  @override
  void initState() {
    selectedDate = widget.deal?.dealDate;
    super.initState();
    
  }

  void save() async {
    await widget.deal?.reference.update(createDealsRecordData(dealDate: selectedDate));
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    bool isActive = selectedDate != null;
    
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
        actions: [
          if (isActive)
            GestureDetector(
              onTap: save,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  FFLocalizations.of(context).getText('i4orpypq'),
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: 'Inter',
                        color: FlutterFlowTheme.of(context).primaryText,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        useGoogleFonts: false,
                      ),
                ),
              ),
            ),
        ],
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(24.0, 12.0, 24.0, 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                currentTime: selectedDate ?? getCurrentTimestamp,
                onChange: (time) async {
                  selectedDate = time;
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
