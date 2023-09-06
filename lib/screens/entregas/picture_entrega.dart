import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PictureEntrega extends StatefulWidget {
  final data;

  const PictureEntrega({
    super.key,
    required this.data
  });

  // final CameraDescription camera;
  @override
  State<PictureEntrega> createState() => _PictureEntregaState();
}

class _PictureEntregaState extends State<PictureEntrega> {
   List<File> imagems = [];
   File? imagem = null;

  _takePicture() async{
    final ImagePicker _imgPicker = ImagePicker();
    XFile imageFile = await _imgPicker.pickImage(
      source: ImageSource.camera, 
      maxWidth: 600
    ) as XFile;
    
    setState(() {
      imagems.add(File(imageFile.path));
      widget.data.imagems = imagems;
    });
  }

  @override
  Widget build(BuildContext context) {
    int _current = 0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (imagems.length >= 1) Container(
            height: 460,
            child: CarouselSlider.builder(
          itemCount: imagems.length,
          options: CarouselOptions(
            autoPlay: false,
            aspectRatio: 2.0,
            // viewportFraction: 1,
          ),
          itemBuilder: (context, index, realIdx) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              child: Center(
                  child: Image.file(imagems[index],
                      fit: BoxFit.cover, width: 1000)),
            );
          },
          ),
        ),
        
        if (imagems.length == 0) Container(
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
        Text('${imagems.length} IMAGEMS ANEXADAS A ENTREGA', 
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