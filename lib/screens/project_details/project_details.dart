import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:start_up_management/resources/app_colors.dart';
import 'package:start_up_management/screens/add_task/add_task.dart';
import 'package:start_up_management/screens/edit_project/edit_project.dart';
import 'package:start_up_management/screens/main_screen/main_screen.dart';
import '../../models/project_model.dart';
import '../../models/task_model.dart';
import '../../resources/app_styles.dart';
import '../../widgets/confirmation_dialog.dart';
import '../../widgets/options_dialog.dart';
import '../task_details/task_details.dart';

class ProjectDetails extends StatefulWidget {
  final Status status;
  final String projectName;
  final String description;
  final List<String> budgetAllocation;
  final List<TeamMember> teamMembers;
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final ValueNotifier<Project?> projectNotifier;

  const ProjectDetails({
    super.key,
    required this.status,
    required this.projectName,
    required this.description,
    required this.budgetAllocation,
    required this.teamMembers,
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.projectNotifier,
  });

  @override
  State<ProjectDetails> createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  late Project project;
  late ValueNotifier<Project> projectNotifier;

  @override
  void initState() {
    super.initState();
    projectNotifier = ValueNotifier<Project>(
      Project(
        id: widget.id,
        name: widget.projectName,
        description: widget.description,
        budgetAllocations: widget.budgetAllocation,
        teamMembers: widget.teamMembers,
        status: widget.status,
        startDate: widget.startDate,
        endDate: widget.endDate,
      ),
    );
  }

  @override
  void dispose() {
    projectNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color textColor;
    switch (projectNotifier.value.status) {
      case Status.toDo:
        textColor = AppColors.red;
        break;
      case Status.inProgress:
        textColor = AppColors.yellow;
        break;
      case Status.done:
        textColor = AppColors.green;
        break;
      default:
        textColor = Colors.white;
    }

    ValueNotifier<Task?> taskNotifier = ValueNotifier<Task?>(null);

    return Scaffold(
      backgroundColor: AppColors.black,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTask(),
            ),
          );
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
            'Add task',
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
              'assets/icons/arrow_back.svg',
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
        actions: [
          GestureDetector(
            onTap: () {
              _showOptionsDialog(context, projectNotifier.value);
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
      body: ValueListenableBuilder(
          valueListenable: projectNotifier,
          builder: (context, project, _) {
            final DateFormat formatter = DateFormat('MMMM d, yyyy');
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        SizedBox(height: 24.h),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            project.status!.getItem(),
                            style: AppStyles.helper3.copyWith(color: textColor),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          '${formatter.format(project.startDate!)} - ${formatter.format(project.endDate!)}',
                          style: AppStyles.helper3
                              .copyWith(color: AppColors.grayA2A9B8),
                        ),
                        if (widget.projectName.isNotEmpty)
                          SizedBox(height: 12.h),
                        Text(
                          project.name!,
                          style: AppStyles.helper2,
                        ),
                        if (project.name!.isNotEmpty) SizedBox(height: 24.h),
                        Text(
                          'Description',
                          style: AppStyles.helper3
                              .copyWith(color: AppColors.grayA2A9B8),
                        ),
                        if (project.description!.isNotEmpty)
                          SizedBox(height: 8.h),
                        Text(
                          project.description!,
                          style: AppStyles.helper3,
                        ),
                        if (project.description!.isNotEmpty)
                          SizedBox(height: 24.h),
                        Text(
                          'Budget allocation',
                          style: AppStyles.helper3
                              .copyWith(color: AppColors.grayA2A9B8),
                        ),
                        SizedBox(height: 8.h),
                        if (project.budgetAllocations!.isNotEmpty )
                          Row(
                            children: project.budgetAllocations!.map((budget) {
                              return Container(
                                padding: const EdgeInsets.all(12),
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(right: 8.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.r),
                                  color: AppColors.black212121,
                                ),
                                child: Text(
                                  budget,
                                  style: AppStyles.helper3,
                                ),
                              );
                            }).toList(),
                          ),
                        if (project.teamMembers!.isNotEmpty &&
                            project.teamMembers != null)
                        SizedBox(height: 24.h),
                        if (project.teamMembers!.isNotEmpty &&
                            project.teamMembers != null)
                        Text(
                          'Team members',
                          style: AppStyles.helper3
                              .copyWith(color: AppColors.grayA2A9B8),
                        ),
                        if (project.teamMembers!.isNotEmpty &&
                            project.teamMembers != null)
                        SizedBox(height: 8.h),
                      ],
                    ),
                  ),
                ),
                if (project.teamMembers!.isNotEmpty &&
                    project.teamMembers != null)
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 150.h,
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          final member = widget.teamMembers[index];

                          return Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              width: 109.w,
                              height: 107.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.r),
                                color: AppColors.black212121,
                              ),
                              child: Column(
                                children: [
                                  member.imagePath != null
                                      ? CircleAvatar(
                                          maxRadius: 30,
                                          minRadius: 30,
                                          backgroundImage: FileImage(
                                              File(member.imagePath!)),
                                        )
                                      : CircleAvatar(
                                          backgroundColor: AppColors.grayA2A9B8,
                                          maxRadius: 30,
                                          minRadius: 30,
                                          child: Text(member.name?[0] ?? ''),
                                        ),
                                  SizedBox(height: 8.h),
                                  IntrinsicWidth(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 6.w, vertical: 4.h),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(2.r),
                                        border: Border.all(
                                            color: AppColors.grayA2A9B8),
                                      ),
                                      child: Text(
                                        member.name ?? '',
                                        style: AppStyles.helper3,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  IntrinsicWidth(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 6.w, vertical: 4.h),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(2.r),
                                        border: Border.all(
                                            color: AppColors.grayA2A9B8),
                                      ),
                                      child: Text(
                                        member.position ?? '',
                                        style: AppStyles.helper3.copyWith(
                                            color: AppColors.grayA2A9B8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            SizedBox(width: 8.w),
                        itemCount: widget.teamMembers.length,
                      ),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 24.h),
                ),
                SliverFillRemaining(
                  child: ValueListenableBuilder(
                    valueListenable: Hive.box<Task>('taskModel').listenable(),
                    builder: (context, box, _) {
                      final tasks = box.values.toList().cast<Task>();
                      return ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 24.h,
                        ),
                        itemCount: tasks.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            SizedBox(height: 16.h),
                        itemBuilder: (BuildContext context, int index) {
                          final task = tasks[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TaskDetails(
                                    status: task.status ?? StatusTask.toDo,
                                    taskName: task.name ?? 'No task name',
                                    description: task.description ?? '',
                                    payment: task.payment ?? '',
                                    executor: task.executor ?? Executor(),
                                    id: task.id ?? '', // Default value
                                    startDate: task.startDate ?? DateTime.now(),
                                    endDate: task.endDate ?? DateTime.now(),
                                    taskNotifier: taskNotifier.value ?? Task(
                                      id: task.id ?? '',
                                      name: task.name ?? '',
                                      description: task.description ?? '',
                                      payment: task.payment ?? '',
                                      status: task.status ?? StatusTask.toDo,
                                      startDate: task.startDate ?? DateTime.now(),
                                      endDate: task.endDate ?? DateTime.now(),
                                      executor: task.executor ?? Executor(),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                color: AppColors.black212121,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Task',
                                    style: AppStyles.helper3.copyWith(
                                      color: AppColors.grayA2A9B8,
                                    ),
                                  ),
                                  Text(
                                    task.name?.isNotEmpty == true
                                        ? task.name!
                                        : 'Enter a project name',
                                    style: AppStyles.helper2,
                                  ),
                                  if (task.description != null && task.description!.isNotEmpty)
                                    SizedBox(height: 8.h),
                                  if (task.description != null && task.description!.isNotEmpty)
                                    Text(
                                      task.description!,
                                      style: AppStyles.helper3,
                                    ),
                                  SizedBox(height: 12.h),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '${formatter.format(task.startDate ?? DateTime.now())} - ${formatter.format(task.endDate ?? DateTime.now())}',
                                      style: AppStyles.helper3.copyWith(
                                          color: AppColors.grayA2A9B8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                )              ],
            );
          }),
    );
  }

  void _showOptionsDialog(BuildContext context, Project project) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return OptionsDialog(
          onEdit: () async {
            Navigator.pop(context);
            final updatedProject = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    EditProject(projectNotifier: projectNotifier),
              ),
            );

            if (updatedProject != null) {
              projectNotifier.value = updatedProject;
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
            var box = GetIt.I.get<Box<Project>>();

            box.delete(widget.id);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MainScreen(),
              ),
            );
          },
          description:
              'If you delete a country, you will not be able to restore it',
        );
      },
    );
  }
}
