import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../resources/app_colors.dart';

class OptionsDialog extends StatelessWidget {
  const OptionsDialog({super.key, required this.left, required this.top, this.onDelete, this.onEdit});

  final double left;
  final double top;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: left,
          top:  top,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 250.w,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(13.r),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: onEdit,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Edit',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 17.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SvgPicture.asset(
                              'assets/icons/edit.svg',
                              fit: BoxFit.contain,
                              width: 24.w,
                              height: 24.h,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(color: Colors.black, thickness: 0.5),
                    GestureDetector(

                      onTap: onDelete,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Delete',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 17.sp,
                                  color: const Color(0xFFFF462D),
                                ),
                              ),
                            ),
                            SvgPicture.asset(
                              'assets/icons/delete.svg',
                              fit: BoxFit.contain,
                              width: 24.w,
                              height: 24.h,
                              color: const Color(0xFFFF462D),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
