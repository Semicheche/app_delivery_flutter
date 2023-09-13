import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/firebase_options.dart';
import 'package:delivery_app/models/auth_user.dart';
import 'package:delivery_app/screens/auth/login_auth.dart';
import 'package:delivery_app/screens/loading_page.dart';
import 'package:delivery_app/screens/menu_page.dart';
import 'package:delivery_app/services/auth/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ObserverLogin extends StatelessWidget {
  const ObserverLogin({Key? key}) : super(key : key);

  Future<void> init(BuildContext context) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
      );
    FirebaseFirestore.instance.enablePersistence;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: this.init(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return LoadingPage();
          } else {
            return  StreamBuilder<AuthUser?>(
              stream: AuthService().userChanges,
                builder: (context, snapshot) {
                 if (snapshot.connectionState == ConnectionState.waiting){
                    return LoadingPage();
                 } else {
                  return snapshot.hasData ? MenuPage() : LoginAuth();                  
                }

            });
          }
        },
      );
  }
}