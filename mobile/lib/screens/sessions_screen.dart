import 'package:flutter/material.dart';

import '../models/lodge_session.dart';
import '../services/api_exception.dart';
import '../services/session_service.dart';
import '../theme/app_theme.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  late Future<List<LodgeSession>> _future;

  @override
  void initState() {
    super.initState();
    _future = SessionService.instance.list();
  }

  Future<void> _reload() async {
    setState(() => _future = SessionService.instance.list());
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _reload,
      child: FutureBuilder<List<LodgeSession>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            final message = snapshot.error is ApiException
                ? (snapshot.error as ApiException).message
                : 'Não foi possível carregar as sessões.';
            return ListView(
              children: [
                const SizedBox(height: 80),
                Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
                const SizedBox(height: 12),
                Text(message, textAlign: TextAlign.center),
              ],
            );
          }

          final sessions = snapshot.data!;

          if (sessions.isEmpty) {
            return ListView(
              children: const [
                SizedBox(height: 80),
                Icon(Icons.event_busy, size: 48, color: AppColors.navy),
                SizedBox(height: 12),
                Text(
                  'Nenhuma sessão registrada ainda.',
                  textAlign: TextAlign.center,
                ),
              ],
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: sessions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final session = sessions[index];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.powderBlueLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColors.navy,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.event,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${session.type} · ${session.degree}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.navyDark,
                            ),
                          ),
                          Text(
                            session.date,
                            style: TextStyle(
                              color: AppColors.navy.withValues(alpha: 0.7),
                              fontSize: 13,
                            ),
                          ),
                          if (session.summary != null &&
                              session.summary!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                session.summary!,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
