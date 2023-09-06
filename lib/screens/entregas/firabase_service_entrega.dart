
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/models/data_entrega.dart';
import 'package:delivery_app/services/firebase_storage/add_storage_file.dart';
import 'package:firebase_storage/firebase_storage.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class FirebaseServiceEntrega {
  var listUrls = [];


  Future<String>  saveEntrega(DataEntrega dataEntrega) async {
    var resp =  'ocrrreu um Erro';
    var ass = '';
    print('SAVE');
    if (dataEntrega.assinatura != null && dataEntrega.imagems!.length > 0){


      try{
        print('==========================');
        print('VAI SALVAR NO FIRESTORE');
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
        };
        print('MAPS');
        print(map);

        _firestore.collection('entregas').add(map);
        
        resp = 'Entrega gravada com Sucesso';
      }catch(err){
        print('Error ao persister entregas: $err');
      }

    }else {
       try{
        _firestore.collection('entregas').add({ 
          'name': '', 
          'cpfCnpj': '', 
          'location': {
            'latitude': dataEntrega.location!.lat,
            'longitude': dataEntrega.location!.lon,
          },
          'assinaturaURL':'', 
          'imagemsURL': dataEntrega.imagemsURL,
          'idEntrega': dataEntrega.idEntrega,
          'observacao': dataEntrega.observacao,
          'criadoEm': dataEntrega.criadoEm?.toIso8601String(),
          'alteradoEm': dataEntrega.alteradoEm?.toIso8601String(),
          'idEntregador': dataEntrega.idEntregador.toString(),
        });
      }catch(err){
        print('Error ao persister entregas OBSERVACOA: $err');
      }
    }

    return resp;
  }

}