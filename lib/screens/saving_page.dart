import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:delivery_app/screens/menu_page.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

class SavingPage extends StatefulWidget {
  var msg;
  bool img;
  bool done;

  SavingPage({super.key,
  required this.msg,
  required this.img,
  required this.done });

  @override
  State<SavingPage> createState() => _SavingPageState();
}

class _SavingPageState extends State<SavingPage> {
  @override
  Widget build(BuildContext context) {
    final fontSize = MediaQuery.of(context).size.width*0.11;
  
    var message = widget.msg ?? 'Salvando';
    var hasSaveImage = widget.img;
    var hasDone = widget.done; 
    return Scaffold(
      backgroundColor: Colors.blue.shade800,
      body: Container(
        alignment: Alignment.center,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(width: 20.0, height: 100.0),
              
              // CircularProgressIndicator(
              //   backgroundColor: Colors.white,
              // ),
              SizedBox(width: 10),
              Text(
                message,
                style: TextStyle(fontSize: fontSize, color: Colors.white),
                ),
              const LinearProgressIndicator(
                backgroundColor: Colors.white,
              ),
              Container(
                alignment: Alignment.center,
                child: 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                const SizedBox(width: 20.0, height: 50.0),
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: fontSize,
                    fontFamily: 'Arial',
                    // fontWeight: FontWeight.bold
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      if (hasSaveImage ) FadeAnimatedText('Imagens...'),
                      FadeAnimatedText(''),
                      FadeAnimatedText('Entrega...'),
                      FadeAnimatedText(''),
                       if (hasDone ) FadeAnimatedText('✔️Concluido')
                    ],
                    onTap: () {
                      print("Tap Event");
                    },
                  ),
                ),]
              )
              ),
            ],
                ),
      )
    );
    // return Scaffold(
    //   body: AnimatedSplashScreen(
    //         duration: 3000,
    //         splash: Icons.home,
    //         nextScreen: Save(),
    //         splashTransition: SplashTransition.fadeTransition,
    //         pageTransitionType: PageTransitionType.scale,
    //         backgroundColor: Colors.blue)
    //     );
  }
}