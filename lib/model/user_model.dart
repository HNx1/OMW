import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? emailId;
  String? birthDate;
  String? userProfile;
  String? uid;
  String? role;
  int? createdAt;
  bool isSelcetdForGroup;
  bool isInvite;
  bool? isAlreadyinvited;
  String? fcmToken;

  UserModel({
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.emailId,
    this.birthDate,
    this.userProfile,
    this.uid,
    this.role,
    this.createdAt,
    this.isInvite = false,
    this.isSelcetdForGroup = false,
    this.isAlreadyinvited,
    this.fcmToken,
  });

  static UserModel parseSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      return UserModel(
        firstName: snapshot["firstName"] ?? "",
        lastName: snapshot["lastName"] ?? "",
        phoneNumber: snapshot["phoneNumber"] ?? "",
        emailId: snapshot["emailId"] ?? "",
        birthDate: snapshot["birthDate"] ?? "",
        userProfile: snapshot["userProfile"] ?? "",
        uid: snapshot["uid"] ?? "",
        role: snapshot["role"] ?? "",
        createdAt: snapshot["createdAt"] ?? 0,
        fcmToken: snapshot["fcmToken"] ?? "",
      );
    }
    return UserModel();
  }

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        "emailId": emailId,
        "birthDate": birthDate,
        "userProfile": userProfile,
        "uid": uid,
        "role": role,
        "createdAt": createdAt,
        "fcmToken": fcmToken,
      };
}
