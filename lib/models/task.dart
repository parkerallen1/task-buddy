import 'dart:convert';

class TaskStep {
  final String id;
  final String text;
  final String? imagePath;

  TaskStep({
    required this.id,
    required this.text,
    this.imagePath,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'imagePath': imagePath,
      };

  factory TaskStep.fromJson(Map<String, dynamic> json) => TaskStep(
        id: json['id'] as String,
        text: json['text'] as String,
        imagePath: json['imagePath'] as String?,
      );
}

class Task {
  final String id;
  final String title;
  final int colorIndex;
  final List<TaskStep> steps;

  Task({
    required this.id,
    required this.title,
    required this.colorIndex,
    required this.steps,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'colorIndex': colorIndex,
        'steps': steps.map((s) => s.toJson()).toList(),
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'] as String,
        title: json['title'] as String,
        colorIndex: json['colorIndex'] as int,
        steps: (json['steps'] as List)
            .map((s) => TaskStep.fromJson(s as Map<String, dynamic>))
            .toList(),
      );
}
