// lib/features/auth/presentation/viewmodels/auth_viewmodel.dart
import 'package:flutter/foundation.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/view_state.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository;
  AuthViewModel(this._repository);

  ViewState _state        = ViewState.idle;
  String?   _errorMessage;

  ViewState get state        => _state;
  String?   get errorMessage => _errorMessage;
  bool      get isLoading    => _state == ViewState.loading;

  /// Retorna true si el login fue exitoso.
  Future<bool> login(String email, String password) async {
    _setState(ViewState.loading);
    try {
      await _repository.login(email, password);
      _setState(ViewState.success);
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _setState(ViewState.error);
      return false;
    } catch (_) {
      _errorMessage = 'Error de conexión. Verifica tu red.';
      _setState(ViewState.error);
      return false;
    }
  }

  /// Retorna true si el registro fue exitoso.
  Future<bool> register(String name, String email, String password) async {
    _setState(ViewState.loading);
    try {
      await _repository.register(name, email, password);
      _setState(ViewState.success);
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _setState(ViewState.error);
      return false;
    } catch (_) {
      _errorMessage = 'Error de conexión. Verifica tu red.';
      _setState(ViewState.error);
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    _setState(ViewState.idle);
  }

  void _setState(ViewState state) {
    _state = state;
    notifyListeners();
  }
}