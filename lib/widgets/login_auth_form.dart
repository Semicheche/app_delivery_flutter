import 'dart:io';

import 'package:delivery_app/models/auth_form_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthForm extends StatefulWidget {
  final void Function(AuthFormData) onSubmit;

  const AuthForm({
    Key? key,
    required this.onSubmit,
    }) : super(key : key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _authData = AuthFormData();
  bool _passwordVisible = true;   
  

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if(!isValid) return;

    widget.onSubmit(_authData);
  }

  @override
  Widget build(BuildContext context) {
    print('AQUI');
    return Card(
      color: Color.fromRGBO(255, 255, 255, 1),
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage("assets/images/delivery-man1.png")
              ),
              TextFormField(
                key: ValueKey('nome'),
                onChanged: (value) {
                  print(value);
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                key: ValueKey('email'),
                initialValue: _authData.email,
                onChanged: (email) => _authData.email = email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: "Email"),
                validator: (_email) {
                  final email = _email ?? '';
                  if (!email.contains('@')){
                    return 'Email informado não e válido.';
                  }
                },
              ),
              TextFormField(
                key: ValueKey('password'),
                initialValue: _authData.password,
                onChanged: (password) => _authData.password = password,
                obscureText: _passwordVisible,
                decoration: InputDecoration(
                  labelText: "Senha",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                      color: Colors.grey,
                      ),
                    onPressed: () {
                      // setState(() {
                      //     _passwordVisible = !_passwordVisible;
                      // });
             },
            ),
          
                  ),
                
                validator: (_password) {
                  final password = _password ?? '';
                  if (password.trim().length < 3) {
                    return 'Senha deve ter no minimo 3 caracteres.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit, 
                child: Text(
                  _authData.isLogin 
                  ? 'Entrar' 
                  : 'Cadastrar')
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  
                    Checkbox(
                        value: _authData.saveCredentials, 
                        onChanged: (bool? value ) {
                          setState(() {
                            _authData.saveCredentials = value!;
                          });
                        }),
                        Text('Lembrar Senha', style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ]
              ),
              // TextButton(onPressed: () {
              //   setState(() {
              //     _authData.toogleAuthMode();
              //   });
              // }, child: Text(
              //   _authData.isLogin 
              //   ? 'Criar uma nova conta?' 
              //   : 'Ja Possui Conta?')
              //   )
            ],
          ),
        ),
      ),
    );
  }
}
