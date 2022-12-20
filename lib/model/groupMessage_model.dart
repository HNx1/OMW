import 'package:cloud_firestore/cloud_firestore.dart';

class GroupMessageModel {
  String? message;
  String? authorId;
  DateTime? createdAt;
  String? imageUrl;
  String? eventId;

  String? senderName;
  String? senderProfile;

  GroupMessageModel(
      {this.message,
      this.authorId,
      this.createdAt,
      this.imageUrl,
      this.senderName,
      this.senderProfile,
      this.eventId});

  static GroupMessageModel parseSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      return GroupMessageModel(
        message: snapshot["message"] ?? "",
        authorId: snapshot["authorId"] ?? "",
        createdAt: (snapshot["createdAt"] as Timestamp).toDate(),
        imageUrl: snapshot["imageUrl"] ?? "",
        senderName: snapshot["senderName"] ?? "",
        senderProfile: snapshot["senderProfile"] ?? "",
        eventId: snapshot["eventId"] ?? "",
      );
    }
    return GroupMessageModel();
  }

  Map<String, dynamic> toJson() => {
        "message": message,
        "authorId": authorId,
        "createdAt": createdAt,
        "imageUrl": imageUrl,
        "senderName": senderName,
        "senderProfile": senderProfile,
        "eventId": eventId,
      };
}
