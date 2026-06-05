
import 'package:coffeshop/features/profile/domain/entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> getProfile();
  Future<UserProfile> updateProfile(String name, String email);
}