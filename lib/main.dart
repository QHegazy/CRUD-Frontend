import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/tasks/controller/task_provider.dart';
import 'features/tasks/screens/task_list_screen.dart';
import 'routes/app_routes.dart';
import 'theme/dark_theme.dart';

void main() {
  runApp(const TaskApp());
}

class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider()..fetchTasks(),
      child: MaterialApp(
        title: 'Task Manager',
        theme: darkTheme,
        debugShowCheckedModeBanner: false,
        home: const TaskListScreen(),
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
