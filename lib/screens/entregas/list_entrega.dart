import 'dart:ffi';
import 'package:badges/badges.dart' as badges;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/models/data_entrega.dart';
import 'package:delivery_app/screens/entregas/stepper_entrega.dart';
import 'package:delivery_app/screens/laoding_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/services.dart';

class ListEntrega extends StatefulWidget {
  const ListEntrega({super.key});

  @override
  State<ListEntrega> createState() => _ListEntregaState();
}

class _ListEntregaState extends State<ListEntrega> {
  var _entregas = {};
  var entregasRealizada = {};

  Future<void> readjson() async {
    final String response = await rootBundle.loadString('assets/imparfm-default-rtdb-export.json');
    final data = await json.decode(response);
    final entregas = {};
    var entregador;
    User? currentUser = FirebaseAuth.instance.currentUser;
  
    await FirebaseFirestore.instance.collection("entregas").orderBy("criadoEm").get().then((value){
      value.docs.forEach((element) {
        var _entregasFeitas = element.data();
        
        print(_entregasFeitas);
        
      }); 
    });


    await FirebaseFirestore.instance.collection("entregadores")
    .where('userId', isEqualTo: currentUser?.uid)
    .get().then(
      (value) async { 
        entregador = value.docs != null ? value.docs[0].data() : null;
        
        data['entregas'].forEach((k, v) async {
          if (v["entregador"].toString() == entregador['idEntregador']) {
            entregas[k] = v;     
          }

        });
        setState(() {
          _entregas = entregas;
        });
      });    
  }

  Widget getIconList(int nrEntrega) {
    if (entregasRealizada[nrEntrega] != null){
      return Icon(Icons.check_box_sharp, color: Colors.green,);
    }else{
      return Icon(Icons.check_box_outline_blank_outlined, color: Colors.amber,);
    }
  }

  Widget getIconListStatus(int nrEntrega) {
    var count = 0;
    bool concluido = false;
    if (entregasRealizada[nrEntrega] != null){
      
      count = entregasRealizada[nrEntrega].length;
      if (count > 0){
        entregasRealizada[nrEntrega].forEach((items){
          if (items['cpfCnpj'] != null && items['assinaturaURL'] != ''){
            concluido = true;
        }
        });
      }
    }
   
    return IconButton(
      icon: concluido 
      ? Icon(Icons.checklist_rtl, color: Colors.green.shade500) 
      : Icon(Icons.pending_actions_sharp),
      onPressed: () {},
      );
  }
 
  @override
  Widget build(BuildContext context) {
    CollectionReference teste = FirebaseFirestore.instance.collection("teste_firestore");

    if (_entregas.isEmpty){
      readjson();
    }

    List<Widget> _items = [];
    var entrega;

    _entregas.forEach((key, value) {
      _items.add(Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 117, 117, 117),
                      width: 0.3,
                    )
                  ),
                  child: ListTile(
                  title: Column(
                    children: [
                        Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Entrega Nº:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                          Text('${value['nrEntrega']}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
                        ],
                        ),
                        Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Quantidade de Produtos:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            Text('${value["doctos"][0]["produtos"].length}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
                          ],
                        )
                      ],
                    ),
                  subtitle: Text('\n Obs: ${value["doctos"][0]["obs"]}'),
                  onTap: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) => StepperEntrega(item: value),
                    ));
                  },
                  //leading: //getIconListStatus(value['nrEntrega']) ///getIconList(value['nrEntrega']),
                  trailing: getIconListStatus(value['nrEntrega'])
                  // const Icon(Icons.pending_actions_sharp),
                  ),
                ),
       );
       
    });

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
                  children: _items,
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