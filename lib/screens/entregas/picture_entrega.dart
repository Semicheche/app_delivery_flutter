import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PictureEntrega extends StatefulWidget {
  final data;
  final value;

  const PictureEntrega({
    super.key,
    required this.data,
    required this.value
  });

  // final CameraDescription camera;
  @override
  State<PictureEntrega> createState() => _PictureEntregaState();
}

class _PictureEntregaState extends State<PictureEntrega> {
   List<File> imagens = [];
   File? imagem = null;

  _takePicture() async{
    final ImagePicker _imgPicker = ImagePicker();
    XFile imageFile = await _imgPicker.pickImage(
      source: ImageSource.camera, 
      maxWidth: 600
    ) as XFile;
    
    setState(() {
      imagens.add(File(imageFile.path));
      widget.data.imagems = imagens;
    });
  }

  @override
  Widget build(BuildContext context) {
    int _current = 0;
    var imagensUlr = widget.value['imagemsURL'] != null ?  widget.value['imagemsURL'] : [];

    if (imagensUlr.length > 0){
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (imagensUlr.length >= 1) Container(
              height: 460,
              child: CarouselSlider.builder(
            itemCount: imagensUlr.length,
            options: CarouselOptions(
              autoPlay: false,
              aspectRatio: 2.0,
              // viewportFraction: 1,
            ),
            itemBuilder: (context, index, realIdx) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: Center(
                    child: Image.network(imagensUlr[index],
                        fit: BoxFit.cover, width: 1000)),
              );
            },
            ),
          )
        ]
      );
    }else{
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
                  child: Image.file(imagens[index],
                      fit: BoxFit.cover, width: 1000)),
            );
          },
          ),
        ),
        
        if (imagens.length == 0) Container(
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
        Text('${imagens.length} imagens ANEXADAS A ENTREGA', 
          style: TextStyle(
            fontSize: 15,
            fontFamily: 'Verdana',
          ),
        ),   
        SizedBox(height: 20,),
        TextButton.icon(
              onPressed: _takePicture, 
              icon: Icon(Icons.camera_alt_rounded), 
              label: Text('Tirar Foto'),
            ),
      ],
    );
  }
  }
}