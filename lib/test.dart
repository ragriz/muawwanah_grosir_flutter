import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() =>
      _TestState();
}

class _TestState extends State<Test> {
  final FocusScopeNode _node = FocusScopeNode();
  final FocusScopeNode _node2 = FocusScopeNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _node.dispose();
    _node2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _formKey,
      body: Column(
        children: [
          FocusScope(
            node: _node,
            child: Container(
              color: Colors.green,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // email
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'john@doe.com',
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    // move to the next field
                    onEditingComplete: _node.nextFocus,
                  ),
                  // password
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    // move to the next field
                    onEditingComplete: _node.nextFocus,
                  ),
                  // submit
                  ElevatedButton(
                    child: Text('Sign In'),
                    onPressed: () {
                      _node.nextFocus();},
                  ),
                ],
              ),
            ),
          ),
          FocusScope(
            parentNode: _node,
            node: _node2,
            child: Container(
              color: Colors.red,
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    onEditingComplete: _node2.nextFocus,
                  ),
                  TextField(
                    onEditingComplete: _node2.nextFocus,
                  ),
                  TextField(
                    onEditingComplete: _node2.previousFocus,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}