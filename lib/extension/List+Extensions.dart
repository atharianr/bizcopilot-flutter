extension ListSortingExtension<T> on List<T> {
  void sortBy<K extends Comparable>(K Function(T element) keySelector, {
    bool descending = false,
  }) {
    sort((a, b) {
      final aKey = keySelector(a);
      final bKey = keySelector(b);
      final cmp = aKey.compareTo(bKey);
      return descending ? -cmp : cmp;
    });
  }

  List<T> sortedBy<K extends Comparable>(K Function(T element) keySelector, {
    bool descending = false,
  }) {
    final copy = List<T>.from(this);
    copy.sortBy(keySelector, descending: descending);
    return copy;
  }
}