import 'package:flutter/material.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/token_storage.dart';
import '../../../models/task.dart';

class TaskProvider with ChangeNotifier {
  String? _token;
  String? get token => _token;

  TaskProvider();

  Future<void> loadToken() async {
    final storedToken = await TokenStorage.getToken();
    if (storedToken != null && storedToken != _token) {
      _token = storedToken;
      notifyListeners();
    }
  }

  Future<void> setToken(String? token) async {
    if (token != null && token != _token) {
      _token = token;
      await TokenStorage.saveToken(token);
      notifyListeners();
    }
  }

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  bool isLoading = false;

  Future<void> fetchTasks() async {
    isLoading = true;
    notifyListeners();
    try {
      final result = await ApiService.fetchTasks(_token);
      _tasks = result['tasks'];
      final newToken = result['token'];
      if (newToken != null) await setToken(newToken);
    } catch (e) {}
    isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(String title, String description) async {
    final taskToAdd = Task(id: 0, title: title, description: description);
    final newTask = await ApiService.addTask(taskToAdd, _token);

    if (newTask != null) {
      _tasks.add(newTask);
      notifyListeners();
    }
  }

  Future<Task?> getTaskById(int id) async {
    try {
      final fetchedTask = await ApiService.getTask(id, _token);
      return fetchedTask;
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteTask(int id) async {
    final newToken = await ApiService.deleteTask(id, _token);
    if (newToken != null) await setToken(newToken);
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  Future<void> updateTask(Task updated) async {
    final newToken = await ApiService.updateTask(updated, _token);
    if (newToken != null) await setToken(newToken);

    final index = _tasks.indexWhere((t) => t.id == updated.id);
    if (index != -1) {
      _tasks[index] = updated;
      notifyListeners();
    }
  }
}
