// Data class to keep the string and have an abbreviation function

class Item {
  const Item({required this.name});

  final String name;

  //Bug Fix 1: Changed from (0,2) -> (0,1) as to get only first char
  String abbrev() {
    return name.substring(0, 1);
  }
}
