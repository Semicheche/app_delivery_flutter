import 'package:delivery_app/models/data_entrega.dart';
import 'package:delivery_app/screens/entregas/stepper_entrega.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

class _descriptionEntregaState extends State<descriptionEntrega> {
  var textSize =  TextStyle(fontSize: 17);
  var textSizeProduct =  TextStyle(fontSize: 15);
  bool isChecked = false;

  

  @override
  Widget build(BuildContext context) {
    var _data = widget.data;
    var _item = widget.item;

    List _produtos = _item["doctos"][0]["produtos"];
  print('is valid ${_data.isValid()}');
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
                                  onChanged: (cpfCnpj) => _data.cpfCnpj = cpfCnpj,
                                  keyboardType: TextInputType.number,
                                  enabled: !_data.isValid(),
                                  validator: (_cpfCnpj) {
                                    final cpfCnpj = _cpfCnpj ?? '';
                                    if (cpfCnpj.length < 11){
                                      return 'Insira um CPF Valido';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'CPF:'
                                  ),
                                ),
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
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                    if (_data.isValid()) Image.asset('assets/images/pngwing.com.png', width: 200, height: 100, fit: BoxFit.fitWidth,), 
                                    if (_data.isValid()) Text('ENTREGA EFEUTADA EM ${DateFormat('dd-MM-yyyy – kk:mm').format(_data?.criadoEm != null ? _data?.criadoEm : DateTime.now())}', style: TextStyle(color: Colors.red.shade800 , fontSize: 17), ),
                                    if (_data.observations.length > 0) Text('TENTATIVA DE ENTREGA EM ${DateFormat('dd-MM-yyyy – kk:mm').format(_data?.criadoEm)}', style: TextStyle(color: Colors.red.shade800 , fontSize: 15), ),
                                    if (_data?.name != null)const SizedBox(height:20),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(width: 10),
                                    Text('FILIAL: ${_item["doctos"][0]["codFilial"]}', style: textSize),
                                    const SizedBox(width: 10),
                                    Text('Nº DOCUMENTO: ${_item["doctos"][0]["nrDocto"]}', style: textSize,),         
                                ]),
                                

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(width: 10),
                                    Text('ENDEREÇO:', style: textSize)
                                  ],
                                ),
                                
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                          '''${_item["doctos"][0]["parceiro"]["endereco"]}, 
                                          ${_item["doctos"][0]["parceiro"]["numero"]}''',
                                          style: textSize,
                                          softWrap: false,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 4,
                                        ),
                                      ),
                                    
                                ],),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(width: 10),
                                    Text('COMPLELEMNTO', style: textSize)
                                  ]
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(width: 10),
                                    Expanded(
                                    child: Text('${_item["doctos"][0]["parceiro"]["complemento"]}', 
                                        style: textSize,
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 4),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(width: 10),
                                    Text('CEP: ${_item["doctos"][0]["parceiro"]["cep"]} ${_item["doctos"][0]["parceiro"]["municipio"]}, ${_item["doctos"][0]["parceiro"]["uf"]}', style: textSize),
                                    
                                  ],
                                ),
                                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(width: 10),
                                    Text('PRODUTOS', style: TextStyle(
                                        fontSize: 20,
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
                                padding: const EdgeInsets.all(16),
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
                                              maxLines: 2)
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