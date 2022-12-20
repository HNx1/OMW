import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omw/model/user_model.dart';

class NotificationModel {
  String? title;
  String? description;
  String? docID;
  int? createdAt;
  String? createdBy;
  String? userId;
  DateTime? time;
  String? type;
  List? typeOfData;

  UserModel? userDetails;

  NotificationModel({
    this.title,
    this.description,
    this.docID,
    this.createdAt,
    this.createdBy,
    this.userDetails,
    this.userId,
    this.time,
    this.type,
    this.typeOfData,
  });

  static NotificationModel parseSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      List lstTypeOfData = snapshot["typeOfData"] ?? [];
      return NotificationModel(
        title: snapshot["title"] ?? "",
        description: snapshot["description"] ?? "",
        docID: snapshot["docID"] ?? "",
        createdAt: snapshot["createdAt"] ?? "",
        createdBy: snapshot["createdBy"] ?? "",
        userId: snapshot["userId"] ?? "",
        time: (snapshot["time"] as Timestamp).toDate(),
        type: snapshot["type"] ?? "",
        typeOfData: lstTypeOfData.map((e) => e).toList(),
      );
    }
    return NotificationModel();
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "docID": docID,
        "createdAt": createdAt,
        "createdBy": createdBy,
        "userId": userId,
        "time": time,
        "type": type,
        "typeOfData": typeOfData,
      };
}
