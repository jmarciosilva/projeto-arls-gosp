import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

const _months = [
  '',
  'JAN', 'FEV', 'MAR', 'ABR', 'MAI', 'JUN',
  'JUL', 'AGO', 'SET', 'OUT', 'NOV', 'DEZ',
];

/// Badge estilo "dia grande / mês abreviado", comum em listas de eventos.
/// Espera uma data no formato ISO (YYYY-MM-DD), como retornada pela API.
class DateBadge extends StatelessWidget {
  final String isoDate;

  const DateBadge({super.key, required this.isoDate});

  @override
  Widget build(BuildContext context) {
    final parts = isoDate.split('-');
    final day = parts.length == 3 ? parts[2] : '--';
    final monthIndex = parts.length == 3 ? int.tryParse(parts[1]) ?? 0 : 0;
    final month = monthIndex >= 1 && monthIndex <= 12 ? _months[monthIndex] : '';

    return Container(
      width: 52,
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            day,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
          Text(
            month,
            style: const TextStyle(
              color: AppColors.powderBlue,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
