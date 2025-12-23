# Development Workflow & Dependency Map
## Complete Guide for Team Members

---

## Table of Contents
1. [File Creation Timeline](#file-creation-timeline)
2. [Dependencies Graph](#dependencies-graph)
3. [Code Flow Diagram](#code-flow-diagram)
4. [Integration Checklist](#integration-checklist)
5. [Common Issues & Solutions](#common-issues--solutions)

---

## File Creation Timeline

Follow this order to avoid dependency issues:

### **Phase 1: Foundation (Day 1) - No Dependencies**
Create these first - they don't depend on anything:

```
Step 1.1: Create lib/models/athlete.dart (30 lines)
          No dependencies needed
          
Step 1.2: Create lib/models/user.dart (25 lines)
          No dependencies needed
          
Step 1.3: Create lib/utils/constants.dart (30 lines)
          No dependencies needed
          
Step 1.4: Create lib/utils/validators.dart (35 lines)
          No dependencies needed
          
Step 1.5: Create lib/utils/mock_data.dart (50 lines)
          Depends on: models/athlete.dart, models/user.dart
          
Step 1.6: Create lib/theme/app_theme.dart (60 lines)
          No dependencies needed
```

**Why This Order?**
- Models are simple data containers
- Utils don't depend on anything
- Mock data can use models once created

**Status after Phase 1**: 📦 All data structures ready

---

### **Phase 2: Root & Navigation (Day 2) - Basic UI**

```
Step 2.1: Create lib/screens/tracking.dart (30 lines)
          No dependencies needed
          
Step 2.2: Create lib/screens/settings.dart (50 lines)
          No dependencies (yet)
          
Step 2.3: Update lib/main.dart (150 lines)
          Depends on: All screens (but they're stubs for now)
          - Imports: tracking.dart, settings.dart
```

**Why This Order?**
- Create simple placeholder screens first
- main.dart ties everything together
- Hot reload to test bottom nav switching

**Status after Phase 2**: 🎯 App shell works, 3 tabs display

---

### **Phase 3: Athlete List (Day 3) - Search Functionality**

```
Step 3.1: Create lib/widgets/athlete_card.dart (40 lines)
          Depends on: models/athlete.dart
          
Step 3.2: Complete lib/screens/athlete_list.dart (120 lines)
          Depends on: 
            - models/athlete.dart
            - widgets/athlete_card.dart
            - utils/mock_data.dart
            - utils/constants.dart
            
Step 3.3: Update lib/main.dart
          Replace placeholder with: AthleteListScreen
```

**Why This Order?**
- Card widget is small, easy to test
- List screen builds on card
- Tests list and search together

**Status after Phase 3**: 📋 Athlete list with search works

---

### **Phase 4: Details & Validation (Day 4) - View & Validate**

```
Step 4.1: Create lib/screens/athlete_detail.dart (150 lines)
          Depends on: models/athlete.dart
          
Step 4.2: Update lib/screens/athlete_list.dart
          Add navigation to athlete_detail.dart
          
Step 4.3: Update lib/main.dart (if needed)
          May need to import athlete_detail.dart
```

**Why This Order?**
- Detail screen is stateless, simpler first
- Test viewing athlete info
- Set up navigation pattern

**Status after Phase 4**: 👤 Can view athlete details

---

### **Phase 5: Forms (Day 5) - Add & Edit Athletes**

```
Step 5.1: Create lib/screens/add_athlete.dart (180 lines)
          Depends on:
            - models/athlete.dart
            - utils/validators.dart
            - utils/constants.dart
            
Step 5.2: Update lib/screens/athlete_list.dart
          Add navigation to add_athlete.dart
          Add logic to receive new athlete back
          
Step 5.3: Create lib/screens/edit_athlete.dart (185 lines)
          Similar to add_athlete.dart but with pre-filled data
          
Step 5.4: Update lib/screens/athlete_detail.dart
          Add navigation to edit_athlete.dart
```

**Why This Order?**
- Add form is simpler (no pre-fill)
- Learn form patterns with add first
- Apply to edit after

**Status after Phase 5**: ✏️ Full CRUD - Create, Read, Update

---

### **Phase 6: User Profile & Delete (Day 6) - Final CRUD**

```
Step 6.1: Create lib/screens/user_profile.dart (100 lines)
          Depends on:
            - models/user.dart
            - utils/mock_data.dart
            
Step 6.2: Update lib/screens/settings.dart
          Add navigation to user_profile.dart
          
Step 6.3: Update lib/screens/athlete_detail.dart
          Add delete button with confirmation
          Return data back to list screen
          
Step 6.4: Update lib/screens/athlete_list.dart
          Handle athlete deletion from list
```

**Why This Order?**
- Profile is independent
- Delete is last because it needs all pieces together

**Status after Phase 6**: 🗑️ Full CRUD complete (Create, Read, Update, Delete)

---

### **Phase 7: Polish & Optimize (Day 7) - Refinement**

```
Step 7.1: Create lib/utils/extensions.dart
          Add utility methods (optional)
          
Step 7.2: Create lib/widgets/form_field.dart
          Reusable form field (optional refactor)
          
Step 7.3: Create lib/widgets/bottom_nav_widget.dart
          Reusable bottom nav (optional refactor)
          
Step 7.4: Code review and cleanup
          Remove unused imports
          Add comments
          
Step 7.5: Create test/widget_test.dart
          Simple widget tests
```

**Status after Phase 7**: ✨ Production ready

---

## Dependencies Graph

### **Visual Dependency Map**

```
┌─────────────────────────────────────────────────┐
│                   main.dart                      │
│              (Root Widget Tree)                 │
└──────────┬──────────────────────────────────────┘
           │
           ├─ imports ─► theme/app_theme.dart
           │
           ├─ creates ──► HomeScreen
           │               │
           │               ├─ AthleteListScreen
           │               │  ├─ uses ──► models/athlete.dart
           │               │  ├─ uses ──► utils/mock_data.dart
           │               │  ├─ uses ──► utils/constants.dart
           │               │  ├─ uses ──► widgets/athlete_card.dart
           │               │  ├─ navigates ──► AddAthleteScreen
           │               │  └─ navigates ──► AthleteDetailScreen
           │               │
           │               ├─ TrackingScreen (placeholder)
           │               │
           │               └─ SettingsScreen
           │                  └─ navigates ──► UserProfileScreen
           │                     ├─ uses ──► models/user.dart
           │                     └─ uses ──► utils/mock_data.dart
           │
           ├─ screens/add_athlete.dart
           │  ├─ uses ──► models/athlete.dart
           │  ├─ uses ──► utils/validators.dart
           │  └─ uses ──► utils/constants.dart
           │
           ├─ screens/edit_athlete.dart
           │  ├─ uses ──► models/athlete.dart
           │  ├─ uses ──► utils/validators.dart
           │  └─ uses ──► utils/constants.dart
           │
           └─ screens/athlete_detail.dart
              ├─ uses ──► models/athlete.dart
              └─ navigates ──► EditAthleteScreen

Independent Layers:
  
  ┌─────────────────────────┐
  │  Models (Independent)   │
  │  - athlete.dart         │
  │  - user.dart            │
  └────────┬────────────────┘
           │ (used by everything below)
  
  ┌─────────────────────────┐
  │  Utils (Independent)    │
  │  - constants.dart       │
  │  - validators.dart      │
  │  - mock_data.dart       │
  │  - extensions.dart      │
  └────────┬────────────────┘
           │ (used by screens & widgets)
  
  ┌─────────────────────────┐
  │  Widgets (Depends on Models)
  │  - athlete_card.dart    │
  │  - form_field.dart      │
  │  - bottom_nav_widget.dart
  └────────┬────────────────┘
           │ (used by screens)
  
  ┌─────────────────────────┐
  │  Screens (Depends on Everything)
  │  - athlete_list.dart    │
  │  - add_athlete.dart     │
  │  - edit_athlete.dart    │
  │  - athlete_detail.dart  │
  │  - tracking.dart        │
  │  - settings.dart        │
  │  - user_profile.dart    │
  └────────┬────────────────┘
           │ (used by main.dart)
  
  ┌─────────────────────────┐
  │  main.dart (Root)       │
  │  (Everything converges) │
  └─────────────────────────┘
```

### **Import Chain Example**

How data flows through imports:

```
athlete_list.dart needs to show athletes:
  │
  ├─ import 'package:flutter/material.dart' (Flutter UI)
  ├─ import '../models/athlete.dart' (Data structure)
  ├─ import '../utils/constants.dart' (app-wide constants)
  ├─ import '../utils/mock_data.dart' (sample athletes)
  ├─ import '../widgets/athlete_card.dart' (reusable card)
  └─ // This allows creating:
     List<Athlete> athletes = mockAthletes;
     ListView(
       children: athletes.map((a) => AthleteCard(athlete: a)).toList()
     )
```

---

## Code Flow Diagram

### **User Interaction Flow**

```
USER OPENS APP
    ↓
main.dart runs void main()
    ↓
MyApp widget builds MaterialApp
    ↓
HomeScreen shows with BottomNavigationBar
    ↓
┌─────────────────────────────────────────────────┐
│ User selects Tab 0: Athletes                    │
└─────────────────────────────────────────────────┘
    ↓
AthleteListScreen builds
    ├─ Loads mockAthletes from utils/mock_data.dart
    ├─ Displays in ListView with AthleteCard widgets
    └─ Shows search bar
    ↓
┌─────────────────────────────────────────────────┐
│ User Scenario A: Search for athlete             │
└─────────────────────────────────────────────────┘
    ↓
User types in search bar
    ↓
onChanged callback triggered
    ↓
searchAthletes() function called
    ↓
filteredAthletes list updated with setState()
    ↓
build() method called again
    ↓
ListView re-renders with filtered results
    ↓
User sees only matching athletes
    ↓

┌─────────────────────────────────────────────────┐
│ User Scenario B: Tap on athlete to view details │
└─────────────────────────────────────────────────┘
    ↓
User taps AthleteCard
    ↓
onTap callback triggers Navigator.push()
    ↓
AthleteDetailScreen displays
    │
    ├─ Shows athlete data from Athlete object
    └─ Shows Edit and Delete buttons
    ↓
┌─ User taps Edit button                          ┐
    │
    └─ Navigator.push() to EditAthleteScreen
        ↓
        EditAthleteScreen builds
        ├─ Pre-fills form with athlete data
        ├─ User modifies fields
        └─ User taps Save
        ↓
        Validates form using FormValidators
        ↓
        If valid: Create new Athlete object
        ↓
        Navigator.pop(context, updatedAthlete)
        ↓
        Back to AthleteDetailScreen
        ↓
        DetailScreen sends updated data back
        ↓
        Back to AthleteListScreen
        ↓
        AthleteListScreen receives updated athlete
        ↓
        setState() updates the athletes list
        ↓
        ListView re-renders
        ↓
        User sees updated athlete in list
        ↓

┌─ User taps Delete button                        ┐
    │
    └─ Confirmation dialog shows
        ↓
        User confirms
        ↓
        Navigator.pop(context, "deleted")
        ↓
        AthleteListScreen receives "deleted" signal
        ↓
        setState() removes athlete from list
        ↓
        ListView re-renders
        ↓
        User sees athlete removed from list
        ↓

┌─ User taps + button on list (Add new)           ┐
    │
    └─ Navigator.push() to AddAthleteScreen
        ↓
        AddAthleteScreen shows empty form
        ├─ User fills Name
        ├─ User selects DateOfBirth
        ├─ User selects Gender from dropdown
        ├─ User selects BeltLevel from dropdown
        └─ User selects Status from dropdown
        ↓
        User taps Save
        ↓
        Form validation runs
        ├─ validateName() checks name not empty
        ├─ validateDateOfBirth() checks date selected
        └─ validateDropdown() checks all selections made
        ↓
        If any invalid: Show error message
        ↓
        If all valid: Create new Athlete object
        ↓
        Navigator.pop(context, newAthlete)
        ↓
        Back to AthleteListScreen
        ↓
        AthleteListScreen receives newAthlete
        ↓
        setState() adds to athletes list
        ↓
        ListView re-renders
        ↓
        User sees new athlete at bottom of list
        ↓

┌─ User selects Tab 2: Settings                   ┐
    │
    └─ SettingsScreen displays
        ├─ Shows "User Profile" option
        ├─ Shows "About" option
        └─ User taps "User Profile"
        ↓
        UserProfileScreen displays
        ├─ Shows mockUser data from utils/mock_data.dart
        ├─ Displays name, email, role, createdDate
        └─ Shows "Edit Profile" button
        ↓
        Back button navigates back
        ↓
```

---

## Integration Checklist

### **Before Each Phase, Verify:**

#### **Phase 1 Complete?**
- [ ] `lib/models/athlete.dart` compiles without errors
- [ ] `lib/models/user.dart` compiles without errors
- [ ] `lib/utils/constants.dart` has all dropdown lists
- [ ] `lib/utils/validators.dart` has all validation methods
- [ ] `lib/utils/mock_data.dart` loads 5 athletes and 1 user
- [ ] Can run: `flutter analyze` with no errors
- [ ] Can run: `flutter run` (may show default app)

#### **Phase 2 Complete?**
- [ ] `lib/main.dart` shows bottom nav with 3 tabs
- [ ] Tapping tabs switches content
- [ ] No import errors
- [ ] No widget errors

#### **Phase 3 Complete?**
- [ ] Athlete list shows 5 athletes
- [ ] Search bar filters athletes by name
- [ ] Tapping athlete (when implemented) is ready for navigation

#### **Phase 4 Complete?**
- [ ] Can tap athlete → see detail screen
- [ ] Detail screen shows all athlete info
- [ ] Date is formatted nicely
- [ ] Back button works

#### **Phase 5 Complete?**
- [ ] Tap + button → form opens
- [ ] All form fields present
- [ ] Validation works (try saving empty form)
- [ ] Save new athlete → appears in list
- [ ] New athlete has correct data

#### **Phase 6 Complete?**
- [ ] Can edit athlete → see changes in list
- [ ] Can delete athlete → removed from list
- [ ] Settings → User Profile shows user data
- [ ] All navigation works smoothly

#### **Phase 7 Complete?**
- [ ] No unused imports anywhere
- [ ] Code is commented
- [ ] No `print()` or `debugPrint()` statements
- [ ] Tests written (if desired)
- [ ] App is polished and ready

---

## Common Issues & Solutions

### **Issue: "Undefined name 'Athlete'"**
**Cause**: Missing import
**Solution**:
```dart
// Add at top of file
import '../models/athlete.dart';
```

### **Issue: "The method 'add' isn't defined for the type 'List<Athlete>'"**
**Cause**: List is immutable or not initialized
**Solution**:
```dart
// Wrong
final athletes = mockAthletes; // mockAthletes is final

// Right
List<Athlete> athletes = List.from(mockAthletes); // Make mutable copy
// Or
List<Athlete> athletes = []; // Start fresh
```

### **Issue: "Navigator.push requires BuildContext"**
**Cause**: Using context from wrong place
**Solution**:
```dart
// Wrong (using widget context)
void onTap() => Navigator.push(context, ...); // context doesn't exist

// Right (using build context)
@override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: () => Navigator.push(context, ...), // context from build()
    child: child,
  );
}
```

### **Issue: "setState() called after widget disposed"**
**Cause**: Using setState in callback after navigation
**Solution**:
```dart
// Wrong
Navigator.pop(context);
setState(() { /* ... */ }); // Context was popped

// Right
setState(() {
  athletes.add(newAthlete); // First update
});
Navigator.pop(context); // Then navigate
```

### **Issue: Form validation not working**
**Cause**: FormState not properly accessed
**Solution**:
```dart
// Declare GlobalKey at class level
final _formKey = GlobalKey<FormState>();

// Wrap form in Form widget
Form(
  key: _formKey,
  child: Column(...),
)

// Validate before saving
if (_formKey.currentState!.validate()) {
  // Save
}
```

### **Issue: DropdownButtonFormField shows null value**
**Cause**: Value doesn't match an item
**Solution**:
```dart
// Wrong
String? gender; // null
items: ["Male", "Female"].map(...).toList();

// Right
String? gender; // stays null until selected
DropdownButtonFormField<String>(
  value: gender, // Can be null before selection
  items: [...],
  onChanged: (v) => setState(() => gender = v),
)
```

### **Issue: Hot reload doesn't work after structural changes**
**Cause**: Structural changes (new classes, removed files) need full restart
**Solution**:
```bash
# Hot reload (for code changes)
r

# Hot restart (for structure changes)
R

# Full restart (if still broken)
Stop (Ctrl+C) and run flutter run again
```

### **Issue: "The operator '[]' isn't defined for the type 'List<Athlete>'"**
**Cause**: Trying to use invalid index
**Solution**:
```dart
// Check length first
if (athletes.length > index && index >= 0) {
  Athlete athlete = athletes[index];
}

// Or use firstWhere
Athlete athlete = athletes.firstWhere(
  (a) => a.id == id,
  orElse: () => null, // Handle not found
);
```

### **Issue: DateTime picker not working**
**Cause**: Missing async/await or not handling null
**Solution**:
```dart
void _selectDate() async { // async keyword required
  final picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1980),
    lastDate: DateTime.now(),
  );
  if (picked != null) { // Check null
    setState(() => _dateOfBirth = picked);
  }
}
```

### **Issue: Search not filtering correctly**
**Cause**: Case sensitivity or empty list
**Solution**:
```dart
// Convert to lowercase for comparison
filteredAthletes = mockAthletes
    .where((athlete) => athlete.name
        .toLowerCase() // Make lowercase
        .contains(searchQuery.toLowerCase())) // Compare lowercase
    .toList();

// Check for empty search
if (searchQuery.isEmpty) {
  filteredAthletes = mockAthletes;
}
```

---

## Testing Each Component

### **Test Models**
```dart
// In main.dart or test file
final athlete = Athlete(
  id: "1",
  name: "Test",
  dateOfBirth: DateTime(2000, 1, 1),
  gender: "Male",
  beltLevel: "White",
  status: "Active",
);
print(athlete.toString()); // Should print: Athlete: Test (White)
```

### **Test Validators**
```dart
// These should return null (valid)
assert(FormValidators.validateName("John") == null);
assert(FormValidators.validateDropdown("Male") == null);
assert(FormValidators.validateDateOfBirth(DateTime.now()) == null);

// These should return error message
assert(FormValidators.validateName("") != null);
assert(FormValidators.validateDropdown("") != null);
assert(FormValidators.validateDateOfBirth(null) != null);
```

### **Test Navigation**
```dart
// In any screen, test navigation
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => AnotherScreen(),
  ),
);

// Should navigate without crashing
```

---

## Summary

1. **Follow the creation order** - Don't create files out of order
2. **Understand dependencies** - Know what each file needs
3. **Test as you go** - Run app after each phase
4. **Use hot reload** - Test code changes instantly
5. **Reference diagrams** - Understand the structure
6. **Fix issues early** - Don't let errors compound

Good luck! 🚀
