enum AuthMode { Login, Signup}

class AuthFormData {
  String email = '';
  String password = '';

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