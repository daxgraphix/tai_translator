# TAI Translator (Community Edition)

> Translate. Learn. Connect.

A fully offline-first, privacy-focused, open-access English ⇄ Swahili
translation, dictionary, and language-learning app, built with Flutter.

100% Free Forever · No Ads · No Tracking · Offline First · AI Enhanced
When Online · Fast on Low-End Android Devices · Privacy by Design.

This repository is a **production-grade architectural scaffold**: every
layer described in the technical specification is implemented and wired
together end-to-end (offline rule-based translation actually works,
dictionary search actually works, flashcards/quiz actually work). A few
native-SDK-dependent pieces (camera OCR, microphone speech-to-text,
text-to-speech voices) are fully wired in code but need to run on a real
device/emulator with the relevant permissions to exercise the native
plugin.

---

## Architecture

**Feature-First + Clean Architecture + Riverpod + Repository Pattern**

```
lib/
├── app/                  # App shell, theming, routing, app-level providers
├── core/                 # Cross-cutting: constants, errors, network, storage, services
├── shared/                # Reusable widgets/components used across features
├── features/
│   ├── translate/        # Translation pipeline (offline + Groq online engine)
│   ├── dictionary/        # Offline dictionary + phrase database, search engine
│   ├── history/            # Translation history (Isar-backed, reactive)
│   ├── favorites/          # Saved words/phrases
│   ├── voice/              # speech_to_text + flutter_tts wrappers
│   ├── image_translation/  # ML Kit OCR flow
│   ├── learning/           # Daily word, flashcards, quiz mode
│   └── settings/           # Theme, online-translation toggle, Groq key, voice tuning
└── data/
    ├── local/seed/        # Starter dictionary + phrase data
    ├── remote/            # (reserved for future remote data sources)
    └── repositories/      # (reserved for cross-feature repositories)
```

Each feature follows `data / domain / presentation`:
- **domain** — entities, repository interfaces, use cases (pure Dart, no Flutter/Isar imports)
- **data** — Isar models, local/remote data sources, repository implementations
- **presentation** — Riverpod providers/controllers, screens, widgets

### Translation Pipeline

```
User Input → Language Detection (explicit en/sw toggle)
           → TranslationCoordinator (TranslationRepositoryImpl)
                 ├─ online && enabled?  → GroqTranslationSource (Groq Cloud)
                 └─ else / on failure   → OfflineTranslationSource
                                             1. exact phrase match
                                             2. exact dictionary word match
                                             3. rule-based, word-by-word with
                                                naive plural handling
           → Result saved to Isar history → Displayed
```

The offline engine **never** touches the network and never throws the
user into a dead end — if the online call fails for any reason (no key,
timeout, server error), the coordinator silently falls back to the
offline engine.

### Local Data Layer — Isar

Isar was chosen over SQLite per the spec (faster, Flutter-optimized,
strong query performance, offline-friendly). Collections:

- `TranslationHistoryModel`
- `DictionaryEntryModel`
- `SavedPhraseModel`
- `FavoriteModel`
- `FlashcardModel`
- `LearningProgressModel`

All collections are opened once in `IsarService` and seeded on first
launch from `lib/data/local/seed/`.

---

## Getting Started

### 1. Prerequisites
- Flutter 3.22+ / Dart 3.3+
- Android Studio or Xcode for platform tooling

### 2. Generate platform folders

This scaffold ships **Dart source only** (`lib/`, `pubspec.yaml`,
`test/`) so it stays lightweight and portable. Generate the native
`android/`, `ios/` (and optionally `macos/`, `web/`, etc.) projects with:

```bash
flutter create . --org com.taitranslator --project-name tai_translator
```

This is safe to run in the project root — it will not overwrite your
`lib/` or `pubspec.yaml` dependency list, only add/refresh the native
platform scaffolding.

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Generate Isar's code-gen files

Isar collections (`*.g.dart`) are generated, not hand-written:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Re-run this any time you add/change an `@collection` class.

### 5. Run

```bash
flutter run
```

### 6. (Optional) Enable AI-enhanced online translation

TAI Translator works fully offline out of the box. To enable the
"AI Enhanced When Online" tier:

1. Get a free API key at https://console.groq.com
2. Open the app → **Settings → Groq API key** → paste it in
3. Toggle **"AI translation when online"** on (it's on by default; the
   key is what actually activates it)

No key configured? The app transparently uses the offline engine only.

---

## Required Permissions

Once you run `flutter create .`, add these to the generated platform
manifests:

**Android** (`android/app/src/main/AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.CAMERA" />
```

**iOS** (`ios/Runner/Info.plist`)
```xml
<key>NSMicrophoneUsageDescription</key>
<string>Used for voice translation input.</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>Used to convert your speech into text for translation.</string>
<key>NSCameraUsageDescription</key>
<string>Used to scan and translate text from photos.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Used to pick images to translate text from.</string>
```

---

## Growing the Dictionary

The starter dictionary (~100 words) and phrase bank (~28 phrases) live
as plain Dart lists in:

- `lib/data/local/seed/dictionary_seed.dart`
- `lib/data/local/seed/phrases_seed.dart`

To add vocabulary, append rows to these lists — they're seeded into
Isar automatically on first launch (the seed step is a no-op once the
collection is non-empty, so bump the app's local data version or clear
app storage during development to re-seed).

---

## Performance Targets (per spec)

| Target | Status |
|---|---|
| Startup time < 2s | Achieved by deferring non-critical seeding to a one-time first-launch check |
| Offline translation < 100ms | Exact/phrase/dictionary lookups are indexed Isar queries; rule-based tokenization is O(n) over words |
| Online translation < 2s | Enforced via Dio connect/receive timeouts on `GroqTranslationService` |
| APK size < 40MB | No heavy ML models bundled; ML Kit text recognition downloads its model on-device via Google Play Services |

---

## Security & Privacy

- No user accounts, no sign-in
- No analytics or tracking SDKs
- No advertising SDKs
- No personal data collection
- Internet is used **only**, optionally, for Groq translation requests —
  controllable from Settings

---

## Stack

`flutter_riverpod` · `go_router` · `isar` · `dio` · `dartz` ·
`google_mlkit_text_recognition` · `speech_to_text` · `flutter_tts` ·
`connectivity_plus` · `path_provider` · `shared_preferences` ·
`google_fonts` · `image_picker` · `share_plus`

---

## License

Community Edition — intended for free, open, educational use. Add a
LICENSE file matching your project's chosen license (MIT/Apache-2.0
recommended for a "100% Free Forever" positioning).
