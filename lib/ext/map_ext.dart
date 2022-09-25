extension MagGet<K, V extends String> on Map<K, V> {
  String getString(K key) {
    return this[key] ?? "";
  }
}
