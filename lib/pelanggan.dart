import 'package:flutter/material.dart';
import 'config/string.dart' as str;
import 'config/color.dart' as clr;
import 'config/sidebar.dart';
import 'config/element.dart';
import 'config/template.dart';

class Pelanggan extends StatefulWidget{
  @override
  _PelangganState createState() => _PelangganState();
}

class _PelangganState extends State<Pelanggan>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text(str.title)),
      drawer: const Sidebar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          temp_headerSearch('Kelola Pelanggan',
              Row(
                children: [
                  eCheckbox('Nama', true, refreshSearch),
                  eCheckbox('Grup', true, refreshSearch),
                  eCheckbox('text', true, refreshSearch)
                ],
              ),
              refreshSearch
          ),
        ],
      ),
    );
  }
}
var count = 0;
refreshSearch(){
  count++;
  print(count);
}