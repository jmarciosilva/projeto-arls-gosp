import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../services/api_exception.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserProfile> _future;

  @override
  void initState() {
    super.initState();
    _future = AuthService.instance.me();
  }

  Future<void> _reload() async {
    setState(() => _future = AuthService.instance.me());
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _reload,
      child: FutureBuilder<UserProfile>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            final message = snapshot.error is ApiException
                ? (snapshot.error as ApiException).message
                : 'Não foi possível carregar o perfil.';
            return ListView(
              children: [
                const SizedBox(height: 80),
                Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
                const SizedBox(height: 12),
                Text(message, textAlign: TextAlign.center),
              ],
            );
          }

          final profile = snapshot.data!;
          final member = profile.member;
          final lodge = profile.lodge;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.powderBlueLight,
                      child: Text(
                        profile.name.isNotEmpty
                            ? profile.name[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 32,
                          color: AppColors.navy,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      member?.nickname ?? profile.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navyDark,
                      ),
                    ),
                    if (member != null)
                      Text(
                        member.degree ?? '',
                        style: TextStyle(color: AppColors.navy.withValues(alpha: 0.7)),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (lodge != null) _SectionCard(
                title: 'Loja',
                rows: {
                  'Nome': lodge.name,
                  'Número': lodge.number,
                  'Rito': lodge.rite,
                  'Cidade/UF': '${lodge.city}/${lodge.state}',
                },
              ),
              if (member != null) ...[
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Dados Maçônicos',
                  rows: {
                    'CIM': member.cim ?? '—',
                    'Grau': member.degree ?? '—',
                    if (member.position != null) 'Cargo': member.position!,
                    'Situação': member.status,
                  },
                ),
              ],
              const SizedBox(height: 16),
              _SectionCard(
                title: 'Conta',
                rows: {
                  'E-mail': profile.email,
                  if (profile.whatsapp != null) 'WhatsApp': profile.whatsapp!,
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Map<String, String> rows;

  const _SectionCard({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.powderBlueLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 10),
          ...rows.entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 110,
                    child: Text(
                      entry.key,
                      style: TextStyle(color: AppColors.navy.withValues(alpha: 0.7)),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: const TextStyle(
                        color: AppColors.navyDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
