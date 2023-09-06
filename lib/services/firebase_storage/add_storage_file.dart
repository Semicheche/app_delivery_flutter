import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;


class StorageFile {
  int counter = 1;
  List imagemsURL = [];
  
  get imagesUrl => [];

  Future<String> uploadImageMemoryToStorage(String name, Uint8List file) async {

    Reference ref  = _storage.ref().child(name);
    UploadTask uploadImg = ref.putData(file);
    TaskSnapshot snapshot = await uploadImg;

    String imageUrl = await snapshot.ref.getDownloadURL();

    return imageUrl;
  }

  Future<List> uploadImageFileToStorage(String folder, List? images) async {
    var imageUrls = await Future.wait(images!.map((image) => uploadFileImage(folder, image)));
   
    return imageUrls;
  }

  Future<String> uploadFileImage(String folder, File _image) async {
    String imagesUrls;
    Reference ref  = _storage.ref().child('$folder/IMG-00${counter++}');
    UploadTask uploadImg = ref.putFile(_image);

    imagesUrls = (await (await uploadImg).ref.getDownloadURL());

    return imagesUrls;
  }

}
