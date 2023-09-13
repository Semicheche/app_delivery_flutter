import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PictureEntrega extends StatefulWidget {
  final data;

  const PictureEntrega({
    super.key,
    required this.data,
  });

  // final CameraDescription camera;
  @override
  State<PictureEntrega> createState() => _PictureEntregaState();
}

class _PictureEntregaState extends State<PictureEntrega> {
   List imagens = [];
   File? imagem = null;

  _takePicture() async{
    final ImagePicker _imgPicker = ImagePicker();
    XFile imageFile = await _imgPicker.pickImage(
      source: ImageSource.camera, 
      maxWidth: 600,
      imageQuality: 50
    ) as XFile;
    
    setState(() {
      imagens.add(File(imageFile.path));
      widget.data.imagens = imagens;
    });
  }

  @override
  Widget build(BuildContext context) {
    var imagens= widget.data.imagens ?? [];
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (imagens.length >= 1) Container(
            height: 460,
            child: CarouselSlider.builder(
          itemCount: imagens.length,
          options: CarouselOptions(
            autoPlay: false,
            aspectRatio: 2.0,
            // viewportFraction: 1,
          ),
          itemBuilder: (context, index, realIdx) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              child: Center(
                  child: (imagens[index] is File) ? Image.file(imagens[index], fit: BoxFit.cover, width: 1000) : Image.network(imagens[index], fit: BoxFit.cover, width: 1000)),
            );
          },
          ),
        ),
        
        if (imagens.length <= 0) Container(
          width: 500,
          height: 460,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey
            )
          ),
          alignment: Alignment.center,
          child: imagem != null 
              ? Image.file(imagem!,
                      width: double.infinity,
                      fit: BoxFit.cover,) :
                      Text('Sem Imagem!'),
        ),
        Text('${imagens.length} IMAGENS ANEXADAS A ENTREGA', 
          style: TextStyle(
            fontSize: 15,
            fontFamily: 'Verdana',
          ),
        ),   
        SizedBox(height: 20,),
        if(!widget.data?.isValid()) TextButton.icon(
              onPressed: _takePicture, 
              icon: Icon(Icons.camera_alt_rounded), 
              label: Text('Tirar Foto'),
            ),
      ],
    );
  }
}
