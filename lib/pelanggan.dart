import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:muawwanah_grosir_flutter/config/global.dart';
import 'config/string.dart' as str;
import 'config/color.dart' as clr;
import 'config/sidebar.dart';
import 'config/element.dart';
import 'config/template.dart';

FocusNode fn = FocusNode();
class Pelanggan extends StatefulWidget{
  @override
  _PelangganState createState() => _PelangganState();
}

class _PelangganState extends State<Pelanggan>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init_db('pelanggan');
    init_db('pelanggan_grup');
    init_db_loadAll(checkData);
    fn.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    // TODO: implement build
    return Scaffold(
      appBar: temp_appBar(context),
      drawer: const Sidebar(),
      body: RawKeyboardListener(
        focusNode: fn,
        onKey: handleKey,
        child: Container(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              temp_headerSearch('Kelola Pelanggan',
                  Row(
                    children: [
                      eCheckbox('Nama', true, checkData),
                      eCheckbox('Grup', true, checkData),
                      eCheckbox('Alamat', true, checkData),
                      eCheckbox('Email', true, checkData),
                      eCheckbox('No Hp', true, checkData)
                    ],
                  ),
                  refreshData
              ),
              const SizedBox(height: 10,),
              Expanded(
                child: table(l_pelanggan),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                height: 50,
                child: Row(
                  children: [
                    ElevatedButton(onPressed: (){}, child: const Text('Tambah')),
                    ElevatedButton( style : ElevatedButton.styleFrom(backgroundColor: Colors.yellow), onPressed: (){}, child: const Text('Tambah')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  checkData() async{
    if( init_db_checkIfAllLoaded() ){
      l_pelanggan = getList_byName('pelanggan');
      setState(() {
        refreshData();
      });
    }
  }

  refreshData(){
    setState((){});
    print('executed');
  }

  handleKey(RawKeyEvent key) {
    if (key.runtimeType.toString() == 'RawKeyDownEvent') {
      if( key.logicalKey == LogicalKeyboardKey.arrowUp ){
        if( selectedPos != 0 ){
          setState(() {
            selectedPos--;
            for( var i=0; i<selectedIndex.length; i++){
              if( i==selectedPos ){
                selectedIndex[i] = true;
              }else{
                selectedIndex[i] = false;
              }
            }
          });
        }
      }
      if( key.logicalKey == LogicalKeyboardKey.arrowDown ){
        if( selectedPos != l_pelanggan.length-1 ){
          setState(() {
            selectedPos++;
            setFocus(selectedPos);
          });
        }
      }
    }
  }
}
var globalContext;
List<bool> selectedIndex = [];
List<dynamic> l_pelanggan = [];
int selectedPos = 0;

setFocus(int pos){
  for( var i=0; i<selectedIndex.length; i++){
    if( i==pos ){
      selectedIndex[i] = true;
    }else{
      selectedIndex[i] = false;
    }
  }
}

class table extends StatefulWidget {
  var d;
  table(List<dynamic> d);
  @override
  State<table> createState() => _tableState();
}

class _tableState extends State<table> {
  @override
  Widget build(BuildContext context) {
    return setRow();
  }

  setRow(){
    l_pelanggan = getList_byName('pelanggan');
    for( var d in l_pelanggan ){
      selectedIndex.add(false);
    }
    var l_pelangganGrup = getList_byName('pelanggan_grup');
    var col = ['ID', 'Grup', 'Nama', 'Alamat', 'Email', 'No Hp'];
    var cellPadding = 2.0;
    List<DataRow> l_rows = [];
    List<DataColumn> l_columns = [];
    for( var d in col ){
      l_columns.add(
          DataColumn(
            label:
            Expanded(
              child: Text( d, style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          )
      );
    }
    for( var i=0; i<l_pelanggan.length; i++){
      Map<String, dynamic> map = jsonDecode(l_pelanggan[i]['json']);
      var alamat = "Alamat Singkat : "+json_stringNullCheck(map['alamatSingkat'])+"\nAlamat Lengkap : \n"+parseLongText(json_stringNullCheck(map['alamatLengkap']));
      if( tf_search_header.text != "" ){
        var passed = true;
        if( l_pelanggan[i]['nama'] != tf_search_header.text ){
          passed = false;
        }
        print(passed);
        if( passed ){
          l_rows.add(DataRow(
              selected: selectedIndex[i],
              onSelectChanged: (bool? b){
                setState((){
                  selectedPos = i;
                  setFocus(selectedPos);
                  print(selectedPos);
                });
              },
              cells: [
                DataCell(Text(l_pelanggan[i]['id'])),
                DataCell(Text(list_getValue(l_pelangganGrup, 'id', l_pelanggan[i]['id_pelangganGrup'], 'nama'))),
                DataCell(Text(l_pelanggan[i]['nama'])),
                DataCell(Text(alamat)),
                DataCell(Text(json_stringNullCheck(map['email']))),
                DataCell(Text(json_stringNullCheck(map['nohp']))),
              ]));
        }
      }else{
        l_rows.add(DataRow(
            selected: selectedIndex[i],
            onSelectChanged: (bool? b){
              setState((){
                selectedPos = i;
                setFocus(selectedPos);
                print(selectedPos);
              });
            },
            cells: [
              DataCell(Text(l_pelanggan[i]['id'])),
              DataCell(Text(list_getValue(l_pelangganGrup, 'id', l_pelanggan[i]['id_pelangganGrup'], 'nama'))),
              DataCell(Text(l_pelanggan[i]['nama'])),
              DataCell(Text(alamat)),
              DataCell(Text(json_stringNullCheck(map['email']))),
              DataCell(Text(json_stringNullCheck(map['nohp']))),
            ]));
      }
    }
    return DataTable(
      onSelectAll: (val){

      },
      columns: l_columns,
      rows: l_rows,
    );
  }
}

/*
child: FutureBuilder(
future: refreshUi(),
builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
rWidget(){
return Center(
child: Container(
child: Column(
children: const [
SizedBox(
width: 60,
height: 60,
child: CircularProgressIndicator(),
),
Padding(
padding: EdgeInsets.only(top: 16),
child: Text('Memuat data . . .'),
),
],
)
),
);
}
if( snapshot.data == true ){
return setRow();
}else{
return rWidget();
}
},
),
 */