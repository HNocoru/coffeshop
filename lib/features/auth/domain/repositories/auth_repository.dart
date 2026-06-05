// lib/features/auth/domain/repositories/auth_repository.dart
// Puerto abstracto — el ViewModel solo conoce esta interfaz
import '../entities/user.dart';

abstract class AuthRepository {
  /// Autentica al usuario. Guarda el token internamente.
  /// Retorna el token para uso posterior si es necesario.
  Future<String> login(String email, String password);

  /// Registra un nuevo usuario y lo retorna.
  Future<User> register(String name, String email, String password);

  /// Elimina el token de la sesión local.
  Future<void> logout();
}