import 'package:flutter/material.dart';

//Our MyApp. Extends StatelessWidget
class WritePage extends StatefulWidget {
  static final String routeName = 'write_page';

  //BuildContext represents a handle to the location of a widget in the widget tree.
  @override
  _WritePageState createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter TextFields',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        //Whether the body (and other floating widgets) should size themselves
        // to avoid the window's bottom padding.
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: const Text('글쓰기'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text('글을 입력하세요'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MrMultiLineTextFieldAndButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Displays text in a snackbar
_showInSnackBar(BuildContext context, String text) {
  Scaffold.of(context).showSnackBar(SnackBar(content: Text(text),));
}

/// Multi-line text field widget with a submit button
/// `StatefulWidegt` is a widget that has mutable state.
class MrMultiLineTextFieldAndButton extends StatefulWidget {
  MrMultiLineTextFieldAndButton({Key key}) : super(key: key);

  @override
  createState() => _TextFieldAndButtonState();
}

// State is information that can be read synchronously when the widget is built and that might change during the lifetime of the widget.
// It is the logic and internal state for a `StatefulWidget`.
class _TextFieldAndButtonState extends State<MrMultiLineTextFieldAndButton> {
  //`TextEditingController` A controller for an editable text field.
  // Whenever the user modifies a text field with an associated `TextEditingController`,
  //the text field updates value and the controller notifies its listeners.
  final TextEditingController _multiLineTextFieldcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      //color: Colors.grey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _multiLineTextFieldcontroller,
            maxLines: 10,
            maxLength: 500,
            decoration: InputDecoration(
              hintText: '글 입력 후 저장하기를 누르세요',
            ),
            onChanged: (str) => print('Multi-line text change: $str'),
            onSubmitted: (str) => print('This will not get called when return is pressed'),
          ),
          SizedBox(height: 10.0),
          FlatButton(
            onPressed: () => _showInSnackBar(context,'${_multiLineTextFieldcontroller.text}',),
            child: const Text('저장하기'),
          ),
        ],
      ),
    );
  }
}
