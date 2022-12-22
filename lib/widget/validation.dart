import 'package:omw/utils/textUtils.dart';

String? isValidEmail(String? email) {
  RegExp regex = RegExp(r'.+@.+\..+');
  if (email!.isEmpty)
    return TextUtils.enterEmailMessage;
  else if (!regex.hasMatch(email))
    return TextUtils.validEmail;
  else
    return null;
}

String? validatFirstName(String? name) {
  RegExp regex = RegExp("[a-zA-Z]");
  if (name!.isEmpty) {
    return TextUtils.enterfirstName;
  } else if (!regex.hasMatch(name)) {
    return TextUtils.valifirstName;
  } else {
    return null;
  }
}

String? validateGropuName(String? name) {
  if (name!.isEmpty) {
    return TextUtils.enterfirstName;
  } else {
    return null;
  }
}

String? validateOldPassword(String? pwd) {
  if (pwd!.isEmpty) {
    return TextUtils.Validoldpwd;
  } else {
    return null;
  }
}

String? validateNewPassword(String? pwd) {
  if (pwd!.isEmpty) {
    return TextUtils.Validnewpwd;
  } else {
    return null;
  }
}

String? validatLastName(String? name) {
  RegExp regex = RegExp("[a-zA-Z]");
  if (name!.isEmpty) {
    return TextUtils.enterLasttName;
  } else if (!regex.hasMatch(name)) {
    return TextUtils.valilasttName;
  } else {
    return null;
  }
}

String? validateName(String? name) {
  RegExp regex = RegExp("[a-zA-Z]");
  if (name!.isEmpty) {
    return TextUtils.enterName;
  } else if (!regex.hasMatch(name)) {
    return TextUtils.entervalideName;
  } else {
    return null;
  }
}

String? validateLocation(String? name) {
  RegExp regex = RegExp("[a-zA-Z]");
  if (name!.isEmpty) {
    return TextUtils.location;
  } else if (!regex.hasMatch(name)) {
    return TextUtils.validateLocation;
  } else {
    return null;
  }
}

String? validateDescription(String? name) {
  if (name!.isEmpty) {
    return TextUtils.enterDescription;
  } else {
    return null;
  }
}

String? validateFullName(String? name) {
  RegExp regex = RegExp("[A-Z][a-z]+\s[A-Z][a-z]");
  if (name!.isEmpty) {
    return TextUtils.enterFullName;
  } else if (!regex.hasMatch(name)) {
    return TextUtils.valideFullName;
  } else {
    return null;
  }
}

String? validateAmount(String? name) {
  RegExp regex = RegExp("[0-9]");
  if (name!.isEmpty) {
    return TextUtils.enterAmount;
  } else if (!regex.hasMatch(name)) {
    return TextUtils.validamount;
  } else {
    return null;
  }
}

String? isvalidOtp(String? Otp) {
  if (Otp == null || Otp.isEmpty)
    return TextUtils.enterOtp;
  else if (Otp.length < 6)
    return TextUtils.validOtp;
  else
    return null;
}

String? isvalidcode(String? Otp) {
  if (Otp == null || Otp.isEmpty)
    return TextUtils.enterOtp;
  else if (Otp.length < 4)
    return TextUtils.validOtp;
  else
    return null;
}

String? validateMobile(String? mbno) {
  String patttern = r'(^(?:[+0]9)?[0-9]{10}$)';
  RegExp regExp = new RegExp(patttern);
  if (mbno!.isEmpty) {
    return TextUtils.entermobile;
  } else if (!regExp.hasMatch(mbno)) {
    return TextUtils.validmobile;
  } else {
    return null;
  }
}

String? validateEmailOrPhone(String? value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (value!.isEmpty) {
    return TextUtils.EnterEmailOrPHone;
  } else if (regex.hasMatch(value))
    return null;
  else {
    if (value.length == 10)
      try {
        int.parse(value);
        return null;
      } catch (e) {
        return TextUtils.EntervalidEmailOrPHone;
      }
    else
      return TextUtils.EntervalidEmailOrPHone;
  }
}

String? isValidpassword(String? password) {
  Pattern pattern =
      r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$";
  RegExp regex = new RegExp(pattern as String);
  print(password);
  if (password!.isEmpty) {
    return TextUtils.enterPassword;
  } else {
    if (!regex.hasMatch(password))
      return "Please make sure that your password meets all of the below criteria";
    else
      return null;
  }
}

String? isvalidinformation(String? information) {
  if (information == null || information.isEmpty)
    return TextUtils.enterInfo;
  else
    return null;
}

String? isvalidPassword(String? pwd) {
  if (pwd == null || pwd.isEmpty)
    return TextUtils.enterPassword;
  else
    return null;
}

String? isvalidDescription(String? description) {
  if (description == null || description.isEmpty)
    return TextUtils.enterDescription;
  else
    return null;
}
