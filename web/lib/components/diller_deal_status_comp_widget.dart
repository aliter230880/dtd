import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'diller_deal_status_comp_model.dart';
export 'diller_deal_status_comp_model.dart';

class DillerDealStatusCompWidget extends StatefulWidget {
  const DillerDealStatusCompWidget({
    super.key,
    required this.status,
  });

  final DealStatus? status;

  @override
  State<DillerDealStatusCompWidget> createState() => _DillerDealStatusCompWidgetState();
}

class _DillerDealStatusCompWidgetState extends State<DillerDealStatusCompWidget> {
  late DillerDealStatusCompModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DillerDealStatusCompModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0.0, 0.0),
      child: Container(
        height: 25.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(
            color: () {
              if (widget.status == DealStatus.InSearch) {
                return const Color(0xFFF29C41);
              } else if (widget.status == DealStatus.InActive) {
                return const Color(0xFF14AE5C);
              } else if ((widget.status == DealStatus.InDispute) || (widget.status == DealStatus.Canceled)) {
                return const Color(0xFFF75555);
              } else if (widget.status == DealStatus.Completed) {
                return const Color(0xFF757575);
              } else {
                return const Color(0xFF5089FD);
              }
            }(),
            width: 1.0,
          ),
        ),
        child: Align(
          alignment: const AlignmentDirectional(0.0, 0.0),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
            child: Text(
              () {
                if (widget.status == DealStatus.InSearch) {
                  return FFLocalizations.of(context).getText('diller_status_in_search');
                } else if (widget.status == DealStatus.InConfirm) {
                  return FFLocalizations.of(context).getText('diller_status_in_confirm');
                } else if (widget.status == DealStatus.InActive) {
                  return FFLocalizations.of(context).getText('diller_status_in_active');
                } else if (widget.status == DealStatus.InDispute) {
                  return FFLocalizations.of(context).getText('diller_status_in_dispute');
                } else if (widget.status == DealStatus.Canceled) {
                  return FFLocalizations.of(context).getText('diller_status_in_canceled_by_diller');
                } else if (widget.status == DealStatus.CanceledByAdmin) {
                  return FFLocalizations.of(context).getText('diller_status_in_canceled');
                } else if (widget.status == DealStatus.InConfirmComplete) {
                  return FFLocalizations.of(context).getText('diller_status_in_confirm_complete');
                } else {
                  return FFLocalizations.of(context).getText('diller_status_in_complete');
                }
              }(),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    color: () {
                      if (widget.status == DealStatus.InSearch) {
                        return const Color(0xFFF29C41);
                      } else if (widget.status == DealStatus.InActive) {
                        return const Color(0xFF14AE5C);
                      } else if ((widget.status == DealStatus.InDispute) || (widget.status == DealStatus.Canceled)) {
                        return const Color(0xFFF75555);
                      } else if (widget.status == DealStatus.Completed) {
                        return const Color(0xFF757575);
                      } else {
                        return const Color(0xFF5089FD);
                      }
                    }(),
                    fontSize: 11.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                    useGoogleFonts: false,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
