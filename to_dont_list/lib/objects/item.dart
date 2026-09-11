// Data class to keep the string and have an abbreviation function

import 'package:flutter/material.dart';

enum BookStatus {unopened, started, finished}

extension BookStatusX on BookStatus {
  Color get color {
    switch (this) {
      case BookStatus.unopened:
        return Colors.grey;
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

class Item {
  const Item({required this.name, this.status = BookStatus.unopened});

  final String name;
  final BookStatus status;

  //Bug Fix 1: Changed from (0,2) -> (0,1) as to get only first char
  String abbrev() {
    return name.substring(0, 1);
  }

  
}
