import 'package:flutter/material.dart';
import '../features/tasks/screens/task_detail_screen.dart';
import '../models/task.dart';

class AppRoutes {
  static const taskDetail = '/task-detail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case taskDetail:
        final task = settings.arguments as Task;
        return MaterialPageRoute(builder: (_) => TaskDetailScreen(task: task));
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
