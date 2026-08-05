// lib/features/auth/presentation/pages/login_page.dart
import 'package:coffeshop/core/routes/app_routes.dart';
import 'package:coffeshop/features/profile/presentation/viewmodel/profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/view_state.dart';
import '../viewmodels/auth_viewmodel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey   = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool  _obscure   = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final vm = context.read<AuthViewModel>();
    final ok = await vm.login(_emailCtrl.text.trim(), _passCtrl.text);
    if (!mounted) return;
    if (ok) {
      await context.read<ProfileViewModel>().loadProfile();
      if (!mounted) return;

      final profileVM = context.read<ProfileViewModel>();
      if (profileVM.profile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No se pudo cargar tu perfil'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }

      // ADMIN → lista normal
      if (profileVM.isAdmin) {
        Navigator.pushReplacementNamed(context, AppRoutes.orderList);
      } else if (profileVM.isCashier) {
        // CASHIER → vista cajero
        Navigator.pushReplacementNamed(context, AppRoutes.cashier);
      } else {
        // WAITER → lista de pedidos
        Navigator.pushReplacementNamed(context, AppRoutes.orderList);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.errorMessage ?? 'Error desconocido'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Icon(Icons.restaurant, size: 64, color: cs.primary),
                      const SizedBox(height: 8),
                      Text('RestaurantApp', style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 24),

                      // Email
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Correo electrónico',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Campo requerido';
                          if (!v.contains('@')) return 'Email inválido';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password
                      TextFormField(
                        controller: _passCtrl,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => setState(() => _obscure = !_obscure),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Campo requerido';
                          if (v.length < 6) return 'Mínimo 6 caracteres';
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Botón login
                      Consumer<AuthViewModel>(
                        builder: (_, vm, _) => vm.state == ViewState.loading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: _submit,
                                child: const Text('Iniciar Sesión'),
                              ),
                      ),
                      const SizedBox(height: 8),

                      // Navegar a register
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
                        child: const Text('¿No tienes cuenta? Regístrate'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}