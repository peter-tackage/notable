import 'package:notable/data/base_entity.dart';
import 'package:notable/data/provider.dart';

// Higher level modelling, may combine multiple data Providers
class Repository<T extends BaseEntity> {
  final Provider _provider;

  Repository(this._provider);

  Future<List<T>> getAll() async {
    return _provider.getAll();
  }

  Future<T> get(String id) async {
    return _provider.get(id);
  }

  Future<T> save(T entity) async {
    if (entity.id == null) {
      return _provider.add(entity);
    } else {
      return _provider.update(entity);
    }
  }

  Future<T> delete(String id) async {
    return _provider.delete(id);
  }
}
