import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import '/auth/firebase_auth/auth_util.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'app_bar_model.dart';
export 'app_bar_model.dart';

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({
    super.key,
    String? pageName,
  }) : pageName = pageName ?? '.';

  final String pageName;

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  late AppBarModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AppBarModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  Widget customWidget() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 50.0, 15.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: CachedNetworkImage(
              fadeInDuration: const Duration(milliseconds: 500),
              fadeOutDuration: const Duration(milliseconds: 500),
              imageUrl: currentUserPhoto ??
                  'https://firebasestorage.googleapis.com/v0/b/dealertodealer-84957.appspot.com/o/config%2Favatar.png?alt=media&token=83b57cc6-2b25-4c79-a195-04c51c6785a4',
              width: 52.0,
              height: 52.0,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) {
                print(error);
                return const Icon(Icons.error_outline);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuthUserStreamWidget(
                  builder: (context) => Text(
                    '$currentUserDisplayName ${valueOrDefault(currentUserDocument?.lastName, '')}',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 18.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 0.0),
                  child: AuthUserStreamWidget(
                    builder: (context) => Text(
                      currentUserDocument?.role == Role.superuser ? 'Администратор' : 'Сотрудник',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            color: FlutterFlowTheme.of(context).hintText,
                            fontSize: 14.0,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(50.0, 0.0, 0.0, 0.0),
              child: Text(
                widget.pageName,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      fontSize: 22.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            SizedBox(
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  items: [
                    DropdownMenuItem(
                      value: 'signout',
                      child: Container(
                        width: 210.0,
                        height: 58.0,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          // boxShadow: [
                          //   BoxShadow(
                          //     blurRadius: 100.0,
                          //     color: const Color(0xFF04060F).withOpacity(0.08),
                          //     offset: const Offset(
                          //       0.0,
                          //       20.0,
                          //     ),
                          //   )
                          // ],
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16.0),
                            bottomRight: Radius.circular(16.0),
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(0.0),
                          ),
                        ),
                        child: Align(
                          alignment: const AlignmentDirectional(0.0, 0.0),
                          child: Text(
                            'Выйти',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  customButton: customWidget(),
                  alignment: Alignment.centerRight,
                  onChanged: (value) async {
                    await authManager.signOut();
                    if (context.mounted) {
                      Phoenix.rebirth(context);
                    }
                  },
                  dropdownStyleData: const DropdownStyleData(
                    elevation: 1,
                    width: 210,
                    maxHeight: 58,
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16.0),
                        bottomRight: Radius.circular(16.0),
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(0.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const Divider(
          height: 1.0,
          thickness: 1.0,
          color: Color(0xFFE0E0E0),
        ),
      ],
    );
  }
}
