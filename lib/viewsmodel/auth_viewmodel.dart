
import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../repositories/auth_repository.dart';

enum AuthStatus { authenticated, unauthenticated }

class AuthViewModel extends ChangeNotifier {

  final AuthRepository _authRepository;

  AuthViewModel({required AuthRepository authRepository})
      : _authRepository = authRepository;

AuthStatus status = AuthStatus.unauthenticated;
AppUser? currentUser;
bool isLoading = false;
String? errorMessage;

Future<bool> login(String email, String password) async {
  isLoading = true;
  errorMessage = null;
  notifyListeners();
  try{
    final user = await _authRepository.login(email, password);
    currentUser = user;
    status = AuthStatus.authenticated;
    return true;

  } on AuthException catch (e) {

    errorMessage = e.message;
    return false;

  } catch (_){
    errorMessage = 'Erro inesperado ao entrar. Tente novamente.';
    return false;
  } finally {
    isLoading = false;
    notifyListeners();

  }
}

Future<bool> register({
    required String nome,
    required String username,
    required String email,
  required String password,
}) async {
  isLoading = true;
  errorMessage = null;
  notifyListeners();
  try {
    final user = await _authRepository.register(
        nome: nome,
        username: username,
        email: email,
        password: password
    );
    currentUser = user;
    status = AuthStatus.authenticated;
    return true;
  } on AuthException catch (e) {
    errorMessage = e.message;
    return false;

  } catch (_){
    errorMessage = 'Erro inesperado ao cadastrar. Tente novamente.';
    return false;


  } finally {
    isLoading = false;
    notifyListeners();
  }
}
  void logout() {
  currentUser = null;
  status = AuthStatus.unauthenticated;
  notifyListeners();

  }

  void updateProfile(AppUser update){
  currentUser = update;
  notifyListeners();
  }








}
