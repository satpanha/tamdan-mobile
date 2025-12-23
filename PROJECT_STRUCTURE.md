# Complete Project Structure - Athlete Tracking App
## Flutter Development Guide

---

## Table of Contents
1. [Root Directory Structure](#root-directory-structure)
2. [lib/ - Main Application Code](#lib---main-application-code)
3. [Detailed File Descriptions](#detailed-file-descriptions)
4. [File Organization Chart](#file-organization-chart)
5. [Module Dependencies](#module-dependencies)
6. [File Creation Checklist](#file-creation-checklist)

---

## Root Directory Structure

```
tamdan/
├── .dart_tool/                          # Dart tool cache (auto-generated)
├── .github/                             # GitHub workflows
├── android/                             # Android native code
│   ├── app/
│   ├── gradle/
│   └── settings.gradle.kts
├── build/                               # Build artifacts (auto-generated)
├── ios/                                 # iOS native code
│   ├── Runner/
│   ├── Runner.xcworkspace/
│   └── Runner.xcodeproj/
├── lib/                                 # 🔴 MAIN APPLICATION CODE
│   ├── main.dart
│   ├── models/
│   ├── screens/
│   ├── widgets/
│   ├── utils/
│   └── theme/
├── test/                                # Unit and widget tests
│   └── widget_test.dart
├── web/                                 # Web platform
├── windows/                             # Windows platform
├── linux/                               # Linux platform
├── macos/                               # macOS platform
├── analysis_options.yaml                # Linting rules
├── pubspec.yaml                         # Dependencies & metadata
├── pubspec.lock                         # Locked dependency versions
├── README.md                            # Project overview
├── FLUTTER_BEGINNER_GUIDE.md            # 📚 Development guide
├── ONBOARDING_PLAN.md                   # 📅 7-day task plan
├── PROJECT_STRUCTURE.md                 # 📋 This file
├── HENG.md                              # Development guide (copy)
├── PANHA.md                             # Task plan (copy)
└── tamdan.iml                           # IDE config

```

---

## lib/ - Main Application Code

### **Complete Directory Structure**

```
lib/
├── main.dart                            ⭐ App entry point
├── models/
│   ├── athlete.dart                     # Athlete data class
│   └── user.dart                        # User data class
├── screens/
│   ├── athlete_list.dart                # Athletes tab screen
│   ├── add_athlete.dart                 # Add athlete form screen
│   ├── edit_athlete.dart                # Edit athlete form screen
│   ├── athlete_detail.dart              # Athlete detail view screen
│   ├── tracking.dart                    # Tracking tab placeholder
│   ├── settings.dart                    # Settings tab screen
│   └── user_profile.dart                # User profile screen
├── widgets/
│   ├── athlete_card.dart                # Reusable athlete list card
│   ├── form_field.dart                  # Reusable form field widget
│   └── bottom_nav_widget.dart           # Bottom navigation widget
├── utils/
│   ├── constants.dart                   # App constants & config
│   ├── validators.dart                  # Form validation logic
│   ├── mock_data.dart                   # Mock/sample data
│   └── extensions.dart                  # Utility extensions
└── theme/
    └── app_theme.dart                   # App colors, fonts, styles
```

---

## Detailed File Descriptions

### **Core Entry Point**

#### `lib/main.dart`
- **Purpose**: App initialization and root widget
- **Contains**:
  - `void main()` - Entry point
  - `MyApp` class (StatelessWidget) - App configuration
  - `HomeScreen` class (StatefulWidget) - Main screen with bottom nav
  - `_HomeScreenState` - Navigation logic between tabs
- **Size**: ~150 lines
- **Dependencies**: All screens, theme

**Key Responsibilities**:
```
main.dart
├── Initialize MaterialApp
├── Set up theme
├── Manage tab navigation (4 tabs)
└── Route between screens
```

---

### **Models Directory** (`lib/models/`)

Models are data classes that represent your application data.

#### `lib/models/athlete.dart`
- **Purpose**: Define the Athlete data structure
- **Contains**:
  - `Athlete` class with properties:
    - `id` (String) - Unique identifier
    - `name` (String) - Athlete name
    - `dateOfBirth` (DateTime) - Birth date
    - `gender` (String) - Gender (Male/Female/Other)
    - `beltLevel` (String) - Martial arts belt level
    - `status` (String) - Active/Inactive
  - `toString()` method
- **Size**: ~30 lines
- **No Dependencies**

**Structure**:
```dart
class Athlete {
  final String id;
  final String name;
  final DateTime dateOfBirth;
  final String gender;
  final String beltLevel;
  final String status;

  Athlete({required properties});
  
  @override
  String toString() => ...;
}
```

#### `lib/models/user.dart`
- **Purpose**: Define the User data structure
- **Contains**:
  - `User` class with properties:
    - `name` (String) - User name
    - `email` (String) - Email address
    - `role` (String) - Job role
    - `createdDate` (DateTime) - Account creation date
  - `toString()` method
- **Size**: ~25 lines
- **No Dependencies**

---

### **Screens Directory** (`lib/screens/`)

Screens are the main pages/views of the app.

#### `lib/screens/athlete_list.dart`
- **Purpose**: Display list of athletes with search
- **Widget Type**: StatefulWidget
- **State Variables**:
  - `List<Athlete> athletes` - All athletes
  - `List<Athlete> filteredAthletes` - Search results
  - `String searchQuery` - Current search text
- **Features**:
  - Search bar with real-time filtering
  - ListView of athlete cards
  - FloatingActionButton to add athlete
  - Navigation to detail/add screens
- **Size**: ~120 lines
- **Dependencies**: Athlete model, AthleteCard widget, AddAthleteScreen

#### `lib/screens/add_athlete.dart`
- **Purpose**: Form to create new athlete
- **Widget Type**: StatefulWidget
- **State Variables**:
  - Form field values (name, DOB, gender, etc.)
  - Error messages
- **Features**:
  - TextFormField for name
  - DatePicker for DOB
  - DropdownButtonFormField for selections
  - Form validation
  - Save/Cancel buttons
- **Size**: ~180 lines
- **Dependencies**: Athlete model, FormValidators, Constants

#### `lib/screens/edit_athlete.dart`
- **Purpose**: Form to edit existing athlete
- **Widget Type**: StatefulWidget
- **Differences from Add**:
  - Receives Athlete as parameter
  - Pre-fills all form fields
  - Updates existing athlete instead of creating
- **Size**: ~185 lines
- **Dependencies**: Athlete model, FormValidators, Constants

#### `lib/screens/athlete_detail.dart`
- **Purpose**: Display athlete information (read-only)
- **Widget Type**: StatelessWidget
- **Features**:
  - Display formatted athlete data
  - Edit button → navigates to EditAthleteScreen
  - Delete button with confirmation dialog
  - Back button navigation
- **Size**: ~150 lines
- **Dependencies**: Athlete model, EditAthleteScreen

#### `lib/screens/tracking.dart`
- **Purpose**: Placeholder for tracking feature
- **Widget Type**: StatelessWidget
- **Content**: Simple message "Coming soon"
- **Size**: ~30 lines
- **Dependencies**: None

#### `lib/screens/settings.dart`
- **Purpose**: Settings screen with navigation
- **Widget Type**: StatelessWidget
- **Features**:
  - ListTile items for settings options
  - Navigation to UserProfileScreen
- **Size**: ~50 lines
- **Dependencies**: UserProfileScreen

#### `lib/screens/user_profile.dart`
- **Purpose**: Display and edit user profile
- **Widget Type**: StatelessWidget
- **Features**:
  - Display user info from mock data
  - Edit button (non-functional for now)
  - User avatar
- **Size**: ~100 lines
- **Dependencies**: User model, mock_data

---

### **Widgets Directory** (`lib/widgets/`)

Reusable UI components.

#### `lib/widgets/athlete_card.dart`
- **Purpose**: Reusable card for displaying athlete in list
- **Widget Type**: StatelessWidget
- **Props**:
  - `Athlete athlete` - Data to display
  - `VoidCallback onTap` - Tap handler
- **Features**:
  - CircleAvatar with athlete initials
  - Name, belt level, status display
  - Arrow icon indicating clickable
- **Size**: ~40 lines
- **Dependencies**: Athlete model

#### `lib/widgets/form_field.dart`
- **Purpose**: Reusable custom form field
- **Widget Type**: StatelessWidget
- **Props**:
  - `String label` - Field label
  - `String? Function(String?)? validator` - Validator function
  - `void Function(String)? onChanged` - Change callback
- **Size**: ~30 lines
- **Dependencies**: None

#### `lib/widgets/bottom_nav_widget.dart`
- **Purpose**: Reusable bottom navigation bar
- **Widget Type**: StatelessWidget
- **Props**:
  - `int currentIndex` - Current selected tab
  - `void Function(int) onTap` - Tab change callback
- **Size**: ~45 lines
- **Dependencies**: None

---

### **Utils Directory** (`lib/utils/`)

Utility files for constants, validation, data.

#### `lib/utils/constants.dart`
- **Purpose**: Central place for all app constants
- **Contains**:
  - String constants (app name, labels)
  - Numeric constants (padding, radius)
  - List constants (dropdown options)
  - Color constants
- **Example**:
  ```dart
  const String appName = "Athlete Tracker";
  const double defaultPadding = 16.0;
  const List<String> genders = ["Male", "Female", "Other"];
  const List<String> beltLevels = ["White", "Yellow", ...];
  const List<String> statuses = ["Active", "Inactive"];
  ```
- **Size**: ~30 lines
- **No Dependencies**

#### `lib/utils/validators.dart`
- **Purpose**: Form validation logic
- **Contains**:
  - `FormValidators` class with static methods:
    - `validateName(String?)` → String?
    - `validateDropdown(String?)` → String?
    - `validateDateOfBirth(DateTime?)` → String?
  - Each returns error message or null (valid)
- **Size**: ~35 lines
- **No Dependencies**

#### `lib/utils/mock_data.dart`
- **Purpose**: Sample data for development/testing
- **Contains**:
  - `mockAthletes` - List of 5 sample athletes
  - `mockUser` - Sample user
- **Size**: ~50 lines
- **Dependencies**: Athlete, User models

#### `lib/utils/extensions.dart`
- **Purpose**: Utility extension methods
- **Contains**:
  - DateTime extensions (formatting)
  - String extensions (capitalization)
  - List extensions (useful helpers)
- **Size**: ~40 lines
- **No Dependencies**

---

### **Theme Directory** (`lib/theme/`)

App styling and theming.

#### `lib/theme/app_theme.dart`
- **Purpose**: Centralized app theme configuration
- **Contains**:
  - Color palette definitions
  - Text style definitions
  - Material theme configuration
  - Border radius constants
- **Example**:
  ```dart
  class AppColors {
    static const primary = Colors.blue;
    static const secondary = Colors.teal;
    static const error = Colors.red;
    static const success = Colors.green;
  }

  class AppTextStyles {
    static const headingLarge = TextStyle(...);
    static const bodyRegular = TextStyle(...);
  }

  ThemeData getAppTheme() {
    return ThemeData(...);
  }
  ```
- **Size**: ~60 lines
- **No Dependencies**

---

### **Test Directory** (`test/`)

#### `test/widget_test.dart`
- **Purpose**: Basic widget tests
- **Contains**:
  - Example test for main widget
  - Test setup and helpers
- **Size**: Variable
- **Dependencies**: flutter_test

---

## File Organization Chart

```
DEPENDENCY GRAPH:

main.dart
├── HomeScreen (navigation hub)
├── AthleteListScreen
│   ├── AthleteCard (widget)
│   ├── AddAthleteScreen
│   └── AthleteDetailScreen
│       ├── EditAthleteScreen
│       └── model: Athlete
├── TrackingScreen
├── SettingsScreen
│   └── UserProfileScreen
│       └── model: User
└── theme: AppTheme

Utils (used everywhere):
├── constants.dart (used by all screens)
├── validators.dart (used by forms)
├── mock_data.dart (used by list/detail screens)
└── extensions.dart (used by various screens)

Models (data layer):
├── athlete.dart
└── user.dart
```

---

## Module Dependencies

### **Dependency Flow**

```
Models (Independent)
  ↑
  ├── Used by: Screens, Widgets
  │
Utilities (Independent)
  ↑
  ├── Used by: Screens, Widgets, Widgets
  │
Widgets (Depends on Models)
  ↑
  ├── Used by: Screens
  │
Screens (Depends on Models, Widgets, Utils)
  ↑
  ├── Used by: main.dart
  │
main.dart (Root)
  └── Uses everything
```

### **Import Pattern**

Good import organization:

```dart
// Standard library imports first
import 'dart:async';

// Package imports
import 'package:flutter/material.dart';

// Relative imports (your project)
import '../models/athlete.dart';
import '../utils/constants.dart';
import '../widgets/athlete_card.dart';
```

---

## File Creation Checklist

### **Phase 1: Setup (Day 1)**
- [x] Create `lib/models/athlete.dart`
- [x] Create `lib/models/user.dart`
- [x] Create `lib/utils/constants.dart`
- [x] Create `lib/utils/validators.dart`
- [x] Create `lib/utils/mock_data.dart`

### **Phase 2: Base UI (Day 2)**
- [x] Update `lib/main.dart` (root + bottom nav)
- [x] Create `lib/screens/athlete_list.dart` (placeholder)
- [x] Create `lib/screens/tracking.dart`
- [x] Create `lib/screens/settings.dart` (placeholder)

### **Phase 3: List & Search (Day 3)**
- [x] Create `lib/widgets/athlete_card.dart`
- [x] Complete `lib/screens/athlete_list.dart` (with list & search)

### **Phase 4: Forms & Detail (Day 4-5)**
- [x] Create `lib/screens/athlete_detail.dart`
- [x] Create `lib/screens/add_athlete.dart`
- [x] Create `lib/theme/app_theme.dart` (optional, for better UI)

### **Phase 5: Full CRUD (Day 6)**
- [x] Create `lib/screens/edit_athlete.dart`
- [x] Create `lib/screens/user_profile.dart`
- [x] Create `lib/widgets/form_field.dart` (optional reusable)
- [x] Create `lib/widgets/bottom_nav_widget.dart` (optional refactor)

### **Phase 6: Polish (Day 7)**
- [x] Create `lib/utils/extensions.dart`
- [x] Add comprehensive comments
- [x] Create `test/widget_test.dart`

---

## Quick File Count

| Directory | Files | Purpose |
|-----------|-------|---------|
| `models/` | 2 | Data structures |
| `screens/` | 7 | Main app pages |
| `widgets/` | 3 | Reusable components |
| `utils/` | 4 | Helpers & constants |
| `theme/` | 1 | App styling |
| `test/` | 1 | Unit tests |
| **Root** | **1** | Entry point |
| **TOTAL** | **19** | Total files |

---

## How to Create This Structure

### **Option 1: Manual Creation**
```bash
cd lib
mkdir -p models screens widgets utils theme

# Create files
touch models/athlete.dart models/user.dart
touch screens/{athlete_list,add_athlete,edit_athlete,athlete_detail,tracking,settings,user_profile}.dart
touch widgets/{athlete_card,form_field,bottom_nav_widget}.dart
touch utils/{constants,validators,mock_data,extensions}.dart
touch theme/app_theme.dart
```

### **Option 2: IDE**
- Right-click on `lib/`
- New → Directory
- Create: `models`, `screens`, `widgets`, `utils`, `theme`
- Right-click each directory
- New → File
- Create files with `.dart` extension

### **Option 3: Use VS Code**
- Create folders using File Explorer in sidebar
- Create files using "New File" command

---

## Best Practices for File Organization

1. **One Class Per File** (usually)
   - ✅ Good: `athlete_card.dart` contains only `AthleteCard` class
   - ❌ Bad: Multiple unrelated classes in one file

2. **Meaningful File Names**
   - ✅ Good: `athlete_list.dart`, `add_athlete.dart`
   - ❌ Bad: `screen1.dart`, `widget_helper.dart`

3. **Consistent Naming**
   - Classes: PascalCase (e.g., `AthleteCard`)
   - Files: snake_case (e.g., `athlete_card.dart`)
   - Variables: camelCase (e.g., `athleteName`)

4. **Group Related Files**
   - All screens in `screens/`
   - All widgets in `widgets/`
   - All utilities in `utils/`

5. **Keep Files Focused**
   - Each file should have one primary responsibility
   - If a file gets > 300 lines, consider splitting it

6. **Use Relative Imports Consistently**
   ```dart
   // Good
   import '../models/athlete.dart';
   
   // Avoid
   import 'package:tamdan/models/athlete.dart'; // From same project
   ```

---

## Next Steps

1. **Read** `HENG.md` or `FLUTTER_BEGINNER_GUIDE.md` for concepts
2. **Follow** `PANHA.md` or `ONBOARDING_PLAN.md` for daily tasks
3. **Use** this `PROJECT_STRUCTURE.md` as reference
4. **Create** files following the structure above
5. **Develop** following the 7-day plan

---

## Summary

- **19 total files** to create
- **Organized into 6 directories** (models, screens, widgets, utils, theme)
- **Clear responsibilities** for each file
- **Reusable components** in widgets/
- **Centralized utilities** in utils/
- **Easy to scale** and maintain

Good luck with your development! 🚀
