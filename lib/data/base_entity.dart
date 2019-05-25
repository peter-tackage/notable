import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

abstract class BaseEntity {
  String id;
  DateTime updatedDate;

  BaseEntity({this.id, this.updatedDate});

  @mustCallSuper
  BaseEntity onPersist() {
    this.id = Uuid().v1().toString();
    this.updatedDate = DateTime.now();
    return this;
  }

  @mustCallSuper
  BaseEntity onUpdate() {
    this.updatedDate = DateTime.now();
    return this;
  }

}
