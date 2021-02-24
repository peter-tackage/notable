import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

abstract class BaseEntity {
  String id;
  DateTime updatedDate;

  BaseEntity({this.id, this.updatedDate});

  @mustCallSuper
  BaseEntity onPersist() {
    id = Uuid().v1().toString();
    updatedDate = DateTime.now();
    return this;
  }

  @mustCallSuper
  BaseEntity onUpdate() {
    updatedDate = DateTime.now();
    return this;
  }

}
