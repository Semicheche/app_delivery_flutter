import 'package:delivery_app/models/data_entrega.dart';
import 'package:flutter/material.dart';

class Entregas with ChangeNotifier {
  List<DataEntrega> _itemsEntregas = [];

  List<DataEntrega> get items {
    return [..._itemsEntregas];
  }

  int get itemCount {
    return _itemsEntregas.length;
  }

  DataEntrega itemByIndex(int index) {
    return _itemsEntregas[index];
  } 
}