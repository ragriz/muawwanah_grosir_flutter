import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'login.dart';
import 'main.dart';
import 'pelanggan.dart';
import 'config/global.dart';

void main() => runApp(MaterialApp(
  routes: {
    '/' : (context) => Login(),
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
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Image(image: AssetImage('logo.jpg'))
      ),
    );
  }
}