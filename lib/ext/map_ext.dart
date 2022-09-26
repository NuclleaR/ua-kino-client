extension MagGetStri<K, V extends String> on Map<K, V> {
  String getString(K key) {
    return this[key] ?? "";
  }
}

extension MagGet<K, V> on Map<K, V> {
  V? get(K key) {
    return this[key];
  }
}
