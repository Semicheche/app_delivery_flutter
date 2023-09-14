import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LocationEntrega {
  final double? lat;
  final double? lon;

  LocationEntrega(this.lat, this.lon);
}

class Entrega {
  late String id;
  late String? name;
  late String? cpfCnpj;
  late LocationEntrega? location;
  late Uint8List? assinatura;
  late String? assinaturaUrl;
  late List? imagens;
  // late List imagemsUrl;
  late int? idEntrega;
  late String? observacao;
  late DateTime? criadoEm;
  late DateTime? alteradoEm;
  late int idEntregador;
  late List observations;

  Entrega(
     this.id, 
     this.name, 
     this.cpfCnpj, 
     this.location,
     this.assinatura,
     this.assinaturaUrl, 
     this.imagens,
    //  this.imagemsUrl,
     this.idEntrega,
     this.observacao,
     this.criadoEm,
     this.alteradoEm,
     this.idEntregador,
     this.observations);
  
   Map<String, dynamic> toFirestore() {
    return { 
        'name': name, 
        'cpfCnpj': cpfCnpj, 
        'location': { 'latitude': location!.lat, 'longitude': location!.lon, },
        'assinaturaUrl': assinaturaUrl != null ? assinaturaUrl : null, 
        'imagens': imagens,
        'idEntrega': idEntrega,
        'observacao': observacao,
        'criadoEm': criadoEm?.toIso8601String(),
        'alteradoEm': alteradoEm?.toIso8601String(),
        'idEntregador': idEntregador.toString(),
        'observations': observations
      };
   }

  factory Entrega.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options
  ) {
    final data = snapshot.data();

    return Entrega(
      '', 
      data?['name'], 
      data?['cpfCnpj'], 
      LocationEntrega(data?['location']['latitude'], data?['location']['longitude']),
      data?['assinatura'], 
      data?['assinaturaUrl'],
      data?['imagens'], 
      data?['idEntrega'], 
      data?['observacao'], 
      DateTime.parse(data?['criadoEm']), 
      DateTime.parse(data?['alteradoEm']), 
      int.parse(data?['idEntregador']),
      data?['observations']
      );
  }

   Map toJson() => {
        if (name != null) 'name': name, 
        if (cpfCnpj != null) 'cpfCnpj': cpfCnpj, 
        if (location != null) 'location': { 'latitude': location!.lat, 'longitude': location!.lon, },
        if (assinaturaUrl != null) 'assinaturaUrl': assinaturaUrl, 
        if (imagens != null) 'imagemsURL': imagens,
        if (idEntrega != null) 'idEntrega': idEntrega,
        if (observacao != null) 'observacao': observacao,
        if (criadoEm != null) 'criadoEm': criadoEm?.toIso8601String(),
        if (alteradoEm != null) 'alteradoEm': alteradoEm?.toIso8601String(),
        if (idEntregador != null) 'idEntregador': idEntregador.toString(),
        if (observations != null) 'observations': observations
      };

  bool isValid(){
    if( name != null && cpfCnpj != null && assinatura != null && imagens!.length > 0 ){
      return true;
    }else{
      return false;
    }
  }
}