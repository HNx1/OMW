import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  String? docID;
  String? paymentByUserId;
  dynamic amount;
  DateTime? paymentTime;
  DateTime? createdAt;
  String? eventId;
  String? eventName;
  String? eventHostedBy;
  String? paymentBy;
  String? paymentToUserId;

  String? payment_method;
  String? currency;
  String? paidUserProfile;
  String? receivedUserProfile;

  PaymentModel({
    this.docID,
    this.paymentBy,
    this.amount,
    this.createdAt,
    this.paymentTime,
    this.eventHostedBy,
    this.eventId,
    this.eventName,
    this.paymentByUserId,
    this.payment_method,
    this.currency,
    this.paidUserProfile,
    this.paymentToUserId,
    this.receivedUserProfile
  });

  static PaymentModel parseSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      return PaymentModel(
        docID: snapshot["docID"] ?? "",
        paymentBy: snapshot["paymentBy"] ?? "",
        amount: snapshot["amount"] ?? "",
        createdAt: (snapshot["createdAt"] as Timestamp).toDate(),
        paymentTime: (snapshot["paymentTime"] as Timestamp).toDate(),
        eventHostedBy: snapshot["eventHostedBy"] ?? "",
        eventId: snapshot["eventId"] ?? "",
        eventName: snapshot["eventName"] ?? "",
        paymentByUserId: snapshot["paymentByUserId"] ?? "",
        payment_method: snapshot["payment_method"] ?? "",
        currency: snapshot["currency"] ?? "",
        paidUserProfile: snapshot["paidUserProfile"] ?? "",
        paymentToUserId: snapshot["paymentToUserId"] ?? "",
        receivedUserProfile: snapshot["receivedUserProfile"] ?? "",

      );
    }
    return PaymentModel();
  }

  Map<String, dynamic> toJson() => {
        "docID": docID,
        "paymentBy": paymentBy,
        "amount": amount,
        "createdAt": createdAt,
        "paymentTime": paymentTime,
        "eventHostedBy": eventHostedBy,
        "eventId": eventId,
        "eventName": eventName,
        "paymentByUserId": paymentByUserId,
        "payment_method": payment_method,
        "currency": currency,
        "paidUserProfile": paidUserProfile,
        "paymentToUserId": paymentToUserId,
        "receivedUserProfile": receivedUserProfile,

      };
}
