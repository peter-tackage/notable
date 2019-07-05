// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a messages locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

// ignore: unnecessary_new
final messages = new MessageLookup();

// ignore: unused_element
final _keepAnalysisHappy = Intl.defaultLocale;

// ignore: non_constant_identifier_names
typedef MessageIfAbsent(String message_str, List args);

class MessageLookup extends MessageLookupByLibrary {
  get localeName => 'messages';

  final messages = _notInlinedMessages(_notInlinedMessages);

  static _notInlinedMessages(_) => <String, Function>{
        "audio_note_create_tooltip":
            MessageLookupByLibrary.simpleMessage("Create audio clip"),
        "audio_note_title": MessageLookupByLibrary.simpleMessage("Audio"),
        "checklist_add_item_label":
            MessageLookupByLibrary.simpleMessage("Add item"),
        "checklist_create_tooltip":
            MessageLookupByLibrary.simpleMessage("Create checklist"),
        "checklist_item_hint": MessageLookupByLibrary.simpleMessage("Task..."),
        "checklist_note_title":
            MessageLookupByLibrary.simpleMessage("Checklist"),
        "drawing_note_create_tooltip":
            MessageLookupByLibrary.simpleMessage("Create drawing"),
        "drawing_note_title": MessageLookupByLibrary.simpleMessage("Drawing"),
        "no_notes_msg": MessageLookupByLibrary.simpleMessage(
            "You don\'t have any notes yet"),
        "note_delete_menu_item": MessageLookupByLibrary.simpleMessage("Delete"),
        "note_save_tooltip": MessageLookupByLibrary.simpleMessage("Save"),
        "note_title_hint": MessageLookupByLibrary.simpleMessage("Title..."),
        "note_untitled_placeholder":
            MessageLookupByLibrary.simpleMessage("Untitled"),
        "text_note_create_tooltip":
            MessageLookupByLibrary.simpleMessage("Create note"),
        "text_note_hint":
            MessageLookupByLibrary.simpleMessage("Enter your note..."),
        "text_note_title": MessageLookupByLibrary.simpleMessage("Note")
      };
}
