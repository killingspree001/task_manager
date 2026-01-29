import 'package:flutter/material.dart';

enum QuantumState { orbit, crystallizing, active, transcended }

class QuantumTask {
  final String id;
  final String title;
  final String description;
  final QuantumState state;
  final double impactScore; // 0.0 to 1.0
  final double energyRequirement; // 0.0 to 1.0
  final DateTime createdAt;
  final DateTime? deadline;

  QuantumTask({
    required this.id,
    required this.title,
    this.description = '',
    this.state = QuantumState.crystallizing,
    this.impactScore = 0.5,
    this.energyRequirement = 0.5,
    required this.createdAt,
    this.deadline,
  });

  Color get stateColor {
    switch (state) {
      case QuantumState.orbit:
        return Colors.purpleAccent;
      case QuantumState.crystallizing:
        return Colors.amberAccent;
      case QuantumState.active:
        return Colors.blueAccent;
      case QuantumState.transcended:
        return Colors.tealAccent;
    }
  }
}
