import 'package:delivery_app/models/auth_form_data.dart';
import 'package:delivery_app/services/auth/atuh_save_credential.dart';
import 'package:delivery_app/services/auth/auth_service.dart';
import 'package:delivery_app/services/biometry/biometry.dart';
import 'package:delivery_app/widgets/login_auth_form.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class LoginAuth extends StatefulWidget {
  const LoginAuth({ Key? key}) : super( key: key);

  @override
  State<LoginAuth> createState() => _LoginAuthState();
}

class _LoginAuthState extends State<LoginAuth> {
  bool _isLoading = false;
  bool _errorLogin = false;

  String? message = null;
  AuthSaveCredentials _credentials = AuthSaveCredentials();
  final LocalAuthentication localAuth = LocalAuthentication();

  @override
  void initState(){
    super.initState();
    checkBiometry();
  }


  Future<void> checkBiometry() async{
     Biometry bio = Biometry();
     AuthSaveCredentials _credentials = AuthSaveCredentials();

    if (await bio.activeBiometry()){
      print('tem biometria');
      bool authLocal =  await bio.authenticate();
      if (authLocal){
        var email = await _credentials.getByKey('email');
        var password = await _credentials.getByKey('password');

        setState(() => _isLoading = !_isLoading);
        
        
        AuthService().login(email!, password!);
      
      }
    }    
  }

  Future<void> _handleSubmit(AuthFormData authData) async {

    final biometry = Biometry();
    
    try {
      setState(() => _isLoading = !_isLoading);

        if (await biometry.hasBiometric() &&  !(await _credentials.getByKey('biometria') == '1')){
          showDialog(
            context: context, 
            builder: (BuildContext context) =>  AlertDialog(
                title: const Text('Ativar Biometria'), 
                content: const Text('Deseja ativar o Login com a Biometria!'),
                actions: [
                  TextButton(onPressed: () {
                      _credentials.add('biometria', '1');
                      _credentials.add('email', authData.email);
                      _credentials.add('password', authData.password);
                      Navigator.of(context).pop();
                  } , child: const Text('OK')),
                  TextButton(onPressed: (){
                    Navigator.of(context).pop();
                  }, child: const Text('Cancelar'))
                ],
                ),
          );
        }

      if (authData.isLogin){
        await AuthService().login(authData.email, authData.password);
        if (authData.saveCredentials){
         
          _credentials.add('email', authData.email);
          _credentials.add('password', authData.password);
          _credentials.add('check', '1');
        }

      
      } else {
        await AuthService().signup(authData.email, authData.password);
      }
    } catch(error){
      // ERRRO Tratar
      print(error);
      if (error.toString().contains('[firebase_auth/wrong-password]')){
        message = 'Email ou Senha incorreto';
      }
      if (error.toString().contains('[firebase_auth/too-many-requests]')){
        message = 'Acesso Bloqueado ao usuario por varias tentativas, tente mais tarde!';
      }
      if (error.toString().contains('[firebase_auth/network-request-failed]')){
        message = 'Sem internet - verfique sua conexao';
      }
      
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(message: message!),
      );
      
    } finally {
      setState(() => _isLoading = !_isLoading);
      setState(() => _errorLogin = !_errorLogin);
    }   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: 
      Focus(
        onFocusChange: (hasFocus) {
          if (hasFocus){
            checkBiometry();
          }
        },
        child:
         Stack(
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
      ),
    );
  }
}