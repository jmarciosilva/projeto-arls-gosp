import 'package:flutter/material.dart';

import '../../models/lodge.dart';
import '../../services/api_exception.dart';
import '../../services/auth_service.dart';
import '../../services/lodge_service.dart';
import '../../theme/app_theme.dart';
import '../login_screen.dart';
import 'register_lodge_screen.dart';

class LodgeListScreen extends StatefulWidget {
  const LodgeListScreen({super.key});

  @override
  State<LodgeListScreen> createState() => _LodgeListScreenState();
}

class _LodgeListScreenState extends State<LodgeListScreen> {
  late Future<List<Lodge>> _future;

  @override
  void initState() {
    super.initState();
    _future = LodgeService.instance.list();
  }

  Future<void> _reload() async {
    setState(() => _future = LodgeService.instance.list());
    await _future;
  }

  Future<void> _logout() async {
    await AuthService.instance.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _openRegisterWizard() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const RegisterLodgeScreen()),
    );
    if (created == true) _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lojas GOSP'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: _logout,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openRegisterWizard,
        icon: const Icon(Icons.add),
        label: const Text('Cadastrar Loja'),
      ),
      body: RefreshIndicator(
        onRefresh: _reload,
        child: FutureBuilder<List<Lodge>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              final message = snapshot.error is ApiException
                  ? (snapshot.error as ApiException).message
                  : 'Não foi possível carregar as Lojas.';
              return ListView(
                children: [
                  const SizedBox(height: 100),
                  Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
                  const SizedBox(height: 12),
                  Text(message, textAlign: TextAlign.center),
                ],
              );
            }

            final lodges = snapshot.data!;

            if (lodges.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 100),
                  Icon(Icons.domain_outlined, size: 48, color: AppColors.textMuted),
                  SizedBox(height: 12),
                  Text(
                    'Nenhuma Loja cadastrada ainda.\nToque em "Cadastrar Loja" para começar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ],
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 96),
              itemCount: lodges.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final lodge = lodges[index];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.powderBlueLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.domain, color: AppColors.navy),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lodge.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.navyDark,
                              ),
                            ),
                            Text(
                              'Nº ${lodge.number} · ${lodge.rite}',
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12.5,
                              ),
                            ),
                            Text(
                              '${lodge.city}/${lodge.state}',
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12.5,
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
      ),
    );
  }
}
