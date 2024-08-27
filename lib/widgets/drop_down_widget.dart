import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:start_up_management/resources/app_styles.dart';

import '../resources/app_colors.dart';

class Category {
  final List<Description> tasks;

  Category({required this.tasks});
}

class Description {
  final String title;
  final String description;

  Description({required this.title, required this.description});
}

class DropDownWidget extends StatefulWidget {
  const DropDownWidget({
    super.key,
    required this.categories,
    required this.click,
    this.title,
    this.hint = 'Select an option',
    this.selectedText = '',
  });

  final List<Category> categories;
  final Function(String text, String desc) click;
  final String? title;
  final String hint;
  final String selectedText;

  @override
  _DropDownWidgetState createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  int selectedTile = -1;
  late String selectedText = widget.selectedText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.categories.map((category) {
        final isExpanded = widget.categories.indexOf(category) == selectedTile;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTile =
                        isExpanded ? -1 : widget.categories.indexOf(category);
                  });
                },
                child: Container(
                  height: 50.h,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(selectedText.isEmpty ? widget.hint : selectedText,
                          style: AppStyles.helper3.copyWith(
                            color: selectedText.isEmpty
                                ? AppColors.grayA2A9B8
                                : AppColors.black,
                          )),
                      SvgPicture.asset(
                        isExpanded
                            ? 'assets/png/icons/arrow_up.svg'
                            : 'assets/png/icons/arrow_down.svg',
                        width: 24.w,
                        height: 24.h,
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: isExpanded ? 1.0 : 0.0,
                child: const Divider(
                  color: Color(0xFF3E3E3E),
                  thickness: 1.0,
                  height: 1.0,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: isExpanded ? null : 0,
                child: isExpanded
                    ? SingleChildScrollView(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20.r),
                              bottomLeft: Radius.circular(20.r),
                            ),
                          ),
                          child: Column(
                            children: category.tasks.map((task) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 8.h),
                                child: GestureDetector(
                                  onTap: () {
                                    widget.click(task.title, task.description);
                                    setState(() {
                                      selectedText = task.title;
                                      selectedTile = -1;
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            task.title,
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.grayA2A9B8,
                                            ),
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
