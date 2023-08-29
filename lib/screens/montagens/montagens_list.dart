import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/screens/laoding_page.dart';

import 'package:flutter/material.dart';

class MontagemsList extends StatelessWidget {
  const MontagemsList({super.key});

  


  @override
  Widget build(BuildContext context) {
    CollectionReference teste = FirebaseFirestore.instance.collection("teste_firestore");
    
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          automaticallyImplyLeading: true,
          actions: [],
          title: Text("MONTAGENS", style: TextStyle(color: Colors.white),),
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
                final nome = doc.get("nome");
                final sobrenome = doc.get("sobrenome");
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 0.5,
                    )
                  ),
                  child: ListTile(
                  title: Text('Nome: $nome $sobrenome'),
                  subtitle: Text('MONTAGENS:  Lorem  Ipsum Text about somthing.'),
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