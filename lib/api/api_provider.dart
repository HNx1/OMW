import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:omw/model/cookie_model.dart';

import '../model/block_User_Model.dart';
import '../model/bugsAndReport_model.dart';
import '../model/createEvent_model.dart';
import '../model/groupModel.dart';
import '../model/notification_model.dart';
import '../model/payment_model.dart';
import '../model/privacyPolicy_model.dart';
import '../model/termsAndConditionsModel.dart';
import '../model/user_model.dart';
import 'package:http/http.dart' as http;

final FirebaseAuth _auth = FirebaseAuth.instance;
DocumentSnapshot? lastDocument;
DocumentSnapshot? lastDocumentOfContact;
DocumentSnapshot? lastDocumentOfSearchEvent;
DocumentSnapshot? lastUpComingEventsDocument;
DocumentSnapshot? lastDocumentOfBlock;

int pazeSize = 30;

class ApiProvider {
  DocumentSnapshot? AllData;

  Future<bool> isDuplicatePhoneNumber(String phoneNumber) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get();
    print(query.docs.isNotEmpty);
    return query.docs.isNotEmpty;
  }

  Future AddUserData(UserModel userModel) async {
    userModel.createdAt = DateTime.now().toUtc().millisecondsSinceEpoch;

    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .set(userModel.toJson());
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future getListOfUser() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection("users").get();
    return snapshot.docs
        .map((docData) => UserModel.parseSnapshot(docData))
        .toList();
  }

  Future<UserModel> getUserDetail(String userId) async {
    UserModel objUsers = UserModel();
    try {
      QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where("uid", isEqualTo: userId)
          .limit(1)
          .get();
      if (result.docs.isNotEmpty) {
        for (var docData in result.docs) {
          objUsers = UserModel.parseSnapshot(docData);
        }
        return objUsers;
      }
    } catch (e) {
      print(e);
    }
    return objUsers;
  }

  Future<PrivacyPolicyModel> getPrivacyPolicy() async {
    PrivacyPolicyModel objPrivacyPolicy = PrivacyPolicyModel();

    try {
      QuerySnapshot result =
          await FirebaseFirestore.instance.collection('privacyPolicy').get();
      if (result.docs.isNotEmpty) {
        for (var docData in result.docs) {
          objPrivacyPolicy = PrivacyPolicyModel.parseSnapshot(docData);
        }
        return objPrivacyPolicy;
      }
    } catch (e) {
      print(e);
    }
    return objPrivacyPolicy;
  }

  Future<TermAndConditionModel> getTermsAndCondition() async {
    TermAndConditionModel objTermAndConditionModel =
        TermAndConditionModel();

    try {
      QuerySnapshot result = await FirebaseFirestore.instance
          .collection('termsAndConditions')
          .get();
      if (result.docs.isNotEmpty) {
        for (var docData in result.docs) {
          objTermAndConditionModel =
              TermAndConditionModel.parseSnapshot(docData);
        }
        return objTermAndConditionModel;
      }
    } catch (e) {
      print(e);
    }
    return objTermAndConditionModel;
  }

  Future<CookieModel> getCookie() async {
    CookieModel objCookieModel = CookieModel();
    try {
      QuerySnapshot result =
          await FirebaseFirestore.instance.collection('cookie').get();
      if (result.docs.isNotEmpty) {
        for (var docData in result.docs) {
          objCookieModel = CookieModel.parseSnapshot(docData);
        }
        return objCookieModel;
      }
    } catch (e) {
      print(e);
    }
    return objCookieModel;
  }

  Future<BugsAndReportModel> getBugAndReport() async {
    BugsAndReportModel objBugsAndReportModel = BugsAndReportModel();
    try {
      QuerySnapshot result =
          await FirebaseFirestore.instance.collection('bugsAndReports').get();
      if (result.docs.isNotEmpty) {
        for (var docData in result.docs) {
          objBugsAndReportModel = BugsAndReportModel.parseSnapshot(docData);
        }
        return objBugsAndReportModel;
      }
    } catch (e) {
      print(e);
    }
    return objBugsAndReportModel;
  }

  Future updateCookie(
    String docId,
    String description,
    String title,
  ) async {
    await FirebaseFirestore.instance.collection('cookie').doc(docId).update({
      "description": description,
      "title": title,
      'updatedAt': DateTime.now().toUtc().millisecondsSinceEpoch,
      "updatedBy": _auth.currentUser!.uid,
    }).catchError((e) {
      print(e);
    });
  }

  Future updatePrivacyPolicy(
    String docId,
    String description,
    String title,
  ) async {
    await FirebaseFirestore.instance
        .collection('privacyPolicy')
        .doc(docId)
        .update({
      "description": description,
      "title": title,
      'updatedAt': DateTime.now().toUtc().millisecondsSinceEpoch,
      "updatedBy": _auth.currentUser!.uid,
    }).catchError((e) {
      print(e);
    });
  }

  Future updateTermsAndConditions(
    String docId,
    String description,
    String title,
  ) async {
    await FirebaseFirestore.instance
        .collection('termsAndConditions')
        .doc(docId)
        .update({
      "description": description,
      "title": title,
      'updatedAt': DateTime.now().toUtc().millisecondsSinceEpoch,
      "updatedBy": _auth.currentUser!.uid,
    }).catchError((e) {
      print(e);
    });
  }

  Future updateBugAndReport(
    String docId,
    String description,
    String title,
  ) async {
    await FirebaseFirestore.instance
        .collection('bugsAndReports')
        .doc(docId)
        .update({
      "description": description,
      "title": title,
      'updatedAt': DateTime.now().toUtc().millisecondsSinceEpoch,
      "updatedBy": _auth.currentUser!.uid,
    }).catchError((e) {
      print(e);
    });
  }

  Future updateEmailAddress(
    String email,
  ) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .update({
      "emailId": email,
    }).catchError((e) {
      print(e);
    });
  }

  Future updateToken(
    String token,
  ) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .update({"fcmToken": token}).catchError((e) {
      print(e);
    });
  }

  Future updateFullaName(
    String firstName,
    String lastName,
  ) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .update({
      "firstName": firstName,
      "lastName": lastName,
    }).catchError((e) {
      print(e);
    });
  }

  Future updatePhoneNumber(
    String phoneNumber,
  ) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .update({
      "phoneNumber": phoneNumber,
    }).catchError((e) {
      print(e);
    });
  }

  Future updateProfile(
    String userProfile,
  ) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .update({
      "userProfile": userProfile,
    }).catchError((e) {
      print(e);
    });
  }

  Future<bool> checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return true;
  }

  Future creteEvent(CreateEventModel objCreateEventModel) async {
    var docId = FirebaseFirestore.instance.collection("events").doc().id;

    objCreateEventModel.createdAt =
        DateTime.now().toUtc().millisecondsSinceEpoch;
    objCreateEventModel.updatedAt =
        DateTime.now().toUtc().millisecondsSinceEpoch;
    objCreateEventModel.docId = docId;

    try {
      FirebaseFirestore.instance.collection("events").doc(docId).set(
            objCreateEventModel.toJson(),
          );
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<CreateEventModel>> getListOfMyUpcomingEventswithCoHost(
      String name) async {
    List<CreateEventModel> lstCreateEventModel = [];
    try {
      QuerySnapshot result = await FirebaseFirestore.instance
          .collection('events')
          .where("coHost", isEqualTo: name)
          .where("guestsID", arrayContains: _auth.currentUser!.uid)
          .where("eventEndDate", isGreaterThanOrEqualTo: DateTime.now().toUtc())
          .get();
      if (result.docs.isNotEmpty) {
        for (var docData in result.docs) {
          CreateEventModel objCreateEventModel = CreateEventModel();
          objCreateEventModel = CreateEventModel.parseSnapshot(docData);
          lstCreateEventModel.add(objCreateEventModel);
        }
        return lstCreateEventModel;
      }
    } catch (e) {
      print(e);
    }
    return lstCreateEventModel;
  }

  Future<List<CreateEventModel>> getListOfMyPastEventswithCoHost(
      String name) async {
    List<CreateEventModel> lstCreateEventModel = [];
    try {
      QuerySnapshot result = await FirebaseFirestore.instance
          .collection('events')
          .where("coHost", isEqualTo: name)
          .where("guestsID", arrayContains: _auth.currentUser!.uid)
          .where(
            "eventEndDate",
            isLessThan: DateTime.now().toUtc(),
          )
          .get();
      if (result.docs.isNotEmpty) {
        for (var docData in result.docs) {
          CreateEventModel objCreateEventModel = CreateEventModel();
          objCreateEventModel = CreateEventModel.parseSnapshot(docData);
          lstCreateEventModel.add(objCreateEventModel);
        }
        return lstCreateEventModel;
      }
    } catch (e) {
      print(e);
    }
    return lstCreateEventModel;
  }

  Future<List<CreateEventModel>> getListOfMyPastEvents() async {
    List<CreateEventModel> lstCreateEventModel = [];
    try {
      QuerySnapshot result = await FirebaseFirestore.instance
          .collection('events')
          .where("ownerID", isEqualTo: _auth.currentUser!.uid)
          .where("eventEndDate", isLessThan: DateTime.now().toUtc())
          .get();
      if (result.docs.isNotEmpty) {
        for (var docData in result.docs) {
          CreateEventModel objCreateEventModel = CreateEventModel();
          objCreateEventModel = CreateEventModel.parseSnapshot(docData);
          lstCreateEventModel.add(objCreateEventModel);
        }
        return lstCreateEventModel;
      }
    } catch (e) {
      print(e);
    }
    return lstCreateEventModel;
  }

  Future<List<CreateEventModel>> getEventDetails(String docId) async {
    List<CreateEventModel> objCreateEventModel = [];
    try {
      QuerySnapshot result = await FirebaseFirestore.instance
          .collection('events')
          .where("docId", isEqualTo: docId)
          .get();
      if (result.docs.isNotEmpty) {
        for (var docData in result.docs) {
          CreateEventModel objEvent = CreateEventModel();
          objEvent = CreateEventModel.parseSnapshot(docData);
          objCreateEventModel.add(objEvent);
        }
        return objCreateEventModel;
      }
    } catch (e) {
      print(e);
    }
    return objCreateEventModel;
  }

  Future<CreateEventModel> eventDetails(String eventid) async {
    CreateEventModel objEvent = CreateEventModel();
    try {
      QuerySnapshot result = await FirebaseFirestore.instance
          .collection('events')
          .where("docId", isEqualTo: eventid)
          .get();
      if (result.docs.isNotEmpty) {
        for (var docData in result.docs) {
          objEvent = CreateEventModel.parseSnapshot(docData);
        }
        return objEvent;
      }
    } catch (e) {
      print(e);
    }
    return objEvent;
  }

  Future<CreateEventModel> getNotificationEventDetails(
      String notificationId) async {
    CreateEventModel objEvent = CreateEventModel();
    try {
      QuerySnapshot result = await FirebaseFirestore.instance
          .collection('events')
          .where("docId", isEqualTo: notificationId)
          .get();
      if (result.docs.isNotEmpty) {
        for (var docData in result.docs) {
          objEvent = CreateEventModel.parseSnapshot(docData);
        }
        return objEvent;
      }
    } catch (e) {
      print(e);
    }
    return objEvent;
  }

  Future addGuestList(
    List<GuestModel>? guest,
    String docId,
    List guestsID,
    List<AllDates>? alldates,
  ) async {
    var jsonMap = guest!.map((e) => e.toJson()).toList();
    var selectedDate = alldates!.map((e) => e.toJson()).toList();

    await FirebaseFirestore.instance.collection('events').doc(docId).update(
      {
        "guest": jsonMap,
        "guestsID": guestsID,
        "allDates": selectedDate,
      },
    ).catchError((e) {
      print(e);
      print(jsonMap);
    });
  }

  Future<List<CreateEventModel>> getListOfpastEvents(String userId) async {
    List<CreateEventModel> lstCreateEventModel = [];
    try {
      QuerySnapshot result = await FirebaseFirestore.instance
          .collection('events')
          .where("guestsID", arrayContains: userId)
          .where("eventEndDate", isLessThan: DateTime.now().toUtc())
          .get();
      if (result.docs.isNotEmpty) {
        for (var docData in result.docs) {
          CreateEventModel objCreateEventModel = CreateEventModel();
          objCreateEventModel = CreateEventModel.parseSnapshot(docData);
          lstCreateEventModel.add(objCreateEventModel);
        }
        print(lstCreateEventModel);
        return lstCreateEventModel;
      }
    } catch (e) {
      print(e);
    }
    return lstCreateEventModel;
  }

  Future getGuestList(List<Object?>? guestId) async {
    print("Guest ID List: $guestId");
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection("users").get();

      return snapshot.docs
          .map(
            (docData) => UserModel.parseSnapshot(docData),
          )
          .where((e) => guestId!.contains(e.uid))
          .toList();
    } catch (e) {
      print(e);
    }
  }

  Future removeCohost(
    String docId,
    List<String>? cohostList,
  ) async {
    await FirebaseFirestore.instance.collection('events').doc(docId).update({
      "cohostList": cohostList,
    }).catchError((e) {
      print(e);
    });
  }

  Future editEventDetails(
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
      List<String>? cohostList,
      List<AllDates>? allDates) async {
    dynamic jsonMap2 = allDates!.map((e) => e.toJson()).toList();
    await FirebaseFirestore.instance.collection('events').doc(docId).update({
      'eventname': eventname,
      'selectedDate': selectedDate,
      'selectedTime': selectedTime,
      'description': description,
      'location': location,
      'eventPhoto': eventPhoto,
      'inviteFriends': inviteFriends,
      'enableCostSplite': enableCostSplite,
      'costAmount': costAmount,
      'coHost': coHost,
      'eventStartDate': eventStartDate,
      'eventEndDate': eventEndDate,
      'updatedAt': DateTime.now().toUtc().millisecondsSinceEpoch,
      "allDates": jsonMap2,
      "cohostList": cohostList,
    }).catchError((e) {
      print(e);
    });
  }

  Future ceateGroup(GroupModel objGroupModel) async {
    var docId = FirebaseFirestore.instance.collection("groups").doc().id;

    objGroupModel.createdAt = DateTime.now().toUtc().millisecondsSinceEpoch;
    objGroupModel.updateAt = DateTime.now().toUtc();
    objGroupModel.docID = docId;
    objGroupModel.createdBy = _auth.currentUser!.uid;
    objGroupModel.updateBy = _auth.currentUser!.uid;

    try {
      FirebaseFirestore.instance.collection("groups").doc(docId).set(
            objGroupModel.toJson(),
          );
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future pushNotification(NotificationModel notificationModel) async {
    var docId = FirebaseFirestore.instance.collection("notifications").doc().id;

    notificationModel.createdAt = DateTime.now().toUtc().millisecondsSinceEpoch;
    notificationModel.createdBy = _auth.currentUser!.uid;
    notificationModel.docID = docId;
    try {
      await FirebaseFirestore.instance
          .collection("notifications")
          .doc(docId)
          .set(notificationModel.toJson());
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future sendPushNotification(
    String token,
    String title,
    String body,
    String type,
    String conversationId,
    String eventId,
    String eventHostUserId,
  ) async {
    if (token == "") {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      var response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          "Authorization":
              "key=AAAAvB2yNBw:APA91bHhCfQ_wZEDnflrirLxeXdJ_e8WsOLCAlSpi-XCGC3uQNjWV9HFqZbXi4Bt5euNypCN4js-WXhQCuQF8QWNs7Jhpbe2-eidjmdZOp-KT149Ylc1H096aQ0A4FJMPVPSA4KAgQnM"
        },
        body: jsonEncode({
          "to": token,
          "notification": {
            "title": title,
            "body": body,
          },
          "data": {
            "type": type,
            "sendBy": _auth.currentUser!.uid,
            "conversationId": conversationId,
            "eventId": eventId,
            "eventHostUserId": eventHostUserId
          },
        }),
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        print('FCM request for device sent!');
      }
    } catch (e) {
      print(e);
    }
  }

  Future getListOfAllNotification() async {
    try {
      QuerySnapshot querySnapshot;
      if (lastDocument == null) {
        querySnapshot = await FirebaseFirestore.instance
            .collection('notifications')
            .where("userId", isEqualTo: _auth.currentUser!.uid)
            .limit(pazeSize)
            .get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection('notifications')
            .where("userId", isEqualTo: _auth.currentUser!.uid)
            .startAfterDocument(lastDocument!)
            .limit(pazeSize)
            .get();
        print(1);
      }

      if (querySnapshot.docs.isEmpty) {
        print("No More Data");
      } else {
        lastDocument = querySnapshot.docs.last;
      }
      return querySnapshot.docs
          .map((docData) => NotificationModel.parseSnapshot(docData))
          .toList();
    } catch (e) {
      print(e);
    }
  }

  Future<List<CreateEventModel>> getListOfMyUpcomingEvents() async {
    List<CreateEventModel> lstCreateEventModel = [];
    try {
      QuerySnapshot result = await FirebaseFirestore.instance
          .collection('events')
          .where("ownerID", isEqualTo: _auth.currentUser!.uid)
          .where("eventEndDate", isGreaterThanOrEqualTo: DateTime.now().toUtc())
          .get();
      if (result.docs.isNotEmpty) {
        for (var docData in result.docs) {
          CreateEventModel objCreateEventModel = CreateEventModel();
          objCreateEventModel = CreateEventModel.parseSnapshot(docData);
          lstCreateEventModel.add(objCreateEventModel);
        }
        return lstCreateEventModel;
      }
    } catch (e) {
      print(e);
    }
    return lstCreateEventModel;
  }

  Future<List<CreateEventModel>> getListOfUpcomingEvents() async {
    List<CreateEventModel> lstCreateEventModel = [];
    try {
      QuerySnapshot result = await FirebaseFirestore.instance
          .collection('events')
          .where("guestsID", arrayContains: _auth.currentUser!.uid)
          .where("eventEndDate", isGreaterThanOrEqualTo: DateTime.now().toUtc())
          .get();
      print(
          "getting snapshot of upcoming events ===> Length:${result.docs.length}");
      if (result.docs.isNotEmpty) {
        for (var docData in result.docs) {
          CreateEventModel objCreateEventModel = CreateEventModel();
          print("event model datum 1");
          objCreateEventModel = CreateEventModel.parseSnapshot(docData);

          print("event model datum 2");
          lstCreateEventModel.add(objCreateEventModel);
          print("event model datum 3");
        }

        print("Event model found: $lstCreateEventModel");
        return lstCreateEventModel;
      }
    } catch (e) {
      print(e);
    }
    return lstCreateEventModel;
  }

  Future getSpecificChat(String user1, String user2) async {
    try {
      QuerySnapshot querySnapshot;
      querySnapshot = await FirebaseFirestore.instance
          .collection('conversations')
          .where("members", arrayContains: user1)
          .where("members", arrayContains: user2)
          .orderBy("uid")
          .limit(pazeSize)
          .get();
    } catch (e) {
      print(e);
    }
  }

  Future getListOfContactUser() async {
    try {
      QuerySnapshot querySnapshot;
      if (lastDocumentOfContact == null) {
        querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where("uid", isNotEqualTo: _auth.currentUser!.uid)
            .orderBy("uid")
            .limit(pazeSize)
            .get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where("uid", isNotEqualTo: _auth.currentUser!.uid)
            .orderBy("uid")
            .limit(pazeSize)
            .startAfterDocument(lastDocumentOfContact!)
            .get();
      }

      if (querySnapshot.docs.isEmpty) {
        print("No More Data");
      } else {
        lastDocumentOfContact = querySnapshot
            .docs[querySnapshot.docs.length - 1]; //querySnapshot.docs.last;
      }
      return querySnapshot.docs
          .map((docData) => UserModel.parseSnapshot(docData))
          .toList();
    } catch (e) {
      print(e);
    }
  }

  Future getListOfHostingAllNotification() async {
    try {
      QuerySnapshot querySnapshot;
      if (lastDocument == null) {
        querySnapshot = await FirebaseFirestore.instance
            .collection('notifications')
            .where("userId", isEqualTo: _auth.currentUser!.uid)
            .where('title', isEqualTo: "Response to your Invitation")
            .limit(pazeSize)
            .get();
        print("Query Snapshot: $querySnapshot");
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection('notifications')
            .where("userId", isEqualTo: _auth.currentUser!.uid)
            .limit(pazeSize)
            .startAfterDocument(lastDocument!)
            .get();
        print(1);
      }

      if (querySnapshot.docs.isEmpty) {
        print("No More Data");
      } else {
        lastDocument = querySnapshot.docs.last;
      }
      return querySnapshot.docs
          .map((docData) => NotificationModel.parseSnapshot(docData))
          .toList();
    } catch (e) {
      print(e);
    }
  }

  Future getInvitationsNotification() async {
    try {
      QuerySnapshot querySnapshot;
      if (lastDocument == null) {
        querySnapshot = await FirebaseFirestore.instance
            .collection('notifications')
            .where("userId", isEqualTo: _auth.currentUser!.uid)
            .where("title", isEqualTo: "Event Invitation")
            .limit(pazeSize)
            .get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection('notifications')
            .where("userId", isEqualTo: _auth.currentUser!.uid)
            .startAfterDocument(lastDocument!)
            .limit(pazeSize)
            .get();
        print(1);
      }

      if (querySnapshot.docs.isEmpty) {
        print("No More Data");
      } else {
        lastDocument = querySnapshot.docs.last;
      }
      return querySnapshot.docs
          .map((docData) => NotificationModel.parseSnapshot(docData))
          .toList();
    } catch (e) {
      print(e);
    }
  }

  Future getAllEventList() async {
    try {
      QuerySnapshot querySnapshot;

      if (lastDocumentOfSearchEvent == null) {
        querySnapshot = await FirebaseFirestore.instance
            .collection('events')
            .where("guestsID", arrayContains: _auth.currentUser!.uid)
            .orderBy("docId")
            .limit(pazeSize)
            .get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection('events')
            .where("guestsID", arrayContains: _auth.currentUser!.uid)
            .orderBy("docId")
            .limit(pazeSize)
            .startAfterDocument(lastDocumentOfSearchEvent!)
            .get();
        print(1);
      }

      if (querySnapshot.docs.isEmpty) {
        print("No More Data");
      } else {
        lastDocumentOfSearchEvent = querySnapshot.docs.last;
      }
      return querySnapshot.docs
          .map((docData) => CreateEventModel.parseSnapshot(docData))
          .toList();
    } catch (e) {
      print(e);
    }
  }

  Future doPayment(PaymentModel objPaymentModel) async {
    var docId = FirebaseFirestore.instance.collection("payments").doc().id;

    objPaymentModel.docID = docId;
    objPaymentModel.paymentByUserId = _auth.currentUser!.uid;

    try {
      FirebaseFirestore.instance.collection("payments").doc(docId).set(
            objPaymentModel.toJson(),
          );
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future addConversition(
    String docId,
    List members,
  ) async {
    await FirebaseFirestore.instance
        .collection('conversations')
        .doc(docId)
        .set({
      'members': members,
      'updatedAt': Timestamp.now(),
      "isGroup": true
    }).catchError((e) {
      print(e);
    });
  }

  Future<List<CreateEventModel>> getListOfProfilePastEvent(
      String userId) async {
    List<CreateEventModel> lstCreateEventModel = [];
    try {
      QuerySnapshot result = await FirebaseFirestore.instance
          .collection('events')
          .where("ownerID", isEqualTo: userId)
          .where("eventEndDate", isLessThan: DateTime.now().toUtc())
          .get();
      if (result.docs.isNotEmpty) {
        for (var docData in result.docs) {
          CreateEventModel objCreateEventModel = CreateEventModel();
          objCreateEventModel = CreateEventModel.parseSnapshot(docData);
          lstCreateEventModel.add(objCreateEventModel);
        }
        return lstCreateEventModel;
      }
    } catch (e) {
      print(e);
    }
    return lstCreateEventModel;
  }

  Future<List<PaymentModel>> getListOfReceivedpayments() async {
    List<PaymentModel> lstPaymentModel = [];
    try {
      QuerySnapshot result = await FirebaseFirestore.instance
          .collection('payments')
          .where("paymentToUserId", isEqualTo: _auth.currentUser!.uid)
          .get();
      if (result.docs.isNotEmpty) {
        for (var docData in result.docs) {
          PaymentModel objPaymentModel = PaymentModel();
          objPaymentModel = PaymentModel.parseSnapshot(docData);
          lstPaymentModel.add(objPaymentModel);
        }
        print(lstPaymentModel);
        return lstPaymentModel;
      }
    } catch (e) {
      print(e);
    }
    return lstPaymentModel;
  }

  Future<List<PaymentModel>> getListOfPaidpayments() async {
    List<PaymentModel> lstPaymentModel = [];
    try {
      QuerySnapshot result = await FirebaseFirestore.instance
          .collection('payments')
          .where("paymentByUserId", isEqualTo: _auth.currentUser!.uid)
          .get();
      if (result.docs.isNotEmpty) {
        for (var docData in result.docs) {
          PaymentModel objPaymentModel = PaymentModel();
          objPaymentModel = PaymentModel.parseSnapshot(docData);
          lstPaymentModel.add(objPaymentModel);
        }
        print(lstPaymentModel);
        return lstPaymentModel;
      }
    } catch (e) {
      print(e);
    }
    return lstPaymentModel;
  }

  createPaymentIntent(dynamic amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      print(body);
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer sk_test_51LE9ZpLtPhgIm71dPPWHoX1vOKGjlHro9iORhvbIJZN2qh5Oq4Ni7VOFf5iUyBNApFX7DgrRRJsZfvOLkxSxagTh007PFPv6E6',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      print('Create Intent reponse ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(dynamic amount) {
    final a = (amount * (100).toInt());
    return a.toString();
  }

  Future AddUserToBlock(BlockUserModel blockUserModel) async {
    var docId = FirebaseFirestore.instance.collection("blockUser").doc().id;

    blockUserModel.docId = docId;
    blockUserModel.BlockAt = DateTime.now();
    blockUserModel.blockBy = _auth.currentUser!.uid;

    try {
      await FirebaseFirestore.instance
          .collection("blockUser")
          .doc(docId)
          .set(blockUserModel.toJson());
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<BlockUserModel> getBlockUserDetail(String userId) async {
    BlockUserModel blockUserModel = BlockUserModel();
    try {
      QuerySnapshot result = await FirebaseFirestore.instance
          .collection('blockUser')
          .where("blockTo", isEqualTo: userId)
          .where("blockBy", isEqualTo: _auth.currentUser!.uid)
          .limit(1)
          .get();
      if (result.docs.isNotEmpty) {
        for (var docData in result.docs) {
          blockUserModel = BlockUserModel.parseSnapshot(docData);
        }
        return blockUserModel;
      }
    } catch (e) {
      print(e);
    }
    return blockUserModel;
  }

  Future<BlockUserModel> checkThatCurrentUserBlcokOrNot(String userId) async {
    BlockUserModel blockUserModel = BlockUserModel();
    try {
      QuerySnapshot result = await FirebaseFirestore.instance
          .collection('blockUser')
          .where("blockTo", isEqualTo: _auth.currentUser!.uid)
          .where("blockBy", isEqualTo: userId)
          .limit(1)
          .get();
      if (result.docs.isNotEmpty) {
        for (var docData in result.docs) {
          blockUserModel = BlockUserModel.parseSnapshot(docData);
        }
        return blockUserModel;
      }
    } catch (e) {
      print(e);
    }
    return blockUserModel;
  }

  Future unBlockUser(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection("blockUser")
          .doc(docId)
          .delete();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<BlockUserModel>> getListOfBlockUsers() async {
    List<BlockUserModel> lstPaymentModel = [];
    try {
      QuerySnapshot result = await FirebaseFirestore.instance
          .collection('blockUser')
          .where(
            "blockBy",
            isEqualTo: _auth.currentUser!.uid,
          )
          .get();
      return result.docs
          .map(
            (docData) => BlockUserModel.parseSnapshot(
              docData,
            ),
          )
          .toList();
    } catch (e) {
      print(e);
    }
    return lstPaymentModel;
  }

  Future chnageResponseOfuser(
    String docId,
    List<AllDates>? alldates,
  ) async {
    dynamic selectedDate = alldates!.map((e) => e.toJson()).toList();

    await FirebaseFirestore.instance.collection('events').doc(docId).update(
      {
        "allDates": selectedDate,
      },
    ).catchError((e) {
      print(e);
    });
  }

  Future sendNotificationToTheHost(
      String docId, bool isNotificationSent) async {
    await FirebaseFirestore.instance.collection('events').doc(docId).update(
      {
        "isNotificationSent": isNotificationSent,
      },
    ).catchError((e) {
      print(e);
    });
  }
}
