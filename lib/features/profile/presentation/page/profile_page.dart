import 'package:coffeshop/core/utils/view_state.dart';
import 'package:coffeshop/features/profile/presentation/page/edit_profile_page.dart';
import 'package:coffeshop/features/profile/presentation/viewmodel/profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // addPostFrameCallback: espera que el árbol de widgets esté listo
    // antes de disparar la carga. Equivale a ViewDidAppear en iOS.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi perfil'),
        actions: [
          if (vm.profile != null)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfilePage()),
              ),
            ),
        ],
      ),
      body: switch (vm.state) {
        ViewState.loading || ViewState.idle =>
          const Center(child: CircularProgressIndicator()),
        ViewState.error => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(vm.errorMessage ?? 'Error al cargar perfil'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => context.read<ProfileViewModel>().loadProfile(),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ViewState.success => _ProfileBody(vm: vm),
      },
    );
  }
}

class _ProfileBody extends StatelessWidget {
  final ProfileViewModel vm;
  const _ProfileBody({required this.vm});

  @override
  Widget build(BuildContext context) {
    final p = vm.profile!;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Center(
          child: CircleAvatar(
            radius: 52,
            backgroundImage:
                p.avatarUrl != null ? NetworkImage(p.avatarUrl!) : null,
            child: p.avatarUrl == null
                ? Text(
                    p.name.isNotEmpty ? p.name[0].toUpperCase() : '?',
                    style: const TextStyle(fontSize: 36),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 28),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Nombre'),
                subtitle: Text(p.name),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: const Text('Correo'),
                subtitle: Text(p.email),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          icon: const Icon(Icons.edit),
          label: const Text('Editar perfil'),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EditProfilePage()),
          ),
        ),
      ],
    );
  }
}
