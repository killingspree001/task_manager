import 'package:flutter/material.dart';
import 'package:task_manager/core/repository/quantum_repository.dart';
import 'package:task_manager/models/task_model.dart';

class QuantumProvider with ChangeNotifier {
  final QuantumRepository _repository = QuantumRepository();
  List<QuantumTask> _tasks = [];
  bool _isLoading = true;

  List<QuantumTask> get tasks => _tasks;
  bool get isLoading => _isLoading;

  QuantumProvider() {
    loadTasks();
  }

  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();
    _tasks = await _repository.getTasks();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(QuantumTask task) async {
    await _repository.insertTask(task);
    await loadTasks();
  }

  Future<void> toggleTaskState(String id) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final task = _tasks[index];
      final newState = task.state == QuantumState.active 
          ? QuantumState.transcended 
          : QuantumState.active;
      
      final updatedTask = QuantumTask(
        id: task.id,
        title: task.title,
        description: task.description,
        state: newState,
        impactScore: task.impactScore,
        energyRequirement: task.energyRequirement,
        createdAt: task.createdAt,
        deadline: task.deadline,
      );

      await _repository.updateTask(updatedTask);
      await loadTasks();
    }
  }

  Future<void> deleteTask(String id) async {
    await _repository.deleteTask(id);
    await loadTasks();
  }

  // Energy Bank Logic
  double get totalImpact => _tasks.fold(0.0, (sum, t) => sum + t.impactScore);
}
