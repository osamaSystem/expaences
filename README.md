# Expense Tracker Pro

A production-ready Flutter expense tracker using GetX, SQLite, reactive charts, local auth, export to Excel/PDF, and persisted theme settings.

## Setup

1. Ensure Flutter stable is installed.
2. From project root:
   ```bash
   flutter pub get
   ```
3. If Android/iOS folders are missing (in this scaffold-only repo), generate them once:
   ```bash
   flutter create .
   ```
4. Run app:
   ```bash
   flutter run
   ```

## Features

- Local auth (register/login/session restore)
- Expense CRUD with SQLite persistence
- Reactive filters (month/category/search)
- Summary cards (overall/monthly/category)
- Monthly bar chart + category pie chart (fl_chart)
- Export filtered expenses to `.xlsx` and `.pdf`
- Theme mode persistence (system/light/dark)
- Route guards via GetX middleware

## Main Structure

- `lib/main.dart`
- `lib/app/routes/*`
- `lib/app/bindings/*`
- `lib/app/themes/*`
- `lib/data/models/*`
- `lib/data/database/*`
- `lib/data/services/*`
- `lib/modules/auth/*`
- `lib/modules/home/*`
- `lib/modules/expense/*`
- `lib/modules/settings/*`
- `lib/widgets/*`
