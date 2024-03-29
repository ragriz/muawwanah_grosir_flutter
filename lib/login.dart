import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:muawwanah_grosir_flutter/pelanggan.dart';
import 'package:muawwanah_grosir_flutter/test.dart';
import 'package:muawwanah_grosir_flutter/test2.dart';
import 'config/string.dart';
import 'config/global.dart' as global;
import 'package:http/http.dart' as http;
import 'main.dart';

var globalContext;
List<HakAkses> list = [];
int id_hakAkses = 0;
String str_bt_server = "Login";
bool vis_bt_server = false;
bool vis_login = false, vis_database = false, vis_loading = true;
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
List<HakAkses> l_hakAkses = [];
GlobalKey<w_btnServerState> key_btnServer = GlobalKey();
GlobalKey<w_cardServerState> key_cardServer  = GlobalKey();
GlobalKey<w_cardLoginState> key_cardLogin  = GlobalKey();
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
void main() => runApp(MaterialApp(
  routes: {
    '/' : (context) => Login(),
    '/test' : (context) => Test(),
    '/test2' : (context) => Test2(),
    '/login' : (context) => Login(),
    '/main' : (context) => Main(),
    '/pelanggan' : (context) => Pelanggan(),
  },
));
//main
class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}
class _LoginState extends State<Login> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkSession();
  }
  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return Scaffold(
        body: RawKeyboardListener(
          focusNode: fn,
          onKey: handleKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: vis_loading,
                  child: Card(
                    elevation: 10,
                    child : Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(height: 10,),
                          Text('Memuat . . .')
                        ],
                      ),
                    )
                  ),
                ),
                w_cardLogin(key : key_cardLogin),
                w_cardServer(key: key_cardServer)
              ],
            ),
          ),
        )
    );
  }

  checkSession() async{
    var ses = await global.sessionGet(session_idAkun);
    if( ses != null ){
      global.toast(globalContext, 'sesi belum berakhir, mengalihkan ke halaman utama . . .');
      Timer(const Duration(seconds : 2 ), (){Navigator.pushReplacementNamed(globalContext, '/main');});
    }else{
      global.init_db('akun');
      global.init_db('hak_akses');
      global.init_db('pegawai');
      fn.requestFocus();
      vis_loading = false;
      vis_database = true;
      vis_cpi_bt_server = false;
      tf_server.text = "";
      str_bt_server = "Pilih";
      key_cardLogin.currentState!.setState((){});
      key_cardServer.currentState!.setState((){});
      key_btnServer.currentState!.setState((){});
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
      if( fn_tf_pass.hasFocus ){
        if( key.logicalKey == LogicalKeyboardKey.enter ){
          login(context);
        }
      }
    }
  }
}
//function
getServer() async {
  //
  isCheckingServer = true;
  var curServer = tf_server.text;
  //
  enableServerButton(){
    key_btnServer.currentState?.setState(() {
      vis_cpi_bt_server = false;
      str_bt_server = 'Pilih';
    });
  }
  disableServerButton(){
    vis_cpi_bt_server = true;
    str_bt_server = 'Menghubungkan';
    key_btnServer.currentState?.setState(() {});
  }
  doServerError(){
    global.dialog(globalContext, 'gagal memuat database !');
    fn_tf_server.requestFocus();
    enableServerButton();
  }
  //
  disableServerButton();
  if( curServer != "" ){
    try {
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
        await global.sessionSet(postObject_serverAddress, curServer);
        Map<String, dynamic> map = jsonDecode(response.body);
        if( map['msg'] == 's_001' ){
          global.init_db_reset();
          global.init_db_loadAll(checkData);
        }else{
          doServerError();
        }
      }else{
        doServerError();
      }
    } catch(e){
      print(e);
      doServerError();
    }
  }else{
    global.dialog(globalContext, 'alamat server harus diisi !');
    enableServerButton();
  }
}
kembali() async {
  vis_database = true;
  vis_login = false;
  tf_user.text = "";
  tf_pass.text = "";
  vis_cpi_bt_server = false;
  str_bt_server = 'Pilih';
  fn_tf_server.requestFocus();
  key_cardLogin.currentState!.setState(() {});
  key_cardServer.currentState!.setState(() {});
  key_btnServer.currentState!.setState((){});
}
login(BuildContext context) async {
  if( tf_user.text != "" ){
    if( tf_pass.text != "" ){
      bool isAkunExist = false;
      var curAkun, curNama;
      List<dynamic> l_akun = global.getList_byName('akun');
      for( dynamic l in l_akun ){
        Map<String, dynamic> map = json.decode(l['json']);
        if( tf_user.text == l['username'] && tf_pass.text == l['pass'] && id_hakAkses == int.parse(l['id_hakAkses']) ){
          curAkun = l['id'];
          if( map['boolean_akunKhusus']!=null ){
            if( map['boolean_akunKhusus'] ){
              curNama = map['string_nama'];
            }else{
              curNama = global.list_getValue(global.getList_byName('pegawai'), 'id', map['integer_idPegawai'], 'nama');
            }
          }
          isAkunExist = true;
        }
      }
      if( isAkunExist ){
        await global.sessionSet(session_idAkun, curAkun);
        await global.sessionSet(session_nama, curNama);
        await global.sessionSet(session_idHakAkses, id_hakAkses);
        await global.sessionSet(session_hakAkses, global.list_getValue(global.getList_byName('hak_akses'), 'id', id_hakAkses.toString(), 'nama'));
        await Navigator.pushReplacementNamed(globalContext, '/main');
        kembali();
      }else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("username atau password tidak sesuai !"),));
      }
    }else{
      global.dialog(context, 'Password harus diisi!');
    }
  }else{
    global.dialog(context, 'Username harus diisi!');
  }
  /*
   */
}
checkData(){
  if( global.init_db_checkIfAllLoaded() ){
    vis_database = false;
    vis_login = true;
    isCheckingServer = false;
    key_cardServer.currentState!.setState(() {});
    key_cardLogin.currentState!.setState((){});
    l_hakAkses.clear();
    for( var d in global.getList_byName('hak_akses') ){
      l_hakAkses.add(HakAkses(int.parse(d['id']), d['nama']));
    }
    fn_tf_user.requestFocus();
  }
}
//widget
class w_cardServer extends StatefulWidget{
  const w_cardServer ({required Key key}) : super(key: key);
  @override
  State<w_cardServer> createState() => w_cardServerState();
}
class w_cardServerState extends State<w_cardServer>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Visibility(
      visible: vis_database,
      child: Wrap(
        children: [Container(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 10,
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
                    child: w_btnServer(
                        key: key_btnServer
                    ),
                  ),
                ],
              ),
            ),
          ),
        )],
      ),
    );
  }
}
class w_cardLogin extends StatefulWidget{
  const w_cardLogin ({required Key key}) : super(key: key);
  @override
  State<w_cardLogin> createState() => w_cardLoginState();
}
class w_cardLoginState extends State<w_cardLogin>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Visibility(
      visible: vis_login,
      child: Wrap(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    const ListTile(
                      leading: Image(image: AssetImage('assets/logo.jpg')),
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
                            child: DropdownButtonExample())
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange),
                              onPressed: () {
                                kembali();
                              },
                              focusNode: fn_bt_back,
                              child: const Text('Kembali')),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: ElevatedButton(
                                onPressed: () {
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
          )
        ],
      ),
    );
  }
}
class w_btnServer extends StatefulWidget{
  const w_btnServer ({required Key key}) : super(key: key);
  @override
  State<w_btnServer> createState() => w_btnServerState();
}
class w_btnServerState extends State<w_btnServer>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 500),
          child: ElevatedButton(
              onPressed: (){
                getServer();
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
    );
  }
}
class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});
  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}
class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  var items;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items = l_hakAkses.map((item) {
      return DropdownMenuItem<int>(
        child: Text(item.nama),
        value: item.id,
      );
    }).toList();
    id_hakAkses = l_hakAkses[0].id;
  }
  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: id_hakAkses,
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 5,
      onChanged: (int? value) {
        // This is called when the user selects an item.
        setState(() {
          id_hakAkses = value!;
        });
      },
      focusNode: fn_dd_hakAkses,
      items: items,
    );
  }

  List<HakAkses> parsePackages(String responseBody) {
    final parsedJson = json.decode(responseBody);
    final parsed = parsedJson.cast<Map<String, dynamic>>();
    return parsed.map<HakAkses>((json) => HakAkses.fromJson(json)).toList();
  }
}