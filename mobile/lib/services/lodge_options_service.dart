import 'api_client.dart';

class LodgeOptions {
  final List<String> rites;
  final List<String> degrees;
  final List<String> states;

  LodgeOptions({required this.rites, required this.degrees, required this.states});

  factory LodgeOptions.fromJson(Map<String, dynamic> json) {
    return LodgeOptions(
      rites: List<String>.from(json['rites'] as List),
      degrees: List<String>.from(json['degrees'] as List),
      states: List<String>.from(json['states'] as List),
    );
  }
}

class LodgeOptionsService {
  LodgeOptionsService._();

  static final LodgeOptionsService instance = LodgeOptionsService._();

  final _api = ApiClient.instance;

  Future<LodgeOptions> fetch() async {
    final data = await _api.get('/lodge-options', authenticated: false);
    return LodgeOptions.fromJson(data as Map<String, dynamic>);
  }
}
