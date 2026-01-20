import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/task.dart';
import '../utils/colors.dart';
import 'celebration_screen.dart';

class TaskExecutionScreen extends StatefulWidget {
  final Task task;

  const TaskExecutionScreen({super.key, required this.task});

  @override
  State<TaskExecutionScreen> createState() => _TaskExecutionScreenState();
}

class _TaskExecutionScreenState extends State<TaskExecutionScreen> {
  int _currentStepIndex = 0;
  final Set<int> _completedSteps = {};
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.4);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _speak(String text) async {
    await _tts.speak(text);
  }

  void _completeStep() {
    setState(() {
      _completedSteps.add(_currentStepIndex);
      if (_currentStepIndex < widget.task.steps.length - 1) {
        _currentStepIndex++;
      } else {
        _showCelebration();
      }
    });
  }

  void _previousStep() {
    if (_currentStepIndex > 0) {
      setState(() => _currentStepIndex--);
    }
  }

  void _showCelebration() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => CelebrationScreen(taskTitle: widget.task.title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.task.steps[_currentStepIndex];
    final color = pastelColors[widget.task.colorIndex % pastelColors.length];
    final progress = (_currentStepIndex + 1) / widget.task.steps.length;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F3),
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Text(
                widget.task.title,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              'Step ${_currentStepIndex + 1}/${widget.task.steps.length}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Compact progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ),
          
          // Image - takes up most of the screen
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: step.imagePath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.file(
                        File(step.imagePath!),
                        fit: BoxFit.contain,
                        width: double.infinity,
                      ),
                    )
                  : Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 120,
                        color: Colors.grey[300],
                      ),
                    ),
            ),
          ),
          
          // Bottom controls row
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Back button row (if not first step)
                if (_currentStepIndex > 0)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _previousStep,
                        icon: const Icon(Icons.arrow_back, size: 28),
                        label: const Text('Back', style: TextStyle(fontSize: 22)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                
                // Main control row
                SizedBox(
                  height: 80,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Text box (scrollable)
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: color, width: 2),
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              step.text,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // Tap to hear button
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () => _speak(step.text),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB4A7D6),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.volume_up, size: 32),
                              SizedBox(height: 4),
                              Text(
                                'Hear',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // Done button
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _completeStep,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF81C784),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _currentStepIndex == widget.task.steps.length - 1
                                    ? Icons.check_circle
                                    : Icons.check,
                                size: 36,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _currentStepIndex == widget.task.steps.length - 1
                                    ? 'Finish!'
                                    : 'Done',
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
