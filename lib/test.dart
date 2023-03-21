import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hovering/hovering.dart';
import 'package:muawwanah_grosir_flutter/config/global.dart';
import 'config/string.dart' as str;
import 'config/color.dart' as clr;
import 'config/sidebar.dart';
import 'config/element.dart';
import 'config/template.dart';

FocusNode fn = FocusNode();
FocusNode fn_table = FocusNode();
FocusNode fn_search = FocusNode();
bool isTableFocused = false;
bool isHover_table = false;
class Test extends StatefulWidget{
  @override
  _TestState createState() => _TestState();
}
Color colorTable = Colors.red;
class _TestState extends State<Test>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkSession(context);
    init_db('pelanggan');
    init_db('pelanggan_grup');
    init_db_loadAll(checkData);
    fn.requestFocus();
  }

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
        child: GestureDetector(
          onTap: (){
            if( isHover_table ){
              colorTable = Colors.blueAccent;
              isTableFocused = true;
              setFocus(selectedPos);
            }else{
              colorTable = Colors.red;
              isTableFocused = false;
              clearFocusTable();
            }
            print('isHover_table : '+isHover_table.toString());
            print('colorTable : '+colorTable.toString());
            print('isTableFocused : '+isTableFocused.toString());
            setState((){});
          },
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.transparent)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Row(
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
                                focusNode: fn_search,
                                onTapOutside: (PointerDownEvent pde){
                                  refreshData();
                                  fn_search.unfocus();
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
                ),
                const SizedBox(height: 10,),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: colorTable)
                    ),
                    child: MouseRegion(
                        onEnter: (PointerEvent){
                          isHover_table = true;
                        },
                        onExit: (PointerEvent){
                          isHover_table = false;
                        },
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
                  isTableFocused = true;
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
      if( isTableFocused ){
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

clearFocusTable(){
  for( var i=0; i<selectedIndex.length; i++ ){
    selectedIndex[i] = false;
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
  var colorTest;

  setRow(){
    for( var d in l_pelanggan ){
      selectedIndex.add(false);
    }
    var l_pelangganGrup = getList_byName('pelanggan_grup');
    List<TableCell> l_rowsHeader = [];
    List<TableRow> l_rows = [];
    for( var d in col){
      l_rowsHeader.add(TableCell(
        child: Container(
            color: Colors.black,
            child: Text(d, style: const TextStyle(color : Colors.white))),
      ));
    }
    l_rows.add(TableRow(
      children: l_rowsHeader
    ));
    List<Widget> l_rows_child = [];
    for( var i=0; i<l_pelanggan.length; i++){
      Map<String, dynamic> map = jsonDecode(l_pelanggan[i]['json']);
      var alamat = "Alamat Singkat : "+json_stringNullCheck(map['alamatSingkat'])+"\nAlamat Lengkap : \n"+parseLongText(json_stringNullCheck(map['alamatLengkap']));
      if( tf_search_header.text != "" ){
        var passed = true;
        if( l_pelanggan[i]['nama'] != tf_search_header.text ){
          passed = false;
        }
        if( passed ){
          l_rows.add(
            TableRow(
              children: [
                TableCell(
                  child: MouseRegion(
                    onEnter: (PointerEvent e){
                      colorTest = Colors.blueAccent.withAlpha(50);
                    },
                      onExit: (PointerExitEvent e){
                        colorTest = Colors.white;
                      },
                      child: Container(
                        color: colorTest,
                          child: Text(l_pelanggan[i]['id']))),
                ),
                TableCell(
                  child: Text('text'),
                ),
                TableCell(
                  child: Text('Text'),
                ),
                TableCell(
                  child: Text('Text'),
                ),
                TableCell(
                  child: Text('Text'),
                ),
                TableCell(
                  child: Text('Text'),
                ),
              ]
            )
          );
        }
      }else{
        print('not passed');
        l_rows.add(
            TableRow(
                children: [
                  cell(i, l_pelanggan[i]['id']),
                  cell(i, list_getValue(l_pelangganGrup, 'id', l_pelanggan[i]['id_pelangganGrup'], 'nama')),
                  cell(i, l_pelanggan[i]['nama']),
                  cell(i, alamat),
                  cell(i, json_stringNullCheck(map['email'], '-')),
                  cell(i, json_stringNullCheck(map['nohp'], '-')),
                ]
            )
        );
      }
    }
    return Table(
      border: TableBorder.all(),
      children: l_rows,
    );
  }
}
addRow(){

}

class cell extends StatefulWidget {
  String value;
  int pos;
  cell(this.pos, this.value, {super.key});
  @override
  State<cell> createState() => _cellState();
}

class _cellState extends State<cell> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if( widget.pos%2 == 0 ){
      colorBg = Colors.black.withOpacity(0.5);
    }else{
      colorBg = Colors.white;
    }
  }

  var colorTest;
  var colorBg;

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: GestureDetector(
        onTap : (){
          toast(context, widget.value);
        },
        child: Container(
          height: 17,
            color: colorBg,
            child: Text(widget.value, overflow: TextOverflow.ellipsis,)),
      ),
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