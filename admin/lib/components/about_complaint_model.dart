import '/components/active_complaint_widget.dart';
import '/components/no_active_complaints_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'about_complaint_widget.dart' show AboutComplaintWidget;
import 'package:flutter/material.dart';

class AboutComplaintModel extends FlutterFlowModel<AboutComplaintWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for ActiveComplaint component.
  late ActiveComplaintModel activeComplaintModel;
  // Model for NoActiveComplaints component.
  late NoActiveComplaintsModel noActiveComplaintsModel;

  @override
  void initState(BuildContext context) {
    activeComplaintModel = createModel(context, () => ActiveComplaintModel());
    noActiveComplaintsModel =
        createModel(context, () => NoActiveComplaintsModel());
  }

  @override
  void dispose() {
    activeComplaintModel.dispose();
    noActiveComplaintsModel.dispose();
  }
}
