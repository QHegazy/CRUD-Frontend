import 'package:flutter/material.dart';
import '../../../models/task.dart';
import '../../../routes/app_routes.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onRefresh;

  const TaskCard({super.key, required this.task, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.task_alt, color: Colors.greenAccent),
        title: Text(
          task.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(task.description),
        onTap: () async {
          await Navigator.pushNamed(
            context,
            AppRoutes.taskDetail,
            arguments: task,
          );
          onRefresh();
        },
      ),
    );
  }
}
