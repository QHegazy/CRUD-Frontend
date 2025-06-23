String? validateTitle(String? value) {
  if (value == null || value.trim().isEmpty) return 'Title is required';
  if (value.trim().length < 5) return 'Title must be at least 5 characters';
  if (value.trim().length > 100) return 'Title must not exceed 100 characters';
  return null;
}

String? validateDescription(String? value) {
  if (value == null || value.trim().isEmpty) return 'Description is required';
  if (value.trim().length < 8)
    return 'Description must be at least 8 characters';
  if (value.trim().length > 250)
    return 'Description must not exceed 250 characters';
  return null;
}
