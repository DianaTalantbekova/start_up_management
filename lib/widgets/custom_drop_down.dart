import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:start_up_management/resources/app_colors.dart';

import '../resources/app_styles.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> items;
  final String hint;
  final String? selectedValue;
  final Function(String?)? onChanged;

  const CustomDropdown({
    super.key,
    required this.items,
    this.hint = 'Select',
    this.selectedValue,
    this.onChanged,
  });

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  bool _isDropdownOpened = false;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Text(
          widget.hint,
          style: AppStyles.helper3.copyWith(color: AppColors.grayA2A9B8),
          overflow: TextOverflow.ellipsis,
        ),
        items: widget.items.map((String item) {
          Color textColor;
          switch (item) {
            case 'To do':
              textColor = AppColors.red;
              break;
            case 'In progress':
              textColor = AppColors.yellow;
              break;
            case 'Done':
              textColor = AppColors.green;
              break;
            default:
              textColor = Colors.white;
          }

          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: AppStyles.helper3.copyWith(color: textColor),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        value: widget.selectedValue,
        onChanged: (value) {
          setState(() {
            widget.onChanged?.call(value);
            _isDropdownOpened = !_isDropdownOpened;
          });
        },
        buttonStyleData: ButtonStyleData(
          width: double.infinity,
          height: 51.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.black212121,
          ),
        ),
        iconStyleData: IconStyleData(
          icon: SvgPicture.asset(
            _isDropdownOpened
                ? 'assets/icons/arrow_up.svg'
                : 'assets/icons/arrow_down.svg',
            fit: BoxFit.contain,
            width: 20.w,
            height: 20.h,
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200.h,
          width: 343.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.black212121,
          ),
          elevation: 0,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 50,
        ),
        onMenuStateChange: (isOpened) {
          setState(() {
            _isDropdownOpened = isOpened;
          });
        },
      ),
    );
  }
}