import 'dart:async';

import 'package:meta/meta.dart';
import 'package:notable/data/base_entity.dart';
import 'package:notable/storage/file_storage.dart';

class Provider<T extends BaseEntity> {
  final Map<String, T> _store = Map();
  final EntityStorage<T> storage;

  Provider({@required this.storage}) {
    _init();
  }

  Future<List<T>> getAll() async {
    return _store.values.toList();
  }

  Future<T> get(String id) async {
    return _store[id];
  }

  Future<T> add(T entity) async {
    assert(entity.id == null); // shouldn't already have an id

    T initializedEntity = entity.onPersist();
    final result = _store.putIfAbsent(initializedEntity.id, () => initializedEntity);
    writeToStorage();
    return result;
  }

  Future<T> update(T entity) async {
    assert(entity.id != null); // must already have an id

    // Replace the item entirely
    final result = _store.update(entity.id, (__) => entity.onUpdate());
    writeToStorage();
    return result;
  }

  Future<T> delete(String id) async {
    final result = _store.remove(id);
    writeToStorage();
    return result;
  }

  void _init() async {
    await addFromStorage();
  }

  Future addFromStorage() async {
    List<T> entities = await storage.readAll();
    _store.addAll(
        Map.fromEntries(entities.map((entity) => MapEntry(entity.id, entity))));
  }

  Future writeToStorage() async {
    await storage.writeAll(_store.values.toList());
  }
}
