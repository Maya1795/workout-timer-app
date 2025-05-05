import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const WorkoutTimerApp());
}

class WorkoutTimerApp extends StatelessWidget {
  const WorkoutTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Timer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF2E2E2E),
      ),
      home: const TimerScreen(),
    );
  }
}

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int workoutMinutes = 5;
  int workoutSeconds = 0;
  int restMinutes = 0;
  int restSeconds = 30;

  bool isWorkoutPhase = true;
  bool isRunning = false;
  int remainingSeconds = 300; // 5 minutes in seconds

  Timer? timer;

  @override
  void initState() {
    super.initState();
    _calculateInitialTime();
  }

  void _calculateInitialTime() {
    setState(() {
      remainingSeconds = (workoutMinutes * 60) + workoutSeconds;
    });
  }

  void _startTimer() {
    if (isRunning) {
      timer?.cancel();
      setState(() {
        isRunning = false;
      });
      return;
    }

    setState(() {
      isRunning = true;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else {
          _switchPhase();
        }
      });
    });
  }

  void _switchPhase() {
    timer?.cancel();
    setState(() {
      isWorkoutPhase = !isWorkoutPhase;
      if (isWorkoutPhase) {
        remainingSeconds = (workoutMinutes * 60) + workoutSeconds;
      } else {
        remainingSeconds = (restMinutes * 60) + restSeconds;
      }
      isRunning = false;
    });
  }

  void _resetTimer() {
    timer?.cancel();
    setState(() {
      isWorkoutPhase = true;
      remainingSeconds = (workoutMinutes * 60) + workoutSeconds;
      isRunning = false;
    });
  }

  String _formatTime(int seconds) {
    int minutes = (seconds / 60).floor();
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget _buildTimeDropdown(String label, int value, List<int> options,
      ValueChanged<int?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: DropdownButtonFormField<int>(
        value: value,
        items: options
            .map((value) => DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value ${label.toLowerCase()}'),
                ))
            .toList(),
        onChanged: isRunning ? null : onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide.none,
          ),
        ),
        dropdownColor: Colors.white,
        style: const TextStyle(color: Colors.black, fontSize: 14),
        isExpanded: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Timer'),
        centerTitle: true,
        backgroundColor: const Color(0xFF2E2E2E),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Container(
                  color: const Color(0xFF2E2E2E),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Timer Input Fields
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Set Timer:',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Workout Time',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildTimeDropdown(
                                            'min',
                                            workoutMinutes,
                                            List.generate(60, (index) => index),
                                            (value) {
                                              setState(() {
                                                workoutMinutes = value!;
                                                _calculateInitialTime();
                                              });
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: _buildTimeDropdown(
                                            'sec',
                                            workoutSeconds,
                                            List.generate(60, (index) => index),
                                            (value) {
                                              setState(() {
                                                workoutSeconds = value!;
                                                _calculateInitialTime();
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Rest Time',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildTimeDropdown(
                                            'min',
                                            restMinutes,
                                            List.generate(60, (index) => index),
                                            (value) {
                                              setState(() {
                                                restMinutes = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: _buildTimeDropdown(
                                            'sec',
                                            restSeconds,
                                            List.generate(60, (index) => index),
                                            (value) {
                                              setState(() {
                                                restSeconds = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Timer Display
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isWorkoutPhase ? 'WORKOUT' : 'REST',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 32),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E2E2E),
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: Text(
                                _formatTime(remainingSeconds),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Arial',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Control Buttons
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: _startTimer,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF4500),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                isRunning ? 'STOP' : 'START',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: _resetTimer,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[700],
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'RESET',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
