import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class CelebrationScreen extends StatefulWidget {
  final String taskTitle;

  const CelebrationScreen({super.key, required this.taskTitle});

  @override
  State<CelebrationScreen> createState() => _CelebrationScreenState();
}

class _CelebrationScreenState extends State<CelebrationScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9E6),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 10,
              minBlastForce: 5,
              emissionFrequency: 0.05,
              numberOfParticles: 30,
              gravity: 0.3,
              colors: const [
                Color(0xFFFFD6E8),
                Color(0xFFCCE7FF),
                Color(0xFFD4F1D4),
                Color(0xFFFFF4CC),
                Color(0xFFE6CCFF),
                Color(0xFFFFDFCC),
              ],
            ),
          ),

          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Trophy icon
                Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    size: 150,
                    color: Color(0xFFFFD700),
                  ),
                ),
                const SizedBox(height: 48),
                
                // Success message
                const Text(
                  '🎉 Amazing! 🎉',
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'You completed:',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.taskTitle,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 64),
                
                // Done button
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  icon: const Icon(Icons.home, size: 36),
                  label: const Text(
                    'Back to Tasks',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB4A7D6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 24,
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
