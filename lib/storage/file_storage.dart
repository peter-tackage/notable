import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:notable/data/base_entity.dart';
import 'package:notable/storage/entity_mapper.dart';

abstract class EntityStorage<E> {
  Future<File> writeAll(List<E> entities);

  Future<List<E>> readAll();

  Future<FileSystemEntity> clean();
}

class FileStorage<E extends BaseEntity> implements EntityStorage<E> {
  final String tag;
  final Future<Directory> Function() getDirectory;
  final EntityMapper<E> entityMapper;

  FileStorage(
      {@required this.tag,
      @required this.getDirectory,
      @required this.entityMapper});

  @override
  Future<File> writeAll(List<E> entities) async {
    final file = await _getLocalFile();
    return file.writeAsString(jsonEncode(entities));
  }

  @override
  Future<List<E>> readAll() async {
    File file = await _getLocalFile();
    print(file.toString());

    if (await file.exists()) {
      final string = await file.readAsString();
      final json = jsonDecode(string);
      List<E> entities = List.from(
          json.map((entityJson) => entityMapper.toEntity(entityJson)));
      return entities;
    } else {
      return List<E>();
    }
  }

  Future<File> _getLocalFile() async {
    final dir = await getDirectory();
    return File('${dir.path}${Platform.pathSeparator}Notable__$tag.json');
  }

  Future<FileSystemEntity> clean() async {
    final file = await _getLocalFile();
    return file.delete();
  }
}
