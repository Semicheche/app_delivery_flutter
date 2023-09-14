import 'package:delivery_app/models/data_entrega.dart';
import 'package:delivery_app/screens/entregas/stepper_entrega.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class descriptionEntrega extends StatefulWidget {
  final data;
  final item;

  const descriptionEntrega
  ({super.key,
  required this.data,
  required this.item});

  @override
  State<descriptionEntrega> createState() => _descriptionEntregaState();
}

class ExampleMask {

  final TextEditingController textController = TextEditingController();
  final MaskTextInputFormatter formatter;
  final FormFieldValidator<String>? validator;
  final String hint;
  final TextInputType textInputType;

  ExampleMask({
    required this.formatter,
    this.validator,
    required this.hint,
    required this.textInputType
  });

}


class _descriptionEntregaState extends State<descriptionEntrega> {
  bool isChecked = false;

  

  @override
  Widget build(BuildContext context) {
    var textSize =  TextStyle(fontSize: MediaQuery.of(context).size.width*0.040);
    var textSizeProduct =  TextStyle(fontSize: MediaQuery.of(context).size.width*0.040);
    var _data = widget.data;
    var _item = widget.item;
    var fontSize = MediaQuery.of(context).size.width*0.042;
    var width = MediaQuery.of(context).size.width*0.02;

    List _produtos = _item["doctos"][0]["produtos"];

    var maskFormatter = MaskTextInputFormatter(
      mask: '###.###.###-##', 
      filter: { "#": RegExp(r'[0-9]') },
      type: MaskAutoCompletionType.lazy
    );

    return Column(
                  children: [
                    Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Column(
                                    children: [                
                                if (!isChecked) TextFormField(
                                  key: ValueKey('name'),
                                  initialValue: _data?.name != null ? _data?.name : '',
                                  onChanged: (name) => setState(() {
                                    _data?.name = name;
                                  }),
                                  autofocus: _data?.name != null ? false : true,
                                  enabled: !_data.isValid(),
                                  validator: (_name) {
                                    final nome = _name ?? '';
                                    if (nome.length < 3){
                                      return 'Nome informado não e válido.';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Nome:',
                                    border: OutlineInputBorder()
                                  ),
                                ),
                                SizedBox(height: 10,),
                                if (!isChecked) TextFormField(
                                                key: ValueKey('cpfCnpj'),
                                                initialValue: _data?.cpfCnpj != null ? _data?.cpfCnpj : '',
                                                inputFormatters: [ maskFormatter ],
                                                autocorrect: false,
                                                keyboardType: TextInputType.number,
                                                onChanged: (cpfCnpj) => _data.cpfCnpj = cpfCnpj,
                                                enabled: !_data.isValid(),
                                                autofocus:  _data?.cpfCnpj != null ? false : true,
                                                decoration: const InputDecoration(
                                                  hintText: '000.000.000-00',
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(),
                                                  labelText: 'CPF:'
                                                  
                                                ),
                                                
                                              ),
                                // if (!isChecked) buildTextField(cpfMask())
                                
                              ]),
                              ),
                                
                                const SizedBox(height: 20),
                                 
                                 Container(
                                    decoration:  BoxDecoration(
                                    color: Colors.amber.shade50,
                                    border: Border.all(
                                      color: Color.fromARGB(255, 168, 168, 168),
                                      width: 0.5,
                                    ),
                                    ),
                                    child: Column(
                                    children: [
                                      if (_data?.name == null) const SizedBox(height:20),
                                      Text('DETALHES DA ENTREGA', style: TextStyle(
                                        fontSize: fontSize,
                                        fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                    if (_data.isValid()) Image.asset('assets/images/pngwing.com.png', width: 200, height: 100, fit: BoxFit.fitWidth,), 
                                    if (_data.isValid()) Text('ENTREGA EFEUTADA EM ${DateFormat('dd-MM-yyyy – kk:mm').format(_data?.alteradoEm)}', style: TextStyle(color: Colors.red.shade800 , fontSize: fontSize, fontWeight: FontWeight.bold)),
                                    if (_data.observations != null && _data.observations.length > 0 || _data.isValid()) const SizedBox(height:10),
                                    if (_data.observations != null && _data.observations.length > 0 && !_data.isValid()) Text('TENTATIVA DE ENTREGA EM ${DateFormat('dd-MM-yyyy – kk:mm').format(DateTime.parse(_data.observations.last['criadoEm']))}', style: TextStyle(color: Colors.red.shade800 , fontSize: fontSize, fontWeight: FontWeight.bold), ),
                                    if (_data.observations != null && _data.observations.length > 0) const SizedBox(height:10),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: width),
                                    Text('FILIAL: ${_item["doctos"][0]["codFilial"]}', style: textSize),
                                    SizedBox(width: width),
                                    Text('Nº DOCUMENTO: ${_item["doctos"][0]["nrDocto"]}', style: textSize,),         
                                ]),
                                

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: width),
                                    Text('ENDEREÇO:', style: textSize)
                                  ],
                                ),
                                
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(width: width),
                                    Expanded(
                                      child: Text(
                                          '''${_item["doctos"][0]["parceiro"]["endereco"]}, 
                                          ${_item["doctos"][0]["parceiro"]["numero"]}''',
                                          style: textSize,
                                          softWrap: false,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 8,
                                        ),
                                      ),
                                    
                                ],),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: width),
                                    Text('COMPLELEMNTO', style: textSize)
                                  ]
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: width),
                                    Expanded(
                                    child: Text('${_item["doctos"][0]["parceiro"]["complemento"]}', 
                                        style: textSize,
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 6),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: width),
                                    Expanded(
                                    child: Text('CEP: ${_item["doctos"][0]["parceiro"]["cep"]} ${_item["doctos"][0]["parceiro"]["municipio"]}, ${_item["doctos"][0]["parceiro"]["uf"]}',
                                        style: textSize,
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 6),
                                    ),
                                    
                                  ],
                                ),
                                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: width),
                                    Text('PRODUTOS', style: TextStyle(
                                        fontSize: fontSize,
                                        fontWeight: FontWeight.bold,
                                        backgroundColor: Colors.amber.shade50,
                                    ),),
                                  ],
                                ),
                              ]
                            ),
                          ),
                        ]
                      ),
                    // ),
                    //     ),
                    ),
                     Column(
                        children: _produtos.map((e) {
                          return Container(
                                padding: const EdgeInsets.all(10),
                                decoration:  BoxDecoration(
                                color: Colors.amber.shade50,
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 0.5,
                                )
                              ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [Text('CODIGO: ${e["codigo"]}', style: textSizeProduct,)]
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text('DESCRIÇÃO: ${e["descricao"]}', 
                                              style: textSizeProduct,
                                              softWrap: false,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3)
                                    ),
                                  ]
                                ),
                                
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [Text('QTD: ${e["qtd"]}', style: textSizeProduct,)]
                                ),
                                ]),
                            );
                            // );
                        }).toList()
                        )
                  ]
                );
  }
}
