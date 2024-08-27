import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:start_up_management/resources/app_colors.dart';
import 'package:start_up_management/widgets/date_text_widget.dart';
import 'package:start_up_management/widgets/team_member_dialog.dart';

import '../../event_bus.dart';
import '../../models/project_model.dart';
import '../../resources/app_styles.dart';
import '../../widgets/confirmation_dialog.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/drop_down_widget.dart';

class AddProject extends StatefulWidget {
  const AddProject({super.key});

  @override
  State<AddProject> createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  DateTime? _startDate;
  DateTime? _endDate;
  DateTime? _selectedDate;
  final List<TextEditingController> _budgetControllers = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  Status? status;
  final List<Map<String, dynamic>> _teamMembers = [];

  @override
  void initState() {
    super.initState();
    _budgetControllers.add(TextEditingController());
  }

  void _addBudgetField() {
    if (_budgetControllers.isNotEmpty && _budgetControllers.last.text.isEmpty) {
    } else {
      setState(() {
        _budgetControllers.add(TextEditingController());
      });
    }
  }

  void _removeBudgetField(int index) {
    setState(() {
      if (_budgetControllers.isNotEmpty) {
        TextEditingController controller = _budgetControllers.removeAt(index);
        controller.dispose();

        if (_budgetControllers.isEmpty) {
          _budgetControllers.add(TextEditingController());
        }
      }
    });
  }

  Future<void> _onSave() async {
    try {
      final projectKey = DateTime.now().toIso8601String();

      List<String> budgetAllocations =
          _budgetControllers.map((controller) => controller.text).toList();

      print("Budget Allocations: $budgetAllocations");

      List<TeamMember> teamMembersData = _teamMembers.map((member) {
        print("Converting member: $member");
        return TeamMember(
          name: member['name'],
          position: member['position'],
          imagePath: member['image'] != null
              ? (member['image'] as File).path
              : null,
        );
      }).toList();

      final addProject = Project(
        name: _nameController.text,
        description: _descriptionController.text,
        id: projectKey,
        budgetAllocations: budgetAllocations,
        teamMembers: teamMembersData,
        status: status ?? Status.values.first,
        startDate: _startDate ?? DateTime.now(),
        endDate: _endDate ?? DateTime.now(),
      );

      print("Project to save: $addProject");

      var data = GetIt.I.get<Box<Project>>();
      data.put(projectKey, addProject);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: () {
          _onSave();
        },
        child: Container(
          alignment: Alignment.center,
          height: 51.h,
          margin: EdgeInsets.symmetric(horizontal: 107.w),
          decoration: BoxDecoration(
            color: AppColors.blue1C4DFA,
            borderRadius: BorderRadius.circular(7.r),
          ),
          child: Text(
            'Add project',
            style: AppStyles.helper1,
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: AppColors.black,
        leading: GestureDetector(
          onTap: () => _onBackPressed(context),
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/cross.svg',
              fit: BoxFit.contain,
              width: 24.w,
              height: 24.h,
            ),
          ),
        ),
        title: Text(
          'Project',
          style: AppStyles.helper2,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color(0xFF3E3E3E),
            height: 1.0,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
              CustomTextField(
                controller: _nameController,
                onChanged: (value) {
                  setState(() {});
                },
              ),
              SizedBox(height: 24.h),
              DateTextWidget(
                onTap: () => _showDatePicker(context, true),
                text: 'Start date',
                dateTime: _startDate ?? DateTime.now(),
              ),
              SizedBox(height: 24.h),
              DateTextWidget(
                onTap: () => _showDatePicker(context, false),
                text: 'End date',
                dateTime: _endDate ?? DateTime.now(),
              ),
              SizedBox(height: 24.h),
              Text(
                'Description',
                style: AppStyles.helper3,
              ),
              SizedBox(height: 8.h),
              CustomTextField(
                hintText: 'Enter a description',
                maxLines: 5,
                color: AppColors.black212121,
                hasBorder: false,
                hasIcon: false,
                controller: _descriptionController,
                onChanged: (value) {
                  setState(() {});
                },
              ),
              SizedBox(height: 24.h),
              Text(
                'Budget allocation',
                style: AppStyles.helper3,
              ),
              ..._budgetControllers.asMap().entries.map((entry) {
                int index = entry.key;
                TextEditingController controller = entry.value;

                return Column(
                  children: [
                    SizedBox(height: 8.h),
                    CustomTextField(
                      hasBorder: false,
                      color: AppColors.black212121,
                      hintText: 'Enter a budget',
                      hasIcon: controller.text.isNotEmpty,
                      controller: controller,
                      onCrossTap: () {
                        _removeBudgetField(index);
                      },
                    ),
                  ],
                );
              }).toList(),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: _addBudgetField,
                child: Container(
                  alignment: Alignment.center,
                  height: 51.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Text(
                    'Add a new budget',
                    style: AppStyles.helper3,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'Status',
                style: AppStyles.helper3,
              ),
              SizedBox(height: 8.h),
              CustomDropdown(
                selectedValue: status?.getItem(),
                items: Status.values
                    .map(
                      (e) => e.getItem(),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {});
                  status = Status.values
                      .where(
                        (element) => element.getItem() == value,
                      )
                      .firstOrNull;
                },
              ),
              SizedBox(height: 24.h),
              Text(
                'Team members',
                style: AppStyles.helper3,
              ),
              SizedBox(height: 8.h),
              if (_teamMembers.isNotEmpty)
                SizedBox(
                  height: 150.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _teamMembers.length + 1,
                    itemBuilder: (context, index) {
                      if (index < _teamMembers.length) {
                        final member = _teamMembers[index];
                        return Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            width: 109.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.r),
                              color: AppColors.black212121,
                            ),
                            child: Column(
                              children: [
                                member['image'] != null
                                    ? CircleAvatar(
                                        maxRadius: 30,
                                        minRadius: 30,
                                        backgroundImage:
                                            FileImage(member['image']),
                                      )
                                    : CircleAvatar(
                                        maxRadius: 30,
                                        minRadius: 30,
                                        child: Text(member['name'][0]),
                                      ),
                                SizedBox(height: 8.h),
                                IntrinsicWidth(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6.w, vertical: 4.h),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2.r),
                                      border: Border.all(
                                          color: AppColors.grayA2A9B8),
                                    ),
                                    child: Text(
                                      member['name'],
                                      style: AppStyles.helper3,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                if(member['position'] != null)
                                IntrinsicWidth(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6.w, vertical: 4.h),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2.r),
                                      border: Border.all(
                                          color: AppColors.grayA2A9B8),
                                    ),
                                    child: Text(
                                      member['position'],
                                      style: AppStyles.helper3.copyWith(
                                          color: AppColors.grayA2A9B8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return GestureDetector(
                          onTap: _showTeamMemberDialog,
                          child: Container(
                            alignment: Alignment.center,
                            height: 87.h,
                            width: 109.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.r),
                              color: AppColors.black212121,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/plus.svg',
                                  fit: BoxFit.contain,
                                  width: 24.w,
                                  height: 24,
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  'Add',
                                  style: AppStyles.helper3,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              if (_teamMembers.isEmpty)
                GestureDetector(
                  onTap: _showTeamMemberDialog,
                  child: Container(
                    alignment: Alignment.center,
                    height: 87.h,
                    width: 109.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.r),
                      color: AppColors.black212121,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/plus.svg',
                          fit: BoxFit.contain,
                          width: 24.w,
                          height: 24,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'Add',
                          style: AppStyles.helper3,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 90.h),
            ],
          ),
        ),
      ),
    );
  }

  void _showDatePicker(BuildContext context, bool isStart) {
    DateTime initialDate =
        isStart ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now());

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          backgroundColor: AppColors.black212121,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 24.w),
                    Text(
                      isStart ? 'Start date' : 'End date',
                      style: AppStyles.helper3,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: SvgPicture.asset(
                        'assets/icons/cross.svg',
                        fit: BoxFit.contain,
                        width: 24.w,
                        height: 24.h,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 200.h,
                  child: CupertinoTheme(
                    data: CupertinoThemeData(
                      brightness: Brightness.dark,
                    ),
                    child: CupertinoDatePicker(
                      backgroundColor: AppColors.black212121,
                      initialDateTime: initialDate,
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: (val) {
                        setState(() {
                          _selectedDate = val;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 28.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDate = DateTime.now();
                            if (isStart) {
                              _startDate = DateTime.now();
                            } else {
                              _endDate = DateTime.now();
                            }
                          });
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 51.h,
                          width: 115.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(7.r),
                          ),
                          child: Text(
                            'Reset',
                            style: AppStyles.helper3,
                          ),
                        ),
                      ),
                      SizedBox(width: 20.w),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isStart) {
                              _startDate = _selectedDate;
                            } else {
                              _endDate = _selectedDate;
                            }
                            _selectedDate = null;
                          });
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 51.h,
                          width: 115.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.r),
                            color: AppColors.blue1C4DFA,
                          ),
                          child: Text(
                            'Select',
                            style: AppStyles.helper3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showTeamMemberDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return const TeamMemberDialog(
          name: 'N',
          asset: 'assets/icons/plus.svg',
        );
      },
    );

    if (result != null) {
      setState(() {
        _teamMembers.add({
          'name': result['name'] ?? '',
          'position': result['position'] ?? '',
          'image': result['image'],
        });
      });
    }
  }

  void _showExitConfirmationDialog(BuildContext context) {
    showCupertinoDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          onTap: () {
            Navigator.of(context).pop(true);
            Navigator.pop(context);
          },
          name: 'Do you still want to exit?',
          description:
              'You have not saved your draft. Click “add project” to do that',
          leftText: 'Exit',
          isRed: false,
        );
      },
    );
  }

  void _onBackPressed(BuildContext context) {
    if (_nameController.text.isNotEmpty ||
        _descriptionController.text.isNotEmpty ||
        _budgetControllers.any((controller) =>
            controller.text.isNotEmpty || _teamMembers.isNotEmpty)) {
      _showExitConfirmationDialog(context);
    } else {
      Navigator.pop(context);
    }
  }
}
