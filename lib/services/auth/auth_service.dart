import 'package:delivery_app/models/auth_user.dart';
import 'package:delivery_app/services/auth/auth_firebase_service.dart';

abstract class AuthService {
  AuthUser? get currentUser;

  Stream<AuthUser?> get userChanges;

  Future<void> signup(String email, String password);
  Future<void> login(String email, String password);
  Future<void> logout();

  factory AuthService() {
    return AuthFirebaseService();
    // return LoginAuthService();
  }
}