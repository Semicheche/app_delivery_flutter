
import 'package:delivery_app/services/loca_storage/local_storage.dart';

enum AuthMode { Login, Signup}

class AuthFormData {
  String email = '';
  String password =  '';
  bool saveCredentials = false;

  AuthMode _mode = AuthMode.Login;

  bool get isLogin {
    return _mode == AuthMode.Login;
  }

  bool get isSignup {
    return _mode == AuthMode.Signup;
  }

  void toogleAuthMode() {
    _mode = isLogin ? AuthMode.Signup : AuthMode.Login;
  }
}