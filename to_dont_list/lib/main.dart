// Started with https://docs.flutter.dev/development/ui/widgets-intro
import 'package:flutter/material.dart';
import 'package:to_dont_list/objects/books.dart';
import 'package:to_dont_list/widgets/book_list_item.dart';
import 'package:to_dont_list/widgets/book_dialog.dart';

class BookList extends StatefulWidget {
  const BookList({super.key});

  @override
  State createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  final List<Books> books = [const Books(title: "add more books")];
  void _handleListChanged(Books book, BookStatus newStatus) {
    setState(() {
      // When a user changes what's in the list, you need
      // to change _itemSet inside a setState call to
      // trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.

      final index = books.indexOf(book);
      books[index] = book.copyWith(status: newStatus);
    });
  }

  void _handleDeleteItem(Books book) {
    setState(() {
      print("Deleting item");
      books.remove(book);
    });
  }

  void _handleNewBook(String title, TextEditingController textController) {
    setState(() {
      print("Adding new item");
    //bug fix: change itemText to a string var not literal string
    //remove const so it can change
      books.insert(0, Books(title: title));
      textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Book List'),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: books.map((book) {
            return BookListItem(
              book: book,
              onStatusChanged: _handleListChanged,
              onDeleteItem: _handleDeleteItem,
            );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return BookDialog(onListAdded: _handleNewBook);
                  });
            }));
  }
}

void main() {
  runApp(const MaterialApp(
    title: 'Book List',
    home: BookList(),
  ));
}
