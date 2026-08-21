import 'package:auto_deal_admin/auth/firebase_auth/auth_util.dart';
import 'package:auto_deal_admin/workers_page/workers_page_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/backend/backend.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'edit_worker_widget.dart';
import 'workers_tab_model.dart';
export 'workers_tab_model.dart';

class WorkersTabWidget extends StatefulWidget {
  final StaffFilter filter;
  const WorkersTabWidget({super.key, required this.filter});

  @override
  State<WorkersTabWidget> createState() => _WorkersTabWidgetState();
}

class _WorkersTabWidgetState extends State<WorkersTabWidget> {
  late WorkersTabModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WorkersTabModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  Widget customButton() {
    return SvgPicture.asset('assets/images/more_circle.svg');
  }

  void onTapDropdown(AdminsRecord admin, bool isEdit) async {
    if (isEdit) {
      await showDialog(
        context: context,
        builder: (dialogContext) {
          return Dialog(
            elevation: 0,
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            alignment: const AlignmentDirectional(0.0, 0.0).resolve(Directionality.of(context)),
            child: EditWorkerWidget(adminRecord: admin),
          );
        },
      );

      if (mounted) {
        setState(() {});
      }
    } else {
      bool isBlocked = admin.isBlocked;
      await admin.reference.update(createAdminsRecordData(isBlocked: !isBlocked));
      if (mounted) setState(() => ());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(0.0),
          bottomRight: Radius.circular(0.0),
          topLeft: Radius.circular(0.0),
          topRight: Radius.circular(0.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Divider(
            height: 1.0,
            thickness: 1.0,
            color: Color(0xFFE0E0E0),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
            child: Container(
              height: 44.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(0.0),
                  bottomRight: Radius.circular(0.0),
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                border: Border.all(
                  color: const Color(0xFFE9E9E9),
                  width: 1.0,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    child: Text(
                      '№',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            color: FlutterFlowTheme.of(context).hintText,
                            fontSize: 12.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: SizedBox(
                      width: 320,
                      child: Text(
                        'Ф.И.О.',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              color: FlutterFlowTheme.of(context).hintText,
                              fontSize: 12.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Задачи',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            color: FlutterFlowTheme.of(context).hintText,
                            fontSize: 12.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Статус',
                      textAlign: TextAlign.start,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            color: FlutterFlowTheme.of(context).hintText,
                            fontSize: 12.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder<List<AdminsRecord>>(
            future: queryAdminsRecordOnce(
              queryBuilder: (adminsRecord) {
                adminsRecord = adminsRecord.where(
                  'status',
                  isEqualTo: AdminStatus.accept.serialize(),
                );

                if (widget.filter == StaffFilter.Blocked) {
                  adminsRecord = adminsRecord.where('is_blocked', isEqualTo: true);
                } else if (widget.filter == StaffFilter.Active) {
                  adminsRecord = adminsRecord.where('is_blocked', isEqualTo: false);
                }

                return adminsRecord;
              },
            ),
            builder: (context, snapshot) {
              // Customize what your widget looks like when it's loading.
              if (!snapshot.hasData) {
                return Center(
                  child: SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  ),
                );
              }
              List<AdminsRecord> listViewAdminsRecordList =
                  snapshot.data!.where((u) => u.uid != currentUserUid).toList();

              if (listViewAdminsRecordList.isEmpty) {
                return const Expanded(child: _EmptyWidget());
              }

              return Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  itemCount: listViewAdminsRecordList.length,
                  itemBuilder: (context, listViewIndex) {
                    final listViewAdminsRecord = listViewAdminsRecordList[listViewIndex];
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFE9E9E9),
                          width: 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: 48.0,
                            height: 64.0,
                            decoration: const BoxDecoration(),
                            child:
                                // add +1
                                Align(
                              alignment: const AlignmentDirectional(0.0, 0.0),
                              child: Text(
                                (listViewIndex + 1).toString(),
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Inter',
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ),
                          ),
                          Container(
                            height: 64.0,
                            width: 320,
                            decoration: const BoxDecoration(),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 12.0, 0.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100.0),
                                    child: CachedNetworkImage(
                                      fadeInDuration: const Duration(milliseconds: 500),
                                      fadeOutDuration: const Duration(milliseconds: 500),
                                      imageUrl: listViewAdminsRecord.photoUrl ??
                                          'https://firebasestorage.googleapis.com/v0/b/dealertodealer-84957.appspot.com/o/config%2Favatar.png?alt=media&token=83b57cc6-2b25-4c79-a195-04c51c6785a4',
                                      width: 36.0,
                                      height: 36.0,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, error, stackTrace) => Image.asset(
                                        'assets/images/error_image.svg',
                                        width: 36.0,
                                        height: 36.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  '${listViewAdminsRecord.displayName} ${listViewAdminsRecord.lastName}',
                                  maxLines: 1,
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Inter',
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.normal,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 24),
                              child: Text(
                                listViewAdminsRecord.access.map((e) => adminAccessName(e)).toList().join(', '),
                                maxLines: 3,
                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Inter',
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                    ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 68),
                                  decoration: BoxDecoration(
                                    color: valueOrDefault<Color>(
                                      listViewAdminsRecord.isBlocked
                                          ? FlutterFlowTheme.of(context).error
                                          : FlutterFlowTheme.of(context).success,
                                      FlutterFlowTheme.of(context).success,
                                    ),
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Align(
                                    alignment: const AlignmentDirectional(0.0, 0.0),
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(8.0, 2.0, 8.0, 2.0),
                                      child: Text(
                                        valueOrDefault<String>(
                                          listViewAdminsRecord.isBlocked ? 'Заблокирован' : 'Активен',
                                          'Активен',
                                        ),
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: 'Inter',
                                              color: FlutterFlowTheme.of(context).primaryText,
                                              fontSize: 12.0,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 68.0,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                items: [
                                  DropdownMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset('assets/images/Edit.svg'),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Редактировать',
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: 'Inter',
                                                fontSize: 14.0,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'block',
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset('assets/images/Unlock.svg'),
                                        const SizedBox(width: 4),
                                        Text(
                                          listViewAdminsRecord.isBlocked ? 'Разблокировать' : 'Заблокировать',
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: 'Inter',
                                                fontSize: 14.0,
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                value: null,
                                onChanged: (String? value) {
                                  if (value != null) {
                                    onTapDropdown(listViewAdminsRecord, value == 'edit');
                                  }
                                  print(value);
                                },
                                customButton: customButton(),
                                dropdownStyleData: DropdownStyleData(offset: const Offset(-150, 0),
                                  elevation: 2,
                                  width: 212,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 44,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _EmptyWidget extends StatelessWidget {
  const _EmptyWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Align(
            alignment: const AlignmentDirectional(-0.11, 0.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(0.0),
                bottomRight: Radius.circular(0.0),
                topLeft: Radius.circular(0.0),
                topRight: Radius.circular(0.0),
              ),
              child: Image.asset(
                'assets/images/search.png',
                width: 142.0,
                height: 142.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                  child: Text(
                    'Сотрудников нет',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          fontSize: 26.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Text(
                  'Пока в вашем приложении нет ни одного активного сотрудника',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        color: FlutterFlowTheme.of(context).hintText,
                        fontSize: 18.0,
                        letterSpacing: 0.0,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
