import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/core/theme/design_system.dart';
import 'package:task_manager/core/state/quantum_provider.dart';
import 'package:task_manager/features/dashboard/bento_dashboard.dart';

void main() {
  runApp(const QuantumApp());
}

class QuantumApp extends StatelessWidget {
  const QuantumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuantumProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QuantumTask',
        theme: QuantumTheme.darkTheme,
        home: const BentoDashboard(),
      ),
    );
  }
}
