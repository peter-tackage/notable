import 'package:meta/meta.dart';

import 'label.dart';

@immutable
abstract class BaseNote {
  final String id;
  final DateTime updatedDate;
  final String title;
  final List<Label> labels;

  BaseNote(this.title, this.labels, {this.id, this.updatedDate});
}

