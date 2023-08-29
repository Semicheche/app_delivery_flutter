import 'dart:math';

import 'package:delivery_app/services/auth/auth_service.dart';
import 'package:delivery_app/models/auth_user.dart';
import 'dart:async';

class LoginAuthService implements AuthService {
  static final Map<String, AuthUser> _users = {};
  static AuthUser? _currentUser;
  static MultiStreamController<AuthUser?>? _controller;
  static final _userStream = Stream<AuthUser?>.multi((controller) { 
    _controller = controller;
    _updateUser(null);
    
  });

  AuthUser? get currentUser {
    return _currentUser;
  }

  Stream<AuthUser?> get userChanges {
    return _userStream;
  }

  Future<void> signup(String email, String password) async {
    final newUser = AuthUser(
      id: Random().nextDouble().toString(), 
      name: "User", 
      password: password, 
      email: email
    );

    _users.putIfAbsent(email, () => newUser);
    _updateUser(newUser);
  }

  Future<void> login(String email, String password) async {
    _updateUser(_users[email]);
  }
  Future<void> logout() async {
    _updateUser(null);
  }

  static void _updateUser(AuthUser? user){
    _currentUser = user;
    _controller?.add(_currentUser);
  }
}