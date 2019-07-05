import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notable/l10n/messages_all.dart';

class NotableLocalizations {
  /// Initialize localization systems and messages
  static Future<NotableLocalizations> load(Locale locale) async {
    final String localeName =
        locale.countryCode == null || locale.countryCode.isEmpty
            ? locale.languageCode
            : locale.toString();

    final String canonicalLocaleName = Intl.canonicalizedLocale(localeName);
    await initializeMessages(canonicalLocaleName);

    Intl.defaultLocale = canonicalLocaleName;

    return NotableLocalizations();
  }

  //
  // Localized Messages
  //

  //
  // General Note
  //
  String get note_title_hint => Intl.message(
        'Title...',
        name: 'note_title_hint',
        desc: 'Hint for the note title text field',
      );

  String get note_delete_menu_item => Intl.message(
        'Delete',
        name: 'note_delete_menu_item',
        desc: 'Delete note menu item label',
      );

  String get note_save_tooltip => Intl.message(
        'Save',
        name: 'note_save_tooltip',
        desc: 'Save note button',
      );

  String get note_untitled_placeholder => Intl.message(
        'Untitled',
        name: 'note_untitled_placeholder',
        desc: 'Placeholder title for untitled note',
      );

  //
  // Home
  //

  String get no_notes_msg => Intl.message(
        'You don\'t have any notes yet',
        name: 'no_notes_msg',
        desc: 'No notes message',
      );

  //
  // Text Note
  //

  String get text_note_create_tooltip => Intl.message(
        'Create note',
        name: 'text_note_create_tooltip',
        desc: 'Create Text note tooltip',
      );

  String get text_note_title => Intl.message(
        'Note',
        name: 'text_note_title',
        desc: 'Text Note screen title',
      );

  String get text_note_hint => Intl.message(
        'Enter your note...',
        name: 'text_note_hint',
        desc: 'Hint for the text note field',
      );

  //
  // Checklist
  //

  String get checklist_create_tooltip => Intl.message(
        'Create checklist',
        name: 'checklist_create_tooltip',
        desc: 'Create Checklist tooltip',
      );

  String get checklist_note_title => Intl.message(
        'Checklist',
        name: 'checklist_note_title',
        desc: 'Checklist note screen title',
      );

  String get checklist_item_hint => Intl.message(
        'Task...',
        name: 'checklist_item_hint',
        desc: 'Hint for the checklist item field',
      );

  String get checklist_add_item_label => Intl.message(
        'Add item',
        name: 'checklist_add_item_label',
        desc: 'Label for the checklist add item widget',
      );

  //
  // Drawing
  //

  String get drawing_note_create_tooltip => Intl.message(
        'Create drawing',
        name: 'drawing_note_create_tooltip',
        desc: 'Create Drawing note tooltip',
      );

  String get drawing_note_title => Intl.message(
        'Drawing',
        name: 'drawing_note_title',
        desc: 'Drawing note screen title',
      );

  String get drawing_tool_brush_tooltip => Intl.message(
        'Brush',
        name: 'drawing_tool_brush_tooltip',
        desc: 'Drawing brush tool tooltip',
      );

  String get drawing_tool_eraser_tooltip => Intl.message(
        'Eraser',
        name: 'drawing_tool_eraser_tooltip',
        desc: 'Drawing eraser tool tooltip',
      );

  String get drawing_undo_action_tooltip => Intl.message(
        'Undo',
        name: 'drawing_undo_action_tooltip',
        desc: 'Drawing undo action tooltip',
      );

  String get drawing_redo_action_tooltip => Intl.message(
        'Redo',
        name: 'drawing_redo_action_tooltip',
        desc: 'Drawing redo action tooltip',
      );

  String get drawing_clear_tooltip => Intl.message(
        'Clear',
        name: 'drawing_clear_tooltip',
        desc: 'Drawing clear tooltip',
      );

  //
  // Audio
  //

  String get audio_note_create_tooltip => Intl.message(
        'Create audio clip',
        name: 'audio_note_create_tooltip',
        desc: 'Create Audio note tooltip',
      );

  String get audio_note_title => Intl.message(
        'Audio',
        name: 'audio_note_title',
        desc: 'Audio note screen title',
      );

  static NotableLocalizations of(BuildContext context) =>
      Localizations.of<NotableLocalizations>(context, NotableLocalizations);
}

class NotableLocalizationsDelegate
    extends LocalizationsDelegate<NotableLocalizations> {
  const NotableLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['es', 'en'].contains(locale.languageCode);

  @override
  Future<NotableLocalizations> load(Locale locale) =>
      NotableLocalizations.load(locale);

  @override
  bool shouldReload(LocalizationsDelegate<NotableLocalizations> old) => false;
}
