import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../resources/app_colors.dart';
import '../resources/app_styles.dart';

class DateTextWidget extends StatelessWidget {

  const DateTextWidget({
    super.key,
    required this.text,
    this.onTap, this.dateTime,
  });

  final String text;
  final VoidCallback? onTap;
  final DateTime? dateTime;

  @override
  Widget build(BuildContext context) {
    String month = DateFormat.MMMM().format(dateTime!);
    String date = DateFormat.d().format(dateTime!);
    String year = DateFormat.y().format(dateTime!);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: AppStyles.helper3.copyWith(color: AppColors.grayA2A9B8),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: Colors.white),
            ),
            child: Text(
              '$month $date, $year',
              style: AppStyles.helper3,
            ),
          ),
        )
      ],
    );
  }
}
