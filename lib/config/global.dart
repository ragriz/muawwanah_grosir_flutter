import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:muawwanah_grosir_flutter/config/string.dart';

var urlWebServer = url_webServer;
var arrObjTable = [];
init_db(String table){
  if( arrObjTable.isNotEmpty ){ //prevent duplication
    var isTableExist = false;
    for( var d in arrObjTable ){
      if( d['tbl'] == table ){
        isTableExist = true;
      }
    }
    if( !isTableExist ){
      arrObjTable.add({
        'tbl':table,
        'loaded':false,
        'list':[],
      });
    }
  }else{
    arrObjTable.add({
      'tbl':table,
      'loaded':false,
      'list':[],
    });
  }
}
init_db_loadAll(Function fn){
  for( var i=0; i<arrObjTable.length; i++ ){
    var d = arrObjTable[i];
    init_db_load(d['tbl'], i, fn);
  }
}
init_db_load(String table, int pos, Function fn) async{
  var curServer = await SessionManager().get(postObject_serverAddress);
  var url = 'http://$curServer/$urlWebServer/config/service_client_read.php';
  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      postObject_serverAddress: curServer,
      postObject_table : table
    }),
  );
  if( response.statusCode == 200 ){
    arrObjTable[pos]['loaded'] = true;
    arrObjTable[pos]['list'] = jsonDecode(response.body);
    fn(); //function for refresh ui
  }else{
    print('fail to load $table');
  }
}
init_db_reset(){
  for( var i=0; i<arrObjTable.length; i++ ){
    arrObjTable[i]['loaded'] = false;
  }
}
init_db_checkIfAllLoaded(){
  print('\n');
  var value = true;
  for( dynamic d in arrObjTable ){
      if( !d['loaded'] ){
        print(d['tbl'].toString()+' is not loaded');
         value = false;
      }else{
        print(d['tbl'].toString()+' is loaded');
      }
  }
  return value;
}
//get list only work for loaded table
getList_byName(String table){
  var value;
  for( var d in arrObjTable ){
    if( d['tbl'] == table  ){
      value = d['list'];
    }
  }
  return value;
}
list_getValue(var list, String targetObj, String targetKey, String targetReturn){
  var value;
  for( var d in list ){
    if( d[targetObj] == targetKey ){
      value = d[targetReturn];
    }
  }
  return value;
}
json_stringNullCheck([String? val]){
  var value = "";
  if( val != null ){
    value = val;
  }
  return value;
}

dialog(BuildContext context, String text){
  FocusNode fn = FocusNode();
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Error'),
        content: Text(text),
        actions: <Widget>[
          TextButton(
            focusNode: fn,
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      )
  );
  fn.requestFocus();
}

sessionSet(String key, dynamic d) {
  SessionManager().set(key, d);
}
sessionGet(String data) async {
  var d = SessionManager().get(data);
  return d;
}
sessionRemove(String data) async {
  await SessionManager().remove(data);
}
sessionDestroy(){
  SessionManager().destroy();
}

init_onFocus_selectAllText(FocusNode fn, TextEditingController te){
  fn.addListener(() {
    if( fn.hasFocus ){
      Timer(const Duration(milliseconds: 1), (){te.selection = TextSelection(baseOffset: 0, extentOffset: te.value.text.length);});
    }
  });

}

init_nav_keyDown_lrtb(RawKeyEvent key, FocusNode fn, [FocusNode? toLeft, toRight, toTop, toBottom]){
  int delayTime = 1;
  if( toLeft != null ){
    if (fn.hasFocus) { //user focus
      if (key.logicalKey == LogicalKeyboardKey.arrowLeft) {
        Timer(Duration(milliseconds: delayTime), (){toLeft.requestFocus();});
      }
    }
  }
  if( toRight != null ){
    if (fn.hasFocus) { //user focus
      if (key.logicalKey == LogicalKeyboardKey.arrowRight) {
        Timer(Duration(milliseconds: delayTime), (){toRight.requestFocus();});
      }
    }
  }
  if( toTop != null ){
    if (fn.hasFocus) { //user focus
      if (key.logicalKey == LogicalKeyboardKey.arrowUp) {
        Timer(Duration(milliseconds: delayTime), (){toTop.requestFocus();});
      }
    }
  }
  if( toBottom != null ){
    if (fn.hasFocus) { //user focus
      if (key.logicalKey == LogicalKeyboardKey.arrowDown) {
        Timer(Duration(milliseconds: delayTime), (){toBottom.requestFocus();});
      }
    }
  }
}

toast(BuildContext context, String message){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message),));
}

parseLongText(String str){
  return str.replaceAll('<br>', '\n');
}

checkSession(BuildContext context) async{
  var ses = await sessionGet(session_idAkun);
  if( ses == null ){
    toast(context, 'Anda belum login !');
    Navigator.pushReplacementNamed(context, '/login');
    print('executed');
  }
}