import 'package:flutter/material.dart';
import 'package:muawwanah_grosir_flutter/config/string.dart';

var titleFontSize = 24.0;
var searchFieldSize = 150.0;

temp_appBar(BuildContext context){
  return AppBar(
      title: Text(title),
      actions: [
        IconButton(
          icon: const Icon(Icons.message),
          tooltip: 'Pesan',
          onPressed: () {

          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications),
          tooltip: 'Notifikasi',
          onPressed: () {

          },
        ),
      ],
  );
}

class temp_headerDefault extends StatelessWidget {
  final String text;
  const temp_headerDefault(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold));
  }
}


TextEditingController tf_search_header = TextEditingController();
class temp_headerSearch extends StatelessWidget {
  final String text;
  final Function fc_search;
  final Widget sw_checkbox;
  const temp_headerSearch(this.text, this.sw_checkbox, this.fc_search);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text, style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold)),
        Row(
          children: [
            const Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Text('Filter : ', style : TextStyle(fontWeight: FontWeight.bold)),
            ),
            sw_checkbox,
            SizedBox(
              width: searchFieldSize,
              child: TextField(
                controller: tf_search_header,
                onTapOutside: (PointerDownEvent e){
                  fc_search();

                },
                onEditingComplete: (){
                  fc_search();
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search)
                ),
              ),
            ),
          ],
        ),
    ],);
  }
}