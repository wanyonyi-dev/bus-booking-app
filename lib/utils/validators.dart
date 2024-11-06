class Validators {
static String? validateEmail(String? value) {
if (value == null || value.isEmpty) {
return 'Please enter your email';
}
final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
if (!emailRegex.hasMatch(value)) {
return 'Please enter a valid email';
}
return null;
}

static String? validatePassword(String? value) {
if (value == null || value.isEmpty) {
return 'Please enter your password';
}
if (value.length < 8) {
return 'Password must be at least 8 characters';
}
if (!value.contains(RegExp(r'[A-Z]'))) {
return 'Password must contain at least one uppercase letter';
}
if (!value.contains(RegExp(r'[0-9]'))) {
return 'Password must contain at least one number';
}
return null;
}

static String? validateConfirmPassword(String? value, String password) {
if (value == null || value.isEmpty) {
return 'Please confirm your password';
}
if (value != password) {
return 'Passwords do not match';
}
return null;
}
}