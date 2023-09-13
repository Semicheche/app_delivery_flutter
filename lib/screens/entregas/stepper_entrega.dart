import 'dart:typed_data';
import 'package:delivery_app/screens/loading_page.dart';
import 'package:delivery_app/screens/saving_page.dart';
import 'package:delivery_app/widgets/messages.dart';
import 'package:intl/intl.dart';

import 'package:delivery_app/models/data_entrega.dart';
import 'package:delivery_app/screens/entregas/description_entrega.dart';
import 'package:delivery_app/screens/entregas/firabase_service_entrega.dart';
import 'package:delivery_app/screens/entregas/picture_entrega.dart';
import 'package:delivery_app/screens/entregas/signature_entrega.dart';
import 'package:delivery_app/services/firebase_storage/add_storage_file.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';


class StepperEntrega extends StatefulWidget {
  var item;
  var entrega;

  StepperEntrega({
    Key? key, 
    required this.item,
    required this.entrega
    }) : super(key: key);

  @override
  State<StepperEntrega> createState() => _StepperEntregasState();
}



class _StepperEntregasState extends State<StepperEntrega> {
  int _index = 0;
  bool isChecked = false;
  
  var _data;
  var data;
  LocationData? _locationData = null;
  double _padding = 0;

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
    _data = widget.entrega;
    if (!isChecked && !_data.isValid()){
      var msg = ' ${ _data.name == null ? ", Nome" : ""} ${_data.cpfCnpj == null ? ", CPF" : ""} ${_data.assinatura == null ? ", Assinatura" : ""} ${_data.imagens.length <= 0 ? ", Fotos" : ""} ';

      SnackMsg().error(context, "Complete as Informações: $msg");
      return;
    }

    if (isChecked && _data.observacao == ''){
      SnackMsg().error(context, 'insira uma observação!');
      return;
    }
    if (!isChecked){
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => SavingPage(msg: 'Salvando', img: _data.imagens.length > 0, done: _data.assinatura != null,)),
      );

    }else{
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => SavingPage(msg: 'Salvando', img: _data.imagens.length > 0, done: _data.assinatura != null,)),
      );
    }
    if (_data.id != '') {
      
      List listUrls = [];
      var assinaturaUrl;
      var folder = 'entregas_concluidas/${_data?.idEntrega}';
      
      
      await _getCurrentLocation();
      final LocationEntrega localizacao = getLocation();

      _data.location = localizacao;
      _data.alteradoEm = DateTime.now();

     
        
      if (_data.assinatura != null){
        assinaturaUrl = await StorageFile().uploadImageMemoryToStorage('$folder/assinatura', _data.assinatura as Uint8List);
         _data.assinaturaUrl = assinaturaUrl;
      }

      if (_data.imagens != null){
        listUrls = await StorageFile().uploadImageFileToStorage(folder, _data.imagens);
         _data.imagens = listUrls;
      }
      
      var res = await FirebaseServiceEntrega().updateEntrega(_data);
      Navigator.pop(context);
      Navigator.pop(context);

      if (res.contains('Error')){
         SnackMsg().error(context, res);
      }else{
        SnackMsg().success(context, res);
      }
    
    }else {
     
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SavingPage(msg: 'Salvando', img: (_data.imagens != null), done: true,)),
        );
      await _getCurrentLocation();
      final LocationEntrega localizacao = getLocation();

      _data.location = localizacao;
      _data.criadoEm = _data.criadoEm ?? DateTime.now();
      _data.alteradoEm = DateTime.now();

      
      if (_data != null) {
        List listUrls = [];
        var assinaturaUrl;
        var folder = 'entregas_concluidas/${_data?.idEntrega}';
        
        

        if (_data.assinatura != null){
          assinaturaUrl = await StorageFile().uploadImageMemoryToStorage('$folder/assinatura', _data.assinatura as Uint8List);
        }

        if (_data.imagens != null){
          listUrls = await StorageFile().uploadImageFileToStorage(folder, _data.imagens);
        }

        _data.assinaturaUrl = assinaturaUrl;
        _data.imagens = listUrls;
        
        FirebaseServiceEntrega().saveEntrega(_data);
        if (_data.imagens != null) {
          Navigator.pop(context);
        }
        Navigator.pop(context);
        Navigator.pop(context);

        var message = (_data.observacao != '' || _data.observacao != null) ?  'Salva tentativa de Entrega!' : 'Entrega Efetuada com Sucesso!';

        SnackMsg().success(context, message);
      }
    }

  }

  List<Widget> listObservations( BuildContext context){
    var fontSize = MediaQuery.of(context).size.width*0.045;
    List<Widget> list = [];
    widget.entrega.observations.forEach((obs){
        list.add( Container(
              decoration: BoxDecoration(
                color:  Colors.amber.shade50,
                border: Border.all(
                  color: Colors.black45,
                  width: 0.8)
              ),
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if(MediaQuery.of(context).size.width >= 350) Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [ 
                    Text('Observação', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
                    Text('${DateFormat('dd-MM-yyyy – kk:mm').format(DateTime.parse(obs["criadoEm"]))}', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
                   ]),
                  if(MediaQuery.of(context).size.width <= 350) Text('Observação', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
                  if(MediaQuery.of(context).size.width <= 350) Text('${DateFormat('dd-MM-yyyy – kk:mm').format(DateTime.parse(obs["criadoEm"]))}', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
                  Text('${obs["observacao"]}', style: TextStyle(fontSize: fontSize)),
                  
                ],
              ),
            ),
           
        );
      });
    return list;
  }


  @override
  Widget build(BuildContext context) {
     var textSize =  TextStyle(fontSize: MediaQuery.of(context).size.width*0.042);
     var fontSize = (MediaQuery.of(context).size.width*0.055);
     var _item = widget.item;
     var entrega = widget.entrega;
        
         Widget display(_data){
          _data.idEntregador = _item['entregador'];
          _data.idEntrega = _item['nrEntrega'];
          return Container(
          child: Column(
            children: [
              Expanded(
                child: Stepper(
            type:  MediaQuery.of(context).size.width < 350 ? StepperType.vertical : StepperType.horizontal,
            currentStep: _index,
            onStepCancel: () {
              if (_index > 0) {
                setState(() {
                  if (isChecked) {
                    _index -= 3;
                    isChecked = false;
                  }else{
                    _index -= 1;
                  }
                });
              }
            },
            onStepContinue: () {
              if (_index <= 2) {
                setState(() {
                  _index += 1;
                });
              }
            },
            onStepTapped: (int index) {
              setState(() {
                _index = index;
              });
            },
            controlsBuilder: (BuildContext context, ControlsDetails details) {
              return Container(
                margin: EdgeInsets.only(top: 50),
                child: Row(
                  children: [
                    if ( _index < 3)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: details.onStepContinue,
                          child: Text('Proximo' ),
                          )
                        ),
                      SizedBox(width: 12,),
                    if (_index != 0 && (_index < 3 || _data?.isValid()))
                      Expanded(
                        child: ElevatedButton(
                          onPressed: details.onStepCancel,
                          child: Text('Voltar'),
                          )
                      ),
                  ],
                ),
              );
            },
            steps: <Step>[
              Step(
                isActive: _index >= 0,
                title: const Text('Detalhes'),
                content: Column(
                  children: [
                          Text('INFORMAÇÕES DO CLIENTE', 
                          style: TextStyle(
                                  fontSize:  fontSize,
                                  fontWeight: FontWeight.bold,
                                  ),
                          ),
                        Row( 
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [                               
                            SizedBox(height: 20,),
                            if (!_data.isValid()) Text('Cliente não se encontra', style: textSize,),
                            if (!_data.isValid()) Checkbox(
                                value: isChecked,
                                onChanged: (bool? value ) {
                                  setState(() {
                                    isChecked = value!;
                                    _index = 3;
                                    _data.observacao = '';
                                  });
                                }),
                            ]
                          ),
                        descriptionEntrega(data: _data, item: _item),
                  ]
                ),
                state: _index > 0 ? StepState.complete : StepState.disabled
              ),
              Step(
                isActive: _index >= 1,
                title: Text('Assinatura'),
                content: SignatureEntrega(data: _data),
                state: _index > 1 ? StepState.complete : StepState.disabled
              ),
              Step(
                isActive: _index >= 2,
                title: const Text('Foto'),
                content: Container(
                  alignment: Alignment.centerLeft,
                  child: PictureEntrega(data: _data),
                ),
                state: _index > 2 ? StepState.complete : StepState.disabled
              ),
              Step(
                isActive: _index >= 3,
                title: const Text('Enviar'),
                content: Container(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: _padding,
                          horizontal: 0
                        ),
                        child: Column(
                          children: [ 
                            if (!isChecked) Container(
                              child: Column(
                                children: [
                                Text('CHECKLIST FINAL', style: TextStyle(
                                            fontSize: fontSize,
                                            fontWeight: FontWeight.bold,
                                        ),),
                                Row(
                                  children: [
                                      _data?.name != null 
                                      ? IconButton( icon: Icon(Icons.check_box, color: Colors.green), onPressed: () {})
                                      : IconButton( icon: Icon(Icons.check_box_outline_blank, color: Colors.red), onPressed: () {
                                           setState(() {
                                             _index = 0;
                                           });
                                      },),
                                      Text('Nome Cliente' , style: textSize,) 
                                  ]
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                      _data.cpfCnpj != null 
                                      ? IconButton( icon: Icon(Icons.check_box, color: Colors.green), onPressed: () {})
                                      : IconButton( icon: Icon(Icons.check_box_outline_blank, color: Colors.red), onPressed: () {
                                           setState(() {
                                             _index = 0;
                                           });
                                      },),
                                      Text('CPF Cliente' , style: textSize,)
                                ]),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                      _data.assinaturaUrl != null || _data.assinatura != null 
                                      ? IconButton( icon: Icon(Icons.check_box, color: Colors.green), onPressed: () {}) 
                                      : IconButton( icon: Icon(Icons.check_box_outline_blank, color: Colors.red), onPressed: () {
                                           setState(() {
                                             _index = 1;
                                           });
                                      },),
                                      Text('Assinatura Cliente' , style: textSize,)
                                ]),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                      (_data.imagens != null && _data.imagens.length > 0) 
                                      ? IconButton( icon: Icon(Icons.check_box, color: Colors.green), onPressed: () {})
                                      : IconButton( icon: Icon(Icons.check_box_outline_blank, color: Colors.red), onPressed: () {
                                           setState(() {
                                             _index = 2;
                                           });
                                      },),
                                      Text('${_data.imagens == null ? 0 : _data.imagens.length} Fotos dos produtos' , style: textSize,)
                                ]),

                                SizedBox(height: 10),
                                
                                ]
                              )
                            ),
                            
                            if (isChecked) Container(
                              child: Column(children: [
                                  Text('INSIRA UMA OBSERVAÇÃO',
                                  style: TextStyle(
                                            fontSize: fontSize,
                                            fontWeight: FontWeight.bold,
                                        ), ),
                                SizedBox(height: 20,),
                                 TextFormField(
                                  key: ValueKey('OBS:'),
                                  maxLines: 4,
                                  initialValue: _data.observacao,
                                  onChanged: (obs) => _data.observacao = obs,
                                  validator: (_obs) {
                                    final obs = _obs ?? '';
                                    if (obs.trim() != ''){
                                      return 'OBS e obrigatorio!';
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Observação:',
                                    border: OutlineInputBorder(),    
                                  ),
                                ),
                               
                              ]),
                      
                            ),
                            if (_data?.observations.length > 0) Column(
                               children: listObservations(context).toList()
                             ),
                            
                            ]
                        )
                      ),
                      if (isChecked || _data != null) Padding(
                            padding: EdgeInsets.all(5),
                            child: Container( 
                              child : ElevatedButton.icon(
                                  onPressed: _onSubmitEntrega,
                                  icon: Icon(Icons.check),
                                  label: Text('Conlcuir Entrega')
                                ),
                              )
                        ),
                    ]),
                ),
                state: _index > 3 ? StepState.complete : StepState.disabled
              ),
            ],
          )
              )
            ])
        );
        }

        return Scaffold(
            appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          automaticallyImplyLeading: true,
          actions: [],
          title: Text(" Entrega Nº ${_item['nrEntrega']}", style: TextStyle(color: Colors.white),),
          centerTitle: true,
          elevation: 3,
          leading: BackButton(color: Colors.white),
        ), body: Center(
                  child: display(entrega),
                    )
          );
      
  }


  // @override
  // Widget build(BuildContext context) {
  //   var _item = widget.item;
  //   var _entrega = null;
  //   var textSize =  TextStyle(fontSize: 17);
  //   var itemsObs = [];
  //   var _data = Entrega( '', null, null, null, null, null, [], null, null, null, null, 0,[]);
 

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
  //               content: SignatureEntrega(data: _data, value:  {} ),
  //               state: _index > 1 ? StepState.complete : StepState.disabled
  //             ),
  //             Step(
  //               isActive: _index >= 2,
  //               title: const Text('Foto'),
  //               content: Container(
  //                 alignment: Alignment.centerLeft,
  //                 child:PictureEntrega(data: _data,  value:  {}),
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
  //                                     _data.cpfCnpj != null ? Icon(Icons.check_box, color: Colors.green,) : Icon(Icons.check_box_outline_blank, color: Colors.red,),
  //                                     Text('CPF Cliente' , style: textSize,)
  //                               ]),
  //                               SizedBox(height: 10,),
  //                               Row(
  //                                 children: [
  //                                     _data.assinatura != null ? Icon(Icons.check_box, color: Colors.green,) : Icon(Icons.check_box_outline_blank, color: Colors.red,),
  //                                     Text('Assinatura Cliente' , style: textSize,)
  //                               ]),
  //                               SizedBox(height: 10,),
  //                               Row(
  //                                 children: [
  //                                     _data.imagems != null  ? Icon(Icons.check_box, color: Colors.green,) : Icon(Icons.check_box_outline_blank, color: Colors.red,),
  //                                     Text('${_data.imagems?.length} Fotos dos produtos Entregues.' , style: textSize,)
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
  //                                 initialValue: _data.observacao,
  //                                 onChanged: (obs) => _data.observacao = obs,
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