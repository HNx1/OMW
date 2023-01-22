import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:omw/model/notification_model.dart';

import '../api/apiProvider.dart';
import '../model/user_model.dart';
import '../widget/scaffoldSnackbar.dart';

class NotificationNotifier extends ChangeNotifier {
  bool isLoading = false;
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

  bool ismessageSend = false;

  isismessageSend(val) {
    ismessageSend = val;
    notifyListeners();
  }

  bool isConnected = false;
  Future<void> pushNotification(
      {required BuildContext context,
      required String? title,
      required String? description,
      required String? userId,
      required String? type,
      required List typeOfData}) async {
    await checkConnection();
    if (isConnected == true) {
      try {
        isLoading = true;

        await ApiProvider().checkConnection();

        NotificationModel notificationModel = NotificationModel(
            title: title,
            description: description,
            time: DateTime.now().toUtc(),
            userId: userId,
            type: type,
            typeOfData: typeOfData);
        await ApiProvider().pushNotification(notificationModel);
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

  sendPushNotification(
    BuildContext context,
    String token,
    String title,
    String body,
    String type,
    String conversationId,
    String eventId,
    String eventHostUserId,
  ) async {
    await checkConnection();
    if (isConnected == true) {
      try {
        isLoading = true;

        await ApiProvider().sendPushNotification(
            token, title, body, type, conversationId, eventId, eventHostUserId);
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
  }

  List<NotificationModel> lstNotificationModel = [];
  List<NotificationModel> loadedNotification = [];

  Future getListOfAllNotifications(
    BuildContext context,
  ) async {
    await checkConnection();

    if (isConnected == true) {
      try {
        isLoading = true;
        loadedNotification =
            await ApiProvider().getListOfAllNotification().then((value) async {
          for (var i = 0; i < value.length; i++) {
            try {
              QuerySnapshot result = await FirebaseFirestore.instance
                  .collection('users')
                  .where("uid", isEqualTo: value[i].createdBy)
                  .get();
              if (result.docs.isNotEmpty) {
                for (var docData in result.docs) {
                  value[i].userDetails = UserModel.parseSnapshot(docData);
                }
              }
            } catch (e) {
              print(e);
            }
          }

          return value;
        });
        loadedNotification.sort((b, a) => a.createdAt!.compareTo(b.createdAt!));
        if (loadedNotification.isNotEmpty) {
          lstNotificationModel.addAll(loadedNotification);
        }

        print("=====================>abc:-${lstNotificationModel.length}");
        print(
            "=====================>lstNotificationModel:-$loadedNotification");
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

  List<NotificationModel> lstHostingNotificationModel = [];

  Future getListOfHostingNotifications(
    BuildContext context,
  ) async {
    await checkConnection();

    if (isConnected == true) {
      try {
        isLoading = true;
        loadedNotification = await ApiProvider()
            .getListOfHostingAllNotification()
            .then((value) async {
          for (var i = 0; i < value.length; i++) {
            try {
              QuerySnapshot result = await FirebaseFirestore.instance
                  .collection('users')
                  .where("uid", isEqualTo: value[i].createdBy)
                  .get();
              if (result.docs.isNotEmpty) {
                for (var docData in result.docs) {
                  value[i].userDetails = UserModel.parseSnapshot(docData);
                }
              }
            } catch (e) {
              print(e);
            }
          }

          return value;
        });
        loadedNotification.sort((b, a) => a.createdAt!.compareTo(b.createdAt!));
        if (loadedNotification.isNotEmpty) {
          lstHostingNotificationModel.addAll(loadedNotification);
        }

        print(
            "=====================>abc:-${lstHostingNotificationModel.length}");
        print(
            "=====================>lstHostingNotificationModel:-$loadedNotification");
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

  List<NotificationModel> lstInvitationsNotificationModel = [];

  Future getListOfInvitationsNotifications(
    BuildContext context,
  ) async {
    await checkConnection();

    if (isConnected == true) {
      try {
        isLoading = true;
        loadedNotification = await ApiProvider()
            .getInvitationsNotification()
            .then((value) async {
          for (var i = 0; i < value.length; i++) {
            try {
              QuerySnapshot result = await FirebaseFirestore.instance
                  .collection('users')
                  .where("uid", isEqualTo: value[i].createdBy)
                  .get();
              if (result.docs.isNotEmpty) {
                for (var docData in result.docs) {
                  value[i].userDetails = UserModel.parseSnapshot(docData);
                }
              }
            } catch (e) {
              print(e);
            }
          }

          return value;
        });
        loadedNotification.sort((b, a) => a.createdAt!.compareTo(b.createdAt!));
        if (loadedNotification.isNotEmpty) {
          lstInvitationsNotificationModel.addAll(loadedNotification);
        }

        print(
            "=====================>abc:-${lstInvitationsNotificationModel.length}");
        print(
            "=====================>lstInvitationsNotificationModel:-$loadedNotification");
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
