import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:task_manager/core/theme/design_system.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/core/state/quantum_provider.dart';

class CrystallizationFlow extends StatefulWidget {
  const CrystallizationFlow({super.key});

  @override
  State<CrystallizationFlow> createState() => _CrystallizationFlowState();
}

class _CrystallizationFlowState extends State<CrystallizationFlow> {
  final _titleController = TextEditingController();
  double _impact = 0.5;
  double _energy = 0.5;
  QuantumState _state = QuantumState.crystallizing;

  @override
  Widget build(BuildContext context) {
    return QuantumGlassContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Crystallize Task',
            style: TextStyle(
              color: QuantumColors.textHeader,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: 'Task Title...',
              hintStyle: TextStyle(color: QuantumColors.textBody),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: QuantumColors.glassBorder),
              ),
            ),
            style: const TextStyle(color: QuantumColors.textHeader),
          ),
          const SizedBox(height: 32),
          _buildSlider('Impact Potential', _impact, (v) => setState(() => _impact = v)),
          _buildSlider('Energy Requirement', _energy, (v) => setState(() => _energy = v)),
          const SizedBox(height: 24),
          DropdownButton<QuantumState>(
            value: _state,
            dropdownColor: QuantumColors.surface,
            items: QuantumState.values.map((state) {
              return DropdownMenuItem(
                value: state,
                child: Text(state.name.toUpperCase(), style: const TextStyle(color: QuantumColors.textHeader)),
              );
            }).toList(),
            onChanged: (v) => setState(() => _state = v!),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: QuantumColors.primary,
                padding: const EdgeInsets.all(16),
              ),
              onPressed: () {
                if (_titleController.text.isNotEmpty) {
                  final task = QuantumTask(
                    id: const Uuid().v4(),
                    title: _titleController.text,
                    impactScore: _impact,
                    energyRequirement: _energy,
                    state: _state,
                    createdAt: DateTime.now(),
                  );
                  context.read<QuantumProvider>().addTask(task);
                  Navigator.pop(context);
                }
              },
              child: const Text('Initiate Sequence', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(String label, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: QuantumColors.textBody, fontSize: 12)),
        Slider(
          value: value,
          onChanged: onChanged,
          activeColor: QuantumColors.primary,
          inactiveColor: QuantumColors.surface,
        ),
      ],
    );
  }
}
