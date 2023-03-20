import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'config/string.dart';
import 'login.dart';
import 'main.dart';
import 'pelanggan.dart';
import 'test.dart';
import 'config/global.dart';

void main() => runApp(MaterialApp(
  routes: {
    '/' : (context) => Preload(),
    '/test' : (context) => Test(),
    '/login' : (context) => Login(),
    '/main' : (context) => Main(),
    '/pelanggan' : (context) => Pelanggan(),
  },
));

class Preload extends StatefulWidget{
  @override
  _PreloadState createState() => _PreloadState();
}

class _PreloadState extends State<Preload>{
  var msg = "";
  @override
  initState() {
    // TODO: implement initState
    super.initState();
    checkSession();
  }
  @override
  void didUpdateWidget(covariant Preload oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Image(image: AssetImage('logo.jpg'))
      ),
    );
  }

  checkSession() async{
    var ses = await sessionGet(session_idAkun);
    if( ses != null ){
      //Navigator.pushReplacementNamed(context, '/main');
    }else{
      Navigator.pushReplacementNamed(context, '/login');
    }
    /*

     */
  }
}

