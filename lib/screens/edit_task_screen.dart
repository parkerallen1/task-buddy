import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../models/task.dart';
import '../utils/colors.dart';

class EditTaskScreen extends StatefulWidget {
  final Task? task;

  const EditTaskScreen({super.key, this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late int _selectedColorIndex;
  List<TaskStep> _steps = [];
  String? _mainImagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _selectedColorIndex = widget.task?.colorIndex ?? 0;
    _steps = widget.task?.steps.map((s) => s).toList() ?? [];
    _mainImagePath = widget.task?.mainImagePath;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a task title')),
      );
      return;
    }

    if (_steps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one step')),
      );
      return;
    }

    final task = Task(
      id: widget.task?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      colorIndex: _selectedColorIndex,
      steps: _steps,
      mainImagePath: _mainImagePath,
    );

    Navigator.pop(context, task);
  }

  Future<void> _addStep() async {
    final textController = TextEditingController();
    String? imagePath;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Step', style: TextStyle(fontSize: 28)),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        content: StatefulBuilder(
          builder: (context, setDialogState) => SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: textController,
                          decoration: const InputDecoration(
                            labelText: 'Step instruction',
                            labelStyle: TextStyle(fontSize: 20),
                          ),
                          style: const TextStyle(fontSize: 22),
                          maxLines: 3,
                          autofocus: true,
                        ),
                        const SizedBox(height: 20),
                        if (imagePath != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(imagePath!),
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final image = await _picker.pickImage(source: ImageSource.camera);
                            if (image != null) {
                              final appDir = await getApplicationDocumentsDirectory();
                              final fileName = 'step_${DateTime.now().millisecondsSinceEpoch}.jpg';
                              final savedImage = await File(image.path).copy('${appDir.path}/$fileName');
                              setDialogState(() => imagePath = savedImage.path);
                            }
                          },
                          icon: const Icon(Icons.camera_alt, size: 28),
                          label: Text(
                            imagePath == null ? 'Take Photo' : 'Retake Photo',
                            style: const TextStyle(fontSize: 20),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(fontSize: 20)),
          ),
          ElevatedButton(
            onPressed: () {
              if (textController.text.trim().isNotEmpty) {
                Navigator.pop(context, {
                  'text': textController.text.trim(),
                  'imagePath': imagePath,
                });
              }
            },
            child: const Text('Add', style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    ).then((result) {
      if (result != null) {
        setState(() {
          _steps.add(TaskStep(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text: result['text'],
            imagePath: result['imagePath'],
          ));
        });
      }
    });
  }

  void _deleteStep(int index) {
    setState(() => _steps.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F3),
      appBar: AppBar(
        title: Text(
          widget.task == null ? 'Create Task' : 'Edit Task',
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: _saveTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB4A7D6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.check, size: 28),
                  SizedBox(width: 8),
                  Text('Save', style: TextStyle(fontSize: 22)),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                labelStyle: TextStyle(fontSize: 24),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            const Text(
              'Main Picture:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            if (_mainImagePath != null)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      File(_mainImagePath!),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      onPressed: () => setState(() => _mainImagePath = null),
                      icon: const Icon(Icons.close, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            if (_mainImagePath == null)
              ElevatedButton.icon(
                onPressed: () async {
                  final image = await _picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    final appDir = await getApplicationDocumentsDirectory();
                    final fileName = 'main_${DateTime.now().millisecondsSinceEpoch}.jpg';
                    final savedImage = await File(image.path).copy('${appDir.path}/$fileName');
                    setState(() => _mainImagePath = savedImage.path);
                  }
                },
                icon: const Icon(Icons.camera_alt, size: 28),
                label: const Text('Take Main Photo', style: TextStyle(fontSize: 20)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
              ),
            const SizedBox(height: 24),
            const Text(
              'Choose Color:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: List.generate(
                pastelColors.length,
                (index) => GestureDetector(
                  onTap: () => setState(() => _selectedColorIndex = index),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: pastelColors[index],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedColorIndex == index
                            ? Colors.black
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Steps:',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
                ElevatedButton.icon(
                  onPressed: _addStep,
                  icon: const Icon(Icons.add, size: 24),
                  label: const Text('Add Step', style: TextStyle(fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _steps.isEmpty
                  ? Center(
                      child: Text(
                        'No steps yet. Tap "Add Step" to start!',
                        style: TextStyle(fontSize: 20, color: Colors.grey[500]),
                      ),
                    )
                  : ReorderableListView.builder(
                      itemCount: _steps.length,
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) newIndex--;
                          final step = _steps.removeAt(oldIndex);
                          _steps.insert(newIndex, step);
                        });
                      },
                      itemBuilder: (context, index) {
                        final step = _steps[index];
                        return Card(
                          key: ValueKey(step.id),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: pastelColors[_selectedColorIndex],
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            title: Text(
                              step.text,
                              style: const TextStyle(fontSize: 20),
                            ),
                            subtitle: step.imagePath != null
                                ? const Text(
                                    '📷 Has photo',
                                    style: TextStyle(fontSize: 16),
                                  )
                                : null,
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              iconSize: 28,
                              onPressed: () => _deleteStep(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
