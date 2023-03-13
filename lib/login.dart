import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'config/string.dart' as str;
import 'config/color.dart' as clr;
import 'config/global.dart' as global;
import 'package:http/http.dart' as http;

List<String> list = <String>['Front Office'];
String dropdownValue = list.first;
String str_bt_server = "Login";
bool vis_bt_server = false;
bool vis_login = false, vis_database = true;
TextEditingController tf_server = TextEditingController();
TextEditingController tf_user = TextEditingController();
TextEditingController tf_pass = TextEditingController();
FocusNode fn_tf_user = FocusNode();
FocusNode fn_tf_pass = FocusNode();
FocusNode fn_tf_server = FocusNode();
FocusNode fn_bt_server = FocusNode();
FocusNode fn_bt_back = FocusNode();
FocusNode fn_bt_login = FocusNode();
FocusNode fn_dd_hakAkses = FocusNode();
FocusNode fn = FocusNode();
List<Map<String, dynamic>> lD = [];
class Login extends StatefulWidget {
  Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String, dynamic> map = new Map();
    map.putIfAbsent('control', () => tf_user);
    map.putIfAbsent('focus', () => fn_tf_user);
    lD.add(map);
  }
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
                                leading: Image(image : AssetImage('logo.jpg')),
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
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                                        onPressed: (){
                                          setState((){
                                            kembali();
                                          });
                                        },
                                        focusNode: fn_bt_back,
                                        child: const Text('Kembali')),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                      child: ElevatedButton(
                                          onPressed: (){
                                            login(context);
                                          },
                                          focusNode: fn_bt_login,
                                          child: const Text('Login')),
                                    )
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
                                  autofocus: true,
                                  focusNode: fn_tf_server,
                                  controller: tf_server,
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
                                    AnimatedSize(
                                      duration: const Duration(seconds: 1),
                                      child: ElevatedButton(
                                        onPressed: (){
                                          setState((){
                                            getServer(context);
                                          });
                                        },
                                        focusNode: fn_bt_server,
                                        child: Row(
                                          children: [
                                            Visibility(
                                                child: CircularProgressIndicator(),
                                            visible: vis_ic_,),
                                            const Text('Pilih')
                                          ],
                                        )),
                                    )
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

getServer(BuildContext context) async {
  var curServer = tf_server.text;
  if( curServer != "" ){
    try {
      final response = await http.post(
        Uri.parse('http://$curServer/muawwanahgrosirmaster/config/service_client.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'server_address': curServer,
          'opr' : 'check_connection'
        }),
      );
      if( response.statusCode == 200 ){
        Map<String, dynamic> map = jsonDecode(response.body);
        if( map['msg'] == 's_001' ){
          vis_database = false;
          vis_login = true;
          fn_tf_user.requestFocus();
        }else{
          global.dialog(context, 'gagal memuat database !');
        }
        /*
          //Map<String, dynamic> map = jsonDecode(response.body);
          List<dynamic> list = json.decode(response.body);
          for( dynamic l in list ){
            print(l['id']);
            Map<String, dynamic> map = json.decode(l['json']);
            if( map['email']!=null ){

            }
          }
          */
      }else{
        doServerError(context);
      }
    } catch(e){
      doServerError(context);
    }
  }else{
    global.dialog(context, 'alamat server harus diisi !');
  }
  /*
  vis_database = false;
  vis_login = true;
  fn_tf_user.requestFocus();
   */
}
doServerError(BuildContext context){
  global.dialog(context, 'gagal memuat database !');
  fn_tf_server.requestFocus();
}
kembali(){
  vis_database = true;
  vis_login = false;
  tf_user.text = "";
  tf_pass.text = "";
  fn_tf_server.requestFocus();
}

login(BuildContext context) {
  if( tf_user.text != "" ){
    if( tf_pass.text != "" ){
      Navigator.pushReplacementNamed(context, '/main');
    }else{
      global.dialog(context, 'Password harus diisi!');
    }
  }else{
    global.dialog(context, 'Username harus diisi!');
  }
  /*
   */
}

handleKey(RawKeyEvent key) {
  if (key.runtimeType.toString() == 'RawKeyDownEvent') {
    global.init_nav_keyDown_lrtb(key, fn_tf_server, null, null, null, fn_bt_server);
    global.init_nav_keyDown_lrtb(key, fn_bt_server, null, null, fn_tf_server, null);
    global.init_nav_keyDown_lrtb(key, fn_tf_user, null, null, null, fn_tf_pass);
    global.init_nav_keyDown_lrtb(key, fn_tf_pass, null, null, fn_tf_user, fn_dd_hakAkses);
    global.init_nav_keyDown_lrtb(key, fn_dd_hakAkses, null, fn_bt_back, fn_tf_pass, fn_bt_login);
    global.init_nav_keyDown_lrtb(key, fn_bt_back, fn_dd_hakAkses, fn_bt_login, fn_dd_hakAkses, null);
    global.init_nav_keyDown_lrtb(key, fn_bt_login, fn_bt_back, null, fn_dd_hakAkses, null);
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
      focusNode: fn_dd_hakAkses,
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}