import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omw/model/user_model.dart';

class BlockUserModel {
  String? docId;
  String? blockBy;
  String? blockTo;
  DateTime? BlockAt;
  UserModel? lstUser;
  String? UserName;
  String? UserProfile;
  String? UserPhone;

  BlockUserModel({
    this.docId,
    this.blockBy,
    this.blockTo,
    this.BlockAt,
    this.lstUser,
    this.UserName,
    this.UserProfile,
    this.UserPhone,
  });

  static BlockUserModel parseSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      return BlockUserModel(
        docId: snapshot["docId"] ?? "",
        blockBy: snapshot["blockBy"] ?? "",
        blockTo: snapshot["blockTo"] ?? "",
        BlockAt: (snapshot["BlockAt"] as Timestamp).toDate(),
        UserName: snapshot["UserName"] ?? "",
        UserProfile: snapshot["UserProfile"] ?? "",
        UserPhone: snapshot["UserPhone"] ?? "",
      );
    }
    return BlockUserModel();
  }

  Map<String, dynamic> toJson() => {
        "docId": docId,
        "blockBy": blockBy,
        "blockTo": blockTo,
        "BlockAt": BlockAt,
        "UserName": UserName,
        "UserProfile": UserProfile,
        "UserPhone": UserPhone,

      };
}
