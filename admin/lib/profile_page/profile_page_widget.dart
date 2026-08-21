import 'package:auto_deal_admin/flutter_flow/flutter_flow_widgets.dart';
import 'package:auto_route/auto_route.dart';

import 'package:image_picker/image_picker.dart';

import '../flutter_flow/snackbar_service.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/enums/enums.dart';
import '/components/app_bar_widget.dart';
import '/components/app_button_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'profile_page_model.dart';
export 'profile_page_model.dart';

@RoutePage()
class ProfilePageWidget extends StatefulWidget {
  const ProfilePageWidget({super.key});

  @override
  State<ProfilePageWidget> createState() => _ProfilePageWidgetState();
}

class _ProfilePageWidgetState extends State<ProfilePageWidget> {
  late ProfilePageModel _model;
  bool isDataUploading = false;
  late TextEditingController nameController;
  late TextEditingController lastnameController;
  late TextEditingController phoneController;
  late TextEditingController positionController;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    nameController = TextEditingController(text: currentUserDisplayName);
    lastnameController = TextEditingController(text: valueOrDefault(currentUserDocument?.lastName, ''));
    phoneController = TextEditingController(text: currentPhoneNumber);

    super.initState();
    _model = createModel(context, () => ProfilePageModel());

    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textFieldFocusNode3 ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    nameController.dispose();
    lastnameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void onPickImage() async {
    if (isDataUploading) return;
    XFile? file = await ImagePickerHelper.pickImage(ImageSource.gallery);

    if (file == null) return;

    try {
      setState(() => isDataUploading = true);

      String? url = await ImagePickerHelper.uploadToDB(file);

      await currentUserReference!.update(createAdminsRecordData(photoUrl: url));

      setState(() => isDataUploading = false);
      if (mounted) {
        showSnackBar(context, 'Сохранено!');
      }
    } catch (e) {
      print(e);
      setState(() => isDataUploading = false);
    }
  }

  void onSave() async {
    if (nameController.text.isEmpty || lastnameController.text.isEmpty || phoneController.text.isEmpty) {
      showSnackBar(context, 'Заполните  поля');
      return;
    }
    await currentUserReference!.update(createAdminsRecordData(
      displayName: nameController.text,
      lastName: lastnameController.text,
      phoneNumber: phoneController.text,
    ));

    if(mounted){
      setState(() {
        _model.inEdit = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            wrapWithModel(
              model: _model.appBarModel,
              updateCallback: () => setState(() {}),
              child: const AppBarWidget(
                pageName: 'ПРОФИЛЬ',
              ),
            ),
         
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(110.0, 50.0, 0.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: const AlignmentDirectional(1.0, 1.0),
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: isDataUploading
                            ? SizedBox(width: 160.0, height: 160.0, child: loadingWidget(context))
                            : CachedNetworkImage(
                                fadeInDuration: const Duration(milliseconds: 500),
                                fadeOutDuration: const Duration(milliseconds: 500),
                                imageUrl: currentUserPhoto ??
                                    'https://firebasestorage.googleapis.com/v0/b/dealertodealer-84957.appspot.com/o/config%2Favatar.png?alt=media&token=83b57cc6-2b25-4c79-a195-04c51c6785a4',
                                width: 160.0,
                                height: 160.0,
                                errorWidget: (context, url, error) {
                                  print(error);
                                  return const Icon(Icons.error_outline);
                                },
                                fit: BoxFit.cover,
                              ),
                      ),
                      Builder(
                        builder: (context) {
                          if (_model.inEdit == true) {
                            return Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 2.0, 2.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: onPickImage,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(0.0),
                                    bottomRight: Radius.circular(0.0),
                                    topLeft: Radius.circular(0.0),
                                    topRight: Radius.circular(0.0),
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/images/Exclude.svg',
                                    width: 30.0,
                                    height: 30.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              decoration: const BoxDecoration(),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(70.0, 0.0, 0.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Имя',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                              ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 14.0),
                          child: SizedBox(
                            width: 380.0,
                            child: TextFormField(
                              controller: nameController,
                              focusNode: _model.textFieldFocusNode1,
                              autofocus: false,
                              textCapitalization: TextCapitalization.none,
                              textInputAction: TextInputAction.next,
                              readOnly: _model.inEdit == false,
                              obscureText: false,
                              decoration: InputDecoration(
                                hintText: 'Введите имя',
                                hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Inter',
                                      color: FlutterFlowTheme.of(context).hintText,
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                    ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFFBDBDBD),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFFBDBDBD),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFFBDBDBD),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFFBDBDBD),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                filled: true,
                                fillColor: FlutterFlowTheme.of(context).primaryBackground,
                                contentPadding: const EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
                              ),
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    color: FlutterFlowTheme.of(context).primaryText,
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                              validator: _model.textController1Validator.asValidator(context),
                            ),
                          ),
                        ),
                        Text(
                          'Фамилия',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                              ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 14.0),
                          child: SizedBox(
                            width: 380.0,
                            child: TextFormField(
                              controller: lastnameController,
                              focusNode: _model.textFieldFocusNode2,
                              autofocus: false,
                              textCapitalization: TextCapitalization.none,
                              textInputAction: TextInputAction.next,
                              readOnly: _model.inEdit == false,
                              obscureText: false,
                              decoration: InputDecoration(
                                hintText: 'Введите фамилию',
                                hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Inter',
                                      color: FlutterFlowTheme.of(context).hintText,
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                    ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFFBDBDBD),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFFBDBDBD),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFFBDBDBD),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFFBDBDBD),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                filled: true,
                                fillColor: FlutterFlowTheme.of(context).primaryBackground,
                                contentPadding: const EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
                              ),
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    color: FlutterFlowTheme.of(context).primaryText,
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                              validator: _model.textController2Validator.asValidator(context),
                            ),
                          ),
                        ),
                        Text(
                          'Должность',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                              ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 14.0),
                          child: Container(
                            width: 380.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primaryBackground,
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: const Color(0xFFBDBDBD),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(20.0, 16.0, 0.0, 16.0),
                              child: AuthUserStreamWidget(
                                builder: (context) => Text(
                                  currentUserDocument?.role == Role.superuser ? 'Администратор' : 'Сотрудник',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Inter',
                                        color: FlutterFlowTheme.of(context).primaryText,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'Номер телефона',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                              ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 14.0),
                          child: SizedBox(
                            width: 380.0,
                            child: TextFormField(
                              controller: phoneController,
                              focusNode: _model.textFieldFocusNode3,
                              autofocus: false,
                              textCapitalization: TextCapitalization.none,
                              textInputAction: TextInputAction.next,
                              readOnly: _model.inEdit == false,
                              obscureText: false,
                              decoration: InputDecoration(
                                hintText: 'Введите номер',
                                hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Inter',
                                      color: FlutterFlowTheme.of(context).hintText,
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                    ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFFBDBDBD),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFFBDBDBD),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFFBDBDBD),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFFBDBDBD),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                filled: true,
                                fillColor: FlutterFlowTheme.of(context).primaryBackground,
                                contentPadding: const EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 20.0),
                              ),
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    color: FlutterFlowTheme.of(context).primaryText,
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                              validator: _model.textController3Validator.asValidator(context),
                              inputFormatters: [_model.textFieldMask3],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: const AlignmentDirectional(1.0, 1.0),
                child: Builder(
                  builder: (context) {
                    if (_model.inEdit == true) {
                      return Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 18.0, 50.0),
                        child: AppButtonWidget(
                          label: 'Сохранить',
                          width: 300,
                          onPressed: onSave,
                          isActive: true,
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 18.0, 50.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            _model.inEdit = true;
                            setState(() {});
                          },
                          child: wrapWithModel(
                            model: _model.editButtonModel,
                            updateCallback: () => setState(() {}),
                            child: const AppButtonWidget(
                              label: 'Редактировать',
                              width: 300,
                              isActive: true,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
