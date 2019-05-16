import 'dart:async';

import 'package:notable/data/base_entity.dart';

class Provider<T extends BaseEntity> {
  final Map<String, T> _store = Map();

  Future<List<T>> getAll() async {
    return _store.values.toList();
  }

  Future<T> get(String id) async {
    return _store[id];
  }

  Future<T> add(T entity) async {
    assert(entity.id == null); // shouldn't already have an id

    T initializedEntity = entity.onPersist();
    return _store.putIfAbsent(initializedEntity.id, () => initializedEntity);
  }

  Future<T> update(T entity) async {
    assert(entity.id != null); // must already have an id

    // Replace the item entirely
    return _store.update(entity.id, (__) => entity.onUpdate());
  }

  Future<T> delete(String id) async {
    return _store.remove(id);
  }
}
