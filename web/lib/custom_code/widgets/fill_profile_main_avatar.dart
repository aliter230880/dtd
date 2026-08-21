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

import 'package:flutter_svg/flutter_svg.dart';

class FillProfileMainAvatar extends StatefulWidget {
  const FillProfileMainAvatar({
    super.key,
    this.width,
    this.height,
    this.bytes,
    required this.onTap,
  });

  final double? width;
  final double? height;
  final FFUploadedFile? bytes;
  final Future Function() onTap;

  @override
  State<FillProfileMainAvatar> createState() => _FillProfileMainAvatarState();
}

class _FillProfileMainAvatarState extends State<FillProfileMainAvatar> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: widget.onTap,
      child: Container(
        width: widget.width,
        height: widget.height,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: (widget.bytes?.bytes ?? []).isNotEmpty
            ? Image.memory(
                widget.bytes!.bytes!,
                fit: BoxFit.cover,
                width: widget.width,
                height: widget.height,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/error_image.png',
                  fit: BoxFit.cover,
                ),
              )
            : Center(
                child: SvgPicture.asset('assets/images/person.svg'),
              ),
      ),
    );
  }
}
