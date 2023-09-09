import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:delivery_app/models/data_entrega.dart';
import 'package:delivery_app/screens/entregas/description_entrega.dart';
import 'package:delivery_app/screens/entregas/firabase_service_entrega.dart';
import 'package:delivery_app/screens/entregas/picture_entrega.dart';
import 'package:delivery_app/screens/entregas/signature_entrega.dart';
import 'package:delivery_app/screens/laoding_page.dart';
import 'package:delivery_app/screens/loading_position_page.dart';
import 'package:delivery_app/screens/loading_save_page.dart';
import 'package:delivery_app/screens/menu_page.dart';
import 'package:delivery_app/services/firebase_storage/add_storage_file.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';


/// Flutter code sample for [Stepper].

class StepperEntrega extends StatefulWidget {
  var item;
  // var entrega;

  StepperEntrega({
    Key? key, 
    required this.item,
    // this.entrega
    }) : super(key: key);

  @override
  State<StepperEntrega> createState() => _StepperEntregasState();
}



class _StepperEntregasState extends State<StepperEntrega> {
  int _index = 0;
  bool isChecked = false;


  
  late Entrega _dataform;
  var data;
  LocationData? _locationData = null;
  double _padding = 190;

  Future<void> _getCurrentLocation() async {
    
    final PermissionStatus _permissionGranted;
    final _serviceEnable = await Location().serviceEnabled();
  
    _permissionGranted = await Location().requestPermission();
    if (!_serviceEnable) {
      return;
    }
    if (_permissionGranted != PermissionStatus.denied){
      final locationData = await Location().getLocation();
      
      _locationData = locationData;
    }
  }

  LocationEntrega getLocation() {
    if (_locationData == null){
      _getCurrentLocation();
    }

    return LocationEntrega(_locationData!.latitude, _locationData!.longitude);
  }
  

  void _onSubmitEntrega() async {
    if (isChecked && _dataform.observacao == ''){
      showTopSnackBar(
        Overlay.of(context), 
        CustomSnackBar.error(message: 'insira uma observação!'),
      );
      return;
    }
    if (!isChecked){
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => const LoadingPositionPage()),
      );
    }
    await _getCurrentLocation();
    final LocationEntrega? localizacao = getLocation();

    Entrega _dataSubmit = Entrega(
      '',
      isChecked ? null : _dataform.name, 
      isChecked ? null : _dataform.cpfCnpj,
      localizacao,
      isChecked ? null : _dataform.assinatura, 
      isChecked ? [] : _dataform.imagems, 
      [],
      _dataform.idEntrega,
      _dataform.observacao,
      DateTime.now(),
      DateTime.now(),
      _dataform.idEntregador,
      []
      );
    
    if (_dataSubmit != null) {
      List listUrls = [];
      var assinaturaUrl;
      var folder = 'entregas/${_dataSubmit?.idEntrega}';
      
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => LoadingSavePage()),
      );

      if (_dataSubmit.assinatura != null){
        assinaturaUrl = await StorageFile().uploadImageMemoryToStorage('$folder/assinatura', _dataSubmit.assinatura as Uint8List);
      }
      listUrls = await StorageFile().uploadImageFileToStorage(folder, _dataSubmit.imagems);

      _dataSubmit.assinaturaUrl = assinaturaUrl;
      _dataSubmit.imagemsURL = listUrls;
      
      FirebaseServiceEntrega().saveEntrega(_dataSubmit);

      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);

      showTopSnackBar(
        Overlay.of(context), 
        CustomSnackBar.success(message: 'Entrega Efetuada com Sucesso!'),
      );
    }

  }



  @override
  void initState(){

  }

  Future<Map<String, dynamic>> firebaseCallAsync(int nrEntrega) async{
    print(nrEntrega);
    data = await FirebaseServiceEntrega().getCollection('entregas', 'idEntrega', '==', nrEntrega);
    print(data);
    return data;
  }

  @override
  Widget build(BuildContext context) {
     var _item = widget.item;
    
      Widget deafaultTemplate(AsyncSnapshot snapshot){
        return Scaffold(
            appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          automaticallyImplyLeading: true,
          actions: [],
          title: Text(" Entrega Nº ${_item['nrEntrega']}", style: TextStyle(color: Colors.white),),
          centerTitle: true,
          elevation: 3,
        ), body: Center(
                  child: Text('AQUI ${snapshot.data} '),
                    )
          );
      }
    

     return FutureBuilder(
      future: firebaseCallAsync(_item['nrEntrega']), 
      builder: (context, AsyncSnapshot snapshot) {
        print(snapshot.connectionState);
        if (snapshot.connectionState == ConnectionState.waiting){
          return LoadingPage();
        }else if (snapshot.hasError){
          return deafaultTemplate(snapshot);
        }else{

          return  deafaultTemplate(snapshot);
        }
      });
  }



  // @override
  // Widget build(BuildContext context) {
  //   var _item = widget.item;
  //   var _entrega = null;
  //   var textSize =  TextStyle(fontSize: 17);
  //   var itemsObs = [];
  //   var _dataform = Entrega( '', null, null, null, null, null, [], null, null, null, null, 0,[]);
 

  //   return Scaffold(
  //     appBar: AppBar(
  //         backgroundColor: Theme.of(context).primaryColor,
  //         automaticallyImplyLeading: true,
  //         actions: [],
  //         title: Text(" Entrega Nº ${_item['nrEntrega']}", style: TextStyle(color: Colors.white),),
  //         centerTitle: true,
  //         elevation: 3,
  //       ),
  //     body:
  //      Container(
  //         child: Column(
  //           children: [
  //             Expanded(
  //               child: Stepper(
  //           type: StepperType.horizontal,
  //           currentStep: _index,
  //           onStepCancel: () {
  //             if (_index > 0) {
  //               setState(() {
  //                 if (isChecked) {
  //                   _index -= 3;
  //                   isChecked = false;
  //                 }else{
  //                   _index -= 1;
  //                 }
  //               });
  //             }
  //           },
  //           onStepContinue: () {
  //             if (_index <= 2) {
  //               setState(() {
  //                 _index += 1;
  //               });
  //             }
  //           },
  //           onStepTapped: (int index) {
  //             setState(() {
  //               _index = index;
  //             });
  //           },
  //           controlsBuilder: (BuildContext context, ControlsDetails details) {
  //             return Container(
  //               margin: EdgeInsets.only(top: 50),
  //               child: Row(
  //                 children: [
  //                   if ( _index < 3)
  //                     Expanded(
  //                       child: ElevatedButton(
  //                         onPressed: details.onStepContinue,
  //                         child: Text('Proximo' ),
  //                         )
  //                       ),
  //                     SizedBox(width: 12,),
  //                   if (_index != 0 && (_index < 3 ))
  //                     Expanded(
  //                       child: ElevatedButton(
  //                         onPressed: details.onStepCancel,
  //                         child: Text('Voltar'),
  //                         )
  //                     ),
  //                 ],
  //               ),
  //             );
  //           },
  //           steps: <Step>[
  //             Step(
  //               isActive: _index >= 0,
  //               title: const Text('Descrição'),
  //               content: Column(
  //                 children: [
  //                         const Text('INFORMAÇÕES DO CLIENTE', 
  //                         style: TextStyle(
  //                                 fontSize: 20,
  //                                 fontWeight: FontWeight.bold,
  //                                 ),
  //                         ),
  //                       Row( 
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [                               
  //                           SizedBox(height: 20,),
  //                           Text('Cliente não se encontra', style: textSize,),
  //                           Checkbox(
  //                               value: isChecked,
  //                               onChanged: (bool? value ) {
  //                                 setState(() {
  //                                   isChecked = value!;
  //                                   _index = 3;
  //                                 });
  //                               }),
  //                           ]
  //                         ),
  //                       descriptionEntrega(data: _data,item: _item, value: {}),
  //                 ]
  //               ),
  //               state: _index > 0 ? StepState.complete : StepState.disabled
  //             ),
  //             Step(
  //               isActive: _index >= 1,
  //               title: Text('Assinatura'),
  //               content: SignatureEntrega(data: _dataform, value:  {} ),
  //               state: _index > 1 ? StepState.complete : StepState.disabled
  //             ),
  //             Step(
  //               isActive: _index >= 2,
  //               title: const Text('Foto'),
  //               content: Container(
  //                 alignment: Alignment.centerLeft,
  //                 child:PictureEntrega(data: _dataform,  value:  {}),
  //               ),
  //               state: _index > 2 ? StepState.complete : StepState.disabled
  //             ),
  //             Step(
  //               isActive: _index >= 3,
  //               title: const Text('Enviar'),
  //               content: Container(
  //                 alignment: Alignment.bottomCenter,
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   crossAxisAlignment: CrossAxisAlignment.stretch,
  //                   children: [
  //                     Padding(
  //                       padding: EdgeInsets.symmetric(
  //                         vertical: _padding,
  //                         horizontal: 0
  //                       ),
  //                       child: Column(
  //                         children: [ 
  //                           if (!isChecked) Container(
  //                             child: Column(
  //                               children: [
  //                               Text('CHECKLIST FINAL', style: TextStyle(
  //                                           fontSize: 20,
  //                                           fontWeight: FontWeight.bold,
  //                                       ),),
  //                               Row(
  //                                 children: [
  //                                     _data != null ? Icon(Icons.check_box, color: Colors.green,) : Icon(Icons.check_box_outline_blank, color: Colors.red,),
  //                                     Text('Nome Cliente' , style: textSize,) 
  //                                 ]
  //                               ),
  //                               SizedBox(height: 10,),
  //                               Row(
  //                                 children: [
  //                                     _dataform.cpfCnpj != null ? Icon(Icons.check_box, color: Colors.green,) : Icon(Icons.check_box_outline_blank, color: Colors.red,),
  //                                     Text('CPF Cliente' , style: textSize,)
  //                               ]),
  //                               SizedBox(height: 10,),
  //                               Row(
  //                                 children: [
  //                                     _dataform.assinatura != null ? Icon(Icons.check_box, color: Colors.green,) : Icon(Icons.check_box_outline_blank, color: Colors.red,),
  //                                     Text('Assinatura Cliente' , style: textSize,)
  //                               ]),
  //                               SizedBox(height: 10,),
  //                               Row(
  //                                 children: [
  //                                     _dataform.imagems != null  ? Icon(Icons.check_box, color: Colors.green,) : Icon(Icons.check_box_outline_blank, color: Colors.red,),
  //                                     Text('${_dataform.imagems?.length} Fotos dos produtos Entregues.' , style: textSize,)
  //                               ]),

  //                               SizedBox(height: 10),
                                
  //                               ]
  //                             )
  //                           ),
                            
  //                           if (isChecked) Container(
  //                             child: Column(children: [
  //                                const Text('INSIRA UMA OBSERVAÇÃO',
  //                                 style: TextStyle(
  //                                           fontSize: 20,
  //                                           fontWeight: FontWeight.bold,
  //                                       ), ),
  //                               SizedBox(height: 20,),
  //                                TextFormField(
  //                                 key: ValueKey('OBS:'),
  //                                 maxLines: 4,
  //                                 initialValue: _dataform.observacao,
  //                                 onChanged: (obs) => _dataform.observacao = obs,
  //                                 validator: (_obs) {
  //                                   final obs = _obs ?? '';
  //                                   if (obs.trim() != ''){
  //                                     return 'OBS e obrigatorio!';
  //                                   }
  //                                 },
  //                                 decoration: const InputDecoration(
  //                                   labelText: 'Observação:',
  //                                   border: OutlineInputBorder(),    
  //                                 ),
  //                               ),
                               
  //                             ]),
                      
  //                           ),
  //                           // if (false) Column(
  //                           //   children: itemsObs
  //                           // ),
                            
  //                           ]
  //                       )
  //                     ),
  //                     if (isChecked) Padding(
  //                           padding: EdgeInsets.all(5),
  //                           child: Container( 
  //                             child : ElevatedButton.icon(
  //                                 onPressed: _onSubmitEntrega,
  //                                 icon: Icon(Icons.check), 
  //                                 label: Text('Conlcuir Entrega')
  //                               ),
  //                             )
  //                       ),
  //                   ]),
  //               ),
  //               state: _index > 3 ? StepState.complete : StepState.disabled
  //             ),
  //           ],
  //         )
  //             )
  //           ])
  //       )
  //   );
  // }
}