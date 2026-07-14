import '../models/lodge_session.dart';
import 'api_client.dart';

class SessionService {
  SessionService._();

  static final SessionService instance = SessionService._();

  final _api = ApiClient.instance;

  Future<List<LodgeSession>> list() async {
    final data = await _api.get('/sessions');
    final items = data['data'] as List;
    return items
        .map((json) => LodgeSession.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
