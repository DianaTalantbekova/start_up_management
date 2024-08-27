import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../models/project_model.dart';
import '../../models/task_model.dart';
import '../../resources/app_colors.dart';
import '../../resources/app_styles.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/date_text_widget.dart';
import '../../widgets/team_member_dialog.dart';

class EditTask extends StatefulWidget {
  const EditTask({super.key, required this.taskNotifier});

  final ValueNotifier<Task> taskNotifier;

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late DateTime _startDate;
  late DateTime _endDate;
  late TextEditingController _paymentController;
  late Executor _executor;
  StatusTask? status;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    final task = widget.taskNotifier?.value;

    // Проверяем, что task не null, инициализируем контроллеры с защитой от null
    _nameController = TextEditingController(text: task?.name ?? '');
    _descriptionController = TextEditingController(text: task?.description ?? '');
    _startDate = task?.startDate ?? DateTime.now();
    _endDate = task?.endDate ?? DateTime.now();
    _paymentController = TextEditingController(text: task?.payment ?? '');

    _executor = task?.executor ?? Executor(); // Используем Executor по умолчанию
    status = task?.status ?? StatusTask.toDo; // Устанавливаем статус по умолчанию, если он null
  }

  void _onSave() {
    // Проверяем, что статус не null перед сохранением
    if (status == null) {
      print('Status is null, cannot save task.');
      return;
    }

    final updatedTask = Task(
      name: _nameController.text.isNotEmpty ? _nameController.text : null,
      startDate: _startDate,
      endDate: _endDate,
      description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
      payment: _paymentController.text.isNotEmpty ? _paymentController.text : null,
      status: status!,
      executor: _executor,
    );

    // Проверяем, что task.id не null перед сохранением
    if (widget.taskNotifier?.value.id != null) {
      var data = GetIt.I.get<Box<Task>>();
      data.put(widget.taskNotifier!.value.id!, updatedTask);
    }

    Navigator.pop(context, updatedTask);
    print('Task saved: ${updatedTask.name}');
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
            'Save',
            style: AppStyles.helper1,
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: AppColors.black,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
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
          'Task',
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
                dateTime: _startDate,
              ),
              SizedBox(height: 24.h),
              DateTextWidget(
                onTap: () => _showDatePicker(context, false),
                text: 'End date',
                dateTime: _endDate,
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
                'Payment',
                style: AppStyles.helper3,
              ),
              SizedBox(height: 8.h),
              CustomTextField(
                hintText: 'Enter a payment',
                color: AppColors.black212121,
                hasBorder: false,
                hasIcon: false,
                controller: _paymentController,
                onChanged: (value) {
                  setState(() {});
                },
              ),
              SizedBox(height: 24.h),
              Text(
                'Status',
                style: AppStyles.helper3,
              ),
              SizedBox(height: 8.h),
              CustomDropdown(
                selectedValue: status?.getItem(),
                items: Status.values.map((e) => e.getItem()).toList(),
                onChanged: (value) {
                  setState(() {
                    status = StatusTask.values
                        .where((element) => element.getItem() == value)
                        .firstOrNull;
                  });
                },
              ),
              SizedBox(height: 24.h),
              Text(
                'Executor',
                style: AppStyles.helper3,
              ),
              SizedBox(height: 8.h),
              if (_executor != null)
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  width: 109.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.r),
                    color: AppColors.black212121,
                  ),
                  child: Column(
                    children: [
                      _executor.imagePath != null
                          ? CircleAvatar(
                        maxRadius: 30,
                        minRadius: 30,
                        backgroundImage: FileImage(File(_executor.imagePath!)),
                      )
                          : CircleAvatar(
                        backgroundColor: AppColors.grayA2A9B8,
                        maxRadius: 30,
                        minRadius: 30,
                        child: Text(
                          _executor.name?[0] ?? '',
                          style: AppStyles.helper3,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      IntrinsicWidth(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.r),
                            border: Border.all(color: AppColors.grayA2A9B8),
                          ),
                          child: Text(
                            _executor.name ?? '',
                            style: AppStyles.helper3,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      IntrinsicWidth(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.r),
                            border: Border.all(color: AppColors.grayA2A9B8),
                          ),
                          child: Text(
                            _executor.position ?? '',
                            style: AppStyles.helper3.copyWith(color: AppColors.grayA2A9B8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (_executor == null)
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
    DateTime initialDate = isStart ? _startDate : _endDate;
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
                      'Start date',
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
                      textTheme: CupertinoTextThemeData(
                        dateTimePickerTextStyle: TextStyle(
                          // color: Colors.black,
                          fontSize: 17.sp,
                        ),
                      ),
                      // primaryColor: Colors.white,
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
                              _startDate = _selectedDate ?? _startDate;
                            } else {
                              _endDate = _selectedDate ?? _endDate;
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
          title: 'Executor',
        );
      },
    );

    if (result != null) {
      setState(() {
        _executor = Executor(
          name: result['name'] ?? '',
          position: result['position'] ?? '',
          imagePath: (result['image'] as File?)?.path,
        );
      });
    }
  }
}
