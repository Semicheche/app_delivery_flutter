import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LocationEntrega {
  final double? lat;
  final double? lon;

  LocationEntrega(this.lat, this.lon);
}

class DataEntrega {
  late String id;
  late String? name;
  late String? cpfCnpj;
  late LocationEntrega? location;
  late Uint8List? assinatura;
  late String? assinaturaUrl;
  late List? imagems;
  late List imagemsURL;
  late int? idEntrega;
  late String? observacao;
  late DateTime? criadoEm;
  late DateTime? alteradoEm;
  late int idEntregador;

  DataEntrega(
     this.id, 
     this.name, 
     this.cpfCnpj, 
     this.location, 
     this.assinatura, 
     this.imagems,
     this.imagemsURL,
     this.idEntrega,
     this.observacao,
     this.criadoEm,
     this.alteradoEm,
     this.idEntregador);

}