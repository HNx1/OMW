import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../api/api_provider.dart';
import '../model/payment_model.dart';
import '../widget/scaffold_snackbar.dart';

class PaymentNotifier extends ChangeNotifier {
  bool isLoading = false;
  bool isConnected = false;
  checkConnection() async {
    try {
      isLoading = true;
      isConnected = await ApiProvider().checkConnection();
    } catch (e) {
      isLoading = false;
    } finally {
      isLoading = false;
    }
  }

  PaymentModel objPaymentModel = PaymentModel();
  Future doPayment(
      BuildContext context,
      String eventHost,
      String eventId,
      String eventName,
      String paymentBy,
      dynamic amount,
      String paymentMethod,
      String paidUserProfile,
      String receivedUserProfile,
      String paymentToUserId) async {
    await checkConnection();
    if (isConnected == true) {
      isLoading = true;
      try {
        objPaymentModel = PaymentModel(
            paymentTime: Timestamp.now().toDate(),
            amount: amount,
            createdAt: Timestamp.now().toDate(),
            eventHostedBy: eventHost,
            eventId: eventId,
            eventName: eventName,
            paymentBy: paymentBy,
            payment_method: paymentMethod,
            currency: "GBP",
            paidUserProfile: paidUserProfile,
            paymentToUserId: paymentToUserId,
            receivedUserProfile: receivedUserProfile);
        await ApiProvider().doPayment(objPaymentModel);
        ScaffoldSnackbar.of(context).show("Payment done successfully!!!");
      } catch (e) {
        print(e);
        ScaffoldSnackbar.of(context).show(e.toString());
        isLoading = false;
      } finally {
        isLoading = false;
      }
    } else {
      ScaffoldSnackbar.of(context).show("Turn on the data and retry again");
    }
    notifyListeners();
  }

  List<PaymentModel> lstofOfReceivedpayments = [];

  getListOfReceivedpayments(BuildContext context) async {
    await checkConnection();
    if (isConnected == true) {
      isLoading = true;
      try {
        lstofOfReceivedpayments =
            await ApiProvider().getListOfReceivedpayments();
        print(
            "lstofOfReceivedpayments=====================>$lstofOfReceivedpayments");
      } catch (e) {
        print(e);
        // ScaffoldSnackbar.of(context).show(e.toString());
        isLoading = false;
      } finally {
        isLoading = false;
      }
    } else {
      ScaffoldSnackbar.of(context).show("Turn on the data and retry again");
      isLoading = false;
    }
    notifyListeners();
  }

  List<PaymentModel> lstOfPaidpayments = [];

  getListOfPaidpayments(BuildContext context) async {
    await checkConnection();
    if (isConnected == true) {
      isLoading = true;
      try {
        lstOfPaidpayments = await ApiProvider().getListOfPaidpayments();
        print("lstOfPaidpayments=====================>$lstOfPaidpayments");
      } catch (e) {
        print(e);
        isLoading = false;
      } finally {
        isLoading = false;
      }
    } else {
      ScaffoldSnackbar.of(context).show("Turn on the data and retry again");
      isLoading = false;
    }
    notifyListeners();
  }
}
