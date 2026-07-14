import 'package:flutter/material.dart';

import '../models/lodge_session.dart';
import '../models/user_profile.dart';
import '../services/api_exception.dart';
import '../services/auth_service.dart';
import '../services/session_service.dart';
import '../theme/app_theme.dart';
import '../widgets/section_header.dart';
import '../widgets/session_card.dart';
import '../widgets/stat_card.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback onSeeAllSessions;
  final VoidCallback onLogout;

  const DashboardScreen({
    super.key,
    required this.onSeeAllSessions,
    required this.onLogout,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<(UserProfile, List<LodgeSession>)> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<(UserProfile, List<LodgeSession>)> _load() async {
    final results = await Future.wait([
      AuthService.instance.me(),
      SessionService.instance.list(),
    ]);
    return (
      results[0] as UserProfile,
      results[1] as List<LodgeSession>,
    );
  }

  Future<void> _reload() async {
    setState(() => _future = _load());
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _reload,
        child: FutureBuilder<(UserProfile, List<LodgeSession>)>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              final message = snapshot.error is ApiException
                  ? (snapshot.error as ApiException).message
                  : 'Não foi possível carregar seus dados.';
              return ListView(
                children: [
                  const SizedBox(height: 100),
                  Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
                  const SizedBox(height: 12),
                  Text(message, textAlign: TextAlign.center),
                ],
              );
            }

            final (profile, sessions) = snapshot.data!;
            final member = profile.member;
            final nextSession = sessions.isNotEmpty ? sessions.first : null;
            final preview = sessions.take(3).toList();

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.navy,
                      child: Text(
                        profile.name.isNotEmpty
                            ? profile.name[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Olá, ${member?.nickname ?? profile.name.split(' ').first}',
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: AppColors.navyDark,
                            ),
                          ),
                          if (profile.lodge != null)
                            Text(
                              profile.lodge!.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textMuted,
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout, color: AppColors.textMuted),
                      tooltip: 'Sair',
                      onPressed: widget.onLogout,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        icon: Icons.workspace_premium_outlined,
                        accent: AppColors.navy,
                        value: member?.degree ?? '—',
                        label: 'Grau',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        icon: Icons.verified_outlined,
                        accent: AppColors.accentGreen,
                        value: member?.status.toUpperCase() ?? '—',
                        label: 'Situação',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        icon: Icons.event_available_outlined,
                        accent: AppColors.accentAmber,
                        value: nextSession?.date ?? '—',
                        label: 'Próx. sessão',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                SectionHeader(
                  title: 'Próximas sessões',
                  actionLabel: sessions.isNotEmpty ? 'Ver todas' : null,
                  onAction: widget.onSeeAllSessions,
                ),
                const SizedBox(height: 12),
                if (preview.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: AppTheme.cardShadow,
                    ),
                    child: const Text(
                      'Nenhuma sessão registrada ainda.',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  )
                else
                  Column(
                    children: [
                      for (final session in preview) ...[
                        SessionCard(session: session),
                        const SizedBox(height: 10),
                      ],
                    ],
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
