import 'package:flutter/material.dart';

import '../models/lodge_session.dart';
import '../services/api_exception.dart';
import '../services/session_service.dart';
import '../theme/app_theme.dart';
import '../widgets/session_card.dart';

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
                Icon(Icons.event_busy, size: 48, color: AppColors.textMuted),
                SizedBox(height: 12),
                Text(
                  'Nenhuma sessão registrada ainda.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textMuted),
                ),
              ],
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: sessions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) => SessionCard(session: sessions[index]),
          );
        },
      ),
    );
  }
}
