import 'package:delivery_app/models/data_entrega.dart';
import 'package:flutter/material.dart';

class Entregas with ChangeNotifier {
  List<Entrega> _itemsEntregas = [];

  List<Entrega> get items {
    return [..._itemsEntregas];
  }

  int get itemCount {
    return _itemsEntregas.length;
  }

  Entrega itemByIndex(int index) {
    return _itemsEntregas[index];
  } 
}