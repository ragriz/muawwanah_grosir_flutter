import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

var isAkunLoaded = false;
var arrTableLoaded = [];
init_load_db(String table){

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

sessionSet(dynamic d) async {
  await SessionManager().set('id', d);
}
sessionGet(String data) async {
  var d = await SessionManager().get(data);
  print(d);
}
sessionRemove(String data) async {
  var d = await SessionManager().remove(data);
  print(d);
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