import 'dart:io';

import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

String soundFilenameGenerator() {
  // By defining the filename rather than use the default (so different notes have different filenames),
  // we also have to supply the extension. This is a bit clumsy, because I'm
  // not really in control of the format.
  final extension = Platform.isIOS ? "m4a" : "mp4";
  return "sound_note_${Uuid().v1().toString()}.$extension";
}

class SoundStorage {
  final Future<Directory> Function() getDirectory;
  final String Function() filenameGenerator;

  SoundStorage({@required this.getDirectory, @required this.filenameGenerator});

  Future<String> generateFilename() async {
    final dir = await getDirectory();
    final filename = filenameGenerator();
    return "${dir.path}${Platform.pathSeparator}$filename";
  }

  Future<FileSystemEntity> delete(String filename) async {
    final file = _getLocalFile(filename);
    return file.delete();
  }

  File _getLocalFile(String filename) {
    return File(filename);
  }
}
