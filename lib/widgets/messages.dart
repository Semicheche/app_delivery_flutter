import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SnackMsg {

  void info(context, String message){
    showTopSnackBar(
        Overlay.of(context), 
        CustomSnackBar.info(message: message),
      );
   }

   void success(context, String message){
    showTopSnackBar(
        Overlay.of(context), 
        CustomSnackBar.success(message: message),
      );
   }

   void error(context, String message){
    showTopSnackBar(
        Overlay.of(context), 
        CustomSnackBar.error(message: message),
      );
   }

}