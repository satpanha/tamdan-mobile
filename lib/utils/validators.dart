class FormValidators {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Name is required";
    }
    if (value.trim().length < 2) {
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

  static String? validateDateOfBirth(DateTime? date) {
    if (date == null) {
      return "Date of birth is required";
    }
    return null;
  }
  static String? validateAdmin(String? value) {
  if (value == null || value.trim().isEmpty) {
    return "This field is required";
  }
  return null;
}
}
