import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/screens/entregas/list_entrega.dart';
import 'package:delivery_app/screens/loading_page.dart';
import 'package:delivery_app/screens/montagens/montagens_list.dart';
import 'package:delivery_app/services/auth/auth_firebase_service.dart';
import 'package:delivery_app/services/auth/login_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool shouldPop = true;
  User? currentUser = FirebaseAuth.instance.currentUser;
  var funcionarioType;

  Future<void> getTipoFuncionario() async {
    await FirebaseFirestore.instance.collection("colaboradores")
    .where('userId', isEqualTo: currentUser?.uid)
    .get().then(
      (value) { 
      funcionarioType = value.docs[0].data() ?? null;
    }
    );
  

  }
  
  
  @override
  Widget build(BuildContext context) {
    // print(currentUser);
    funcionarioType = getTipoFuncionario();
    return FutureBuilder(
      future: getTipoFuncionario(), 
      builder: (context, snapshot){
      if (snapshot.connectionState == ConnectionState.waiting){
        return LoadingPage();
      }else{
        return  WillPopScope(
                  onWillPop: () => _onBackButtonPressed(context),
                  child: Scaffold(
                    appBar: AppBar(
                        backgroundColor: Theme.of(context).primaryColor,
                        automaticallyImplyLeading: true,
                        actions: [],
                        centerTitle: true,
                        elevation: 3,
                      ),
                    body: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 150),
                        if (funcionarioType['tipo'] == 0 || funcionarioType['tipo'] == 2) Center(
                          child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => ListEntrega()),
                                );
                              },
                              label: const Text('ENTREGAS'),
                              icon: Icon(Icons.local_shipping_rounded,size: 100.0),
                              style: ElevatedButton.styleFrom(
                                      // backgroundColor: Colors.grey.shade100,
                                      minimumSize: Size(150, 140)
                                    ),
                            ),
                          ),
                        const SizedBox(height: 35),
                        if (funcionarioType['tipo'] >= 1)Center(
                          child: ElevatedButton.icon(
                              onPressed:  () {
                                Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => const MontagemsList()),
                                );
                              }, 
                              label: const Text('MONTAGENS'),
                              icon: Icon(Icons.weekend_rounded, size: 100.0),
                              style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white70, //elevated btton background color
                                      minimumSize: Size(150, 140)
                                    ),
                          ),
                          ),
                        // TextButton(onPressed: () {
                        //   LoginAuthService().logout();
                        // }, child: Text('Logout'))
                      ],
                    ),
                    ),
                  ),
                );
          }
      });
  }

  Future<bool> _onBackButtonPressed(BuildContext context) async {
  bool exitApp = await showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text('ATENÇÃO!'),
          content: const Text("Tem certeza que quer Sair?"),
          actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                  },
                child: Text("NÃO")
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  AuthFirebaseService().logout();
                  },
                child: Text("SIM")
              ),
          ],
        );
      });

      return exitApp ?? false;
  }
}