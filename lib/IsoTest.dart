import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
class isotest extends StatefulWidget {
  const isotest({Key? key}) : super(key: key);

  @override
  _isotestState createState() => _isotestState();
}

class _isotestState extends State<isotest> {
  String? isoout;
  @override
  void initState() {
    testInit();
    // TODO: implement initState
    super.initState();
  }
  void testInit()async{
    await testIso();
    print('Done');
  }
  Future<void> testIso()async{
    Completer comp = new Completer();
    bool isFinished = false;
    final receivePort = ReceivePort();
    final isolate = await Isolate.spawn(isoFunction, [receivePort.sendPort, ['Isolate Test 1','Isolate Test 2','Isolate Test 3','end']],
    );
    await receivePort.listen((message) {
      print(message);
      setState(() {
        isoout = message;
      });
      if(message == 'end'){
        setState(() {
          isFinished = true;
        });
        receivePort.close();
        isolate.kill();
      }
    },
      onDone: (){
      comp.complete();
      }
    );
    await Future.wait([comp.future]);
    print('Finished');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text((isoout != null)?isoout!:'Null'),
      ),
    );
  }
}
void isoFunction(List arguments) async{
  SendPort sendPort = arguments[0];
  sendPort.send(arguments[1][0]);
  await Future.delayed(Duration(seconds: 2));
  sendPort.send(arguments[1][1]);
  await Future.delayed(Duration(seconds: 2));
  sendPort.send(arguments[1][2]);
  await Future.delayed(Duration(seconds: 2));
  sendPort.send(arguments[1][3]);

}

