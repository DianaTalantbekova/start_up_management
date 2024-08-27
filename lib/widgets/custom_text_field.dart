import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../resources/app_colors.dart';
import '../resources/app_styles.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.maxLines,
    this.hintText,
    this.color,
    this.hasBorder = true,
    this.hasIcon = false,
    required this.controller,
    this.onCrossTap, this.onChanged,
  });

  final int? maxLines;
  final String? hintText;
  final Color? color;
  final bool hasBorder;
  final bool hasIcon;
  final TextEditingController controller;
  final VoidCallback? onCrossTap;
  final void Function(String)? onChanged;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 16.w, vertical: widget.hasBorder ? 8.h : 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
            color: widget.hasBorder ? AppColors.grayA2A9B8 : AppColors.black212121),
        color: widget.color ?? AppColors.black,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: widget.onChanged,
              controller: widget.controller,
              cursorColor: Colors.white,
              style: AppStyles.helper3,
              maxLines: widget.maxLines ?? 1,
              decoration: InputDecoration.collapsed(
                hintText: widget.hintText ?? 'Enter a project Name',
                hintStyle:
                AppStyles.helper3.copyWith(color: AppColors.grayA2A9B8),
              ),
            ),
          ),
          if (widget.controller.text.isNotEmpty && widget.hasIcon)
            GestureDetector(
              onTap: widget.onCrossTap,
              child: SvgPicture.asset(
                'assets/icons/cross.svg',
                fit: BoxFit.contain,
                width: 24.w,
                height: 24.h,
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }
}
