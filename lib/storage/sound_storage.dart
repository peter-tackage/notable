import 'dart:io';

import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

//
// These are generator functions are injected to improve testability.
//

// Only the filename, without the path.
String soundFilenameGenerator() {
  // By defining the filename rather than use the default (so different notes have different filenames),
  // we also have to supply the extension. This is a bit clumsy, because I'm
  // not really in control of the format.
  return "sound_note_${Uuid().v1().toString()}.${_extension()}";
}

String _extension() {
  return Platform.isIOS ? "m4a" : "mp4";
}

class SoundStorage {
  final Future<Directory> Function() getDirectory;
  final String Function() filenameGenerator;

  SoundStorage({@required this.getDirectory, @required this.filenameGenerator});

  Future<String> toFilePath(String filename) async {
    final dir = await getDirectory();
    return "${dir.path}${Platform.pathSeparator}$filename";
  }

  String generateFilename() {
    return filenameGenerator();
  }

  Future<FileSystemEntity> delete(String filename) async {
    final filePath = await toFilePath(filename);
    print("Deleting sound file: $filePath");
    final file = File(filePath);
    return file.delete();
  }
}
