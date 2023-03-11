import 'package:flutter/material.dart';

class temp_headerDefault extends StatelessWidget {
  final String text;
  const temp_headerDefault(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold));
  }
}

class temp_headerSearch extends StatelessWidget {
  final String text;
  final Function fc_search;
  final StatelessWidget sw_checkbox;
  const temp_headerSearch(this.text, this.sw_checkbox, this.fc_search);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
      Text(text, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        sw_checkbox,
        TextField(
          onChanged: fc_search(),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search)
          ),
        ),
    ],);
  }
}