// import 'package:delivery_app/screens/laoding_page.dart';
// import 'package:delivery_app/screens/auth/login_auth.dart';
import 'package:delivery_app/screens/auth/observer_login.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your apprlication.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delivery APP',
      theme: ThemeData( 
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(color: Colors.blue.shade800)
            ),
            fixedSize: Size.fromWidth(350),

            textStyle: const TextStyle(
              fontSize: 20,
            ),
            backgroundColor: Color.fromARGB(211, 252, 252, 252),
            
          )),
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 55, 125, 206), secondary: Colors.indigoAccent),
        useMaterial3: true,
      ),
      home: ObserverLogin(),
      debugShowCheckedModeBanner: false,
    );
  }
}


