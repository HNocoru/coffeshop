// lib/features/auth/domain/entities/user.dart
// Entidad pura del dominio — sin imports de Flutter ni HTTP
class User {
  final int    id;
  final String name;
  final String email;
  final String role;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });
}