import '../models/lodge.dart';
import 'api_client.dart';

class LodgeService {
  LodgeService._();

  static final LodgeService instance = LodgeService._();

  final _api = ApiClient.instance;

  Future<List<Lodge>> list() async {
    final data = await _api.get('/lodges');
    final items = data['data'] as List;
    return items.map((json) => Lodge.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<Lodge> register(Map<String, dynamic> payload) async {
    final data = await _api.post('/lodges', payload);
    return Lodge.fromJson(data['data'] as Map<String, dynamic>);
  }
}
