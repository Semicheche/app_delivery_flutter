
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/models/data_entrega.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


FirebaseFirestore _firestore = FirebaseFirestore.instance;

class FirebaseServiceEntrega {
  var listUrls = [];
  final _storage = const FlutterSecureStorage();

  Future getCollection(String collection, String field, String condiction, int value) async {
     return await FirebaseFirestore.instance
      .collection("entregas_concluidas")
      .withConverter(
        fromFirestore: Entrega.fromFirestore, 
        toFirestore: (Entrega entrega, _) => entrega.toFirestore())
      .where("idEntrega", isEqualTo: value).get().then((value) {
        
        var result = value.docs.length > 0 ? value.docs[0].data() : null;
        if (result != null){
          result.id = value.docs[0].id;
        }
        return result;
      });
    
  }
  Future<String> updateEntrega(Entrega entrega) async {
    var res = (entrega.assinaturaUrl != null && entrega.imagens!.length > 0) ? 'Entrega Realizada com Sucesso': 'Tentativa de Entrega Salva!' ;
    
      try{
        if (entrega.observacao != null ){
          entrega.observations.add({
              'idEntregador': entrega.idEntregador.toString(),
              'criadoEm': entrega.alteradoEm?.toIso8601String(),
              'observacao': entrega.observacao,
              'geolocation':  {
                'latitude': entrega.location!.lat,
                'longitude': entrega.location!.lon,
              },
            });
        }
        
        await _firestore.collection('entregas_concluidas').doc(entrega.id).withConverter(fromFirestore: Entrega.fromFirestore, toFirestore: (Entrega entrega, _) => entrega.toFirestore()).update(entrega.toFirestore());
        
        return res;
      } catch (err){
        res = 'Error ${err}';
      }
  
    return res;
  }

  Future<String> setEntregaConcluida(String uidEntrega) async{

    await FirebaseFirestore.instance.collection('entregas').doc(uidEntrega).update({'status': true});
    
    return uidEntrega;
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