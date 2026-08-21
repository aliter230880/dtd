// ignore_for_file: use_build_context_synchronously

import 'package:auto_deal_admin/flutter_flow/flutter_flow_drop_down.dart';
import 'package:auto_deal_admin/flutter_flow/form_field_controller.dart';
import 'package:collection/collection.dart';

import '/backend/backend.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'edit_worker_model.dart';
export 'edit_worker_model.dart';

class EditWorkerWidget extends StatefulWidget {
  final AdminsRecord adminRecord;
  const EditWorkerWidget({super.key, required this.adminRecord});

  @override
  State<EditWorkerWidget> createState() => _EditWorkerWidgetState();
}

class _EditWorkerWidgetState extends State<EditWorkerWidget> {
  late EditWorkerModel _model;
  List<AdminAccess> selectedAccess = [];

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    selectedAccess.addAll(widget.adminRecord.access);
    super.initState();
    _model = createModel(context, () => EditWorkerModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 480.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(32.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: const AlignmentDirectional(1.0, -1.0),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 45.0, 45.0, 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.clear_rounded,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 40.0,
                ),
              ),
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(0.0, 0.0),
            child: Text(
              'Редактирование',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    fontSize: 26.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(50.0, 40.0, 0.0, 0.0),
            child: Text(
              'Задачи',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(50.0, 12.0, 50.0, 40.0),
            child: FlutterFlowDropDown<AdminAccess>(
              multiSelectController: FormFieldController<List<AdminAccess>>(selectedAccess),
              options: List<AdminAccess>.from(AdminAccess.values),
              optionLabels: AdminAccess.values.map((e) => e).toList().map((e) => adminAccessName(e) ?? '').toList(),
              width: double.infinity,
              height: 44.0,
              // onChanged: (val) async {
              //   setState(() {
              //     _model.selectedRole = _model.dropDownValue1;
              //   });
              // },
              textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                  ),
              labelTextStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                  ),
              hintText: 'Выберите задачи сотрудника',
              icon: Icon(
                Icons.expand_circle_down,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 18.0,
              ),
              fillColor: FlutterFlowTheme.of(context).primaryBackground,
              elevation: 0.0,
              borderColor: FlutterFlowTheme.of(context).secondaryBackground,
              borderWidth: 1.0,
              borderRadius: 10.0,
              margin: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              hidesUnderline: true,
              isOverButton: false,
              isSearchable: false,
              isMultiSelect: true,
              onMultiSelectChanged: (val) async {
                // setState(() => _model.dropDownValue2 = val);
                setState(() {
                  selectedAccess = val!;
                });
              },
            ),
          ),
          if (selectedAccess.isNotEmpty)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(50.0, 0.0, 50.0, 60.0),
              child: GestureDetector(
                onTap: () async {
                  bool isFullAccess = selectedAccess.firstWhereOrNull((a) => a == AdminAccess.all) != null;

                  await widget.adminRecord.reference.update({
                    ...mapToFirestore(
                      {
                        'access': isFullAccess ? ['all'] : selectedAccess.map((e) => e.serialize()).toList(),
                      },
                    ),
                  });

                  if (context.mounted) Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  height: 42.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        FlutterFlowTheme.of(context).yellowGradient2,
                        FlutterFlowTheme.of(context).yellowGradient1
                      ],
                      stops: const [0.0, 1.0],
                      begin: const AlignmentDirectional(0.03, -1.0),
                      end: const AlignmentDirectional(-0.03, 1.0),
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  alignment: const AlignmentDirectional(0.0, 0.0),
                  child: Text(
                    'Сохранить',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
