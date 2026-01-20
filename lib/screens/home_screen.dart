import 'dart:io';
import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/storage_service.dart';
import '../utils/colors.dart';
import 'edit_task_screen.dart';
import 'task_execution_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storage = StorageService();
  List<Task> _tasks = [];
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _storage.loadTasks();
    setState(() => _tasks = tasks);
  }

  Future<void> _deleteTask(String taskId) async {
    setState(() => _tasks.removeWhere((t) => t.id == taskId));
    await _storage.saveTasks(_tasks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F3),
      appBar: AppBar(
        title: const Text('My Tasks', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Switch(
              value: _isEditMode,
              onChanged: (val) => setState(() => _isEditMode = val),
              activeColor: const Color(0xFFB4A7D6),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(
              _isEditMode ? 'Edit Mode' : 'Do Tasks',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
      body: _tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt, size: 100, color: Colors.grey[300]),
                  const SizedBox(height: 20),
                  Text(
                    'No tasks yet!',
                    style: TextStyle(fontSize: 28, color: Colors.grey[500]),
                  ),
                  if (_isEditMode) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Tap + to create your first task',
                      style: TextStyle(fontSize: 20, color: Colors.grey[400]),
                    ),
                  ],
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.2,
              ),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return _TaskCard(
                  task: task,
                  isEditMode: _isEditMode,
                  onTap: () => _isEditMode
                      ? _editTask(task)
                      : _startTask(task),
                  onDelete: () => _deleteTask(task.id),
                );
              },
            ),
      floatingActionButton: _isEditMode
          ? FloatingActionButton.large(
              onPressed: _createNewTask,
              backgroundColor: const Color(0xFFB4A7D6),
              child: const Icon(Icons.add, size: 40),
            )
          : null,
    );
  }

  Future<void> _createNewTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditTaskScreen()),
    );
    if (result != null && result is Task) {
      setState(() => _tasks.add(result));
      await _storage.saveTasks(_tasks);
    }
  }

  Future<void> _editTask(Task task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditTaskScreen(task: task)),
    );
    if (result != null && result is Task) {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        setState(() => _tasks[index] = result);
        await _storage.saveTasks(_tasks);
      }
    }
  }

  Future<void> _startTask(Task task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TaskExecutionScreen(task: task)),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final Task task;
  final bool isEditMode;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _TaskCard({
    required this.task,
    required this.isEditMode,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = pastelColors[task.colorIndex % pastelColors.length];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: color, width: 4),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (task.mainImagePath != null)
                    Expanded(
                      flex: 2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(task.mainImagePath!),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  if (task.mainImagePath != null) const SizedBox(height: 12),
                  Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${task.steps.length} step${task.steps.length == 1 ? '' : 's'}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            if (isEditMode)
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, color: Colors.red),
                  iconSize: 32,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
