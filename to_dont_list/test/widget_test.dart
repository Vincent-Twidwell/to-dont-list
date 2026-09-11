// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:to_dont_list/main.dart';
import 'package:to_dont_list/objects/books.dart';
import 'package:to_dont_list/widgets/book_dialog.dart';
import 'package:to_dont_list/widgets/book_list_item.dart';

void main() {
  test('Color matches each status', () {
      expect(BookStatus.unopened.color, Colors.blue);
      expect(BookStatus.started.color, Colors.yellow);
      expect(BookStatus.finished.color, Colors.green);
    });

  test('Next cycles from: unopened -> started -> finished -> unopened', () {
      expect(BookStatus.unopened.next, BookStatus.started);
      expect(BookStatus.started.next, BookStatus.finished);
      expect(BookStatus.finished.next, BookStatus.unopened);
    });

  test('CopyWith changes only the specified field', () {
      const book = Books(title: "Dune", author: "Herbert");

      final statusChanged = book.copyWith(status: BookStatus.started);
      expect(statusChanged.title, "Dune");
      expect(statusChanged.author, "Herbert");
      expect(statusChanged.status, BookStatus.started);

      final titleChanged = book.copyWith(title: "Dune Messiah");
      expect(titleChanged.title, "Dune Messiah");
      expect(titleChanged.author, "Herbert");
      expect(titleChanged.status, BookStatus.unopened);
    });
  testWidgets('CircleAvatar shows correct word and color per status',
        (tester) async {
      Future<void> pumpWithStatus(BookStatus status) => tester.pumpWidget(
            MaterialApp(
                home: Scaffold(
                    body: BookListItem(
              book: Books(title: "test", status: status),
              onStatusChanged: (Books book, BookStatus s) {},
              onDeleteItem: (Books book) {},
            ))),
          );

      await pumpWithStatus(BookStatus.unopened);
      CircleAvatar circ = tester.firstWidget(find.byType(CircleAvatar));
      Text ctext = circ.child as Text;
      expect(circ.backgroundColor, Colors.blue);
      expect(ctext.data, "new");

      await pumpWithStatus(BookStatus.started);
      circ = tester.firstWidget(find.byType(CircleAvatar));
      ctext = circ.child as Text;
      expect(circ.backgroundColor, Colors.yellow);
      expect(ctext.data, "reading");

      await pumpWithStatus(BookStatus.finished);
      circ = tester.firstWidget(find.byType(CircleAvatar));
      ctext = circ.child as Text;
      expect(circ.backgroundColor, Colors.green);
      expect(ctext.data, "read");
    });

  testWidgets('Tapping the tile advances status via onStatusChanged',
        (tester) async {
      Books? changedBook;
      BookStatus? newStatus;

      await tester.pumpWidget(MaterialApp(
        //made changes to theme for several test as this one specific error regarding splashFactory prevented progress
        //I suspect this is a error with flutter at the time, as I have found many others with the same issue
          theme: ThemeData(splashFactory: InkRipple.splashFactory),
          home: Scaffold(
              body: BookListItem(
        book: const Books(title: "test"),
        onStatusChanged: (Books book, BookStatus status) {
          changedBook = book;
          newStatus = status;
        },
        onDeleteItem: (Books book) {},
      ))));

      await tester.tap(find.byType(ListTile));
      await tester.pump();

      expect(changedBook?.title, "test");
      expect(newStatus, BookStatus.started);
    });

  testWidgets('OK button passes title and author to callback',
        (tester) async {
      String? capturedTitle;
      String? capturedAuthor;

      await tester.pumpWidget(MaterialApp(
        theme: ThemeData(splashFactory: InkRipple.splashFactory),
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => BookDialog(
                  onListAdded: (title, author, tc, ac) {
                    capturedTitle = title;
                    capturedAuthor = author;
                  },
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'Dune');
      await tester.enterText(find.byType(TextField).last, 'Herbert');
      await tester.pump();

      await tester.tap(find.byKey(const Key("OKButton")));
      await tester.pumpAndSettle();

      expect(capturedTitle, 'Dune');
      expect(capturedAuthor, 'Herbert');
    });
    
    testWidgets('Clicking and typing adds a book to the list',
        (tester) async {
      await tester.pumpWidget(MaterialApp(theme: ThemeData(splashFactory: InkRipple.splashFactory),home: const BookList()));

      expect(find.byType(TextField), findsNothing);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
      expect(find.text("hi"), findsNothing);

      await tester.enterText(find.byType(TextField).first, 'hi');
      await tester.pump();
      expect(find.text("hi"), findsOneWidget);

      await tester.tap(find.byKey(const Key("OKButton")));
      await tester.pump();
      expect(find.text("hi"), findsOneWidget);

      expect(find.byType(BookListItem), findsNWidgets(2));
    });
}
