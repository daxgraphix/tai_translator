# TAI Translator - App Design & Architecture

## 1. Overview
TAI Translator is a comprehensive language learning and translation application for English and Swahili. It is built as an **offline-first** solution that leverages high-performance local databases and integrates modern AI (Groq Llama 3) for enhanced translation accuracy when online.

## 2. Technical Stack
- **Framework:** Flutter (Multi-platform)
- **State Management:** Riverpod (Provider-based, using Notifiers and AsyncNotifiers)
- **Database:** Isar (NoSQL) - Chosen for its speed and native support for Dart objects. Optimized with indexes for fast history and dictionary lookups.
- **AI Integration:** Groq Cloud (Llama 3 8B) - Used for context-aware translations with a 10s timeout budget.
- **Localization:** Flutter Gen-L10n (ARB files) - Supporting English and Swahili.
- **Architecture:** Clean Architecture with a feature-based folder structure:
  - `lib/features/translate`: Core translation logic and UI.
  - `lib/features/learning`: Flashcards, Quizzes, and SRS.
  - `lib/features/dictionary`: Local word and phrase lookup.
  - `lib/core`: Shared services (Network, Storage, AI).

## 3. Core Systems

### A. Translation Engine
The app uses a hybrid translation strategy with a multi-stage fallback pipeline:
1. **Cache Lookup:** Checks Isar for identical previous translations to save battery and data.
2. **AI Mode (Online):** If connected and enabled, uses Groq Llama 3 for high-quality results.
3. **Offline Mode:** Uses a local dictionary and rule-based engine (prefix/suffix handling).
4. **Literal Fallback:** If all else fails, returns the source text as a "Literal" result to ensure the UI remains responsive.

**Race Condition Protection:** 
- A `_lastRequestId` counter tracks every request in `TranslateController`.
- Incoming results are discarded if their ID is lower than the current `_lastRequestId`.
4. **Debouncing:** A 400ms debounce ensures that network or heavy database operations only trigger once the user pauses typing.

### B. Learning Module & SRS
The learning module helps users memorize vocabulary using a Spaced Repetition System (SRS):
1. **Flashcards:** Cards are selected based on:
   - Priority 1: Never reviewed.
   - Priority 2: Low accuracy (< 80% correct).
   - Priority 3: Overdue (last review > 24 hours ago).
2. **Quiz Logic:**
   - Dynamically pulls from `Words` and `Phrases` collections.
   - Generates 4-choice questions.
   - Distractors are picked from the same category to ensure a challenging experience.
   - Logic handles `List<dynamic>` vs `List<String>` casting safely to avoid runtime crashes.

### C. Daily Content Rotation
To encourage daily engagement without a backend server, the app uses a deterministic time-based index:
- `dayIndex = currentTime.millisecondsSinceEpoch ~/ (1000 * 60 * 60 * 24)`
- `dailyItem = items[dayIndex % items.length]`
This ensures all users see the same "Daily Word" and "Daily Phrase" synchronously.

### D. Data Persistence (Isar)
- **TranslationHistory:** Stores every translation performed for quick reference.
- **Favorites:** Allows users to "star" phrases.
- **LearningStats:** Tracks `timesCorrect`, `timesIncorrect`, and `lastReviewed` for every item in the SRS.
- **Dictionary (Words/Phrases):** Pre-seeded local data for offline use.

## 4. UI/UX Design Principles
- **Clean Interface:** Focus on the input/output cards with minimal distractions.
- **Accessibility:** High contrast text and support for Screen Readers.
- **Responsive Navigation:** Uses a Bottom Navigation Bar for quick switching between Translate, Dictionary, and Learn.
- **Instant Feedback:** Skeleton loaders and immediate "copy to clipboard" buttons.

## 5. Development & Maintenance
- **Analysis:** Zero-warning policy (`flutter analyze`).
- **L10n Synchronization:** ARB files are the source of truth for all UI strings.
- **Build System:** Custom Gradle flags (`-Dandroid.disableAarMetadataCheck=true`) are used to optimize build times in specific environments.
