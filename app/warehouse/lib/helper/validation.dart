class Validation {
  static String validatePass(String pass) {
    if (pass == '') {
      return 'Password invalid';
    }
    if (pass.length < 6) {
      return 'Password require minimum 6 characters';
    }
    return null;
  }

  static String validateCfPass(String pass, String cfPass) {
    if (pass != cfPass) {
      return 'Your confirm password don\' same with your password';
    }
    return null;
  }

  static String validateEmail(String email) {
    if (email == '') {
      return 'Email invalid';
    }
    if (!RegExp(r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)")
        .hasMatch(email)) {
      return 'Email invalid';
    }
    return null;
  }

  static String inputStringValidate(String str) {
    if (str == '') {
      return 'Please fill information';
    }
    return null;
  }

  static String inputQuantity(String value) {
    if (value == null && value == '') {
      return 'please fill quantity';
    } else if (int.parse(value) < 1) {
      return 'Quantity must be more than 1 unit';
    }
    return null;
  }

  static String inputIntValidate(String i) {
    try {
      double.parse(i);
    } catch (e) {
      return e.message;
    }
    if (i == null) {
      return 'Please fill number in here';
    }
    return null;
  }

  static String checkDropDownValue(String i) {
    if (i == null) {
      return 'Please Pick Value';
    }
    return null;
  }
}
