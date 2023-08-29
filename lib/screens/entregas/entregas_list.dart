import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/screens/entregas/stepper_entrga.dart';
import 'package:delivery_app/screens/laoding_page.dart';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

class EntregasList extends StatefulWidget {
  const EntregasList({super.key});

  @override
  State<EntregasList> createState() => _EntregasListState();
}

class _EntregasListState extends State<EntregasList> {
  var _items = [];

  Future<void> readjson() async {
    final String response = await rootBundle.loadString('assets/imparfm-default-rtdb-export.json');
    final data = await json.decode(response);
    setState(() {
      print(data);
      _items = data['entregas'];
    });
  }
 
  @override
  Widget build(BuildContext context) {
    CollectionReference teste = FirebaseFirestore.instance.collection("teste_firestore");

    // Future<List<Map>> result = readJsonFile('assets/imparfm-default-rtdb-export.json');
    readjson();
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          automaticallyImplyLeading: true,
          actions: [],
          title: Text("ENTREGAS", style: TextStyle(color: Colors.white),),
          centerTitle: true,
          elevation: 3,
        ),
      body: StreamBuilder<QuerySnapshot>(
        stream: teste.snapshots().map((event) => event),
        builder: (context, snapshot) {
          
          if (!snapshot.hasData) {
            return Center(
              child: LoadingPage(),
            );
          } else {
            return ListView(
              children: snapshot.data!.docs.map((doc) { 
                final Name obj = Name(name: doc.get("nome"), sobrenome: doc.get("sobrenome"));
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 0.5,
                    )
                  ),
                  child: ListTile(
                  title: Text('Nome: ${obj.name} ${obj.sobrenome}'),
                  subtitle: Text('ENTREGAS : Lorem  Ipsum Text about somthing.'),
                  onTap: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) => StepperEntrega(item: obj)),
                    );
                  },
                  leading: const Icon(Icons.check_box_outline_blank_outlined, color: Colors.amber,),
                  trailing: const Icon(Icons.pending_actions_sharp),
                  ),
                );
               }).toList(),
            );
          }
        },
      ),
    );
  }
}

class EntregasFirebase {
  List<Doctos> doctos;
  final Timestamp emissao;
  final Int64 entregador;
  final Int16 filialEntrega;
  final Int16 filialOrigem;
  final Int64 nrEntrega;

  EntregasFirebase(
    this.doctos,
    this.emissao, 
    this.entregador, 
    this.filialEntrega, 
    this.filialOrigem,
    this.nrEntrega);


}

class Doctos {
  final Int? codFilial;
  final Timestamp data;
  final Int64 nrDocto;
  final String? obs;
  final Parceiro parceiro;
  final List<Produto> produtos;

  Doctos(
    this.codFilial,
    this.data,
    this.nrDocto,
    this.obs,
    this.parceiro,
    this.produtos
  );
}

class Produto {
  final String codigo;
  final String descricao;
  final Int qtd;

  Produto(
    this.codigo,
    this.descricao,
    this.qtd
  );
}


class Parceiro {
    final String bairro;
    final String celular;
    final String cep;
    final String complemento;
    final String cpfCnpj;
    final String endereco;
    final String municipio;
    final String nome;
    final String numero;
    final String telefone;
    final String uf;

    Parceiro(
      this.bairro,
      this.celular, 
      this.cep, 
      this.complemento, 
      this.cpfCnpj, 
      this.endereco, 
      this.municipio, 
      this.nome, 
      this.numero, 
      this.telefone, 
      this.uf);
}

class Name {
  final String? name;
  final String? sobrenome;

  Name({
    this.name,
    this.sobrenome,
  });
}