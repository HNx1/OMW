import 'package:cloud_firestore/cloud_firestore.dart';

class PrivacyPolicyModel {
  String? id;
  String? title;
  String? description;
  int? updatedAt;
  String? updatedBy;
  int? createdAt;
  String? createdBy;

  PrivacyPolicyModel(
      {this.id,
      this.title,
      this.description,
      this.updatedAt,
      this.updatedBy,
      this.createdAt,
      this.createdBy});

  static PrivacyPolicyModel parseSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      return PrivacyPolicyModel(
        id: snapshot["id"] ?? "",
        title: snapshot["title"] ?? "",
        description: snapshot["description"] ?? "",
        updatedAt: snapshot["updatedAt"] ?? 0,
        updatedBy: snapshot["updatedBy"] ?? "",
        createdAt: snapshot["createdAt"] ?? 0,
        createdBy: snapshot["createdBy"] ?? "",
      );
    }
    return PrivacyPolicyModel();
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "updatedAt": updatedAt,
        "updatedBy": updatedBy,
        "createdAt": createdAt,
        "createdBy": createdBy,
      };
}
