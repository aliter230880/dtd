// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:scroll_date_picker/scroll_date_picker.dart';

class CreateDealTimePicker extends StatefulWidget {
  const CreateDealTimePicker({
    super.key,
    this.width,
    this.height,
    required this.currentTime,
    required this.onChange,
  });

  final double? width;
  final double? height;
  final DateTime currentTime;
  final Future Function(DateTime time) onChange;

  @override
  State<CreateDealTimePicker> createState() => _CreateDealTimePickerState();
}

class _CreateDealTimePickerState extends State<CreateDealTimePicker> {
  @override
  Widget build(BuildContext context) {
    // final locale = Locale.fromSubtags(languageCode: FFLocalizations.of(context).languageCode);
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 180,
        child: ScrollDatePicker(
          selectedDate: widget.currentTime,
          viewType: [DatePickerViewType.day, DatePickerViewType.month],
          onDateTimeChanged: widget.onChange,
          maximumDate: getCurrentTimestamp.add(Duration(days: 30)),
          minimumDate: getCurrentTimestamp,
          scrollViewOptions: DatePickerScrollViewOptions(
            day: ScrollViewDetailOptions(
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'Inter',
                    color: FlutterFlowTheme.of(context).primaryText,
                    letterSpacing: 0.0,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    useGoogleFonts: false,
                  ),
              selectedTextStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'Inter',
                    color: FlutterFlowTheme.of(context).primaryText,
                    letterSpacing: 0.0,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    useGoogleFonts: false,
                  ),
            ),
            month: ScrollViewDetailOptions(
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.of(context).primaryText,
                      letterSpacing: 0.0,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      useGoogleFonts: false,
                    ),
                selectedTextStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.of(context).primaryText,
                      letterSpacing: 0.0,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      useGoogleFonts: false,
                    ),
                margin: EdgeInsets.only(left: 20)),
            year: ScrollViewDetailOptions(
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'Inter',
                    color: FlutterFlowTheme.of(context).primaryText,
                    letterSpacing: 0.0,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    useGoogleFonts: false,
                  ),
              selectedTextStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    fontFamily: 'Inter',
                    color: FlutterFlowTheme.of(context).primaryText,
                    letterSpacing: 0.0,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    useGoogleFonts: false,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
