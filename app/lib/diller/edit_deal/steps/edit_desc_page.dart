import 'package:auto_deal_app/backend/backend.dart';
import 'package:auto_deal_app/flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class EditDealDescPage extends StatefulWidget {
  const EditDealDescPage({super.key, required this.deal});

  final DealsRecord? deal;
  @override
  State<EditDealDescPage> createState() => _EditDealDescPageState();
}

class _EditDealDescPageState extends State<EditDealDescPage> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: widget.deal?.description);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void save() async {
    await widget.deal?.reference.update(createDealsRecordData(description: controller.text.trim()));
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    bool isActive = controller.text.trim().isNotEmpty;
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
        padding: const EdgeInsetsDirectional.fromSTEB(24.0, 12.0, 24.0, 0.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                child: Text(
                  FFLocalizations.of(context).getText('hvjdr22h'),
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
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {});
                  },
                  controller: controller,
                  autofocus: false,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.done,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: FFLocalizations.of(context).getText('cix8cr0r'),
                    hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          color: FlutterFlowTheme.of(context).hintColor,
                          letterSpacing: 0.0,
                          useGoogleFonts: false,
                        ),
                    errorStyle: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Inter',
                          color: FlutterFlowTheme.of(context).error,
                          fontSize: 10.0,
                          letterSpacing: 0.0,
                          useGoogleFonts: false,
                        ),
                    counterStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          color: const Color(0xFF424245),
                          letterSpacing: 0.0,
                          useGoogleFonts: false,
                        ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0x00000000),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).border,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                    contentPadding: const EdgeInsetsDirectional.fromSTEB(15.0, 18.0, 15.0, 18.0),
                    suffixIcon: controller.text.isNotEmpty
                        ? InkWell(
                            onTap: () async {
                              controller.clear();
                              setState(() {});
                            },
                            child: Icon(
                              Icons.clear,
                              color: FlutterFlowTheme.of(context).border,
                              size: 20.0,
                            ),
                          )
                        : null,
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        letterSpacing: 0.0,
                        useGoogleFonts: false,
                      ),
                  textAlign: TextAlign.start,
                  maxLines: 10,
                  minLines: 1,
                  maxLength: 4000,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  keyboardType: TextInputType.name,
                  cursorColor: FlutterFlowTheme.of(context).primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
