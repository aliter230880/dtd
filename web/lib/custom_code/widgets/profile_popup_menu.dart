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

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../auth/firebase_auth/auth_util.dart';

class ProfilePopupMenu extends StatefulWidget {
  const ProfilePopupMenu({
    super.key,
    this.width,
    this.height,
    required this.onEditData,
    this.onEditCars,
    this.onExit,
    required this.onDeleteAccount,
  });

  final double? width;
  final double? height;
  final Future Function() onEditData;
  final Future Function()? onEditCars;
  final Future Function()? onExit;
  final Future Function() onDeleteAccount;

  @override
  State<ProfilePopupMenu> createState() => _ProfilePopupMenuState();
}

class _ProfilePopupMenuState extends State<ProfilePopupMenu> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: Icon(
          Icons.more_vert,
          size: 24,
          color: FlutterFlowTheme.of(context).primaryText,
        ),
        items: [
          DropdownMenuItem(
            value: 'data',
            onTap: widget.onEditData,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  FontAwesomeIcons.penToSquare,
                  color: Color(0xFF424245),
                  size: 22,
                ),
                const SizedBox(width: 16),
                Text(
                  'Ваши данные',
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: 'Inter',
                        color: const Color(0xFF424245),
                        letterSpacing: 0.0,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        useGoogleFonts: false,
                      ),
                ),
              ],
            ),
          ),
          if (currentUserDocument?.type == UserType.Diller)
            DropdownMenuItem<Divider>(
              enabled: false,
              child: Divider(
                color: const Color(0xFF111111).withOpacity(0.25),
                // height: 0,
                thickness: 1,
              ),
            ),
          if (currentUserDocument?.type == UserType.Diller)
            DropdownMenuItem(
              value: 'car',
              onTap: widget.onEditCars,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    FontAwesomeIcons.penToSquare,
                    color: Color(0xFF424245),
                    size: 22,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Номер авто',
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          fontFamily: 'Inter',
                          color: const Color(0xFF424245),
                          letterSpacing: 0.0,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          useGoogleFonts: false,
                        ),
                  ),
                ],
              ),
            ),
          DropdownMenuItem<Divider>(
            enabled: false,
            child: Divider(
              color: const Color(0xFF111111).withOpacity(0.25),
              // height: 0,
              thickness: 1,
            ),
          ),
          DropdownMenuItem(
            value: 'logout',
            onTap: widget.onExit,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const RotatedBox(
                    quarterTurns: 2,
                    child: Icon(Icons.exit_to_app_outlined,
                        color: Color(0xFF424245), size: 24)),
                const SizedBox(width: 16),
                Text(
                  'Выйти из аккаунта',
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: 'Inter',
                        color: const Color(0xFF424245),
                        letterSpacing: 0.0,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        useGoogleFonts: false,
                      ),
                ),
              ],
            ),
          ),
          DropdownMenuItem<Divider>(
            enabled: false,
            child: Divider(
              color: const Color(0xFF111111).withOpacity(0.25),
              // height: 0,
              thickness: 1,
            ),
          ),
          DropdownMenuItem(
            value: 'delete',
            onTap: widget.onDeleteAccount,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.backspace_outlined,
                  color: Color(0xFF424245),
                  size: 22,
                ),
                const SizedBox(width: 16),
                Text(
                  'Удалить аккаунт',
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: 'Inter',
                        color: const Color(0xFF424245),
                        letterSpacing: 0.0,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        useGoogleFonts: false,
                      ),
                ),
              ],
            ),
          ),
        ],
        onChanged: (value) {},
        dropdownStyleData: DropdownStyleData(
          width: 210,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xFFE9E9E9),
          ),
          offset: const Offset(-181, 0),
        ),
        menuItemStyleData: MenuItemStyleData(
          customHeights: (currentUserDocument?.type == UserType.Diller)
              ? [44, 1, 44, 1, 44, 1, 44]
              : [44, 1, 44, 1, 44],
          padding: const EdgeInsets.only(left: 16, right: 16),
        ),
      ),
    );
  }
}
