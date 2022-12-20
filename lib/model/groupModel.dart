import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omw/model/user_model.dart';

import 'groupMessage_model.dart';

class GroupModel {
  String? groupName;
  String? gropuProfile;
  String? docID;
  List? groupUser;
  int? createdAt;
  String? createdBy;
  DateTime? updateAt;
  String? updateBy;
  List<UserModel>? lstUsers;
  List<GroupMessageModel>? messages;
  List<GroupMessageModel>? count;

  GroupModel(
      {this.groupName,
      this.gropuProfile,
      this.docID,
      this.groupUser,
      this.createdAt,
      this.createdBy,
      this.updateAt,
      this.updateBy,
      this.lstUsers,
      this.messages,
      this.count});

  static GroupModel parseSnapshot(DocumentSnapshot snapshot) {
    List groupUser = snapshot["groupUser"] ?? [];
    if (snapshot.exists) {
      return GroupModel(
        groupName: snapshot["groupName"] ?? "",
        gropuProfile: snapshot["gropuProfile"] ?? "",
        docID: snapshot["docID"] ?? "",
        groupUser: groupUser.map((e) => e).toList(),
        createdAt: snapshot["createdAt"] ?? "",
        createdBy: snapshot["createdBy"] ?? "",
        updateAt: (snapshot["updateAt"] as Timestamp).toDate(),
        updateBy: snapshot["updateBy"] ?? "",
      );
    }
    return GroupModel();
  }

  Map<String, dynamic> toJson() => {
        "groupName": groupName,
        "gropuProfile": gropuProfile,
        "docID": docID,
        "groupUser": groupUser,
        "createdAt": createdAt,
        "createdBy": createdBy,
        "updateAt": updateAt,
        "updateBy": updateBy,
      };
}
