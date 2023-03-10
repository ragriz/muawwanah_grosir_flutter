import 'package:flutter/material.dart';
import 'config/string.dart' as str;
import 'config/color.dart' as clr;

void main(){
  runApp(const MyApp());
}
class MyApp extends StatelessWidget{
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: str.title,
      theme: ThemeData(
        primarySwatch: clr.primary,
      ),
    );
  }
}
class Page extends StatefulWidget {
  Page({super.key, required this.title});
  final String title;

  @override
  State<Page> createState() => _PageState();
}
class _PageState extends State<Page>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                child: Text('Halaman : Dashboard')
            ),
            ListTile(
              title: Text('Dashboard'),
              onTap: (){},
            ),
            ListTile(
              title: Text('Dashboard'),
              onTap: (){},
            ),
            ListTile(
              title: Text('Dashboard'),
              onTap: (){},
            ),
            ListTile(
              title: Text('Dashboard'),
              onTap: (){},
            ),
            ListTile(
              title: Text('Dashboard'),
              onTap: (){},
            ),
            ListTile(
              title: Text('Dashboard'),
              onTap: (){},
            ),
          ],
        ),
      ),
    );
  }
}