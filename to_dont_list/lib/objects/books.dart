// Data class to keep the string and have an abbreviation function

import 'package:flutter/material.dart';

enum BookStatus {unopened, started, finished}

extension BookStatusX on BookStatus {
  Color get color {
    switch (this) {
      case BookStatus.unopened:
        return Colors.blue;
      case BookStatus.started:
        return Colors.yellow;
      case BookStatus.finished:
        return Colors.green;
    }
  }

  BookStatus get next {
    switch (this) {
      case BookStatus.unopened:
        return BookStatus.started;
      case BookStatus.started:
        return BookStatus.finished;
      case BookStatus.finished:
        return BookStatus.unopened;
    }
  }
}

class Books {
  const Books({required this.title, this.author = "", this.status = BookStatus.unopened});
  final String title;
  final String author;
  final BookStatus status;

  //Bug Fix 1: Changed from (0,2) -> (0,1) as to get only first char
  String getStatus() {
    switch (status) {
      case BookStatus.unopened:
        return "new";
      case BookStatus.started:
        return "reading";
      case BookStatus.finished:
        return "read";
    }
  }

  //the function creates a new book since title and status and title are final
Books copyWith({String? title, String? author, BookStatus? status}) {
  String newTitle = this.title;
  if (title != null) {
    newTitle = title;
  }

  String newAuthor = this.author;
  if (author != null) {
    newAuthor = author;
  }

  BookStatus newStatus = this.status;
  if (status != null) {
    newStatus = status;
  }

  return Books(title: newTitle, author: newAuthor, status: newStatus);
}
  
}
