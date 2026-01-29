import 'package:flutter/material.dart';
import 'package:task_manager/core/theme/design_system.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/features/tasks/quantum_engine.dart';

class QuantumTaskCard extends StatelessWidget {
  final QuantumTask task;

  const QuantumTaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final priority = QuantumEngine.calculatePriority(task);
    final isActive = task.state == QuantumState.active;

    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 2),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        final glowIntensity = isActive ? (0.2 + (0.3 * value)) : 0.0;
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: task.stateColor.withValues(alpha: glowIntensity),
                blurRadius: 15,
                spreadRadius: 2,
              )
            ],
          ),
          child: child,
        );
      },
      child: QuantumGlassContainer(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: task.stateColor,
                    shape: BoxShape.circle,
                  ),
                ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  task.title,
                  style: const TextStyle(
                    color: QuantumColors.textHeader,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            QuantumEngine.getPriorityLabel(priority),
            style: TextStyle(
              color: task.stateColor.withValues(alpha: 0.8),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const Spacer(),
          LinearProgressIndicator(
            value: task.impactScore,
            backgroundColor: QuantumColors.background,
            color: task.stateColor,
            minHeight: 2,
          ),
        ],
      ),
    ),
    );
  }
}
