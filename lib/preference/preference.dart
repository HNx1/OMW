import 'package:shared_preferences/shared_preferences.dart';

class PrefServices {
  static final PrefServices _singleton = PrefServices._internal();

  factory PrefServices() {
    return _singleton;
  }

  PrefServices._internal();

  late SharedPreferences prefs;

  init() async {
    prefs = await SharedPreferences.getInstance();
  }

  void setIsUserLoggedIn(bool isLoggedIn) async {
    await prefs.setBool("isLoggedIn", isLoggedIn);
  }

  bool getIsUserLoggedIn() {
    return prefs.getBool("isLoggedIn") ?? false;
  }

  void clearData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
  }

  void setCurrentUserName(String userName) async {
    await prefs.setString("userName", userName);
  }

  void setCurrentUserId(String userId) async {
    await prefs.setString("userId", userId);
  }

  void setCurrentPhoneNumber(String phoneNumber) async {
    await prefs.setString("phoneNumber", phoneNumber);
  }

  String getCurrentUserName() {
    return prefs.getString("userName") ?? "";
  }

  String getCurrentUserId() {
    return prefs.getString("userId") ?? "";
  }

  String getCurrentPhoneNumber() {
    return prefs.getString("phoneNumber") ?? "";
  }
}
