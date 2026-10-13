class AppValidators {
  static final _nameRegExp = RegExp(r'^[a-zA-Z\-]+ *$');
  static final _hasDigit = RegExp(r'[0-9]');
  static final _hasLowercase = RegExp(r'[a-z]');
  static final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.[a-zA-Z]{2,}$",
  );

  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Name cannot be empty';
    }
    if (name.length < 3) {
      return 'Name should be atleast 3 characters';
    }
    if (!_nameRegExp.hasMatch(name)) {
      return 'Only letters and hypens allowed';
    }
    return null;
  }

  static String? validateBVN(String? value) {
    if (value == null || value.isEmpty) {
      return 'BVN is required';
    } else if (!RegExp(r'^\d{11}$').hasMatch(value)) {
      return 'BVN must be exactly 11 digits';
    }
    return null;
  }

  static String? validatePin4(String? pin) {
    if (pin == null || pin.isEmpty) {
      return 'Pin cannot be empty';
    }
    if (pin.length != 4) {
      return 'Pin must be 4 digits';
    }
    return null;
  }

  static String? validatePin6(String? pin) {
    if (pin == null || pin.isEmpty) {
      return 'Pin cannot be empty';
    }
    if (pin.length != 6) {
      return 'Pin must be 6 digits';
    }
    return null;
  }

  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email cannot be empty';
    } else if (!_emailRegExp.hasMatch(email.trim())) {
      return 'Invalid email ';
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password cannot be empty';
    } else if (password.length < 8) {
      return 'Password must be at least 8 characters';
    } else if (!_hasDigit.hasMatch(password)) {
      return 'Password must contain digit';
    } else if (!_hasLowercase.hasMatch(password)) {
      return 'Password must contain lowecase';
    }
    return null;
  }
}
