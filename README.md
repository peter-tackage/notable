# Notable

A simple note taking app written using Flutter.

[![Build Status](https://app.bitrise.io/app/c47c81b05b94cb7a/status.svg?token=6vEQfkde9oSyW7I1DHHOyw&branch=master)](https://app.bitrise.io/app/c47c81b05b94cb7a)

## Generating `json_serialization` and `built_value` files

Run the command: `flutter packages pub run build_runner build`

## Internationalization

Add the new translation to the definitions in `lib/l10n/localization.dart`. 

1. Generate the `intl_messages.arb` file: `flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/l10n/localization.dart`
1. Manually merge any changes from the `intl_messages.arb` file with the existing `.arb` localizations.
1. Add the actual translations for the other supported languages.
1. Delete the file `intl_messages.arb`.
1. Generates the `messages.*.dart` files: `flutter pub pub run intl_translation:generate_from_arb lib/l10n/localization.dart lib/l10n/*.arb  --output-dir=lib/l10n`

## Acknowledgements

Brought to you by the power of the [Chilicorn](http://spiceprogram.org/chilicorn-history/) and the [Futurice Open Source Program](http://spiceprogram.org/).

![Chilicorn Logo](https://raw.githubusercontent.com/futurice/spiceprogram/gh-pages/assets/img/logo/chilicorn_no_text-256.png)
## License

    Copyright 2019 Peter Tackage

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

