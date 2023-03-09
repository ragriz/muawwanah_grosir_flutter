import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
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
List<String> list = <String>['One', 'Two', 'Three', 'Four'];
String dropdownValue = list.first;
var vis_login = false, vis_database = true;
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RawKeyboardListener(
          focusNode: fn,
          onKey: handleKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: vis_login,
                  child: Wrap(
                    children: [Container(
                      padding: const EdgeInsets.all(20),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            children: [
                              const ListTile(
                                leading: Icon(Icons.person),
                                title: Text('Muawwanah Grosir'),
                                subtitle: Text('Silahkan Login untuk menggunakan sistem'),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                                child: TextField(
                                  focusNode: fn_tf_user,
                                  controller: tf_user,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Username',
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: TextField(
                                  textInputAction: TextInputAction.done,
                                  controller: tf_pass,
                                  focusNode: fn_tf_pass,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Password',
                                  ),
                                ),
                              ),
                              Row(
                                children: const [
                                  Text('Hak Akses'),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    child: DropdownButtonExample()
                                  )
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                        onPressed: (){
                                          login(context);
                                        },
                                        child: const Text('Login'))
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
                Visibility(
                  visible: vis_database,
                  child: Wrap(
                    children: [Container(
                      padding: const EdgeInsets.all(20),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            children: [
                              const ListTile(
                                leading: Icon(Icons.cloud),
                                title: Text('Muawwanah Grosir'),
                                subtitle: Text('Silahkan Pilih Database'),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                                child: TextField(
                                  focusNode: fn_tf_user,
                                  controller: tf_user,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Alamat Database',
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                        onPressed: (){

                                        },
                                        child: const Text('Pilih'))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}

TextEditingController tf_user = TextEditingController();
TextEditingController tf_pass = TextEditingController();
FocusNode fn_tf_user = FocusNode();
FocusNode fn_tf_pass = FocusNode();
FocusNode fn = FocusNode();

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
    if( Platform.isWindows ){

    }
    if( kIsWeb ){
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
}

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 5,
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}


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