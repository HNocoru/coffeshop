// lib/features/auth/data/models/user_model.dart
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
  });

  /// Mapea la respuesta JSON de POST /api/auth/register
  /// Campos del backend: id, name, email, role
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id:    json['id']    as int,
    name:  json['name']  as String,
    email: json['email'] as String,
    role:  json['role']  as String,
  );
}