import 'package:coffeshop/features/profile/domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    super.avatarUrl,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id:        json['id']         as int,
      name:      json['name']       as String,
      email:     json['email']      as String,
      role:      json['role']       as String? ?? 'waiter', // fallback seguro
      avatarUrl: json['avatar_url'] as String?,
    );
  }
}