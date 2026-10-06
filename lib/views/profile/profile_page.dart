import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewsmodel/auth_viewmodel.dart';
import '../../viewsmodel/profile_viewmodel.dart';
import '../../widgets/custom_text_field.dart';
import '../auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthViewModel>().currentUser;
    _nameController = TextEditingController(text: user?.nome ?? '');
    _usernameController = TextEditingController(text: user?.username ?? '');
    _bioController = TextEditingController(text: user?.bio ?? '');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().loadStats(user?.id ?? '');
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final authVM = context.read<AuthViewModel>();
    final current = authVM.currentUser!;
    authVM.updateProfile(current.copyWith(
      name: _nameController.text.trim(),
      username: _usernameController.text.trim(),
      bio: _bioController.text.trim(),
    ));
    setState(() => _editing = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Perfil atualizado com sucesso!')));
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();
    final profileVM = context.watch<ProfileViewModel>();
    final user = authVM.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            icon: Icon(_editing ? Icons.close : Icons.edit_outlined),
            onPressed: () => setState(() => _editing = !_editing),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: const Color(0xFF1D3557),
                child: Text(
                  (user?.nome.isNotEmpty == true ? user!.nome[0] : '?').toUpperCase(),
                  style: const TextStyle(fontSize: 32, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatColumn(label: 'Livros lidos', value: '${profileVM.totalLivrosLidos}'),
                  _StatColumn(label: 'Nota media', value: profileVM.mediaNotas.toStringAsFixed(1)),
                ],
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _nameController,
                label: 'Nome',
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe seu nome.' : null,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _usernameController,
                label: 'Usuario',
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Informe um nome de usuario.';
                  final regex = RegExp(r'^[a-zA-Z0-9_]{3,20}$');
                  if (!regex.hasMatch(v.trim())) return 'Use de 3 a 20 letras, numeros ou "_".';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(controller: _bioController, label: 'Bio', maxLines: 3),
              const SizedBox(height: 24),
              if (_editing)
                ElevatedButton(onPressed: _save, child: const Text('Salvar alteracoes')),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Sair'),
                onPressed: () {
                  authVM.logout();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                        (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  const _StatColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
