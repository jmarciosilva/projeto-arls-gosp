import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Início')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.construction, size: 56, color: AppColors.navy),
              const SizedBox(height: 16),
              const Text(
                'Em construção',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                'Perfil, sessões e avisos chegam nas próximas etapas.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.navy.withValues(alpha: 0.7)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
