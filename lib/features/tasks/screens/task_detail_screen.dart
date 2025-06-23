import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_frontend/core/utils/task_valditor.dart';
import '../../../models/task.dart';
import '../controller/task_provider.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool _isLoading = true; // ✅ added loading flag

  @override
  void initState() {
    super.initState();
    _fetchTaskAndInit();
  }

  Future<void> _fetchTaskAndInit() async {
    final provider = Provider.of<TaskProvider>(context, listen: false);
    final updatedTask =
        await provider.getTaskById(widget.task.id) ?? widget.task;

    _titleController = TextEditingController(text: updatedTask.title);
    _descriptionController = TextEditingController(
      text: updatedTask.description,
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    if (!_isLoading) {
      _titleController.dispose();
      _descriptionController.dispose();
    }
    super.dispose();
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      final updatedTask = Task(
        id: widget.task.id,
        title: _titleController.text,
        description: _descriptionController.text,
      );

      final provider = Provider.of<TaskProvider>(context, listen: false);
      await provider.updateTask(updatedTask);
      Navigator.pop(context);
    }
  }

  Future<void> _deleteTask() async {
    final provider = Provider.of<TaskProvider>(context, listen: false);
    await provider.deleteTask(widget.task.id);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteTask,
            tooltip: 'Delete Task',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTask,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
