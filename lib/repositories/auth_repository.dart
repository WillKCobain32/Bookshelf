import '../models/app_user.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

abstract class AuthRepository {
  Future<AppUser> login(String email, String password);
  Future<AppUser> register({
    required String nome,
    required String username,
    required String email,
    required String password,
  });
}


class InMemoryAuthRepository implements AuthRepository {
  static final List<Map<String, String>> _credentials = [
    {'email': 'leitor@teste.com', 'password': '123456', 'userId': 'u1'},
  ];

  static final List<AppUser> _users = [
    const AppUser(
      id: 'u1',
      nome: 'Usuario Teste',
      username: 'leitor_teste',
      email: 'leitor@teste.com',
      bio: 'Apaixonado(a) por livros.',
    ),
  ];

  static int _counter = 1;

  @override
  Future<AppUser> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final normalizedEmail = email.trim().toLowerCase();
    final cred = _credentials.where((c) => c['email'] == normalizedEmail);
    if (cred.isEmpty) {
      throw AuthException('Nao existe conta com este e-mail.');
    }
    if (cred.first['password'] != password) {
      throw AuthException('Senha incorreta.');
    }
    return _users.firstWhere((u) => u.id == cred.first['userId']);
  }

  @override
  Future<AppUser> register({
    required String nome,
    required String username,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final normalizedEmail = email.trim().toLowerCase();
    final emailExists = _credentials.any((c) => c['email'] == normalizedEmail);
    if (emailExists) {
      throw AuthException('Ja existe uma conta com este e-mail.');
    }
    final usernameExists =
    _users.any((u) => u.username.toLowerCase() == username.trim().toLowerCase());
    if (usernameExists) {
      throw AuthException('Este nome de usuario ja esta em uso.');
    }
    _counter++;
    final id = 'u$_counter';
    final user = AppUser(
      id: id,
      nome: nome.trim(),
      username: username.trim(),
      email: normalizedEmail,
    );
    _users.add(user);
    _credentials.add({'email': normalizedEmail, 'password': password, 'userId': id});
    return user;
  }
}
