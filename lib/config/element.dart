import 'package:flutter/material.dart';
import 'dimens.dart' as dm;

class eCheckbox extends StatelessWidget {
  final String text;
  final bool value;
  final Function fn_onChange;
  const eCheckbox(this.text, this.value, this.fn_onChange);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(text),
        Padding(
          padding: const EdgeInsets.fromLTRB(10,  0, 0, 0),
          child: Checkbox(
              value: value,
              onChanged: fn_onChange()
          ),
        )
      ],
    );
  }
}