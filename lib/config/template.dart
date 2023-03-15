import 'package:flutter/material.dart';

var titleFontSize = 24.0;
var searchFieldSize = 150.0;

class temp_headerDefault extends StatelessWidget {
  final String text;
  const temp_headerDefault(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold));
  }
}

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
            sw_checkbox,
            SizedBox(
              width: searchFieldSize,
              child: TextField(
                onChanged: (String? value){
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