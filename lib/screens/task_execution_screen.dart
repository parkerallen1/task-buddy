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
        title: Text(
          widget.task.title,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Step ${_currentStepIndex + 1} of ${widget.task.steps.length}',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 16,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Step content
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image
                    if (step.imagePath != null)
                      Expanded(
                        flex: 2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.file(
                            File(step.imagePath!),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    const SizedBox(height: 32),
                    
                    // Text with speaker button
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _speak(step.text),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: color, width: 3),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.volume_up,
                                size: 48,
                                color: Colors.black.withOpacity(0.6),
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    step.text,
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Tap to hear',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Navigation buttons
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous button
                if (_currentStepIndex > 0)
                  ElevatedButton.icon(
                    onPressed: _previousStep,
                    icon: const Icon(Icons.arrow_back, size: 32),
                    label: const Text('Back', style: TextStyle(fontSize: 24)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 36,
                        vertical: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 120),
                
                // Done button
                ElevatedButton.icon(
                  onPressed: _completeStep,
                  icon: Icon(
                    _currentStepIndex == widget.task.steps.length - 1
                        ? Icons.check_circle
                        : Icons.check,
                    size: 36,
                  ),
                  label: Text(
                    _currentStepIndex == widget.task.steps.length - 1
                        ? 'Finish!'
                        : 'Done',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF81C784),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 28,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
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
