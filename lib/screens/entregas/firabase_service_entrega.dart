
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/models/data_entrega.dart';
import 'package:delivery_app/services/firebase_storage/add_storage_file.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class FirebaseServiceEntrega {
  var listUrls = [];

  Future getCollection(String collection, String field, String condiction, int value) async {
     return await FirebaseFirestore.instance
      .collection("entregas")
      .where("idEntrega", isEqualTo: value).get().then((value) {
        print(value.docs);
        var result = value.docs.length > 0 ? value.docs[0].data() : null;
        print('result');
        print(result);
         return result;
      });
    
      // print('object');
      // print(result);
      // return result;
    
  }

  Future<String>  saveEntrega(Entrega dataEntrega) async {
    var resp =  'ocrrreu um Erro';

    // if (dataEntrega.assinatura != null && dataEntrega.imagems!.length > 0){
      if (dataEntrega.observacao != ''){
        dataEntrega.observations.add({
          'idEntregador': dataEntrega.idEntregador.toString(),
          'criadoEm': dataEntrega.criadoEm?.toIso8601String(),
          'observacao': dataEntrega.observacao,
        });
      }

      try{
        var map = { 
          'name': dataEntrega.name, 
          'cpfCnpj': dataEntrega.cpfCnpj, 
          'location': {
            'latitude': dataEntrega.location!.lat,
            'longitude': dataEntrega.location!.lon,
          },
          'assinaturaURL': dataEntrega.assinaturaUrl, 
          'imagemsURL': dataEntrega.imagemsURL,
          'idEntrega': dataEntrega.idEntrega,
          'observacao': dataEntrega.observacao,
          'criadoEm': dataEntrega.criadoEm?.toIso8601String(),
          'alteradoEm': dataEntrega.alteradoEm?.toIso8601String(),
          'idEntregador': dataEntrega.idEntregador.toString(),
          'observations': dataEntrega.observations
        };

        _firestore.collection('entregas').add(map);
        
        resp = 'Entrega gravada com Sucesso';
      }catch(err){
        print('Error ao persister entregas: $err');
      }

    // }else {
    //    try{
    //     _firestore.collection('entregas').add({ 
    //       'name': '', 
    //       'cpfCnpj': '', 
    //       'location': {
    //         'latitude': dataEntrega.location!.lat,
    //         'longitude': dataEntrega.location!.lon,
    //       },
    //       'assinaturaURL':'', 
    //       'imagemsURL': dataEntrega.imagemsURL,
    //       'idEntrega': dataEntrega.idEntrega,
    //       'observacao': dataEntrega.observacao,
    //       'criadoEm': dataEntrega.criadoEm?.toIso8601String(),
    //       'alteradoEm': dataEntrega.alteradoEm?.toIso8601String(),
    //       'idEntregador': dataEntrega.idEntregador.toString(),
    //     });
    //   }catch(err){
    //     print('Error ao persister entregas OBSERVACOA: $err');
    //   }
    // }

    return resp;
  }

}