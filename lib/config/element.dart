import 'package:flutter/material.dart';
import 'dimens.dart' as dm;

Widget eElevatedButton(String text, Function fn, [Color? clr]){
  if( clr == null ){
    return ElevatedButton(
      onPressed: (){
        fn();
      }, child: Text(text),);
  }else{
    return ElevatedButton(
      onPressed: (){
        fn();
      }, style: ElevatedButton.styleFrom(backgroundColor: clr), child: Text(text),);
  }
}

class eCheckbox extends StatefulWidget {
  final String text;
  bool value;
  final Function fn_onChange;
  eCheckbox(this.text, this.value, this.fn_onChange, {super.key});

  @override
  State<eCheckbox> createState() => _eCheckboxState();
}

class _eCheckboxState extends State<eCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.text, style: const TextStyle(fontStyle: FontStyle.italic),),
        Padding(
          padding: const EdgeInsets.fromLTRB(10,  0, 0, 0),
          child: Checkbox(
              value: widget.value,
              onChanged: (bool? value){
                setState((){
                  widget.value = value!;
                  widget.fn_onChange();
                });
              }
          ),
        )
      ],
    );
  }
}