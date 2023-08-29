import 'package:delivery_app/models/auth_form_data.dart';
import 'package:delivery_app/services/auth/auth_service.dart';
import 'package:delivery_app/widgets/login_auth_form.dart';
import 'package:flutter/material.dart';

class LoginAuth extends StatefulWidget {
  const LoginAuth({ Key? key}) : super( key: key);

  @override
  State<LoginAuth> createState() => _LoginAuthState();
}

class _LoginAuthState extends State<LoginAuth> {
  bool _isLoading = false;
  bool _errorLogin = false;


  Future<void> _handleSubmit(AuthFormData authData) async {

    try {
      setState(() => _isLoading = !_isLoading);

      if (authData.isLogin){
        await AuthService().login(authData.email, authData.password);
      } else {
        await AuthService().signup(authData.email, authData.password);
      }
    } catch(error){
      // ERRRO Tratar
      print('AQUI======');
      print(error);
    } finally {
      setState(() => _isLoading = !_isLoading);
      setState(() => _errorLogin = !_errorLogin);
    }
  
    print(authData.email);
    
  }

  @override
  Widget build(BuildContext context) {
     final snackBar = SnackBar(content: Text('Yay! A SnackBar!'));
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: AuthForm(onSubmit: _handleSubmit),
            )
          ),
          if (_isLoading) Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.5)
            ),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      )
    );
  }
}