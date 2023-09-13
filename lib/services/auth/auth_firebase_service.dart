import 'package:delivery_app/services/auth/atuh_save_credential.dart';
import 'package:delivery_app/services/auth/auth_service.dart';
import 'package:delivery_app/models/auth_user.dart';
import 'package:delivery_app/services/biometry/biometry.dart';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';

class AuthFirebaseService implements AuthService {
  AuthSaveCredentials _storage = AuthSaveCredentials();
  static AuthUser? _currentUser;
  static AuthUser? _user;
  

  static final _userStream = Stream<AuthUser?>.multi((controller) async { 
    final authChanges = FirebaseAuth.instance.authStateChanges();
    await for(final user in authChanges) {
      _currentUser = user == null ? null : _toAuthUser(user);
      controller.add(_currentUser);
    }
  });

  Future<void> getUserLocal() async {
    _user = await AuthUser(
            id: '', 
            name: (await _storage.getByKey('name')) as String, 
            password: (await _storage.getByKey('password')) as String, 
            email: (await _storage.getByKey('email')) as String);
  }

  AuthUser? get currentUser {
    return _currentUser;
  }

  Stream<AuthUser?> get userChanges {
    return _userStream;
  }

  Future<void> signup(String email, String password) async {
    // NAO SERA UTILIZADO POR ENQUANTO
    // final auth = FirebaseAuth.instance;
    // UserCredential user =  await auth.createUserWithEmailAndPassword(
    //   email: email, 
    //   password: password);
  }

  Future<void> login(String email, String password) async {
   
    try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    }catch(err) {
      
    }finally{
      print('PASSOU NO FINALLY');
    }

  }
  Future<void> logout() async {

    FirebaseAuth.instance.signOut();
  }

  static AuthUser _toAuthUser(User user){
    return AuthUser(
        id: user.uid, 
        name: user.displayName ?? user.email!, 
        password: user.hashCode.toString(), 
        email: user.email!,
        );
  }
}