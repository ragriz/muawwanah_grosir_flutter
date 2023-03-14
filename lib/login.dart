import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'config/string.dart';
import 'config/color.dart' as clr;
import 'config/global.dart' as global;
import 'package:http/http.dart' as http;

List<HakAkses> list = [];
int dropdownValue = 1;
String str_bt_server = "Login";
bool vis_bt_server = false;
bool vis_login = false, vis_database = true;
bool vis_cpi_bt_server = false;
bool isCheckingServer = false;
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
List<Map<String, dynamic>> l_hakAkses = [];
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
    global.init_db('akun');
    global.init_db('hak_akses');
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
                                          getServer(context);
                                        },
                                        focusNode: fn_bt_server,
                                        child: Row(
                                          children: [
                                            Visibility(
                                                visible: vis_cpi_bt_server,
                                                child: Row(
                                                  children: const [
                                                    SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child: CircularProgressIndicator(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                  ],
                                                ),
                                            ),
                                            Text(str_bt_server)
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

  getServer(BuildContext context) async {
    isCheckingServer = true;
    var curServer = tf_server.text;
    setState((){
      disableServerButton();
    });
    if( curServer != "" ){
      final response = await http.post(
        Uri.parse('http://$curServer/muawwanahgrosirmaster/config/service_client.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          postObject_serverAddress: curServer,
          postObject_operation : postKey_operation_checkConnection
        }),
      );
      if( response.statusCode == 200 ){
        global.sessionSet(postObject_serverAddress, curServer);
        Map<String, dynamic> map = jsonDecode(response.body);
        if( map['msg'] == 's_001' ){
          global.init_db_reset();
          global.init_db_loadAll(checkData);
        }else{
          doServerError(context);
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
        print(response.statusCode);
        doServerError(context);
      }
      try {

      } catch(e){
        print(e);
        doServerError(context);
      }
    }else{
      global.dialog(context, 'alamat server harus diisi !');
      setState((){
        enableServerButton();
      });
    }
  }
  checkData(){
    if( global.init_db_checkIfAllLoaded() ){
      setState((){
        vis_database = false;
        vis_login = true;
        isCheckingServer = false;
        enableServerButton();
      });
      fn_tf_user.requestFocus();
    }
  }
  enableServerButton(){
    vis_cpi_bt_server = false;
    str_bt_server = 'Pilih';
  }
  disableServerButton(){
    vis_cpi_bt_server = true;
    str_bt_server = 'Menghubungkan';
  }

  doServerError(BuildContext context){
    global.dialog(context, 'gagal memuat database !');
    fn_tf_server.requestFocus();
    setState((){
      enableServerButton();
    });
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
        bool isAkunExist = false;
        for( dynamic l in list ){

          Map<String, dynamic> map = json.decode(l['json']);
          if( map['boolean_akun']!=null ){

          }
          if( tf_user.text == l['username'] && tf_pass.text == l['pass'] ){

          }
        }
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
    return DropdownButton<HakAkses>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 5,
      onChanged: (HakAkses? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = 1;
        });
      },
      focusNode: fn_dd_hakAkses,
      items: [
        DropdownMenuItem(
          child: Text('Admin'),
        value: 1,
      )],
    );
  }

  List<HakAkses> parsePackages(String responseBody) {
    final parsedJson = json.decode(responseBody);
    final parsed = parsedJson.cast<Map<String, dynamic>>();
    return parsed.map<HakAkses>((json) => HakAkses.fromJson(json)).toList();
  }
}

class HakAkses{
  int id;
  String nama;
  HakAkses(this.id, this.nama);
  HakAkses.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nama = json['nama'];
  Map<String, dynamic> toJson() => {
    'id' : id,
    'nama': nama
  };
}