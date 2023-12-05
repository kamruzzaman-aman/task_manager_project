  bool isPasswordValid(String password) {
    RegExp regex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_])[A-Za-z\d\W_]{8,10}$',
    );
    return regex.hasMatch(password);
  }

  bool isEmailValid(String email) {
    RegExp regex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$',
    );
    return regex.hasMatch(email);
  }

  bool isPhoneNumberValid(String phoneNumber) {
    RegExp regex = RegExp(
      r'^[0-9]{11}$',
    );

    return regex.hasMatch(phoneNumber);
  }