import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:start_up_management/resources/app_colors.dart';
import '../../models/task_model.dart';
import '../../resources/app_styles.dart';
import '../../widgets/confirmation_dialog.dart';
import '../../widgets/options_dialog.dart';
import '../edit_task/edit_task.dart';

class TaskDetails extends StatefulWidget {
  final StatusTask status;
  final String taskName;
  final String description;
  final String payment;
  final Executor executor;
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final Task? taskNotifier;

  const TaskDetails({
    super.key,
    required this.status,
    required this.taskName,
    required this.description,
    required this.payment,
    required this.executor,
    required this.id,
    required this.startDate,
    required this.endDate,
    this.taskNotifier, // сделаем опциональным
  });

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  late ValueNotifier<Task> taskNotifier;

  @override
  void initState() {
    super.initState();

    taskNotifier = ValueNotifier<Task>(
      widget.taskNotifier ??
          Task(
            id: widget.id,
            name: widget.taskName.isNotEmpty ? widget.taskName : null,
            description:
                widget.description.isNotEmpty ? widget.description : null,
            payment: widget.payment.isNotEmpty ? widget.payment : null,
            executor: widget.executor,
            status: widget.status,
            startDate: widget.startDate,
            endDate: widget.endDate,
          ),
    );
  }

  @override
  void dispose() {
    taskNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final task = taskNotifier.value;
    final textColor = _getStatusColor(task?.status);

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/arrow_back.svg',
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
        actions: [
          GestureDetector(
            onTap: () {
              if (task != null) {
                _showOptionsDialog(context, task);
              }
            },
            child: Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: SvgPicture.asset(
                'assets/icons/dots.svg',
                fit: BoxFit.contain,
                width: 24.w,
                height: 24.h,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color(0xFF3E3E3E),
            height: 1.0,
          ),
        ),
      ),
      body: ValueListenableBuilder<Task?>(
        valueListenable: taskNotifier,
        builder: (context, task, _) {
          final formatter = DateFormat('MMMM d, yyyy');
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      task?.status?.getItem() ?? '',
                      style: AppStyles.helper3.copyWith(color: textColor),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    '${formatter.format(task?.startDate ?? DateTime.now())} - ${formatter.format(task?.endDate ?? DateTime.now())}',
                    style:
                        AppStyles.helper3.copyWith(color: AppColors.grayA2A9B8),
                  ),
                  if (task?.name?.isNotEmpty ?? false) SizedBox(height: 12.h),
                  Text(
                    task?.name ?? 'No Task Name',
                    style: AppStyles.helper2,
                  ),
                  if (task?.name?.isNotEmpty ?? false) SizedBox(height: 24.h),
                  Text(
                    'Description',
                    style:
                        AppStyles.helper3.copyWith(color: AppColors.grayA2A9B8),
                  ),
                  if (task?.description?.isNotEmpty ?? false)
                    SizedBox(height: 8.h),
                  Text(
                    task?.description ?? 'No Description',
                    style: AppStyles.helper3,
                  ),
                  if (task?.description?.isNotEmpty ?? false)
                    SizedBox(height: 24.h),
                  Text(
                    'Payment',
                    style:
                        AppStyles.helper3.copyWith(color: AppColors.grayA2A9B8),
                  ),
                  SizedBox(height: 8.h),
                  if (task?.payment?.isNotEmpty ?? false)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: AppColors.black212121,
                      ),
                      child: Text(
                        task?.payment ?? '',
                        style: AppStyles.helper3,
                      ),
                    ),
                  SizedBox(height: 24.h),
                  Text(
                    'Executor',
                    style:
                        AppStyles.helper3.copyWith(color: AppColors.grayA2A9B8),
                  ),

                    SizedBox(height: 8.h),
                  Container(
                    padding: const EdgeInsets.all(12),
                    alignment: Alignment.center,
                    width: 109.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.r),
                      color: AppColors.black212121,
                    ),
                    child: Column(
                      children: [
                         task?.executor?.imagePath != null
                            ? CircleAvatar(
                                maxRadius: 30,
                                minRadius: 30,
                                backgroundImage:
                                    FileImage(File(task!.executor!.imagePath!)),
                              )
                            : CircleAvatar(
                                backgroundColor: AppColors.grayA2A9B8,
                                maxRadius: 30,
                                minRadius: 30,
                                child: Text(task?.executor?.name?[0] ?? ''),
                              ),
                        SizedBox(height: 8.h),
                        Text(
                          task?.executor?.name ?? 'No Name',
                          style: AppStyles.helper3,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          task?.executor?.position ?? 'No Position',
                          style: AppStyles.helper3.copyWith(
                            color: AppColors.grayA2A9B8,
                            fontSize: 12.sp,
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
      ),
    );
  }

  Color _getStatusColor(StatusTask? status) {
    switch (status) {
      case StatusTask.toDo:
        return AppColors.red;
      case StatusTask.inProgress:
        return AppColors.yellow;
      case StatusTask.done:
        return AppColors.green;
      default:
        return Colors.white;
    }
  }

  void _showOptionsDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return OptionsDialog(
          onEdit: () async {
            Navigator.pop(context);
            final updatedTask = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditTask(
                  taskNotifier: ValueNotifier(task),
                ),
              ),
            );

            if (updatedTask != null) {
              setState(() {
                taskNotifier.value = updatedTask;
              });
            }
          },
          onDelete: () {
            Navigator.pop(context);
            _showDeleteConfirmationDialog(context);
          },
          left: 120,
          top: 35,
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showCupertinoDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          onTap: () {
            var box = GetIt.I.get<Box<Task>>();

            box.delete(widget.id);
            Navigator.pop(context);
            Navigator.pop(context);
          },
          description:
              'If you delete a country, you will not be able to restore it',
        );
      },
    );
  }
}
