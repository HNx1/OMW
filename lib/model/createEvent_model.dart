import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omw/model/user_model.dart';

class CreateEventModel {
  String? docId;

  String? eventname;
  List? selectedDate;
  String? selectedTime;

  String? description;
  String? location;
  String? eventPhoto;
  bool? inviteFriends;
  String? ownerID;
  bool? enableCostSplite;
  dynamic costAmount;
  String? coHost;

  int? createdAt;
  int? updatedAt;
  List<GuestModel>? guest;
  List? guestsID;
  DateTime? eventStartDate;
  DateTime? eventEndDate;
  UserModel? lstUser;
  List<AllDates>? allDates;
  List<String>? cohostList;
  bool isNotificationSent = false;
  bool? isDatePoll;

  CreateEventModel(
      {this.docId,
      this.eventname,
      this.selectedDate,
      this.selectedTime,
      this.location,
      this.description,
      this.eventPhoto,
      this.inviteFriends,
      this.ownerID,
      this.enableCostSplite,
      this.costAmount,
      this.coHost,
      this.createdAt,
      this.updatedAt,
      this.guest,
      this.eventStartDate,
      this.eventEndDate,
      this.guestsID,
      this.lstUser,
      this.allDates,
      this.isNotificationSent = false,
      this.isDatePoll,
      this.cohostList});

  static CreateEventModel parseSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      List lstGuestList = snapshot["guest"] ?? [];
      List selectedDate = snapshot["selectedDate"] ?? [];
      List guestsID = snapshot["guestsID"] ?? [];
      List lstallDates = snapshot["allDates"] ?? [];
      List<String> cohostListEl =
          snapshot.data().toString().contains('cohostList')
              ? new List<String>.from(snapshot["cohostList"])
              : [snapshot["ownerID"]];
      bool datePollEl = snapshot["selectedDate"].length > 1 ? true : false;

      return CreateEventModel(
          docId: snapshot["docId"] ?? "",
          eventname: snapshot["eventname"] ?? "",
          selectedDate: selectedDate.map((e) => e).toList(),
          selectedTime: snapshot["selectedTime"] ?? "",
          description: snapshot["description"] ?? "",
          location: snapshot["location"] ?? "",
          eventPhoto: snapshot["eventPhoto"] ?? "",
          inviteFriends: snapshot["inviteFriends"] ?? false,
          ownerID: snapshot["ownerID"] ?? "",
          enableCostSplite: snapshot["enableCostSplite"] ?? false,
          costAmount: snapshot["costAmount"] ?? 0,
          coHost: snapshot["coHost"] ?? "",
          cohostList: cohostListEl,
          createdAt: snapshot["createdAt"] ?? 0,
          updatedAt: snapshot["updatedAt"] ?? 0,
          guest: lstGuestList
              .map((member) => GuestModel.fromJson(member))
              .toList(),
          eventStartDate: (snapshot["eventStartDate"] as Timestamp).toDate(),
          eventEndDate: (snapshot["eventEndDate"] as Timestamp).toDate(),
          guestsID: guestsID.map((e) => e.toString()).toList(),
          allDates:
              lstallDates.map((member) => AllDates.fromJson(member)).toList(),
          isNotificationSent: snapshot["isNotificationSent"] ?? false,
          isDatePoll: datePollEl);
    }
    return CreateEventModel();
  }

  Map<String, dynamic> toJson() => {
        "docId": docId,
        "eventname": eventname,
        "selectedDate": selectedDate,
        "selectedTime": selectedTime,
        "location": location,
        "description": description,
        "eventPhoto": eventPhoto,
        "inviteFriends": inviteFriends,
        "ownerID": ownerID,
        "enableCostSplite": enableCostSplite,
        "costAmount": costAmount,
        "coHost": coHost,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "guest": guest == null
            ? []
            : List<Map<String, dynamic>>.from(guest!.map((x) => x.toJson())),
        "allDates": allDates == null
            ? []
            : List<Map<String, dynamic>>.from(allDates!.map((x) => x.toJson())),
        "eventStartDate": eventStartDate,
        "eventEndDate": eventEndDate,
        "guestsID": guestsID,
        "isNotificationSent": isNotificationSent,
        "cohostList": cohostList == null ? [""] : cohostList,
      };
}

class GuestModel {
  String? guestID;
  int? status;
  String? guestUserName;

  GuestModel({this.guestID, this.status, this.guestUserName});

  GuestModel.fromJson(Map<String, dynamic> json) {
    guestID = json['guestID'] ?? "";
    status = json['status'] ?? 0;
    guestUserName = json['guestUserName'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['guestID'] = this.guestID;
    data['status'] = this.status;
    data['guestUserName'] = this.guestUserName;

    return data;
  }
}

class AllDates {
  DateTime? selectedDate;
  List<GuestModel>? guestResponse;

  GuestModel? objguest;

  AllDates({
    this.selectedDate,
    this.guestResponse,
    this.objguest,
  });
  AllDates.fromJson(Map<String, dynamic> json) {
    selectedDate = (json["selectedDate"] as Timestamp).toDate();
    guestResponse = (json['guest'] as List<dynamic>?)
        ?.map((e) => GuestModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> toJson() => {
        "selectedDate": selectedDate,
        "guest": guestResponse == null
            ? []
            : List<Map<String, dynamic>>.from(
                guestResponse!.map((x) => x.toJson())),
      };
}
