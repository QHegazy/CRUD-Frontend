# Task Manager Flutter App

A simple cross-platform **Task Management** application built with **Flutter** for the frontend and **Go** for the backend. It allows users to perform full **CRUD** operations (Create, Read, Update, Delete) on tasks while supporting **secure JWT authentication** and persistent login using `SharedPreferences`.

---

## Features

- Create, update, and delete tasks
- JWT-based secure authentication
- Token stored persistently with `SharedPreferences`
- REST API integration for all task operations
- Auto-refresh after task updates
-  State management with `provider`

---

##  Architecture & Design

### State Management

- Using [`provider`](https://pub.dev/packages/provider) to manage and propagate application state.
- `TaskProvider` is the central class for:
  - Loading/saving token
  - Making API calls
  - Managing and updating task list

### API Layer

- All HTTP interactions are handled inside the `ApiService` class.
- This allows:
  - Clean separation of network logic
  - Easy mocking/testing
  - Automatic inclusion of tokens in requests
  - Replacing tokens when a refreshed one is received from the backend

### Authentication

- Token stored using `SharedPreferences` via a helper class (`TokenStorage`)
- Automatically included in the `Authorization` header
- Backend-issued new token is automatically saved and used

### Form Validation

- Implemented via custom validators in `core/utils/task_validator.dart`
- Ensures:
  - Titles are at least 5 characters
  - Descriptions are at least 8 characters

---

## Folder Structure

```
lib/
├── core/
│ ├── services/ # API service and token storage
│ └── utils/ # Validators and helpers
├── models/ # Task model (data class)
├── features/
│ └── tasks/
│ ├── controller/ # TaskProvider (state & logic)
│ ├── screens/ # TaskListScreen, TaskDetailScreen
│ └── widgets/ # TaskCard, etc.
├── routes/ # AppRoutes (named routes)
├── theme/ # App theme (dark/light)
└── main.dart # Entry point
```

##  Getting Started

###  Prerequisites

- Flutter SDK (latest stable)
- Android Studio or VSCode
- Emulator or physical device

###  Setup

```bash
# 1. Install dependencies
flutter pub get

# 2. Run the app on connected device or emulator
flutter run
```