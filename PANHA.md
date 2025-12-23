# 7-Day Flutter App Development Plan
## Athlete Tracking App - Onboarding Schedule

---

## How to Use This Plan

This plan breaks down the app into small, manageable daily tasks. Each day:

1. **Builds on the previous day** - You'll have a working foundation
2. **Has clear goals** - Know exactly what to finish
3. **Shows expected output** - See what success looks like
4. **Takes 4-6 hours** - Realistic for learning

**Before Starting:**
- Read the Flutter Beginner Guide (in FLUTTER_BEGINNER_GUIDE.md)
- Have Flutter installed and working (`flutter doctor`)
- Create mock data file first

---

## Day 1: Project Setup & Models 🚀

**Theme**: Foundation & Data Structures

### Goals
- [ ] Set up project structure
- [ ] Create data models
- [ ] Create mock data

### Detailed Tasks

#### Task 1.1: Create Project Structure
Create these folders in `lib/`:
```
lib/
├── models/
├── screens/
├── widgets/
├── utils/
└── theme/
```

**How**: Use your file explorer or terminal:
```bash
mkdir -p lib/{models,screens,widgets,utils,theme}
```

**Time**: 5 minutes

---

#### Task 1.2: Create Athlete Model
**File**: `lib/models/athlete.dart`

**Requirements**:
- Properties: `id`, `name`, `dateOfBirth`, `gender`, `beltLevel`, `status`
- All properties required (use `required` keyword)
- Add a simple toString() method

**Example Structure**:
```dart
class Athlete {
  final String id;
  final String name;
  final DateTime dateOfBirth;
  final String gender;
  final String beltLevel;
  final String status;

  Athlete({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    required this.gender,
    required this.beltLevel,
    required this.status,
  });

  @override
  String toString() => 'Athlete: $name ($beltLevel)';
}
```

**Time**: 10 minutes

---

#### Task 1.3: Create User Model
**File**: `lib/models/user.dart`

**Requirements**:
- Properties: `name`, `email`, `role`, `createdDate`
- All properties required
- Add a toString() method

**Example**:
```dart
class User {
  final String name;
  final String email;
  final String role;
  final DateTime createdDate;

  User({
    required this.name,
    required this.email,
    required this.role,
    required this.createdDate,
  });

  @override
  String toString() => '$name - $role';
}
```

**Time**: 10 minutes

---

#### Task 1.4: Create Constants File
**File**: `lib/utils/constants.dart`

**Requirements**:
- App name constant
- List of genders: `["Male", "Female", "Other"]`
- List of belt levels: `["White", "Yellow", "Orange", "Green", "Blue", "Brown", "Black"]`
- List of statuses: `["Active", "Inactive"]`
- Spacing constant (16.0)

**Example**:
```dart
const String appName = "Athlete Tracker";

const double defaultPadding = 16.0;
const double defaultBorderRadius = 8.0;

const List<String> genders = ["Male", "Female", "Other"];
const List<String> beltLevels = ["White", "Yellow", "Orange", "Green", "Blue", "Brown", "Black"];
const List<String> statuses = ["Active", "Inactive"];
```

**Time**: 10 minutes

---

#### Task 1.5: Create Mock Data
**File**: `lib/utils/mock_data.dart`

**Requirements**:
- Create 5 sample athletes with realistic data
- Create 1 sample user
- Use the Athlete and User classes

**Example**:
```dart
import 'package:tamdan/models/athlete.dart';
import 'package:tamdan/models/user.dart';

final List<Athlete> mockAthletes = [
  Athlete(
    id: "1",
    name: "John Doe",
    dateOfBirth: DateTime(2005, 3, 15),
    gender: "Male",
    beltLevel: "White",
    status: "Active",
  ),
  Athlete(
    id: "2",
    name: "Sarah Smith",
    dateOfBirth: DateTime(2004, 7, 22),
    gender: "Female",
    beltLevel: "Yellow",
    status: "Active",
  ),
  // ... 3 more athletes
];

final User mockUser = User(
  name: "Coach Alex",
  email: "coach.alex@gym.com",
  role: "Head Trainer",
  createdDate: DateTime(2023, 1, 1),
);
```

**Time**: 15 minutes

---

### Expected Output by End of Day 1

✅ Project structure created
✅ `athlete.dart` with Athlete class
✅ `user.dart` with User class
✅ `constants.dart` with all app constants
✅ `mock_data.dart` with 5 athletes and 1 user
✅ No errors when you run `flutter pub get`

### Verification

Run this in terminal:
```bash
cd f:\Year3\Mobile Development\tamdan
flutter pub get
flutter analyze
```

Should see no errors.

### Time Estimate
**Total: 1 hour**

---

---

## Day 2: Main Screen & Bottom Navigation 📱

**Theme**: App Shell & Navigation

### Goals
- [ ] Create main app structure
- [ ] Implement bottom navigation
- [ ] Create placeholder screens for each tab

### Detailed Tasks

#### Task 2.1: Create Main App & Home Screen
**File**: `lib/main.dart`

**Requirements**:
- MaterialApp with proper theming
- Home screen with 3 tabs
- Bottom navigation bar with 3 items

**Structure**:
```dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Athlete Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        // Athletes tab content (placeholder)
        const Scaffold(
          body: Center(child: Text("Athletes Tab")),
        ),
        // Tracking tab content (placeholder)
        const Scaffold(
          body: Center(child: Text("Tracking Tab")),
        ),
        // Settings tab content (placeholder)
        const Scaffold(
          body: Center(child: Text("Settings Tab")),
        ),
      ][_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "Athletes",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes),
            label: "Tracking",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
```

**Time**: 20 minutes

---

#### Task 2.2: Create Placeholder Screens
**Files**:
- `lib/screens/athlete_list.dart` (StatefulWidget with placeholder)
- `lib/screens/tracking.dart` (StatelessWidget with placeholder)
- `lib/screens/settings.dart` (StatelessWidget with placeholder)

**Each Screen Should Have**:
- A Scaffold
- AppBar with title
- Center widget with placeholder text

**Example** (`tracking.dart`):
```dart
import 'package:flutter/material.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tracking")),
      body: const Center(
        child: Text("Tracking feature coming soon"),
      ),
    );
  }
}
```

**Time**: 15 minutes

---

#### Task 2.3: Update Main Screen to Use Placeholder Screens
**File**: `lib/main.dart`

**Change**:
Replace the hardcoded placeholder widgets with actual screen imports:

```dart
import 'package:tamdan/screens/athlete_list.dart';
import 'package:tamdan/screens/tracking.dart';
import 'package:tamdan/screens/settings.dart';

// In _HomeScreenState.build():
body: [
  const AthleteListScreen(),
  const TrackingScreen(),
  const SettingsScreen(),
][_selectedIndex],
```

**Time**: 10 minutes

---

#### Task 2.4: Test Navigation
**Manual Testing**:
- [ ] App runs without errors
- [ ] Bottom navigation shows 3 tabs
- [ ] Tapping each tab changes content
- [ ] Tab icons display correctly

**Time**: 10 minutes

---

### Expected Output by End of Day 2

✅ `lib/main.dart` with MaterialApp and bottom navigation
✅ Three placeholder screens created
✅ Navigation between tabs works
✅ App runs and displays correctly

### Verification

Run app and check:
```bash
flutter run
```

- See 3 tabs at bottom
- Tabs switch content when tapped
- No errors

### Time Estimate
**Total: 1-1.5 hours**

---

---

## Day 3: Athlete List Screen 📋

**Theme**: Lists, Search & UI Layout

### Goals
- [ ] Display mock athletes in a list
- [ ] Add search functionality
- [ ] Create athlete card widget
- [ ] Add navigation to detail screen (navigation only, not built yet)

### Detailed Tasks

#### Task 3.1: Create Athlete Card Widget
**File**: `lib/widgets/athlete_card.dart`

**Requirements**:
- Display: name, belt level, status, gender
- Show as a Card widget
- Accept `onTap` callback
- Accept an Athlete object

**Example Structure**:
```dart
import 'package:flutter/material.dart';
import 'package:tamdan/models/athlete.dart';

class AthleteCard extends StatelessWidget {
  final Athlete athlete;
  final VoidCallback onTap;

  const AthleteCard({
    required this.athlete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          leading: CircleAvatar(
            child: Text(athlete.name[0]),
          ),
          title: Text(athlete.name),
          subtitle: Text("${athlete.beltLevel} • ${athlete.status}"),
          trailing: const Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}
```

**Time**: 15 minutes

---

#### Task 3.2: Build Athlete List Screen
**File**: `lib/screens/athlete_list.dart`

**Requirements**:
- Import mock data
- Display list of athletes using AthleteCard
- Add search bar at top
- Filter athletes by name (as user types)
- Show "No athletes found" if list is empty after search

**Key Sections**:

1. **State Variables**:
```dart
List<Athlete> filteredAthletes = [];
String searchQuery = "";

@override
void initState() {
  super.initState();
  filteredAthletes = mockAthletes;
}
```

2. **Search Method**:
```dart
void searchAthletes(String query) {
  setState(() {
    searchQuery = query;
    if (query.isEmpty) {
      filteredAthletes = mockAthletes;
    } else {
      filteredAthletes = mockAthletes
          .where((athlete) => athlete.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  });
}
```

3. **Build Method**:
```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text("Athletes")),
    body: Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search by name...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: searchAthletes,
          ),
        ),
        // List of athletes
        Expanded(
          child: filteredAthletes.isEmpty
              ? const Center(child: Text("No athletes found"))
              : ListView.builder(
                  itemCount: filteredAthletes.length,
                  itemBuilder: (context, index) {
                    return AthleteCard(
                      athlete: filteredAthletes[index],
                      onTap: () {
                        // TODO: Navigate to detail screen
                      },
                    );
                  },
                ),
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        // TODO: Navigate to add athlete screen
      },
      child: const Icon(Icons.add),
    ),
  );
}
```

**Time**: 30 minutes

---

#### Task 3.3: Test the List Screen
**Manual Testing**:
- [ ] Athlete list displays 5 athletes
- [ ] Athletes are shown in cards with name, belt level, status
- [ ] Search bar appears
- [ ] Typing in search filters athletes
- [ ] Clearing search shows all athletes
- [ ] "No athletes found" appears for invalid search
- [ ] Floating "+" button appears

**Time**: 10 minutes

---

### Expected Output by End of Day 3

✅ `lib/widgets/athlete_card.dart` - Reusable card widget
✅ `lib/screens/athlete_list.dart` - Full list screen with search
✅ Search functionality working
✅ Mock data displaying correctly
✅ No console errors

### Verification

Run app, navigate to Athletes tab:
- See list of 5 athletes
- Search bar at top
- Search filters work
- No errors

### Time Estimate
**Total: 1-1.5 hours**

---

---

## Day 4: Form Validation & Athlete Detail Screen (Part 1) 📝

**Theme**: Data Validation & Detail View

### Goals
- [ ] Create form validators
- [ ] Create athlete detail screen (view-only)
- [ ] Add navigation from list to detail
- [ ] Display athlete details with formatting

### Detailed Tasks

#### Task 4.1: Create Form Validators
**File**: `lib/utils/validators.dart`

**Requirements**:
- Validate name (not empty, min 2 chars)
- Validate dropdown (not empty)
- Validate date (not null)

**Code**:
```dart
class FormValidators {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Name is required";
    }
    if (value.length < 2) {
      return "Name must be at least 2 characters";
    }
    return null;
  }

  static String? validateDropdown(String? value) {
    if (value == null || value.isEmpty) {
      return "This field is required";
    }
    return null;
  }

  static String? validateDateOfBirth(DateTime? value) {
    if (value == null) {
      return "Date of birth is required";
    }
    return null;
  }
}
```

**Time**: 10 minutes

---

#### Task 4.2: Create Athlete Detail Screen (View-Only)
**File**: `lib/screens/athlete_detail.dart`

**Requirements**:
- Receive athlete as parameter
- Display athlete info: name, DOB, gender, belt level, status
- Format date nicely (e.g., "15 Mar 2005")
- Show edit and delete buttons (non-functional for now)
- Back button/arrow at top

**Example Structure**:
```dart
import 'package:flutter/material.dart';
import 'package:tamdan/models/athlete.dart';

class AthleteDetailScreen extends StatelessWidget {
  final Athlete athlete;

  const AthleteDetailScreen({required this.athlete});

  String _formatDate(DateTime date) {
    final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Athlete Details"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name section
            const Text("Name", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(athlete.name, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),

            // Date of Birth
            const Text("Date of Birth", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(_formatDate(athlete.dateOfBirth), style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),

            // Gender
            const Text("Gender", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(athlete.gender, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),

            // Belt Level
            const Text("Belt Level", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(athlete.beltLevel, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),

            // Status
            const Text("Status", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(athlete.status, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 32),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Navigate to edit screen
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit"),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Delete athlete
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text("Delete"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

**Time**: 25 minutes

---

#### Task 4.3: Add Navigation from List to Detail
**File**: `lib/screens/athlete_list.dart`

**Change the onTap in AthleteCard**:
```dart
AthleteCard(
  athlete: filteredAthletes[index],
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AthleteDetailScreen(
          athlete: filteredAthletes[index],
        ),
      ),
    );
  },
)
```

**Don't forget to import**:
```dart
import 'package:tamdan/screens/athlete_detail.dart';
```

**Time**: 5 minutes

---

#### Task 4.4: Test Navigation & Detail Screen
**Manual Testing**:
- [ ] Tap on an athlete in list
- [ ] Detail screen opens
- [ ] All athlete info displays correctly
- [ ] Date is formatted nicely
- [ ] Back arrow button works
- [ ] Edit and Delete buttons appear (not functional yet)

**Time**: 10 minutes

---

### Expected Output by End of Day 4

✅ `lib/utils/validators.dart` - Form validation functions
✅ `lib/screens/athlete_detail.dart` - Detail screen with athlete info
✅ Navigation from list → detail working
✅ Date formatting working
✅ All athlete fields displaying correctly

### Verification

Run app:
1. Go to Athletes tab
2. Tap on an athlete
3. See full details
4. Tap back arrow to return

### Time Estimate
**Total: 1-1.5 hours**

---

---

## Day 5: Add Athlete Screen (Form) ➕

**Theme**: Form Creation & Data Input

### Goals
- [ ] Create add athlete form with all fields
- [ ] Implement form validation
- [ ] Handle form submission
- [ ] Navigate back with new athlete data

### Detailed Tasks

#### Task 5.1: Create Add Athlete Screen
**File**: `lib/screens/add_athlete.dart`

**Requirements**:
- Form with: name, DOB, gender, belt level, status
- All fields required (validated)
- Save and Cancel buttons
- Return new athlete to calling screen

**Code Structure**:
```dart
import 'package:flutter/material.dart';
import 'package:tamdan/models/athlete.dart';
import 'package:tamdan/utils/constants.dart';
import 'package:tamdan/utils/validators.dart';

class AddAthleteScreen extends StatefulWidget {
  const AddAthleteScreen();

  @override
  State<AddAthleteScreen> createState() => _AddAthleteScreenState();
}

class _AddAthleteScreenState extends State<AddAthleteScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form fields
  String _name = "";
  DateTime? _dateOfBirth;
  String? _gender;
  String? _beltLevel;
  String? _status;

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _dateOfBirth = picked);
    }
  }

  void _saveAthlete() {
    if (_formKey.currentState!.validate() && _dateOfBirth != null) {
      final newAthlete = Athlete(
        id: DateTime.now().toString(),
        name: _name,
        dateOfBirth: _dateOfBirth!,
        gender: _gender!,
        beltLevel: _beltLevel!,
        status: _status!,
      );
      Navigator.pop(context, newAthlete);
    } else if (_dateOfBirth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Date of birth is required")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Athlete"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Name field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: FormValidators.validateName,
                  onChanged: (value) => _name = value,
                ),
                const SizedBox(height: 16),

                // Date of Birth field
                GestureDetector(
                  onTap: _selectDate,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _dateOfBirth == null
                              ? "Select Date of Birth"
                              : "${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}",
                        ),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Gender dropdown
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Gender",
                    border: OutlineInputBorder(),
                  ),
                  items: genders
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  validator: FormValidators.validateDropdown,
                  onChanged: (value) => setState(() => _gender = value),
                ),
                const SizedBox(height: 16),

                // Belt Level dropdown
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Belt Level",
                    border: OutlineInputBorder(),
                  ),
                  items: beltLevels
                      .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                      .toList(),
                  validator: FormValidators.validateDropdown,
                  onChanged: (value) => setState(() => _beltLevel = value),
                ),
                const SizedBox(height: 16),

                // Status dropdown
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Status",
                    border: OutlineInputBorder(),
                  ),
                  items: statuses
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  validator: FormValidators.validateDropdown,
                  onChanged: (value) => setState(() => _status = value),
                ),
                const SizedBox(height: 32),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: _saveAthlete,
                      child: const Text("Save"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

**Note**: Import constants at top:
```dart
import 'package:tamdan/utils/constants.dart';
```

But use the short names: `genders`, `beltLevels`, `statuses`

**Time**: 40 minutes

---

#### Task 5.2: Add Navigation from List to Add Screen
**File**: `lib/screens/athlete_list.dart`

**Update the floating action button**:
```dart
floatingActionButton: FloatingActionButton(
  onPressed: () async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddAthleteScreen(),
      ),
    );
    if (result != null && result is Athlete) {
      setState(() {
        mockAthletes.add(result);
        filteredAthletes = mockAthletes;
      });
    }
  },
  child: const Icon(Icons.add),
),
```

**Don't forget to import**:
```dart
import 'package:tamdan/screens/add_athlete.dart';
```

**Time**: 10 minutes

---

#### Task 5.3: Test Form & Navigation
**Manual Testing**:
- [ ] Tap + button on athlete list
- [ ] Form opens with all fields
- [ ] Try saving with empty name → error appears
- [ ] Try saving without selecting date → error appears
- [ ] Try saving without selecting dropdowns → errors appear
- [ ] Fill all fields correctly
- [ ] Click Save
- [ ] New athlete appears in list
- [ ] New athlete data is correct

**Time**: 15 minutes

---

### Expected Output by End of Day 5

✅ `lib/screens/add_athlete.dart` - Complete form with all fields
✅ Form validation working for all fields
✅ Date picker working
✅ Navigation from list → form → back to list
✅ New athletes added to list correctly
✅ Form prevents saving with invalid data

### Verification

Run app:
1. Go to Athletes tab
2. Tap + button
3. Try saving empty form → see validation errors
4. Fill all fields
5. Save
6. See new athlete in list

### Time Estimate
**Total: 1.5 hours**

---

---

## Day 6: Edit & Delete Athlete, User Profile 🔄

**Theme**: Update Operations & User Profile

### Goals
- [ ] Implement delete athlete functionality
- [ ] Implement edit athlete functionality
- [ ] Create user profile screen
- [ ] Add edit profile button

### Detailed Tasks

#### Task 6.1: Implement Delete Athlete
**File**: `lib/screens/athlete_detail.dart`

**Update the delete button**:
```dart
ElevatedButton.icon(
  onPressed: () {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Athlete?"),
        content: Text("Are you sure you want to delete ${athlete.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, "deleted"); // Return to list
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  },
  icon: const Icon(Icons.delete),
  label: const Text("Delete"),
  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
),
```

**Update AthleteListScreen to handle deletion**:
```dart
// In athlete_list.dart, update the navigation:
AthleteCard(
  athlete: filteredAthletes[index],
  onTap: () async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AthleteDetailScreen(
          athlete: filteredAthletes[index],
        ),
      ),
    );
    if (result == "deleted") {
      setState(() {
        mockAthletes.removeWhere((a) => a.id == filteredAthletes[index].id);
        filteredAthletes = mockAthletes;
      });
    }
  },
)
```

**Time**: 15 minutes

---

#### Task 6.2: Implement Edit Athlete
**File**: `lib/screens/edit_athlete.dart` (new file)

**Requirements**:
- Same form as AddAthleteScreen but with prefilled data
- Pre-populate all fields with current athlete data
- Save updates back to list

**Code**:
```dart
import 'package:flutter/material.dart';
import 'package:tamdan/models/athlete.dart';
import 'package:tamdan/utils/constants.dart';
import 'package:tamdan/utils/validators.dart';

class EditAthleteScreen extends StatefulWidget {
  final Athlete athlete;

  const EditAthleteScreen({required this.athlete});

  @override
  State<EditAthleteScreen> createState() => _EditAthleteScreenState();
}

class _EditAthleteScreenState extends State<EditAthleteScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late String _name;
  late DateTime _dateOfBirth;
  late String _gender;
  late String _beltLevel;
  late String _status;

  @override
  void initState() {
    super.initState();
    _name = widget.athlete.name;
    _dateOfBirth = widget.athlete.dateOfBirth;
    _gender = widget.athlete.gender;
    _beltLevel = widget.athlete.beltLevel;
    _status = widget.athlete.status;
  }

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth,
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _dateOfBirth = picked);
    }
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final updatedAthlete = Athlete(
        id: widget.athlete.id,
        name: _name,
        dateOfBirth: _dateOfBirth,
        gender: _gender,
        beltLevel: _beltLevel,
        status: _status,
      );
      Navigator.pop(context, updatedAthlete);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Athlete"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Name field
                TextFormField(
                  initialValue: _name,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: FormValidators.validateName,
                  onChanged: (value) => _name = value,
                ),
                const SizedBox(height: 16),

                // Date of Birth
                GestureDetector(
                  onTap: _selectDate,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${_dateOfBirth.day}/${_dateOfBirth.month}/${_dateOfBirth.year}"),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Gender dropdown
                DropdownButtonFormField<String>(
                  value: _gender,
                  decoration: const InputDecoration(
                    labelText: "Gender",
                    border: OutlineInputBorder(),
                  ),
                  items: genders
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  validator: FormValidators.validateDropdown,
                  onChanged: (value) => setState(() => _gender = value ?? ""),
                ),
                const SizedBox(height: 16),

                // Belt Level dropdown
                DropdownButtonFormField<String>(
                  value: _beltLevel,
                  decoration: const InputDecoration(
                    labelText: "Belt Level",
                    border: OutlineInputBorder(),
                  ),
                  items: beltLevels
                      .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                      .toList(),
                  validator: FormValidators.validateDropdown,
                  onChanged: (value) => setState(() => _beltLevel = value ?? ""),
                ),
                const SizedBox(height: 16),

                // Status dropdown
                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: const InputDecoration(
                    labelText: "Status",
                    border: OutlineInputBorder(),
                  ),
                  items: statuses
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  validator: FormValidators.validateDropdown,
                  onChanged: (value) => setState(() => _status = value ?? ""),
                ),
                const SizedBox(height: 32),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: _saveChanges,
                      child: const Text("Save Changes"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

**Time**: 30 minutes

---

#### Task 6.3: Update Athlete Detail to Use Edit Screen
**File**: `lib/screens/athlete_detail.dart`

**Update the edit button**:
```dart
ElevatedButton.icon(
  onPressed: () async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAthleteScreen(athlete: athlete),
      ),
    );
    if (result != null && result is Athlete) {
      Navigator.pop(context, result);
    }
  },
  icon: const Icon(Icons.edit),
  label: const Text("Edit"),
),
```

**Update AthleteListScreen to handle updates**:
```dart
// In the onTap callback:
final result = await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => AthleteDetailScreen(
      athlete: filteredAthletes[index],
    ),
  ),
);
if (result == "deleted") {
  setState(() {
    mockAthletes.removeWhere((a) => a.id == filteredAthletes[index].id);
    filteredAthletes = mockAthletes;
  });
} else if (result != null && result is Athlete) {
  setState(() {
    final idx = mockAthletes.indexWhere((a) => a.id == result.id);
    mockAthletes[idx] = result;
    filteredAthletes = mockAthletes;
  });
}
```

**Time**: 15 minutes

---

#### Task 6.4: Create User Profile Screen
**File**: `lib/screens/user_profile.dart`

**Requirements**:
- Display user info (from mock data)
- Show edit button (non-functional for now)
- Read-only layout

**Code**:
```dart
import 'package:flutter/material.dart';
import 'package:tamdan/utils/mock_data.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen();

  @override
  Widget build(BuildContext context) {
    final user = mockUser;

    return Scaffold(
      appBar: AppBar(title: const Text("User Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Avatar
            Center(
              child: CircleAvatar(
                radius: 50,
                child: Text(
                  user.name[0],
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Name
            const Text("Name", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(user.name, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),

            // Email
            const Text("Email", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(user.email, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),

            // Role
            const Text("Role", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(user.role, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),

            // Member Since
            const Text("Member Since", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              "${user.createdDate.day}/${user.createdDate.month}/${user.createdDate.year}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 32),

            // Edit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement edit profile
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Edit profile coming soon")),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text("Edit Profile"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Time**: 20 minutes

---

#### Task 6.5: Add Navigation to Settings
**File**: `lib/screens/settings.dart`

**Replace the placeholder**:
```dart
import 'package:flutter/material.dart';
import 'package:tamdan/screens/user_profile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("User Profile"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserProfileScreen(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("About"),
            subtitle: const Text("Version 1.0.0"),
          ),
        ],
      ),
    );
  }
}
```

**Time**: 10 minutes

---

#### Task 6.6: Test All New Features
**Manual Testing**:
- [ ] Edit an athlete → form opens with prefilled data
- [ ] Edit fields and save → changes appear in list
- [ ] Delete an athlete → confirmation dialog appears
- [ ] Confirm delete → athlete removed from list
- [ ] Go to Settings tab
- [ ] Tap "User Profile"
- [ ] See user info displayed correctly
- [ ] All navigation works smoothly

**Time**: 15 minutes

---

### Expected Output by End of Day 6

✅ `lib/screens/edit_athlete.dart` - Edit form with prefilled data
✅ Delete athlete functionality with confirmation
✅ Edit athlete functionality working
✅ `lib/screens/user_profile.dart` - User profile screen
✅ Settings screen navigation to profile
✅ All CRUD operations working (Create, Read, Update, Delete)

### Verification

Run app and test:
1. Edit an athlete completely
2. Delete an athlete
3. Navigate to Settings → User Profile
4. See all updates reflected

### Time Estimate
**Total: 2 hours**

---

---

## Day 7: Polish & Testing 🎉

**Theme**: Refinement, Testing & Documentation

### Goals
- [ ] Fix any bugs
- [ ] Improve UI/UX
- [ ] Test all features thoroughly
- [ ] Document the code
- [ ] Clean up and optimize

### Detailed Tasks

#### Task 7.1: Code Review & Cleanup
**What to Check**:
- [ ] No unused imports
- [ ] Consistent naming (camelCase, PascalCase)
- [ ] Comments on complex logic
- [ ] No debug print statements
- [ ] Proper error handling

**In Each File**:
1. Remove unused imports
2. Check widget names follow PascalCase
3. Check variable names follow camelCase
4. Remove any `print()` or `debugPrint()` calls
5. Add comments to complex methods

**Time**: 20 minutes

---

#### Task 7.2: UI/UX Polish
**Improvements to Make**:

1. **Better Date Formatting** (in athlete_detail.dart):
```dart
String _formatDate(DateTime date) {
  final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
  return "${date.day} ${months[date.month - 1]} ${date.year}";
}
```

2. **Add Icons to Athlete Cards** (in athlete_card.dart):
```dart
leading: CircleAvatar(
  backgroundColor: Colors.blue.shade100,
  child: Text(
    athlete.name[0].toUpperCase(),
    style: const TextStyle(fontWeight: FontWeight.bold),
  ),
),
```

3. **Add Empty State Message** (in athlete_list.dart):
```dart
if (mockAthletes.isEmpty)
  const Center(
    child: Text("No athletes yet. Tap + to add one!"),
  )
```

4. **Add Loading Indicator Hint** (optional improvement):
```dart
if (filteredAthletes.isEmpty && searchQuery.isNotEmpty)
  const Center(child: Text("No athletes match your search"))
```

**Time**: 20 minutes

---

#### Task 7.3: Comprehensive Testing
**Test Each Feature Completely**:

**Athlete List Screen**:
- [ ] List displays all athletes
- [ ] Search works correctly
- [ ] Empty state shows if list is empty
- [ ] Tapping athlete navigates to detail

**Add Athlete Screen**:
- [ ] All form fields present
- [ ] Validation works for each field
- [ ] Date picker works
- [ ] Save adds athlete to list
- [ ] Cancel closes without saving

**Athlete Detail Screen**:
- [ ] All athlete info displays
- [ ] Date formatted nicely
- [ ] Edit button opens edit form
- [ ] Delete button with confirmation

**Edit Athlete Screen**:
- [ ] Fields prefilled with current data
- [ ] Edits save correctly
- [ ] Changes reflect in list immediately

**User Profile Screen**:
- [ ] User info displays correctly
- [ ] Navigation from Settings works
- [ ] All fields visible

**Navigation**:
- [ ] Bottom nav switches tabs
- [ ] Back buttons work everywhere
- [ ] Data persists after navigation

**Edge Cases**:
- [ ] Search for non-existent athlete
- [ ] Delete all athletes
- [ ] Add athlete with special characters in name
- [ ] Rotate device and check layout

**Time**: 30 minutes

---

#### Task 7.4: Document Your Code
**Add Comments to Key Files**:

**athlete_list.dart** (at the top):
```dart
/// Displays a list of athletes with search functionality.
/// 
/// Users can:
/// - View all athletes in a scrollable list
/// - Search athletes by name
/// - Tap to view athlete details
/// - Tap + button to add new athlete
class AthleteListScreen extends StatefulWidget {
  ...
}
```

**add_athlete.dart** (at the top):
```dart
/// Form for adding a new athlete.
/// 
/// Validates all fields and returns a new Athlete object
/// or null if cancelled.
class AddAthleteScreen extends StatefulWidget {
  ...
}
```

**models/athlete.dart**:
```dart
/// Represents an athlete in the system.
/// 
/// Contains all athlete information including name, date of birth,
/// gender, belt level, and current status.
class Athlete {
  ...
}
```

**Time**: 15 minutes

---

#### Task 7.5: Final Integration Test
**Complete User Journey Test**:

1. **Add Multiple Athletes**:
   - Add 3 new athletes with different data
   - Verify all appear in list

2. **Search & Filter**:
   - Search for each newly added athlete
   - Verify filtering works

3. **Edit & Delete**:
   - Edit one athlete's details
   - Delete one athlete
   - Verify changes in list

4. **View Profile**:
   - Navigate to Settings tab
   - Open User Profile
   - Verify all info displays

5. **Navigation**:
   - Verify all back buttons work
   - Verify tab switching works
   - Verify no crashes or errors

**Expected Result**: App flows smoothly without errors

**Time**: 20 minutes

---

#### Task 7.6: Optimization & Performance
**Small Improvements**:

1. **Use `const` More**:
```dart
// Instead of this:
return Padding(
  padding: EdgeInsets.all(16),
  child: Text("Hello"),
);

// Do this:
return const Padding(
  padding: EdgeInsets.all(16),
  child: Text("Hello"),
);
```

2. **Cache String Constants**:
```dart
// Instead of hardcoding strings:
Text("Add Athlete") // repeated in multiple places

// Use constants:
const String addAthleteLabel = "Add Athlete";
Text(addAthleteLabel)
```

3. **Minimize Rebuilds** - Don't rebuild parent when editing child

**Time**: 15 minutes

---

#### Task 7.7: Create a README for the App
**File**: `APP_README.md` or update existing `README.md`

**Include**:
- What the app does
- How to run it
- Feature overview
- Known limitations

**Example Content**:
```markdown
# Athlete Tracking App

A simple Flutter app for managing athlete information.

## Features

- View list of athletes
- Search athletes by name
- Add new athletes with form validation
- View athlete details
- Edit athlete information
- Delete athletes
- View user profile

## How to Run

1. Make sure Flutter is installed
2. Run `flutter pub get`
3. Run `flutter run`

## Project Structure

```
lib/
├── models/        # Data models (Athlete, User)
├── screens/       # App screens/pages
├── widgets/       # Reusable widgets
├── utils/         # Constants, validators, mock data
└── main.dart      # App entry point
```

## Known Limitations

- Uses mock data (no database)
- Local state management only (no Provider/BLoC)
- Android only (Material Design)
- No backend/API integration

## Next Steps for Enhancement

- Add local database (SQLite)
- Implement proper state management
- Add unit and widget tests
- Add athlete photos
- Add workout tracking
```

**Time**: 15 minutes

---

### Expected Output by End of Day 7

✅ All code reviewed and cleaned up
✅ UI polished with better formatting
✅ Comprehensive testing completed
✅ Code documented with comments
✅ All features working without bugs
✅ README created
✅ App ready for next phase

### Final Verification

Run app one last time and verify:
- No console errors
- All features work
- Navigation is smooth
- No unused code or imports
- Comments are clear

### Time Estimate
**Total: 2-2.5 hours**

---

---

## Summary: Your Week at a Glance

| Day | Theme | Output |
|-----|-------|--------|
| **Day 1** | Foundation | Models, constants, mock data |
| **Day 2** | App Shell | Main screen, bottom nav, basic routing |
| **Day 3** | List & Search | Athlete list with search functionality |
| **Day 4** | Details & Validation | Detail screen, form validators |
| **Day 5** | Form Input | Complete add athlete form |
| **Day 6** | CRUD Complete | Edit, delete, user profile |
| **Day 7** | Polish & Testing | Code review, testing, documentation |

---

## Weekly Hour Breakdown

- **Day 1**: ~1 hour
- **Day 2**: ~1.5 hours
- **Day 3**: ~1.5 hours
- **Day 4**: ~1.5 hours
- **Day 5**: ~1.5 hours
- **Day 6**: ~2 hours
- **Day 7**: ~2.5 hours

**Total**: ~11.5 hours of focused development

---

## Success Criteria (Definition of Done)

By the end of Day 7, you should have:

✅ A working Flutter app with 4 main screens
✅ Full CRUD operations (Create, Read, Update, Delete)
✅ Form validation on all inputs
✅ Search functionality
✅ Navigation between all screens
✅ No bugs or console errors
✅ Clean, readable code
✅ Basic documentation

**Most importantly**: A solid foundation to build upon!

---

## If You Get Stuck

1. **Check the Flutter Beginner Guide** - Refer back to concepts
2. **Read Error Messages** - They're usually helpful
3. **Use Hot Reload** - Test changes instantly
4. **Print Statements** - Debug by printing variables
5. **Simplify** - Start with minimal code, add complexity later
6. **Ask Questions** - Better to clarify than guess

---

## Tips for Success

1. **Do one task at a time** - Don't jump ahead
2. **Test as you go** - Run the app after each task
3. **Take breaks** - Mental fatigue leads to bugs
4. **Write clean code** - Future you will thank present you
5. **Read the guide** - It answers most beginner questions
6. **Don't skip days** - Each day builds on the previous

---

## After Day 7: What's Next?

Once you complete this plan, you can:

- Add **local database** using SQLite
- Implement **proper state management** (Provider, BLoC)
- Add **unit and widget tests**
- Add **athlete photos** with image picker
- Add **workout tracking** feature
- Deploy to **Google Play Store**

But first, master the fundamentals. Great job! 🎉

---

## Quick Reference: Key Commands

```bash
# Run the app
flutter run

# Check for errors
flutter analyze

# Format code
dart format lib/

# Run tests (after Day 7)
flutter test

# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

---

**Good luck! You've got this! 💪**

If you have questions while following this plan, refer back to the Flutter Beginner Guide for detailed explanations and code examples.
