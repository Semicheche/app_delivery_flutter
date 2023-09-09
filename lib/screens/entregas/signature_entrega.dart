import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class SignatureEntrega extends StatefulWidget {
  final data;
  final value;

  const SignatureEntrega({
    super.key,
    required this.data,
    required this.value
  });

  @override
  State<SignatureEntrega> createState() => _SignatureEntregaState();
}

class _SignatureEntregaState extends State<SignatureEntrega> {
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();
  Uint8List? img = null;

  void _handleClearButtonPressed() async{
    print('CLICK');

    signatureGlobalKey.currentState!.clear();   

    
    setState(() {
      img = null;
      widget.data.assinatura = null;
    }); 
  }

  void _handleSaveButtonPressed () async {
      ui.Image uiImage = await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);

      ByteData? byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
      img = Uint8List.view(byteData!.buffer);
      setState(() {
        widget.data.assinatura = img!;
      });
      
    

  }

  @override
  Widget build(BuildContext context) {
    var data = widget.data;
    var _ass = widget.value;
 
    if (_ass['assinaturaURL'] != null && _ass['assinaturaURL'] != ''){
      return  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  SizedBox(height: 10), 
                  Container(
                          child: Image.network(_ass['assinaturaURL'])
                        ),
                ]
      );

    }else{
      return  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 Text('Assinatura '),
                 Text('${data.name} - ${data.cpfCnpj}', style: TextStyle(fontSize: 17),),
                 Stack(
                  children : [
                    Padding(
                        padding: EdgeInsets.all(1),
                        child: Container(
                            height: 460,
                            child: SfSignaturePad(
                                key: signatureGlobalKey,
                                backgroundColor: Colors.white,
                                strokeColor: Colors.black,
                                minimumStrokeWidth: 1.0,
                                maximumStrokeWidth: 4.0
                              ),
                            decoration:
                                BoxDecoration(border: Border.all(color: Colors.grey)
                        )
                      )
                    ),
                    const SizedBox(height: 10), 
                    if (img != null) Container(
                        child: Image.memory(img!)
                      ),
                    
                  ]),
                  Row(
                      children: <Widget>[
                      TextButton(
                        child: Text('Salvar'),
                        onPressed: _handleSaveButtonPressed,
                      ),
                      TextButton(
                        child: Text('Apagar'),
                        onPressed: _handleClearButtonPressed,
                      )
                    ], 
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly
                    )
      ]);
    }
  }
}

 