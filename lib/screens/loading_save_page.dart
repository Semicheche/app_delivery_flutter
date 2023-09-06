import 'package:flutter/material.dart';

class LoadingSavePage extends StatelessWidget {
  const LoadingSavePage({Key? key}) : super(key : key);

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
              Text("Salvando Entrega...", 
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