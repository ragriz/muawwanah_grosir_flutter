import 'dart:convert';
import 'dart:io';
import 'dart:io';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muawwanah Grosir',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

TextEditingController tf_user = TextEditingController();
TextEditingController tf_pass = TextEditingController();
FocusNode fn_tf_user = FocusNode();
FocusNode fn_tf_pass = FocusNode();
FocusNode fn = FocusNode();

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RawKeyboardListener(
          focusNode: fn,
          onKey: handleKey,
          child: Center(
            child: Visibility(

              child: Wrap(
                children: [Container(
                  padding: EdgeInsets.all(20),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.person),
                            title: Text('Muawwanah Grosir'),
                            subtitle: Text('Silahkan Login untuk menggunakan sistem'),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
                            child: TextField(
                              focusNode: fn_tf_user,
                              controller: tf_user,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Username',
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: TextField(
                              textInputAction: TextInputAction.done,
                              controller: tf_pass,
                              focusNode: fn_tf_pass,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Password',
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text('Hak Akses'),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Expanded(
                                  child: DropdownButton<String>(
                                    value: 'One',
                                    icon: const Icon(Icons.arrow_drop_down),
                                    elevation: 5,
                                    onChanged: (String? value) {
                                      // This is called when the user selects an item.
                                      setState(() {
                                        print(value);
                                      });
                                    },
                                    items: list.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                    onPressed: (){
                                      login(context);
                                    },
                                    child: Text('Login'))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )],
              ),
            ),
          ),
        )
    );
  }
}

login(BuildContext context) async {
  final response = await http.post(
    Uri.parse('http://localhost/muawwanahgrosirmaster/config/service_client_read.php'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'server_address': 'localhost',
      'tbl' : 'pelanggan'
    }),
  );
  if( response.statusCode == 200 ){
    print(jsonDecode(response.body));
    //Map<String, dynamic> map = jsonDecode(response.body);
    List<dynamic> list = json.decode(response.body);
    for( dynamic l in list ){
      print(l['id']);
      Map<String, dynamic> map = json.decode(l['json']);
      if( map['email']!=null ){

      }
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SecondRoute()),
    );
  }else{
    throw Exception('Failed to load db');
  }
}

handleKey(RawKeyEvent key) {
  if (key.runtimeType.toString() == 'RawKeyDownEvent') {
    RawKeyEventDataWeb data = key.data as RawKeyEventDataWeb;
    //print(data.keyCode);
    if (fn_tf_user.hasFocus) { //user focus
      if (data.keyCode == 40) {
        fn_tf_pass.requestFocus();
        //var curPos = tf_user.selection.base.offset;
        //tf_user.selection = TextSelection(baseOffset: curPos, extentOffset: curPos);
      }
    }
    if (fn_tf_pass.hasFocus) { //pass focus
      if (data.keyCode == 38) {
        fn_tf_user.requestFocus();
      }
      if (data.keyCode == 40) {

      }
    }
  }
}
const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to first route when tapped.
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}