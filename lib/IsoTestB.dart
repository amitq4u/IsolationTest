import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
class IsoTestB extends StatefulWidget {
  const IsoTestB({Key? key}) : super(key: key);
  @override
  _IsoTestBState createState() => _IsoTestBState();
}

class _IsoTestBState extends State<IsoTestB> {
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
    final receivePort = ReceivePort();
    final isolate = await Isolate.spawn(isoFunction, [receivePort.sendPort, ['Isolate Test 1','Isolate Test 2','Isolate Test 3','end']],
    );
    await receivePort.listen((message) {
      print(message);
      setState(() {
        isoout = message;
      });
        receivePort.close();
        isolate.kill();
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
  await Future.delayed(Duration(seconds: 4));
  sendPort.send('Hello From Isolate');
}
