// lib/features/auth/data/repositories/auth_repository_impl.dart
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _client;
  AuthRepositoryImpl(this._client);

  @override
  Future<String> login(String email, String password) async {
    final data = await _client.post(
      '/api/auth/login',
      {'email': email, 'password': password},
      requireAuth: false, // login no lleva Bearer token
    );
    final token = data['access_token'] as String;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);

    return token;
  }

  @override
  Future<User> register(String name, String email, String password) async {
    final data = await _client.post(
      '/api/auth/register',
      {'name': name, 'email': email, 'password': password},
      requireAuth: false, // register no lleva Bearer token
    );
    return UserModel.fromJson(data);
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }
}