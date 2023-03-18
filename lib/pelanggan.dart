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
FocusNode fn_table = FocusNode();
class Pelanggan extends StatefulWidget{
  @override
  _PelangganState createState() => _PelangganState();
}

class _PelangganState extends State<Pelanggan>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkSession(context);
    init_db('pelanggan');
    init_db('pelanggan_grup');
    init_db_loadAll(checkData);
  }

  Color colorTable = Colors.red;
  List<dynamic> list_checkbox = [
    {'nama' : 'Nama', 'value' : true},
    {'nama' : 'Grup', 'value' : true},
    {'nama' : 'Alamat', 'value' : true},
    {'nama' : 'Email', 'value' : true},
    {'nama' : 'No Hp', 'value' : true},
  ];

  @override
  Widget build(BuildContext context) {
    globalContext = context;
    checkSession(context);
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Pelanggan', style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Row(
                        children: checkbox_group(),
                      ),
                      SizedBox(
                        width: 150,
                        child: TextField(
                          onTapOutside: (PointerDownEvent pde){
                            refreshData();
                          },
                          onEditingComplete: (){
                            refreshData();
                          },
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.search)
                          ),
                        ),
                      ),
                    ]
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      colorTable = Colors.lightBlueAccent;
                    });
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: colorTable)
                      ),
                      child: table()),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                height: 50,
                child: Row(
                  children: [
                    ElevatedButton(onPressed: (){}, child: const Text('Tambah')),
                    const SizedBox(width: 5,),
                    ElevatedButton( style : ElevatedButton.styleFrom(backgroundColor: Colors.orange), onPressed: (){}, child: const Text('Update')),
                    const SizedBox(width: 5,),
                    ElevatedButton( style : ElevatedButton.styleFrom(backgroundColor: Colors.red), onPressed: (){}, child: const Text('Hapus')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  checkbox_group(){
    List<Widget> value = [];
    for( var i=0; i<list_checkbox.length; i++ ){
      value.add(checkbox(i));
    }
    return value;
  }
  Widget checkbox(int pos){
    return Row(
      children: [
        Text(list_checkbox[pos]['nama'], style: const TextStyle(fontStyle: FontStyle.italic),),
        Padding(
          padding: const EdgeInsets.fromLTRB(10,  0, 0, 0),
          child: Checkbox(
              value: list_checkbox[pos]['value'],
              onChanged: (bool? value){
                setState((){
                  list_checkbox[pos]['value'] = value!;
                  refreshData();
                });
              }
          ),
        )
      ],
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
  @override
  State<table> createState() => _tableState();
}

class _tableState extends State<table> {
  var col = ['ID', 'Grup', 'Nama', 'Alamat', 'Email', 'No Hp'];
  List<DataColumn> l_columns = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

  }
  @override
  Widget build(BuildContext context) {
    if(l_pelanggan.isNotEmpty){
      return setRow();
    }else{
      return Column(children: [
        DataTable(columns: l_columns, rows: []),
        SizedBox(height: 30,),
        CircularProgressIndicator(),
        SizedBox(height: 10,),
        Text('Memuat data . . .')
      ],);
    }
  }

  setRow(){
    for( var d in l_pelanggan ){
      selectedIndex.add(false);
    }
    var l_pelangganGrup = getList_byName('pelanggan_grup');
    List<DataRow> l_rows = [];
    for( var i=0; i<l_pelanggan.length; i++){
      Map<String, dynamic> map = jsonDecode(l_pelanggan[i]['json']);
      var alamat = "Alamat Singkat : "+json_stringNullCheck(map['alamatSingkat'])+"\nAlamat Lengkap : \n"+parseLongText(json_stringNullCheck(map['alamatLengkap']));
      if( tf_search_header.text != "" ){
        var passed = true;
        if( l_pelanggan[i]['nama'] != tf_search_header.text ){
          passed = false;
        }
        if( passed ){
          l_rows.add(DataRow(
              selected: selectedIndex[i],
              onSelectChanged: (bool? b){
                setState((){
                  selectedPos = i;
                  setFocus(selectedPos);
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