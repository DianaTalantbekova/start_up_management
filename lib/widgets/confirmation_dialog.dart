import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    this.onTap,
    required this.description,
    this.name,
    this.leftText,
    this.isRed = true,
  });

  final VoidCallback? onTap;
  final String description;
  final String? name;
  final String? leftText;
  final bool isRed;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        name ?? 'Are you sure?',
        style: TextStyle(
          fontSize: 17.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(
        description,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text(
            'Stay',
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF007AFF),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        CupertinoDialogAction(
          onPressed: onTap,
          child: Text(
            leftText ?? 'Delete',
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
              color: isRed ? const Color(0xFFFF462D) : const Color(0xFF007AFF),
            ),
          ),
        ),
      ],
    );
  }
}
