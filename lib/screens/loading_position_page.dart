import 'package:flutter/material.dart';

class LoadingPositionPage extends StatelessWidget {
  const LoadingPositionPage({Key? key}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
              SizedBox(height: 10),
              Text("Salvando Imagens...", 
              style: TextStyle(
                color: Colors.white,
                fontSize: 20
              )),
            ],
          ),
        ),
    );
  }
}