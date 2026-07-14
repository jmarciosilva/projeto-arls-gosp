import 'package:flutter/material.dart';

import '../screens/admin/lodge_list_screen.dart';
import '../screens/home_screen.dart';

/// Decide qual "home" mostrar de acordo com o papel do usuário logado.
/// platform_admin administra Lojas; os demais papéis (lodge_admin,
/// secretary, member) usam a experiência do obreiro comum.
Widget homeScreenForRole(String role) {
  if (role == 'platform_admin') {
    return const LodgeListScreen();
  }
  return const HomeScreen();
}
