# Flutter GetX Boilerplate Template

A **robust Flutter GetX boilerplate** for rapid project setup with a reusable architecture.  
This template provides a clean, scalable structure for Flutter apps using **GetX** for state management, routing, and dependency injection.

---

## 🔹 Purpose

This boilerplate was created to:

- Reduce repetitive setup for new Flutter projects
- Maintain a consistent folder structure across projects
- Include **common folders and utilities** (`core/`, `feature/`, `routes/`) out-of-the-box
- Provide **cross-platform setup scripts** for automatic project customization
- Ensure **unique app names, Android package IDs, and iOS bundle identifiers** for each project

---

## 🔹 Features

- **Fully structured `lib/` folder** with:
  - `core/` (bindings, utils, services, models, common utilities)
  - `feature/` (sample authentication folder)
  - `routes/` (centralized routing)
  - `main.dart` & `app.dart` with **ScreenUtil** and **GetMaterialApp**
- **Theme support** (`AppTheme.lightTheme` / `darkTheme`)
- **ControllerBinder** for global dependency injection
- **Cross-platform setup scripts**:
  - `setup.sh` → Mac/Linux
  - `setup.ps1` → Windows
- Placeholder `LoginScreen` as a starting point

---

## 🔹 Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) installed and added to PATH
- Git installed
- Recommended: IDE like Android Studio, VSCode, or IntelliJ
- On Windows: run PowerShell as Administrator if required

---

## 🔹 Getting Started

### 1. Create a New Project from the Template

1. Go to the [boilerplate GitHub repo](https://github.com/MdMaruf-22/flutter_boilerplate)
2. Click **Use this template → Create a new repository**
3. Provide a **repository name** (e.g., `shop_app`)
4. Choose Public or Private
5. Click **Create repository from template**

---

### 2. Clone the Repository Locally

```bash
git clone https://github.com/MdMaruf-22/flutter_boilerplate.git
cd shop_app
```

Replace `YOUR_USERNAME` and `shop_app` with your GitHub username and project name.

### 3. Run the Setup Script

**Mac/Linux:**

```bash
chmod +x setup.sh  # only first time
./setup.sh
```

**Windows (PowerShell):**

```powershell
.\setup.ps1
```

The script will prompt for:

- **Project Name** (e.g., `shop_app`)
- **Client Name** (e.g., `acme`)

The script will automatically:

- Replace `__APP_NAME__` in `pubspec.yaml` and `app.dart`
- Generate native folders (`android/`, `ios/`, `web/`) using `flutter create .`
- Update Android package ID → `com.clientname.projectname`
- Update iOS bundle ID → `com.clientname.projectname`
- Run `flutter pub get`

### 4. Run Your Flutter App

```bash
flutter run
```

You now have a fully functional Flutter project with GetX boilerplate ready for development.

---

## 🔹 Folder Structure

```bash
lib/
├─ main.dart
├─ app.dart
├─ routes/
│  └─ app_routes.dart
├─ core/
│  ├─ bindings/
│  ├─ common/
│  ├─ localization/
│  ├─ models/
│  ├─ services/
│  └─ utils/
└─ feature/
   └─ authentication/
      └─ presentation/screens/login_screen.dart
```

---

## 🔹 Recommended Workflow

1. Create new repo from template on GitHub
2. Clone locally
3. Run setup script (`setup.sh` or `setup.ps1`)
4. Run `flutter run` to verify project works
5. Start building features in `feature/` folder, following the GetX architecture

---

## 🔹 Notes

- You can clone and create projects anywhere on your local machine.
- Each new project gets unique bundle IDs, allowing multiple apps on the same device.
- Keep the boilerplate repo updated with improvements; use it for all new projects.
- Scripts are cross-platform: Mac/Linux and Windows.
