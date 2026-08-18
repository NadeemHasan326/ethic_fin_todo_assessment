# EthicFin Task Manager

A Flutter task manager built for the Ethic Financial assessment. Tasks are stored locally first (Hive) and synced to Cloud Firestore when the device is online, so the app stays usable offline.

**Version:** 1.0.0+1  
**Platforms:** Android, iOS  
**Dart SDK:** ^3.11.5

---

## What the app does

Users can create, view, edit, complete, and delete tasks. Each task has a title, description, priority (Low / Medium / High), due date, and completion status. The home screen supports search, filters, sorting, and a live sync banner. Light and dark themes are supported and remembered between launches.

---

## Features

### Task management
- Create and edit tasks with title, description, priority, and due date
- Form validation (title required, min 3 characters; description required, max 500 characters)
- View full task details (due date, created date, priority, sync status)
- Mark a task as completed or pending
- Delete from the list (swipe) or from the detail screen, with a confirmation dialog
- Unique IDs generated with UUID v4

### Search, filter, and sort
- Search tasks by title (live, as you type)
- Filter: **All**, **Completed**, **Pending**
- Sort: **Date Created**, **Due Date**, **Priority** (High first)
- Empty states for no tasks, no search results, and empty filters

### Offline-first sync
- All reads and writes go to Hive first, so the UI never waits on the network
- When online, create / update / delete are pushed to Firestore in the background
- Unsynced tasks are flagged (`isSynced`) and shown with a cloud-off icon
- Deletes made offline are queued in a `pending_deletes` Hive box and flushed on the next sync
- Full sync on reconnect: push pending deletes → push unsynced tasks → pull remote tasks and merge (local unsynced changes win)
- Manual sync button and a tap-to-retry banner
- Connectivity watched via `connectivity_plus`; coming back online triggers auto-sync

### UI / UX
- Animated splash screen
- Material 3 theme with Inter (Google Fonts)
- Light / dark mode, persisted in Hive
- Responsive layout via `flutter_screenutil` (design size 375 × 812)
- Shimmer placeholders while the list loads
- Pull to refresh
- Custom toasts for created / updated / deleted
- Overdue due dates highlighted in red
- Hero title transition from list card to detail
- Progress subtitle: “X of Y tasks completed”

---

## Architecture

The project follows **Clean Architecture** with a single `task` feature. Each layer has a clear job and depends only inward:

```
Presentation  →  Domain  ←  Data
     │              ▲
     │         Use cases
     │              │
     └────────► Repository contract
                    ▲
                    │
              Repository impl
              (Hive + Firestore + NetworkInfo)
```

| Layer | Responsibility |
| --- | --- |
| **Presentation** | Pages, widgets, `TaskBloc` / `ThemeCubit`. Talks to use cases, never to Hive or Firestore. |
| **Domain** | `TaskEntity`, `TaskRepository` (abstract), use cases. No Flutter UI or Firebase imports. |
| **Data** | `TaskModel`, Hive local source, Firestore remote source, `TaskRepositoryImpl` (offline-first sync). |
| **Core** | Shared constants, colors, errors, network check, logging, reusable widgets. |
| **App** | GetIt DI, named router, Material theme, root `TaskManagerApp`. |

### Why this split
- The UI can be rewritten without touching Firestore or Hive.
- Sync rules live in one place (`TaskRepositoryImpl`), not scattered across widgets.
- Use cases keep BLoC handlers thin: `CreateTask`, `UpdateTask`, `DeleteTask`, `GetTasks`, `ToggleTaskStatus`, `SyncTasks`.

### State management
- **`TaskBloc`** owns the task list, search/filter/sort, sync status, and connectivity.
- Mutations are **optimistic**: the list updates immediately, then the use case persists in the background.
- **`ThemeCubit`** toggles `ThemeMode` and writes `is_dark` to the Hive settings box.
- **`TalkerBlocObserver`** logs every BLoC event/state for debugging.

### Dependency injection
`GetIt` (`sl`) registers:
- Externals: `FirebaseFirestore`, `Connectivity`
- Core: `NetworkInfo`
- Data sources and `TaskRepository`
- Use cases
- `TaskBloc` (factory) and `ThemeCubit` (singleton)

---

## Folder structure

```
lib/
├── main.dart                          # Firebase, Hive, DI, Talker, runApp
├── firebase_options.dart              # FlutterFire-generated options
├── exports.dart                       # Barrel file for app + package imports
├── app/
│   ├── app.dart                       # MaterialApp, theme, ScreenUtil, BLoC providers
│   ├── di/injection.dart              # GetIt registrations
│   ├── router/app_router.dart         # Named routes (splash, task list)
│   └── theme/app_theme.dart           # Light / dark ThemeData
├── core/
│   ├── constants/                     # Strings, sizes, durations, enums, images
│   ├── error/                         # Failures + exceptions
│   ├── network/network_info.dart      # connectivity_plus wrapper
│   ├── theme/                         # AppColors, AppPalette, ThemeCubit
│   ├── utils/                         # DateFormatter, Talker logger
│   └── widgets/                       # Toast, page route, dialog, AnimatedAppear
└── features/task/
    ├── domain/
    │   ├── entities/task_entity.dart
    │   ├── repositories/task_repository.dart
    │   └── usecases/                  # get, create, update, delete, toggle, sync
    ├── data/
    │   ├── models/task_model.dart     # Hive + Firestore mapping
    │   ├── datasources/               # local (Hive) + remote (Firestore)
    │   └── repositories/task_repository_impl.dart
    └── presentation/
        ├── bloc/                      # TaskBloc, events, state
        ├── pages/                     # splash, list, add/edit, detail
        └── widgets/                   # card, filter bar, sync banner, empty, shimmer
```

---

## Screens

| Screen | File | What it covers |
| --- | --- | --- |
| Splash | `splash_page.dart` | Brand intro, then fade to the task list |
| Task list | `task_list_page.dart` | Search, filters, sort, sync, FAB, swipe-to-delete |
| Add / Edit | `add_edit_task_page.dart` | Validated form, priority chips, date picker |
| Detail | `task_detail_page.dart` | Full info, complete/pending toggle, edit, delete |

Named routes: `/` (splash) and `/tasks` (list). Add/edit and detail are pushed with `AppPageRoute` (fade + slight slide).

---

## Data model

### Domain entity (`TaskEntity`)

| Field | Type | Notes |
| --- | --- | --- |
| `id` | `String` | UUID |
| `title` | `String` | Min 3 characters |
| `description` | `String` | Max 500 characters |
| `priority` | `TaskPriority` | `low`, `medium`, `high` |
| `dueDate` | `DateTime` | Default: tomorrow |
| `isCompleted` | `bool` | Toggle from detail |
| `createdAt` | `DateTime` | Set on create |
| `isSynced` | `bool` | Local-only flag; not stored in Firestore |

### Storage
- **Hive** box `tasks` — typed `TaskModel` with a generated adapter (`task_model.g.dart`)
- **Hive** box `pending_deletes` — IDs waiting to be removed from Firestore
- **Hive** box `settings` — dark-mode preference
- **Firestore** collection `tasks` — same fields as JSON, without `id` / `isSynced` (document ID is the task ID)

---

## Offline sync flow

```
User action (create / update / delete)
        │
        ▼
  Save to Hive immediately   ← UI reads from here
        │
        ├── online  →  push to Firestore, mark isSynced = true
        └── offline →  leave isSynced = false (or queue delete)

On reconnect / manual sync:
  1. Flush pending_deletes to Firestore
  2. Push all unsynced local tasks
  3. Pull remote tasks
  4. Merge: skip remote docs that are pending-delete;
     keep local unsynced copy if both exist
```

Firestore calls use a 15-second timeout. Failures are logged with Talker and retried on the next sync.

---

## Tech stack

| Area | Package | Role |
| --- | --- | --- |
| UI | Flutter, Material 3 | App framework |
| State | `flutter_bloc` | TaskBloc + ThemeCubit |
| DI | `get_it` | Service locator |
| Remote DB | `firebase_core`, `cloud_firestore` | Cloud persistence |
| Local DB | `hive_flutter` | Offline cache + settings |
| Network | `connectivity_plus` | Online / offline detection |
| IDs | `uuid` | Task IDs |
| Dates | `intl` | Formatting |
| Fonts | `google_fonts` | Inter |
| Layout | `flutter_screenutil` | Responsive sizes |
| Loading | `shimmer` | List placeholders |
| Logging | `talker`, `talker_flutter`, `talker_bloc_logger` | App + BLoC logs |

---

## How to run

### Prerequisites
- Flutter SDK (Dart 3.11+)
- Android Studio / Xcode for device or emulator
- A Firebase project with Cloud Firestore enabled

### Setup
```bash
git clone <repo-url>
cd ethic_fin_todo_assessment
flutter pub get
```

Firebase is already wired for Android and iOS (`lib/firebase_options.dart`, `google-services.json`, `GoogleService-Info.plist`). To point at your own project:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Place:
- Android: `android/app/google-services.json`
- iOS: `ios/Runner/GoogleService-Info.plist`

Firestore rules in this repo allow read/write on `tasks` (assessment / demo). Tighten them before any production use.

### Run
```bash
flutter run
```

Release APK:
```bash
flutter build apk --release
```

---

## Engineering notes

- **Optimistic UI** — list updates before the repository finishes, so create/update/delete feel instant.
- **Local-first** — Hive is the source of truth for the UI; Firestore is a replica.
- **Hardcoded strings and sizes** live in `AppStrings`, `AppSizes`, `AppDurations`, and `AppConstants` instead of magic values in widgets.
- **Theme** uses `ThemeExtension<AppPalette>` so light and dark palettes stay typed and consistent.
- **Keyboard** dismisses on tap outside fields and on list drag.
- **Logging** covers init, CRUD, sync, and BLoC transitions via Talker.

---

## Project status

- Android and iOS Firebase configs are in place.
- Web / macOS / Windows / Linux are not configured.
- Widget tests are a placeholder (`test/widget_test.dart`); the assessment focus is the app architecture and UX.
- `injectable` is in `pubspec.yaml` but DI is registered manually in `injection.dart`.
