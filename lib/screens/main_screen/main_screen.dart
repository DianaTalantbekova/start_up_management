import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

import '../../models/project_model.dart';
import '../../resources/app_colors.dart';
import '../../resources/app_styles.dart';
import '../../widgets/options_dialog.dart';
import '../add_project/add_project.dart';
import '../project_details/project_details.dart';
import 'package:hive/hive.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('MMMM d, yyyy');

    ValueNotifier<Project?> projectNotifier = ValueNotifier<Project?>(null);

    return Scaffold(
      backgroundColor: AppColors.black,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ValueListenableBuilder<Box<Project>>(
        valueListenable: Hive.box<Project>('projectModel').listenable(),
        builder: (context, box, _) {
          final projects = box.values.toList().cast<Project>();

          if (projects.isEmpty) {
            return const SizedBox.shrink();
          }

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddProject(),
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
                'Add project',
                style: AppStyles.helper1,
              ),
            ),
          );
        },
      ),
      appBar: AppBar(
        backgroundColor: AppColors.black,
        leading: GestureDetector(
          onTap: () {},
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/overview.svg',
              fit: BoxFit.contain,
              width: 24.w,
              height: 24.h,
            ),
          ),
        ),
        title: Text(
          'Projects',
          style: AppStyles.helper2,
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: SvgPicture.asset(
                'assets/icons/settings.svg',
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
      body: ValueListenableBuilder<Box<Project>>(
        valueListenable: Hive.box<Project>('projectModel').listenable(),
        builder: (context, box, _) {
          final projects = box.values.toList().cast<Project>();
          final keys = List.generate(projects.length, (index) => GlobalKey());

          return projects.isEmpty
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "You don't have any projects yet",
                style: AppStyles.helper3,
              ),
              SizedBox(height: 24.h),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddProject(),
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
                    'Add project',
                    style: AppStyles.helper1,
                  ),
                ),
              ),
            ],
          )
              : ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24.h),
            itemCount: projects.length,
            separatorBuilder: (BuildContext context, int index) =>
                SizedBox(height: 16.h),
            itemBuilder: (BuildContext context, int index) {
              final project = projects[index];
              final GlobalKey itemKey = keys[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProjectDetails(
                        status: project.status!,
                        projectName: project.name!,
                        description: project.description ?? '',
                        budgetAllocation: project.budgetAllocations ?? [],
                        teamMembers: project.teamMembers ?? [],
                        id: project.id ?? '',
                        startDate: project.startDate!,
                        endDate: project.endDate!,
                        projectNotifier: projectNotifier,
                      ),
                    ),
                  );
                },
                onLongPress: () {
                  _showOptionsDialog(context, itemKey, project);
                },
                child: Container(
                  key: itemKey,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: AppColors.black212121,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.name?.isNotEmpty == true
                            ? project.name!
                            : 'Enter a project name',
                        style: AppStyles.helper2,
                      ),
                      if (project.description != null &&
                          project.description?.isNotEmpty == true)
                        SizedBox(height: 8.h),
                      if (project.description != null &&
                          project.description?.isNotEmpty == true)
                        Text(
                          project.description!,
                          style: AppStyles.helper3,
                        ),
                      SizedBox(height: 12.h),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${formatter.format(project.startDate!)} - ${formatter.format(project.endDate!)}',
                          style: AppStyles.helper3
                              .copyWith(color: AppColors.grayA2A9B8),
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
    );
  }

  void _showOptionsDialog(
      BuildContext context, GlobalKey key, Project project) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? renderBox =
      key.currentContext?.findRenderObject() as RenderBox?;

      if (renderBox != null) {
        final Offset offset = renderBox.localToGlobal(Offset.zero);

        showDialog(
          context: context,
          barrierDismissible: true,
          barrierColor: Colors.transparent,
          builder: (BuildContext context) {
            return OptionsDialog(
              onEdit: () {
                Navigator.pop(context);
              },
              onDelete: () {
                Navigator.pop(context);
                print("Offset dx: ${offset.dx}, Offset dy: ${offset.dy}");
              },
              left: offset.dx - 3.w,
              top: offset.dy - 50.h,
            );
          },
        );
      } else {
        print("RenderBox is null or context is unavailable.");
      }
    });
  }
}