import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CacheClient {
  CacheClient._() {
    _secureStorage = const FlutterSecureStorage();
  }

  static final CacheClient _instance = CacheClient._();
  static CacheClient get instance => _instance;

  late final FlutterSecureStorage _secureStorage;
  final _key = 'authToken';
  final _keyName = 'name';

  Future<String?> getAccessToken() async {
    final accessToken = await _secureStorage.read(key: _key);
    return accessToken;
  }

  Future<void> setAccessToken({required String accessToken}) async {
    await _secureStorage.write(key: _key, value: accessToken);
  }

  Future<String?> getUsername() async {
    final username = await _secureStorage.read(key: _keyName);
    return username;
  }

  Future<void> setUsername({required String name}) async {
    await _secureStorage.write(key: _keyName, value: name);
  }

  Future<void> deleteAccessToken() async {
    await _secureStorage.delete(key: _key);
  }
}
