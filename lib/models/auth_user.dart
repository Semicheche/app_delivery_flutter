import 'package:delivery_app/services/auth/atuh_save_credential.dart';

AuthSaveCredentials _storage = AuthSaveCredentials();


class AuthUser {
  final String id;
  final String name;
  final String password;
  final String email; 

  const AuthUser({
    required this.id,
    required this.name,
    required this.password,
    required this.email,
  });
}