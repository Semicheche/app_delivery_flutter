import 'dart:io';

import 'package:delivery_app/models/auth_form_data.dart';
import 'package:flutter/material.dart';

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


  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if(!isValid) return;

    widget.onSubmit(_authData);


  }
  
  @override
  Widget build(BuildContext context) {
    bool eye = true;
    return Card(
      color: Color.fromRGBO(255, 255, 255, 1),
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CircleAvatar(
                radius: 85,
                backgroundImage: AssetImage("assets/images/delivery-man1.png")
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
                obscureText: eye,
                decoration: InputDecoration(labelText: "Senha" ),
                validator: (_password) {
                  final password = _password ?? '';
                  if (password.trim().length < 3) {
                    return 'Senha deve ter no minimo 3 caracteres.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: _submit, 
                child: Text(
                  _authData.isLogin 
                  ? 'Entrar' 
                  : 'Cadastrar')
              ),
              TextButton(onPressed: () {
                setState(() {
                  _authData.toogleAuthMode();
                });
              }, child: Text(
                _authData.isLogin 
                ? 'Criar uma nova conta?' 
                : 'Ja Possui Conta?')
                )
            ],
          ),
        ),
      ),
    );
  }
}
