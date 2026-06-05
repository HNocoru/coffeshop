import 'package:coffeshop/core/network/api_client.dart';
import 'package:coffeshop/features/profile/data/model/user_profile_model.dart';
import 'package:coffeshop/features/profile/domain/repository/profile_repository.dart';
import 'package:coffeshop/features/profile/domain/entities/user_profile.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ApiClient _client;
  ProfileRepositoryImpl(this._client);

  @override
  Future<UserProfile> getProfile() async {
    final response = await _client.get('/api/users/me');
    return UserProfileModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<UserProfile> updateProfile(String name, String email) async {
    final response = await _client.put('/api/users/me', {
      'name': name,
      'email': email,
    });
    return UserProfileModel.fromJson(response as Map<String, dynamic>);
  }
}