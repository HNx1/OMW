import 'package:flutter/material.dart';

import 'package:omw/utils/textUtils.dart';

class ProviderNotifier extends ChangeNotifier {
  String phone = "";
  set setPhone(value) {
    phone = value;
    notifyListeners();
  }

  get getphone => phone;

  var lasttName = "";
  get getlasttName => lasttName;
  set setlasttName(String val) {
    lasttName = val;
    notifyListeners();
  }

  double? amount;
  get getamount => amount;
  set setamount(double val) {
    amount = val;
    notifyListeners();
  }

  var email = "";
  get getemail => email;
  set setemail(String val) {
    email = val;
    notifyListeners();
  }

  bool isChatNotification = true;
  bool isEventNotification = false;

  isisChatNotificationtoggole(val) {
    isChatNotification = val;
    notifyListeners();
  }

  isisEventNotificationtoggole(val) {
    isEventNotification = val;
    notifyListeners();
  }

  var name = "";
  get getname => name;
  set setname(String val) {
    name = val;
    notifyListeners();
  }

  var allUserprofile = "";
  get getAllUserprofile => allUserprofile;
  set setAllUserprofile(String val) {
    allUserprofile = val;
    notifyListeners();
  }

  var isUserActive;
  get getisUserActive => isUserActive;
  set setisUserActive(bool val) {
    isUserActive = val;
    notifyListeners();
  }

  // List<MultiDate> days = [];
  DateTime selectedDate = DateTime.now();
  DateTime currentDate = DateTime.now();

  // getWeek(startdate, enddate) {
  //   var startDate = startdate;
  //   var endDate = enddate;

  //   for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
  //     days.add(
  //       MultiDate(
  //         date: DateTime(startDate.year, startDate.month, startDate.day + i),
  //         ischeck: false,
  //         isclose: false,
  //         isdesh: false,
  //       ),
  //     );
  //   }
  // }

  List searchList = [];
  List get wishListItems {
    return searchList.where((item) => item == true).toList();
  }

  void addItem(String name) {
    final int index = searchList.indexWhere((item) => item["name"] == name);

    searchList[index]["isCheck"] = true;
    print(searchList[index]["name"]);
    print(wishListItems.length);

    wishListItems.length;
    notifyListeners();
  }

  void removeItem(String name) {
    final int index = searchList.indexWhere((item) => item["name"] == name);

    searchList[index]["isCheck"] = false;
    print(searchList[index]["name"]);
    notifyListeners();
  }

  List lstOfUpcomingFilters = [
    {"name": "Yes", "isSelect": false},
    {"name": "No", "isSelect": false},
    {"name": "Maybe", "isSelect": false},
    {"name": TextUtils.removeFilter, "isSelect": false},
  ];
  List lstOfPastFilters = [
    {"name": "Yes", "isSelect": false},
    {"name": "No", "isSelect": false},
    {"name": "Maybe", "isSelect": false},
    {"name": TextUtils.removeFilter, "isSelect": false},
  ];

  notifyListeners();
}
