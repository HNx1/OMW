import 'package:cloud_firestore/cloud_firestore.dart';

class BugsAndReportModel {
  String? id;
  String? title;
  String? description;
  int? updatedAt;
  String? updatedBy;
  int? createdAt;
  String? createdBy;

  BugsAndReportModel(
      {this.id,
      this.title,
      this.description,
      this.updatedAt,
      this.updatedBy,
      this.createdAt,
      this.createdBy});

  static BugsAndReportModel parseSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      return BugsAndReportModel(
        id: snapshot["id"] ?? "",
        title: snapshot["title"] ?? "",
        description: snapshot["description"] ?? "",
        updatedAt: snapshot["updatedAt"] ?? 0,
        updatedBy: snapshot["updatedBy"] ?? "",
        createdAt: snapshot["createdAt"] ?? 0,
        createdBy: snapshot["createdBy"] ?? "",
      );
    }
    return BugsAndReportModel();
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
