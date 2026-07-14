import '../models/user_profile.dart';
import 'api_client.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final _api = ApiClient.instance;

  Future<UserProfile> login({
    required String email,
    required String password,
  }) async {
    final data = await _api.post('/login', {
      'email': email,
      'password': password,
    }, authenticated: false);

    await _api.saveToken(data['token'] as String);

    return UserProfile.fromJson(data['user'] as Map<String, dynamic>);
  }

  Future<void> logout() async {
    try {
      await _api.post('/logout', {});
    } finally {
      await _api.clearToken();
    }
  }

  Future<UserProfile> me() async {
    final data = await _api.get('/me');
    return UserProfile.fromJson(data['data'] as Map<String, dynamic>);
  }

  Future<bool> get isLoggedIn async => (await _api.token) != null;
}
