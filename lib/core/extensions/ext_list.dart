extension ExtList<E> on List<E>? {
  E? getByIndex(int index) {
    try {
      return this?[index];
    } catch (_) {
      return null;
    }
  }
}
