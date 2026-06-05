import 'package:coffeshop/core/utils/view_state.dart';
import 'package:coffeshop/features/profile/domain/repository/profile_repository.dart';
import 'package:coffeshop/features/profile/domain/entities/user_profile.dart';
import 'package:flutter/foundation.dart';

// ViewModel = Puerto de entrada a la lógica desde la UI
// No importa flutter/material, solo foundation (ChangeNotifier)
class ProfileViewModel extends ChangeNotifier {
  final ProfileRepository _repository;

  ViewState _state = ViewState.idle;
  UserProfile? _profile;
  String? _errorMessage;

  ProfileViewModel(this._repository);

  ViewState get state => _state;
  UserProfile? get profile => _profile;

  bool get isAdmin => _profile?.role == 'admin';
  bool get isCashier => _profile?.role == 'cashier';
  bool get isWaiter => _profile?.role == 'waiter';

  String? get errorMessage => _errorMessage;

  Future<void> loadProfile() async {
    _state = ViewState.loading;
    notifyListeners();
    try {
      _profile = await _repository.getProfile();
      _state = ViewState.success;
    } catch (e) {
      _errorMessage = e.toString();
      _state = ViewState.error;
    }
    notifyListeners();
  }

  Future<bool> updateProfile(String name, String email) async {
    _state = ViewState.loading;
    notifyListeners();
    try {
      _profile = await _repository.updateProfile(name, email);
      _state = ViewState.success;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _state = ViewState.error;
      notifyListeners();
      return false;
    }
  }
}