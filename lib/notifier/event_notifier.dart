import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:omw/model/user_model.dart';
import 'package:permission_handler/permission_handler.dart';

import '../api/apiProvider.dart';
import '../model/createEvent_model.dart';
import '../preference/preference.dart';
import '../widget/scaffoldSnackbar.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class CreateEventNotifier extends ChangeNotifier {
  bool isLoading = false;
  bool isConnected = false;
  List<UserModel> retrieveduserList = [];
  checkConnection() async {
    try {
      isLoading = true;
      isConnected = await ApiProvider().checkConnection();
    } catch (e) {
      isLoading = false;
    } finally {
      isLoading = false;
    }
  }

  getAllUserList(
    BuildContext context,
  ) async {
    isLoading = true;

    await checkConnection();
    if (isConnected == true) {
      isLoading = true;
      try {
        retrieveduserList = await ApiProvider().getListOfUser();
        print("retrieveduserList=============>$retrieveduserList");
      } catch (e) {
        print(e);
        ScaffoldSnackbar.of(context).show(e.toString());
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

  List<Contact>? contacts;
  List myContactList = [];
  List myAppContactList = [];
  List finalList = [];
  List<UserModel> contactList = [];
  List<UserModel> inviteFriendList = [];
  String? getAppcontactnumber;
  String? getcontactnumber;

  Future getinvitatedFriendData(
    BuildContext context,
    String docId,
  ) async {
    inviteFriendList = [];
    myContactList = [];
    myAppContactList = [];
    contactList = [];
    contacts = [];

    await getAllUserList(context);
    await Permission.contacts.request();
    PermissionStatus permission = await Permission.contacts.status;
    if (permission == PermissionStatus.granted) {
      await getDeviceContactList();
      await getAppContactList();
      await getFinalAppContactList(context, docId);
    }
    notifyListeners();
    return null;
  }

  Future getDeviceContactList() async {
    contacts = await ContactsService.getContacts(
      photoHighResolution: true,
    );
    contacts!.forEach((element) {
      element.phones!.forEach((element) {
        if (element.value!.replaceAll(' ', '').length >= 10) {
          var phoneNumber = element.value!.replaceAll(' ', '');
          getcontactnumber = phoneNumber.substring(phoneNumber.length - 10);

          myContactList.add(
            getcontactnumber!,
          );
        }
      });
    });

    print("myContactList================>$myContactList");
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
    print("myAppContactList ==========>$myAppContactList");
    notifyListeners();
  }

  bool isAlreadyInvited = false;
  getFinalAppContactList(BuildContext context, String docId) async {
    bool devContactList = false;
    if (devContactList) {
      finalList = myAppContactList;
    } else {
      finalList =
          myContactList.toSet().intersection(myAppContactList.toSet()).toList();
    }
    print(
      "finalList=================>$finalList",
    );
    await getpericularEvent(context, docId);
    inviteFriendList = [];
    finalList.forEach(
      (frdlst) async {
        contactList = retrieveduserList
            .where((element) =>
                element.phoneNumber!
                    .substring(element.phoneNumber!.length - 10) ==
                frdlst)
            .toList();
        for (var i = 0; i < contactList.length; i++)
          print('============>${contactList[i].phoneNumber}');
        print("AppcontactList================>$contactList");

        inviteFriendList.addAll(contactList);

        print("inviteFriendList===================>$inviteFriendList");

        inviteFriendList.forEach(
          (element) {
            lstofpericularEventList.forEach(
              (element1) {
                if (element1.guest!.isEmpty || element1.guest == null) {
                  element.isInvite = false;
                  element.isAlreadyinvited = false;
                } else {
                  if (element1.guest != null && element1.guest != "") {
                    element1.guest!.forEach(
                      (guest) {
                        if (element.uid == guest.guestID) {
                          element.isInvite = true;
                          element.isAlreadyinvited = true;
                        }
                      },
                    );
                  }
                }
              },
            );
          },
        );
      },
    );
    notifyListeners();
  }

  List<CreateEventModel> getMyupcomingEventList = [];

  getListOfMyUpcomingEvent(
    BuildContext context,
  ) async {
    await checkConnection();
    if (isConnected == true) {
      isLoading = true;
      try {
        getMyupcomingEventList =
            await ApiProvider().getListOfMyUpcomingEvents().then((value) async {
          for (var i = 0; i < value.length; i++)
            try {
              QuerySnapshot result = await FirebaseFirestore.instance
                  .collection('users')
                  .where("uid", isEqualTo: value[i].ownerID)
                  .get();
              if (result.docs.length > 0) {
                for (var docData in result.docs) {
                  value[i].lstUser = UserModel.parseSnapshot(docData);
                }
              }
            } catch (e) {
              print(e);
            }
          return value;
        });
        print(
            "getMyupcomingEventList=====================>$getMyupcomingEventList");
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

  List<CreateEventModel> getListOfMyUpcomingEventswithCoHostList = [];
  getListOfMyUpcomingEventswithCoHost(BuildContext context, String name) async {
    await checkConnection();
    if (isConnected == true) {
      isLoading = true;
      try {
        getListOfMyUpcomingEventswithCoHostList = await ApiProvider()
            .getListOfMyUpcomingEventswithCoHost(name)
            .then((value) async {
          for (var i = 0; i < value.length; i++)
            try {
              QuerySnapshot result = await FirebaseFirestore.instance
                  .collection('users')
                  .where("uid", isEqualTo: value[i].ownerID)
                  .get();
              if (result.docs.length > 0) {
                for (var docData in result.docs) {
                  value[i].lstUser = UserModel.parseSnapshot(docData);
                }
              }
            } catch (e) {
              print(e);
            }
          return value;
        });
        print(
            "getListOfMyUpcomingEventswithCoHostList=====================>$getListOfMyUpcomingEventswithCoHostList");
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

  List<CreateEventModel> getListOfPastEventswithCoHostList = [];
  getListOfMyPastEventswithCoHost(BuildContext context, String name) async {
    await checkConnection();
    if (isConnected == true) {
      isLoading = true;
      try {
        getListOfPastEventswithCoHostList = await ApiProvider()
            .getListOfMyPastEventswithCoHost(name)
            .then((value) async {
          for (var i = 0; i < value.length; i++)
            try {
              QuerySnapshot result = await FirebaseFirestore.instance
                  .collection('users')
                  .where("uid", isEqualTo: value[i].ownerID)
                  .get();
              if (result.docs.length > 0) {
                for (var docData in result.docs) {
                  value[i].lstUser = UserModel.parseSnapshot(docData);
                }
              }
            } catch (e) {
              print(e);
            }

          return List.from(value.reversed);
        });
        print(
            "getListOfPastEventswithCoHostList=====================>$getListOfPastEventswithCoHostList");
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

  List<CreateEventModel> getMyPastEventList = [];
  getListOfMyPastEvent(
    BuildContext context,
  ) async {
    await checkConnection();
    if (isConnected == true) {
      isLoading = true;
      try {
        getMyPastEventList =
            await ApiProvider().getListOfMyPastEvents().then((value) async {
          for (var i = 0; i < value.length; i++)
            try {
              QuerySnapshot result = await FirebaseFirestore.instance
                  .collection('users')
                  .where("uid", isEqualTo: value[i].ownerID)
                  .get();
              if (result.docs.length > 0) {
                for (var docData in result.docs) {
                  value[i].lstUser = UserModel.parseSnapshot(docData);
                }
              }
            } catch (e) {
              print(e);
            }

          return value;
        });
        print("getMyPastEventList=====================>$getMyPastEventList");
      } catch (e) {
        print(e);
        // ScaffoldSnackbar.of(context).show(e.toString());
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

  List<CreateEventModel> lstofpericularEventList = [];

  getpericularEvent(BuildContext context, String docId) async {
    await checkConnection();
    if (isConnected == true) {
      isLoading = true;
      try {
        lstofpericularEventList = await ApiProvider().getEventDetails(docId);
        print(
            "lstofpericularEventList=====================>$lstofpericularEventList");
      } catch (e) {
        print(e);
        // ScaffoldSnackbar.of(context).show(e.toString());
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

  Future addGuestList(
    BuildContext context,
    List<GuestModel>? guest,
    String docId,
    List guestsID,
    List<AllDates>? allDate,
  ) async {
    await checkConnection();
    if (isConnected == true) {
      isLoading = true;
      try {
        await ApiProvider().addGuestList(guest, docId, guestsID, allDate);
      } catch (e) {
        print(e);
        ScaffoldSnackbar.of(context).show(e.toString());
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

  List<CreateEventModel> getupcomingEventList = [];

  getListOfUpcomingEvent(
    BuildContext context,
  ) async {
    await checkConnection();
    if (isConnected == true) {
      try {
        isLoading = true;

        getupcomingEventList =
            await ApiProvider().getListOfUpcomingEvents().then((value) async {
          for (var i = 0; i < value.length; i++)
            try {
              QuerySnapshot result = await FirebaseFirestore.instance
                  .collection('users')
                  .where("uid", isEqualTo: value[i].ownerID)
                  .get();
              if (result.docs.length > 0) {
                for (var docData in result.docs) {
                  value[i].lstUser = UserModel.parseSnapshot(docData);
                }
              }
              value[i].allDates!.forEach((element) {
                element.guestResponse!.forEach((element2) {
                  if (element2.guestID == _auth.currentUser!.uid) {
                    element.objguest = element2;
                  } else {}
                });
              });
            } catch (e) {
              print(e);
            }
          return value;
        });

        print(
            "getupcomingEventList======================>${getupcomingEventList.length}");
      } catch (e) {
        print(e);
        isLoading = false;
      } finally {}
    } else {
      ScaffoldSnackbar.of(context).show("Turn on the data and retry again");
      isLoading = false;
    }
    notifyListeners();
  }

  CreateEventModel getEventDetails = CreateEventModel();

  Future geteventDeatisl(
    BuildContext context,
    String docId,
    String eventHostUserId,
  ) async {
    await checkConnection();
    if (isConnected == true) {
      isLoading = true;
      try {
        getEventDetails =
            await ApiProvider().eventDetails(docId).then((value) async {
          try {
            QuerySnapshot result = await FirebaseFirestore.instance
                .collection('users')
                .where("uid", isEqualTo: eventHostUserId)
                .get();
            if (result.docs.length > 0) {
              for (var docData in result.docs) {
                value.lstUser = UserModel.parseSnapshot(docData);
              }
              print(value);
            }
            value.allDates!.forEach((element) async {
              element.guestResponse!.forEach((element2) async {
                if (element2.guestID == _auth.currentUser!.uid) {
                  element.objguest = element2;
                }
              });
            });
          } catch (e) {
            print(e);
          }
          return value;
        });
      } catch (e) {
        print(e);
        ScaffoldSnackbar.of(context).show(e.toString());
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

  List<CreateEventModel> getpastEventList = [];
  getListOfPastEvent(
    BuildContext context,
  ) async {
    await checkConnection();
    if (isConnected == true) {
      try {
        isLoading = true;

        getpastEventList = await ApiProvider()
            .getListOfpastEvents(_auth.currentUser!.uid)
            .then((value) async {
          for (var i = 0; i < value.length; i++)
            try {
              QuerySnapshot result = await FirebaseFirestore.instance
                  .collection('users')
                  .where("uid", isEqualTo: value[i].ownerID)
                  .get();
              if (result.docs.length > 0) {
                for (var docData in result.docs) {
                  value[i].lstUser = UserModel.parseSnapshot(docData);
                }
              }
            } catch (e) {
              print(e);
            }
          return value;
        });
        getpastEventList
            .sort((a, b) => b.eventEndDate!.compareTo(a.eventEndDate!));
        print("getpastEventList=====================>$getpastEventList");
      } catch (e) {
        print(e);
        isLoading = false;
      } finally {
        // isLoading = false;
      }
    } else {
      ScaffoldSnackbar.of(context).show("Turn on the data and retry again");
      isLoading = false;
    }
    notifyListeners();
  }

  List<CreateEventModel> loadAllEvents = [];
  List<CreateEventModel> lstofAllEvents = [];

  getAllEvent(
    BuildContext context,
  ) async {
    await checkConnection();
    if (isConnected == true) {
      isLoading = true;
      try {
        loadAllEvents =
            await ApiProvider().getAllEventList().then((value) async {
          for (var i = 0; i < value.length; i++)
            try {
              QuerySnapshot result = await FirebaseFirestore.instance
                  .collection('users')
                  .where("uid", isEqualTo: value[i].ownerID)
                  .get();
              if (result.docs.length > 0) {
                for (var docData in result.docs) {
                  value[i].lstUser = UserModel.parseSnapshot(docData);
                }
                print(value);
              }
            } catch (e) {
              print(e);
            }
          return value;
        });
        if (loadAllEvents.isNotEmpty) {
          lstofAllEvents.addAll(loadAllEvents);
        }
        print("loadAllEvents======================>${loadAllEvents.length}");
        print("lstofAllEvents======================>${lstofAllEvents.length}");
      } catch (e) {
        print(e);
        // ScaffoldSnackbar.of(context).show(e.toString());
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

  List<UserModel> retrievedGuestUserList = [];

  Future getAllGuestUserList(
    BuildContext context,
    List guestId,
  ) async {
    await checkConnection();
    if (isConnected == true) {
      isLoading = true;
      try {
        retrievedGuestUserList = await ApiProvider().getGuestList(guestId);
        print(
            "retrievedGuestUserList=====================>$retrievedGuestUserList");
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

  CreateEventModel objCreateEventModel = CreateEventModel();
  Future createEvents(
      BuildContext context,
      String eventname,
      List selectedDate,
      String selectedTime,
      String description,
      String location,
      String eventPhoto,
      bool inviteFriends,
      bool enableCostSplite,
      double costAmount,
      String? coHost,
      File imageFile,
      DateTime eventStartDate,
      DateTime eventEndDate,
      List<AllDates>? allDates,
      List<String> cohostList,
      String? guestUserName) async {
    await checkConnection();
    if (isConnected == true) {
      try {
        isLoading = true;

        if (imageFile.path != "") {
          var imageName = imageFile.path.split('/').last;
          print(imageName);
          var snapshot = await FirebaseStorage.instance
              .ref()
              .child(imageName)
              .putFile(imageFile);
          var downloadUrl = await snapshot.ref.getDownloadURL();
          eventPhoto = downloadUrl;
        }

        print(eventPhoto);
        objCreateEventModel = CreateEventModel(
            eventname: eventname,
            selectedDate: selectedDate,
            selectedTime: selectedTime,
            location: location,
            description: description,
            eventPhoto: eventPhoto,
            inviteFriends: inviteFriends,
            enableCostSplite: enableCostSplite,
            costAmount: costAmount,
            coHost: coHost,
            ownerID: _auth.currentUser!.uid,
            guest: [
              GuestModel(
                guestID: _auth.currentUser!.uid,
                status: 0,
                guestUserName: guestUserName,
              )
            ],
            eventEndDate: eventEndDate,
            eventStartDate: eventStartDate,
            guestsID: [
              _auth.currentUser!.uid,
            ],
            allDates: allDates,
            cohostList: cohostList);
        await ApiProvider().creteEvent(objCreateEventModel);
        await getListOfUpcomingEvent(context);
        await getListOfMyUpcomingEvent(context);
        await getListOfMyPastEvent(context);
        await getListOfPastEvent(context);

        ScaffoldSnackbar.of(context).show("Event Created Successfully!!!");
      } catch (e) {
        print(e);
        ScaffoldSnackbar.of(context).show(e.toString());
        isLoading = false;
      } finally {
        isLoading = false;
      }
    } else {
      ScaffoldSnackbar.of(context).show("Turn on the data and retry again");
    }
    notifyListeners();
  }

  Future updateEventDetails(
      BuildContext context,
      String docId,
      String eventname,
      List selectedDate,
      String selectedTime,
      String description,
      String location,
      String eventPhoto,
      bool inviteFriends,
      bool enableCostSplite,
      double costAmount,
      String? coHost,
      DateTime eventStartDate,
      DateTime eventEndDate,
      List<GuestModel>? guest,
      List<dynamic>? guestsID,
      UserModel? lstUser,
      String? ownerID,
      List<String>? newCohostList,
      List<AllDates>? allDates) async {
    await checkConnection();
    if (isConnected == true) {
      try {
        await ApiProvider().editEventDetails(
            docId,
            eventname,
            selectedDate,
            selectedTime,
            description,
            location,
            eventPhoto,
            inviteFriends,
            enableCostSplite,
            costAmount,
            coHost,
            eventStartDate,
            eventEndDate,
            newCohostList,
            allDates);
        objCreateEventModel = CreateEventModel(
            docId: docId,
            eventname: eventname,
            selectedDate: selectedDate,
            selectedTime: selectedTime,
            location: location,
            description: description,
            eventPhoto: eventPhoto,
            inviteFriends: inviteFriends,
            enableCostSplite: enableCostSplite,
            costAmount: costAmount,
            coHost: coHost,
            eventEndDate: eventEndDate,
            eventStartDate: eventStartDate,
            guest: guest,
            guestsID: guestsID,
            lstUser: lstUser,
            ownerID: ownerID,
            cohostList: newCohostList,
            allDates: allDates);

        print(objCreateEventModel);
        ScaffoldSnackbar.of(context).show("Updated successfully");
      } catch (e) {
        print(e);
        isLoading = false;
      } finally {
        isLoading = false;
      }
    } else {
      ScaffoldSnackbar.of(context).show("Turn on the data");
    }
    notifyListeners();
  }

  CreateEventModel EventData = new CreateEventModel();
  CreateEventModel get getEventData => EventData;
  set setEventData(CreateEventModel val) {
    EventData = val;
    notifyListeners();
  }

  List<CreateEventModel> getList = [];

  List<CreateEventModel> getUpcomingFilterList = [];
  List<CreateEventModel> getPastFilterList = [];

  List<CreateEventModel> goingGuest = [];
  List<CreateEventModel> maybeGuest = [];
  List<CreateEventModel> notGoingGuest = [];
  List<CreateEventModel> goingandMaybeGuest = [];
  List<CreateEventModel> goingandNotGoing = [];
  List<CreateEventModel> maybeandNotGoing = [];
  List<CreateEventModel> goingandmaybeandNotGoing = [];
  int tabIndex = 0;

  ///------------------- when upcoming screen is selected------------------
  bool isUpcommingFilteredData = false;
  bool isPastFilteredData = false;

  getUpcommingYesData(CreateEventNotifier objCreateEventNotifier) {
    goingGuest = [];
    isUpcommingFilteredData = true;
    objCreateEventNotifier.getupcomingEventList.forEach((e) {
      e.guest!.forEach(
        (g) {
          if (g.guestID == _auth.currentUser!.uid && g.status == 0) {
            goingGuest.add(e);
          }
        },
      );
    });

    print("==============>goingGuest:- $goingGuest");
    notifyListeners();
  }

  getUpcommingMaybeData(CreateEventNotifier objCreateEventNotifier) {
    isUpcommingFilteredData = true;
    maybeGuest = [];
    objCreateEventNotifier.getupcomingEventList.forEach((e) {
      e.guest!.forEach((g) {
        if (g.guestID == _auth.currentUser!.uid && g.status == 2) {
          maybeGuest.add(e);
        }
      });
    });
    print("==============>maybeGuest:- $maybeGuest");
    notifyListeners();
  }

  getUpcommingNoData(CreateEventNotifier objCreateEventNotifier) {
    isUpcommingFilteredData = true;
    notGoingGuest = [];
    objCreateEventNotifier.getupcomingEventList.forEach((e) {
      e.guest!.forEach((g) {
        if (g.guestID == _auth.currentUser!.uid && g.status == 1) {
          notGoingGuest.add(e);
        }
      });
    });
    print("==============>notGoingGuest:-$notGoingGuest");
    notifyListeners();
  }

  getUpcommingYesandMaybeGuest(CreateEventNotifier objCreateEventNotifier) {
    isUpcommingFilteredData = true;
    goingandMaybeGuest = [];
    objCreateEventNotifier.getupcomingEventList.forEach((e) {
      e.guest!.forEach((g) {
        if (g.guestID == _auth.currentUser!.uid && g.status != 1) {
          goingandMaybeGuest.add(e);
        }
      });
    });
    print("==============>goingandMaybeGuest:-$goingandMaybeGuest");
    notifyListeners();
  }

  getUpcommingYesandNotGoing(CreateEventNotifier objCreateEventNotifier) {
    isUpcommingFilteredData = true;
    goingandNotGoing = [];
    objCreateEventNotifier.getupcomingEventList.forEach((e) {
      e.guest!.forEach((g) {
        if (g.guestID == _auth.currentUser!.uid && g.status != 2) {
          goingandNotGoing.add(e);
        }
      });
    });
    print("==============>goingandNotGoing:- $goingandNotGoing");
    notifyListeners();
  }

  getUpcommingmaybeandNotGoing(CreateEventNotifier objCreateEventNotifier) {
    isUpcommingFilteredData = true;
    maybeandNotGoing = [];
    objCreateEventNotifier.getupcomingEventList.forEach((e) {
      e.guest!.forEach((g) {
        if (g.guestID == _auth.currentUser!.uid && g.status != 0) {
          maybeandNotGoing.add(e);
        }
      });
    });
    print("==============>maybeandNotGoing:-$maybeandNotGoing");
    notifyListeners();
  }

  getUpcommingYesandMaybeandNotGoing(
      CreateEventNotifier objCreateEventNotifier) {
    goingandmaybeandNotGoing = [];
    isUpcommingFilteredData = true;

    objCreateEventNotifier.getupcomingEventList.forEach((e) {
      e.guest!.forEach((g) {
        if (g.guestID == _auth.currentUser!.uid) {
          goingandmaybeandNotGoing.add(e);
        }
      });
    });
    print("==============>goingandmaybeandNotGoing:-$goingandmaybeandNotGoing");
    notifyListeners();
  }

  ///---------------------- when past screen is selected---------------------
  getPastYesData(CreateEventNotifier objCreateEventNotifier) {
    goingGuest = [];
    isPastFilteredData = true;
    objCreateEventNotifier.getpastEventList.forEach((e) {
      e.guest!.forEach(
        (g) {
          if (g.guestID == _auth.currentUser!.uid && g.status == 0) {
            goingGuest.add(e);
          }
        },
      );
    });

    print("==============>goingGuest:- $goingGuest");
    notifyListeners();
  }

  getPastMaybeData(CreateEventNotifier objCreateEventNotifier) {
    maybeGuest = [];
    isPastFilteredData = true;
    objCreateEventNotifier.getpastEventList.forEach((e) {
      e.guest!.forEach((g) {
        if (g.guestID == _auth.currentUser!.uid && g.status == 2) {
          maybeGuest.add(e);
        }
      });
    });
    print("==============>maybeGuest:- $maybeGuest");
    notifyListeners();
  }

  getPastNoData(CreateEventNotifier objCreateEventNotifier) {
    notGoingGuest = [];
    isPastFilteredData = true;
    objCreateEventNotifier.getpastEventList.forEach((e) {
      e.guest!.forEach((g) {
        if (g.guestID == _auth.currentUser!.uid && g.status == 1) {
          notGoingGuest.add(e);
        }
      });
    });
    print("==============>notGoingGuest:-$notGoingGuest");
    notifyListeners();
  }

  getPastYesandMaybeGuest(CreateEventNotifier objCreateEventNotifier) {
    goingandMaybeGuest = [];
    isPastFilteredData = true;
    objCreateEventNotifier.getpastEventList.forEach((e) {
      e.guest!.forEach((g) {
        if (g.guestID == _auth.currentUser!.uid && g.status != 1) {
          goingandMaybeGuest.add(e);
        }
      });
    });
    print("==============>goingandMaybeGuest:-$goingandMaybeGuest");
    notifyListeners();
  }

  getPastYesandNotGoing(CreateEventNotifier objCreateEventNotifier) {
    goingandNotGoing = [];
    isPastFilteredData = true;
    objCreateEventNotifier.getpastEventList.forEach((e) {
      e.guest!.forEach((g) {
        if (g.guestID == _auth.currentUser!.uid && g.status != 2) {
          goingandNotGoing.add(e);
        }
      });
    });
    print("==============>goingandNotGoing:- $goingandNotGoing");
    notifyListeners();
  }

  getPastmaybeandNotGoing(CreateEventNotifier objCreateEventNotifier) {
    maybeandNotGoing = [];
    isPastFilteredData = true;
    objCreateEventNotifier.getpastEventList.forEach((e) {
      e.guest!.forEach((g) {
        if (g.guestID == _auth.currentUser!.uid && g.status != 0) {
          maybeandNotGoing.add(e);
        }
      });
    });
    print("==============>maybeandNotGoing:-$maybeandNotGoing");
    notifyListeners();
  }

  getPastYesandMaybeandNotGoing(CreateEventNotifier objCreateEventNotifier) {
    goingandmaybeandNotGoing = [];
    isPastFilteredData = true;
    objCreateEventNotifier.getpastEventList.forEach((e) {
      e.guest!.forEach((g) {
        if (g.guestID == _auth.currentUser!.uid) {
          goingandmaybeandNotGoing.add(e);
        }
      });
    });
    print(
        "==============>goingandmaybeandNotGoing:-${goingandmaybeandNotGoing.length}");
    notifyListeners();
  }

  CreateEventModel objEvent = new CreateEventModel();
  Future getNotificationEventDetails(String notificationId) async {
    isLoading = true;

    try {
      objEvent = await ApiProvider()
          .getNotificationEventDetails(notificationId)
          .then((value) async {
        try {
          QuerySnapshot result = await FirebaseFirestore.instance
              .collection('users')
              .where("uid", isEqualTo: value.ownerID)
              .get();
          if (result.docs.length > 0) {
            for (var docData in result.docs) {
              value.lstUser = UserModel.parseSnapshot(docData);
            }
          }
        } catch (e) {
          print(e);
        }
        return value;
      });
      print("objEvent=====================>$objEvent");
    } catch (e) {
      print(e);
      isLoading = false;
    } finally {
      isLoading = false;
    }
    notifyListeners();
  }

  getListOfProfilePastEvent(BuildContext context, String userId) async {
    await checkConnection();
    if (isConnected == true) {
      getMyPastEventList = [];
      isLoading = true;
      try {
        getMyPastEventList = await ApiProvider()
            .getListOfProfilePastEvent(userId)
            .then((value) async {
          for (var i = 0; i < value.length; i++)
            try {
              QuerySnapshot result = await FirebaseFirestore.instance
                  .collection('users')
                  .where("uid", isEqualTo: value[i].ownerID)
                  .get();
              if (result.docs.length > 0) {
                for (var docData in result.docs) {
                  value[i].lstUser = UserModel.parseSnapshot(docData);
                }
              }
            } catch (e) {
              print(e);
            }

          return value;
        });
        print("getMyPastEventList=====================>$getMyPastEventList");
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

  List<CreateEventModel> eventIntersection = [];
  getEventIntersection(BuildContext context, String user1, String user2) async {
    await checkConnection();
    if (isConnected == true) {
      eventIntersection = [];
      List<CreateEventModel> list1 = [];
      List<CreateEventModel> list2 = [];
      List<String?> stringIntersection = [];
      isLoading = true;
      try {
        list1 =
            await ApiProvider().getListOfpastEvents(user1).then((value) async {
          for (var i = 0; i < value.length; i++)
            try {
              QuerySnapshot result = await FirebaseFirestore.instance
                  .collection('users')
                  .where("uid", isEqualTo: value[i].ownerID)
                  .get();
              if (result.docs.length > 0) {
                for (var docData in result.docs) {
                  value[i].lstUser = UserModel.parseSnapshot(docData);
                }
              }
            } catch (e) {
              print(e);
            }

          return value;
        });

        print("list1=====>${list1.map((e) => e.eventname).toSet()}");
        list2 =
            await ApiProvider().getListOfpastEvents(user2).then((value) async {
          for (var i = 0; i < value.length; i++)
            try {
              QuerySnapshot result = await FirebaseFirestore.instance
                  .collection('users')
                  .where("uid", isEqualTo: value[i].ownerID)
                  .get();
              if (result.docs.length > 0) {
                for (var docData in result.docs) {
                  value[i].lstUser = UserModel.parseSnapshot(docData);
                }
              }
            } catch (e) {
              print(e);
            }

          return value;
        });
        ;
        print("list2=====>${list2.map((e) => e.eventname).toSet()}");
        stringIntersection = list1
            .map((e) => e.docId)
            .toSet()
            .intersection(list2.map((e) => e.docId).toSet())
            .toList();
        print("intersection:${stringIntersection}");
        eventIntersection =
            List.from(list1.where((e) => stringIntersection.contains(e.docId)));
        eventIntersection
            .sort((a, b) => b.eventEndDate!.compareTo(a.eventEndDate!));
        print("geteventIntersection=====================>$eventIntersection");
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

  Future changeResponse(
    BuildContext context,
    String docId,
    List<AllDates>? allDate,
  ) async {
    await checkConnection();
    if (isConnected == true) {
      isLoading = true;
      try {
        await ApiProvider().chnageResponseOfuser(docId, allDate);
      } catch (e) {
        print(e);
        ScaffoldSnackbar.of(context).show(e.toString());
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

  Future sendnotificationtotheHost(
      BuildContext context, String docId, bool isNotificationSent) async {
    await checkConnection();
    if (isConnected == true) {
      isLoading = true;
      try {
        await ApiProvider()
            .sendNotificationToTheHost(docId, isNotificationSent);
      } catch (e) {
        print(e);
        ScaffoldSnackbar.of(context).show(e.toString());
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
}
