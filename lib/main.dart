import 'package:flutter/material.dart';
import 'config/string.dart' as str;
import 'config/color.dart' as clr;
import 'config/template.dart';
import 'config/sidebar.dart';


void main(){
  runApp(Main());
}

class Main extends StatefulWidget{
  @override
  _MainState createState() => _MainState();
}
class _MainState extends State<Main>{
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
          const temp_headerDefault('Dashboard'),
          Row()
        ],
      ),
    );
  }
}