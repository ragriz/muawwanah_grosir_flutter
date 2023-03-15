import 'package:flutter/material.dart';
import 'dimens.dart' as dm;

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
        Text(widget.text),
        Padding(
          padding: const EdgeInsets.fromLTRB(10,  0, 0, 0),
          child: Checkbox(
              value: widget.value,
              onChanged: (bool? value){
                setState((){
                  widget.value = value!;
                  print(value!);
                  widget.fn_onChange();
                });
              }
          ),
        )
      ],
    );
  }
}