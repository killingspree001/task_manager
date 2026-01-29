import 'package:flutter/material.dart';
import 'package:task_manager/core/theme/design_system.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/widgets/quantum_task_card.dart';
import 'package:task_manager/core/state/quantum_provider.dart';
import 'package:task_manager/features/tasks/crystallization_flow.dart';
import 'package:provider/provider.dart';

class BentoDashboard extends StatelessWidget {
  const BentoDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuantumProvider>();
    final tasks = provider.tasks;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: QuantumColors.primary,
        onPressed: () => _showCrystallizationFlow(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(provider.totalImpact),
              const SizedBox(height: 32),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = constraints.maxWidth > 800 ? 4 : 2;
                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: [
                        _buildBentoTile(
                          title: 'Active Focus',
                          subtitle: '${tasks.where((t) => t.state == QuantumState.active).length} Tasks',
                          color: QuantumColors.primary,
                          icon: Icons.bolt,
                          delay: 1,
                        ),
                        _buildBentoTile(
                          title: 'In Orbit',
                          subtitle: '${tasks.where((t) => t.state == QuantumState.orbit).length} Items',
                          color: Colors.purpleAccent,
                          icon: Icons.auto_awesome,
                          delay: 2,
                        ),
                        _buildBentoTile(
                          title: 'Crystallizing',
                          subtitle: '${tasks.where((t) => t.state == QuantumState.crystallizing).length} Drafts',
                          color: QuantumColors.accent,
                          icon: Icons.grain,
                          delay: 3,
                        ),
                        _buildBentoTile(
                          title: 'Transcended',
                          subtitle: '${tasks.where((t) => t.state == QuantumState.transcended).length} Done',
                          color: Colors.tealAccent,
                          icon: Icons.check_circle,
                          delay: 4,
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
              _buildTaskFeed(tasks),
            ],
          ),
        ),
      ),
    );
  }

  void _showCrystallizationFlow(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: const CrystallizationFlow(),
      ),
    );
  }

  Widget _buildTaskFeed(List<QuantumTask> tasks) {
    final displayTasks = tasks.reversed.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quantum Feed',
          style: TextStyle(
            color: QuantumColors.textHeader,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: displayTasks.isEmpty 
            ? const Center(child: Text('No active resonance detected.', style: TextStyle(color: QuantumColors.textBody)))
            : ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: displayTasks.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 200,
                    child: QuantumTaskCard(task: displayTasks[index]),
                  );
                },
              ),
        ),
      ],
    );
  }

  Widget _buildHeader(double totalImpact) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Project Quantum',
              style: QuantumTheme.darkTheme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Temporal Oversight Dashboard',
              style: QuantumTheme.darkTheme.textTheme.bodyMedium,
            ),
          ],
        ),
        _buildEnergyBank(totalImpact),
      ],
    );
  }

  Widget _buildEnergyBank(double impact) {
    return Column(
      children: [
        const Text('Energy Bank', style: TextStyle(color: QuantumColors.textBody, fontSize: 10)),
        const SizedBox(height: 8),
        Container(
          width: 60,
          height: 60,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: QuantumColors.primary.withValues(alpha: 0.3)),
          ),
          child: CircularProgressIndicator(
            value: (impact / 10).clamp(0.0, 1.0),
            strokeWidth: 4,
            color: QuantumColors.primary,
            backgroundColor: QuantumColors.surface,
          ),
        ),
      ],
    );
  }

  Widget _buildBentoTile({
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
    int delay = 0,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (delay * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        final clampedValue = value.clamp(0.0, 1.0);
        return Opacity(
          opacity: clampedValue,
          child: Transform.scale(
            scale: value, // Scale can stay as value to allow the overshooting "pop" effect
            child: child,
          ),
        );
      },
      child: QuantumGlassContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: QuantumColors.textHeader,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                color: QuantumColors.textBody,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
