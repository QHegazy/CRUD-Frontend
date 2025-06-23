import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_frontend/core/utils/task_valditor.dart';
import '../controller/task_provider.dart';
import '../widgets/task_card.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<TaskProvider>(context, listen: false);
      await provider.loadToken();
      await provider.fetchTasks();
    });
  }

  void _showAddDialog(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth * 0.9 > 500 ? 500.0 : screenWidth * 0.9;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Task'),
        content: SizedBox(
          width: dialogWidth,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: validateTitle,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: validateDescription,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await Provider.of<TaskProvider>(
                  context,
                  listen: false,
                ).addTask(_titleController.text, _descriptionController.text);

                _titleController.clear();
                _descriptionController.clear();
                Navigator.pop(context);

                await Provider.of<TaskProvider>(
                  context,
                  listen: false,
                ).fetchTasks();
              }
            },
            child: const Text('Add Task'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('My Tasks')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.tasks.isEmpty
          ? const Center(child: Text("📝 You don't have any tasks yet."))
          : ListView.builder(
              itemCount: provider.tasks.length,
              itemBuilder: (_, index) => TaskCard(
                task: provider.tasks[index],
                onRefresh: () async {
                  await provider.fetchTasks();
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
