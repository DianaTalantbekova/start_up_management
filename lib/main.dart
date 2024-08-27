

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:start_up_management/models/project_model.dart';
import 'package:start_up_management/models/task_model.dart';

import 'app.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(ProjectAdapter());
  Hive.registerAdapter(StatusAdapter());
  Hive.registerAdapter(TeamMemberAdapter());
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(StatusTaskAdapter());
  Hive.registerAdapter(ExecutorAdapter());
  GetIt.I.registerSingleton(EventBus());


  var data = await Hive.openBox<Project>('projectModel');
  GetIt.I.registerSingleton(data);

  var task = await Hive.openBox<Task>('taskModel');
  GetIt.I.registerSingleton(task);

  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (BuildContext context, Widget? child) => const MyApp(),
    ),
  );
}
