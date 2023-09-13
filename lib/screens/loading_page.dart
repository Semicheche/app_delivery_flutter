import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key : key);
  

  @override
  Widget build(BuildContext context) {
    final fontSize = MediaQuery.of(context).size.width*0.05;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
              SizedBox(height: 10),
              Text("Carregando...", 
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.white
              )),
            ],
          ),
        ),
    );
  }
}