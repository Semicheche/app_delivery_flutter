
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
      .collection("entregas_concluidas")
      .withConverter(
        fromFirestore: Entrega.fromFirestore, 
        toFirestore: (Entrega entrega, _) => entrega.toFirestore())
      .where("idEntrega", isEqualTo: value).get().then((value) {
        var result = value.docs.length > 0 ? value.docs[0].data() : null;

        print('AQUI GET COLLECTION');
        print(result?.assinaturaUrl);
        return result;
      });
    
  }

  Future<String>  saveEntrega(Entrega dataEntrega) async {
    var resp =  'ocrrreu um Erro';

    // if (dataEntrega.assinatura != null && dataEntrega.imagems!.length > 0){
      if (dataEntrega.observacao != null){
        dataEntrega.observations.add({
          'idEntregador': dataEntrega.idEntregador.toString(),
          'criadoEm': dataEntrega.criadoEm?.toIso8601String(),
          'observacao': dataEntrega.observacao,
          'geolocation':  {
            'latitude': dataEntrega.location!.lat,
            'longitude': dataEntrega.location!.lon,
          },
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
          'assinaturaUrl': dataEntrega.assinaturaUrl, 
          'imagens': dataEntrega.imagens,
          'idEntrega': dataEntrega.idEntrega,
          'observacao': dataEntrega.observacao,
          'criadoEm': dataEntrega.criadoEm?.toIso8601String(),
          'alteradoEm': dataEntrega.alteradoEm?.toIso8601String(),
          'idEntregador': dataEntrega.idEntregador.toString(),
          'observations': dataEntrega.observations
        };

        _firestore.collection('entregas_concluidas').add(map);
        
        resp = 'Entrega gravada com Sucesso';
      }catch(err){
        print('Error ao persister entregas: $err');
      }

    return resp;
  }

}