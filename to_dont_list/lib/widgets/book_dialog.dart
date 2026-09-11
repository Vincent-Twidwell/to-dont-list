import 'package:flutter/material.dart';

typedef BookListAddedCallback = Function(
    String title, String author, TextEditingController titleController, TextEditingController authorController);

class BookDialog extends StatefulWidget {
  const BookDialog({
    super.key,
    required this.onListAdded,
  });

  final BookListAddedCallback onListAdded;

  @override
  State<BookDialog> createState() => _BookDialogState();
}

class _BookDialogState extends State<BookDialog> {
  // Dialog with text from https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.green);
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.red);

  String titleText = "";
  String authorText = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Book To Add'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
        onChanged: (value) {
          setState(() {
            titleText = value;
          });
        },
        controller: _titleController,
        decoration: const InputDecoration(hintText: "Book title"),
      ),
          TextField(
            onChanged: (value) {
              setState(() {
                authorText = value;
              });
            },
            controller: _authorController,
            decoration: const InputDecoration(hintText: "Author name"),
          )
        ],
      ),
      
      actions: <Widget>[
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _titleController,
          builder: (context, value, child) {
            return ElevatedButton(
          //bug fix: spelling Ok - > OK
            key: const Key("OKButton"),
            style: yesStyle,
            onPressed: value.text.isNotEmpty
            ? () {
              setState(() {
              //here*
                widget.onListAdded(titleText, authorText, _titleController, _authorController);
                Navigator.pop(context);
              });
          }
        : null,
        child: const Text('OK'),
        );
      },
    ),
        // https://stackoverflow.com/questions/52468987/how-to-turn-disabled-button-into-enabled-button-depending-on-conditions
        ElevatedButton(
          key: const Key("CancelButton"),
          style: noStyle,
          child: const Text('Cancel'),
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
        ),
      ],
    );
  }
}
