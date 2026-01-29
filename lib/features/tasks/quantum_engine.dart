import 'package:task_manager/models/task_model.dart';

class QuantumEngine {
  /// Calculates the 'Quantum Priority' based on impact and energy requirements.
  /// Higher impact and lower energy = higher priority.
  static double calculatePriority(QuantumTask task) {
    // Basic algorithm: Impact weighted high, energy inversed
    return (task.impactScore * 0.7) + ((1.0 - task.energyRequirement) * 0.3);
  }

  static String getPriorityLabel(double score) {
    if (score > 0.8) return 'Critical Flux';
    if (score > 0.5) return 'Stable Orbit';
    return 'Low Resonance';
  }
}
