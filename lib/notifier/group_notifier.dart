import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

import '../api/api_provider.dart';
import '../model/groupModel.dart';
import '../model/user_model.dart';
import '../widget/scaffold_snackbar.dart';

class GroupNotifier extends ChangeNotifier {
  bool isLoading = false;
  bool isConnected = false;
  var GroupName = "";
  get getGroupName => GroupName;
  set setGroupName(String val) {
    GroupName = val;
    notifyListeners();
  }

  checkConnection(
    BuildContext context,
  ) async {
    try {
      isLoading = true;
      isConnected = await ApiProvider().checkConnection();
    } catch (e) {
      ScaffoldSnackbar.of(context).show(e.toString());
      isLoading = false;
    } finally {
      isLoading = false;
    }
  }

  List<UserModel> retrieveduserList = [];
  List<UserModel> loadedUserModel = [];

  getListOfContactUser(
    BuildContext context,
  ) async {
    isLoading = true;

    await checkConnection(context);
    if (isConnected == true) {
      isLoading = true;
      try {
        loadedUserModel = await ApiProvider().getListOfContactUser();

        if (loadedUserModel.isNotEmpty) {
          retrieveduserList.addAll(loadedUserModel);
        }
        print(
            "loadedUserListl======================>${loadedUserModel.length}");
        print("UserList======================>${retrieveduserList.length}");
      } catch (e) {
        print(e);

        isLoading = false;
      } finally {
        isLoading = false;
      }
    } else {
      ScaffoldSnackbar.of(context).show("Turn on the data and retry again");
      isLoading = false;
    }
    notifyListeners();
  }

  GroupModel objGroupModel = GroupModel();

  List<Contact>? contacts;
  List myContactList = [];
  List myAppContactList = [];
  List finalList = [];
  List<UserModel> contactList = [];
  List<UserModel> selectedUserList = [];
  String? getAppcontactnumber;
  String? getcontactnumber;
  getData(
    BuildContext context,
    String docId,
  ) async {
    selectedUserList = [];
    myContactList = [];
    myAppContactList = [];
    contactList = [];

    contacts = [];
    await getListOfContactUser(context);
    await Permission.contacts.request();
    PermissionStatus permission = await Permission.contacts.status;
    if (permission == PermissionStatus.granted) {
      await getDeviceContactList();
      await getAppContactList();
      await getFinalAppContactList(context, docId);
    }
    notifyListeners();
  }

  getDeviceContactList() async {
    // FlutterContacts.config.includeNotesOnIos13AndAbove = true;
    // FlutterContacts.config.returnUnifiedContacts = false;

    try {
      contacts = await ContactsService.getContacts(
        orderByGivenName: true,
      );

      contacts!.forEach((element) {
        element.phones!.forEach((element2) {
          if (element2.value.toString().replaceAll(' ', '').length >= 10) {
            var phoneNumber = element2.value.toString().replaceAll(' ', '');
            getcontactnumber = phoneNumber.substring(phoneNumber.length - 10);
            // print(getcontactnumber);
            myContactList.add(
              getcontactnumber!,
            );
          }
        });
      });
      print("device Contact List ==========>\n$myContactList");
    } catch (e) {
      print("$e");
    }
    notifyListeners();
  }

  getAppContactList() {
    retrieveduserList.forEach((element) {
      if (element.phoneNumber!.length >= 10) {
        getAppcontactnumber =
            element.phoneNumber!.substring(element.phoneNumber!.length - 10);
        getAppcontactnumber!.replaceAll(' ', '');
        myAppContactList.add(getAppcontactnumber!);
      }
    });
    print("App Contact List ==========>$myAppContactList");
    notifyListeners();
  }

  getFinalAppContactList(BuildContext context, String docId) async {
    myContactList.toSet().intersection(myAppContactList.toSet()).toList();

    print("Sync Contact List $finalList");

    finalList.forEach((f) async {
      contactList = retrieveduserList
          .where((element) =>
              (element.phoneNumber!.length >= 10
                  ? element.phoneNumber!.substring(
                      element.phoneNumber!.length - 10,
                    )
                  : "") ==
              f)
          .toList();

      selectedUserList.addAll(contactList);

      print("selectedUserList$selectedUserList");
    });
    notifyListeners();
  }

  Future createGroup(
    BuildContext context,
    String? groupName,
    String? gropuProfile,
    List? groupUser,
    File imageFile,
  ) async {
    await checkConnection(context);
    if (isConnected == true) {
      isLoading = true;
      try {
        if (imageFile.path != "") {
          var imageName = imageFile.path.split('/').last;
          print(imageName);
          var snapshot = await FirebaseStorage.instance
              .ref()
              .child(imageName)
              .putFile(imageFile);
          var downloadUrl = await snapshot.ref.getDownloadURL();
          gropuProfile = downloadUrl;
        }

        print(gropuProfile);
        objGroupModel = GroupModel(
          groupName: groupName,
          gropuProfile: gropuProfile,
          groupUser: groupUser,
        );
        await ApiProvider().ceateGroup(objGroupModel);
        ScaffoldSnackbar.of(context).show("Group Created Successfully!!!");
      } catch (e) {
        print(e);

        isLoading = false;
      } finally {
        isLoading = false;
      }
    } else {
      ScaffoldSnackbar.of(context).show("Turn on the data and retry again");
    }
    notifyListeners();
  }

  List<UserModel> searchList = [];

  List<UserModel> lstOFUsers = [];
  List<UserModel> get wishListItems {
    return searchList.where((item) => item.isSelcetdForGroup == true).toList();
  }

  addItem(String name) {
    final int index = searchList.indexWhere((item) => item.firstName == name);

    searchList[index].isSelcetdForGroup = true;
    print(searchList[index].firstName);

    lstOFUsers = searchList
        .where((element) => element.isSelcetdForGroup == true)
        .toList();

    print(lstOFUsers.length);
    notifyListeners();
  }

  void removeItem(String name) {
    final int index = searchList.indexWhere((item) => item.firstName == name);

    searchList[index].isSelcetdForGroup = false;
    print(searchList[index].firstName);
    lstOFUsers = searchList
        .where((element) => element.isSelcetdForGroup == true)
        .toList();
    print(lstOFUsers.length);
    notifyListeners();
  }
}
