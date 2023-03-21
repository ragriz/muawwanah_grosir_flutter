import 'package:flutter/material.dart';
import 'config/string.dart' as str;
import 'config/template.dart';
import 'config/sidebar.dart';

class Test2 extends StatefulWidget{
  @override
  _Test2State createState() => _Test2State();
}
class _Test2State extends State<Test2>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  int value = 0;
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
          Center(
            child: myText(key: UniqueKey(), value.toString()),
          ),
          Center(
            child: ElevatedButton(
              onPressed: (){
                value++;
              },
              child: const Text('Click Me !'),
            ),
          )
        ],
      ),
    );
  }
}


class myText extends StatefulWidget{
  const myText(this.value, {super.key});
  final String value;
  @override
  _myTextState createState() => _myTextState();
}

class _myTextState extends State<myText>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text(widget.value);
  }
}