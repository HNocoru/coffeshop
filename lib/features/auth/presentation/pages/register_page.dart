// lib/features/auth/presentation/pages/register_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../viewmodels/auth_viewmodel.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() =>
      _RegisterPageState();
}

class _RegisterPageState
    extends State<RegisterPage> {
  final _formKey =
      GlobalKey<FormState>();

  final _nameCtrl =
      TextEditingController();

  final _emailCtrl =
      TextEditingController();

  final _passCtrl =
      TextEditingController();

  bool _obscure = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();

    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    final messenger =
        ScaffoldMessenger.of(context);

    final vm =
        context.read<AuthViewModel>();

    final ok = await vm.register(
      _nameCtrl.text.trim(),
      _emailCtrl.text.trim(),
      _passCtrl.text.trim(),
    );

    if (!mounted) return;

    if (ok) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Cuenta creada correctamente',
          ),
        ),
      );

      Navigator.pop(context);
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            vm.errorMessage ??
                'Error desconocido',
          ),
          backgroundColor:
              Theme.of(context)
                  .colorScheme
                  .error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs =
        Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,

      appBar: AppBar(
        title: const Text(
          'Crear cuenta',
        ),
      ),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.all(24),

            child: Card(
              child: Padding(
                padding:
                    const EdgeInsets.all(
                      24,
                    ),

                child: Form(
                  key: _formKey,

                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min,

                    children: [
                      Icon(
                        Icons.person_add,
                        size: 64,
                        color: cs.primary,
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      Text(
                        'Registro',
                        style:
                            Theme.of(context)
                                .textTheme
                                .headlineSmall,
                      ),

                      const SizedBox(
                        height: 24,
                      ),

                      // Nombre
                      TextFormField(
                        controller:
                            _nameCtrl,

                        decoration:
                            const InputDecoration(
                              labelText:
                                  'Nombre',
                              prefixIcon: Icon(
                                Icons.person_outline,
                              ),
                            ),

                        validator: (
                          value,
                        ) {
                          if (value ==
                                  null ||
                              value
                                  .trim()
                                  .isEmpty) {
                            return 'Campo requerido';
                          }

                          if (value
                                  .trim()
                                  .length <
                              2) {
                            return 'Nombre demasiado corto';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      // Email
                      TextFormField(
                        controller:
                            _emailCtrl,

                        keyboardType:
                            TextInputType
                                .emailAddress,

                        decoration:
                            const InputDecoration(
                              labelText:
                                  'Correo electrónico',
                              prefixIcon: Icon(
                                Icons.email_outlined,
                              ),
                            ),

                        validator: (
                          value,
                        ) {
                          if (value ==
                                  null ||
                              value
                                  .trim()
                                  .isEmpty) {
                            return 'Campo requerido';
                          }

                          if (!value
                              .contains(
                                '@',
                              )) {
                            return 'Email inválido';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      // Password
                      TextFormField(
                        controller:
                            _passCtrl,

                        obscureText:
                            _obscure,

                        decoration:
                            InputDecoration(
                              labelText:
                                  'Contraseña',

                              prefixIcon:
                                  const Icon(
                                    Icons
                                        .lock_outlined,
                                  ),

                              suffixIcon:
                                  IconButton(
                                    icon: Icon(
                                      _obscure
                                          ? Icons
                                              .visibility
                                          : Icons
                                              .visibility_off,
                                    ),

                                    onPressed: () {
                                      setState(() {
                                        _obscure =
                                            !_obscure;
                                      });
                                    },
                                  ),
                            ),

                        validator: (
                          value,
                        ) {
                          if (value ==
                                  null ||
                              value
                                  .isEmpty) {
                            return 'Campo requerido';
                          }

                          if (value
                                  .length <
                              6) {
                            return 'Mínimo 6 caracteres';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(
                        height: 24,
                      ),

                      // Botón register
                      Consumer<
                        AuthViewModel
                      >(
                        builder:
                            (
                              _,
                              vm,
                              _,
                            ) {
                              return ElevatedButton(
                                onPressed:
                                    vm.isLoading
                                        ? null
                                        : _submit,

                                child:
                                    vm.isLoading
                                        ? const SizedBox(
                                            width:
                                                20,
                                            height:
                                                20,
                                            child:
                                                CircularProgressIndicator(
                                                  strokeWidth:
                                                      2,
                                                ),
                                          )
                                        : const Text(
                                            'Registrarse',
                                          ),
                              );
                            },
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                          );
                        },

                        child: const Text(
                          'Ya tengo cuenta',
                        ),
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