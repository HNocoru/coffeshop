class UserProfile {
  final int    id;
  final String name;
  final String email;
  final String role;       // ← nuevo: "waiter" | "admin" etc.
  final String? avatarUrl; // siempre null por ahora, backend no lo almacena aún

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatarUrl,
  });

  // Conveniencia para no comparar strings en la UI
  bool get isAdmin => role == 'admin';
}