import 'package:flutter/material.dart';
var isAkunLoaded = false, isAkun;
init_load_db(String table){

}
dialog(BuildContext context, String text){
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Error'),
        content: Text(text),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      )
  );
}