extension MyIterable<E> on Iterable<E> {
  Iterable<E> sortedAscBy(Comparable key(E e)) => toList()..sort((a, b) => key(a).compareTo(key(b)));
  Iterable<E> sortedDescBy(Comparable key(E e)) => toList()..sort((a, b) => key(a).compareTo(key(b)));
}
