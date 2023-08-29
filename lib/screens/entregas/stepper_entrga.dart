import 'package:delivery_app/screens/entregas/entregas_list.dart';
import 'package:flutter/material.dart';

/// Flutter code sample for [Stepper].

class StepperEntrega extends StatefulWidget {
  final Name item;
  const StepperEntrega({Key? key, required this.item}) : super(key: key);

  @override
  State<StepperEntrega> createState() => _StepperEntregasState();
}

class _StepperEntregasState extends State<StepperEntrega> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          automaticallyImplyLeading: true,
          actions: [],
          title: Text("ITEM", style: TextStyle(color: Colors.white),),
          centerTitle: true,
          elevation: 3,
        ),
      body:
       Container(
          child: Column(
            children: [
              Expanded(
                child: Stepper(
            type: StepperType.horizontal,
            currentStep: _index,
            onStepCancel: () {
              if (_index > 0) {
                setState(() {
                  _index -= 1;
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
            steps: <Step>[
              Step(
                isActive: _index >= 0,
                title: const Text('Step 1 '),
                content: Container(
                  alignment: Alignment.centerLeft,
                  child: const Text('Content for Step 1'),
                ),
                state: _index > 0 ? StepState.complete : StepState.disabled
              ),
              Step(
                isActive: _index >= 1,
                title: Text('Step 2 '),
                content: Text('Content for Step 2'),
                state: _index > 1 ? StepState.complete : StepState.disabled
              ),
              Step(
                isActive: _index >= 2,
                title: const Text('Step 3 '),
                content: Container(
                  alignment: Alignment.centerLeft,
                  child: const Text('Content for Step 3'),
                ),
                state: _index > 2 ? StepState.complete : StepState.disabled
              ),
              Step(
                isActive: _index >= 3,
                title: const Text('Step 4 '),
                content: Container(
                  alignment: Alignment.centerLeft,
                  child: const Text('Content for Step 4'),
                ),
                state: _index > 3 ? StepState.complete : StepState.disabled
              ),
            ],
          )
              )
            ])
        )
    );
  }
}
