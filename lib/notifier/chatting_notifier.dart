import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../api/apiProvider.dart';
import '../model/block_User_Model.dart';
import '../model/groupMessage_model.dart';
import '../widget/scaffoldSnackbar.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ChattingNotifier extends ChangeNotifier {
  ValueNotifier<int>? notifier = ValueNotifier(0);
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

  Stream<QuerySnapshot> getChatStream(String eventId) {
    return FirebaseFirestore.instance
        .collection("events")
        .doc(eventId)
        .collection(eventId)
        .orderBy("createdAt")
        .snapshots();
  }

  Future<void> sendMessages(
    BuildContext context,
    String eventId,
    String newMessage,
    String imageUrl,
    String senderName,
    String senderProfile,
  ) async {
    try {
      await checkConnection();
      if (isConnected == true) {
        DocumentReference documentReference = FirebaseFirestore.instance
            .collection("events")
            .doc(eventId)
            .collection(eventId)
            .doc(DateTime.now().millisecondsSinceEpoch.toString());
        Timestamp now = Timestamp.now();
        GroupMessageModel groupMessageModel = GroupMessageModel(
          message: newMessage,
          senderName: senderName,
          senderProfile: senderProfile,
          imageUrl: imageUrl,
          createdAt: now.toDate(),
          eventId: eventId,
          authorId: _auth.currentUser!.uid,
        );

        FirebaseFirestore.instance.runTransaction((transaction) async {
          transaction.set(
            documentReference,
            groupMessageModel.toJson(),
          );
        });
      } else {
        ScaffoldSnackbar.of(context).show("Turn on the data and retry again");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> AddUserToBlock({
    required BuildContext context,
    required String blockTo,
    required String userName,
    required String userProfile,
    required String userphone,
  }) async {
    await checkConnection();

    if (isConnected == true) {
      try {
        isLoading = true;

        BlockUserModel blockUserModel = BlockUserModel(
            blockTo: blockTo,
            UserName: userName,
            UserPhone: userphone,
            UserProfile: userProfile);
        await ApiProvider().AddUserToBlock(blockUserModel);
        getBlockUserDetail(context, blockTo);
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

  BlockUserModel getblockUserModel = new BlockUserModel();
  bool isBlock = false;

  Future getBlockUserDetail(BuildContext context, String uid) async {
    await checkConnection();
    if (isConnected == true) {
      isLoading = true;

      try {
        getblockUserModel = await ApiProvider().getBlockUserDetail(uid);
        isBlock =
            getblockUserModel.blockTo == null || getblockUserModel.blockTo == ""
                ? false
                : true;
      } catch (e) {
        print(e);
        isLoading = false;
      } finally {
        isLoading = false;
      }
    } else {
      ScaffoldSnackbar.of(context).show("Turn on the data and retry again");
    }
    notifyListeners();
  }

  Future unBlockUser(
    BuildContext context,
    String docId,
  ) async {
    await checkConnection();
    if (isConnected == true) {
      isLoading = true;

      try {
        getblockUserModel = await ApiProvider().unBlockUser(docId);
      } catch (e) {
        print(e);
        isLoading = false;
      } finally {
        isLoading = false;
      }
    } else {
      ScaffoldSnackbar.of(context).show("Turn on the data and retry again");
    }
    notifyListeners();
  }

  BlockUserModel currentUserIsBlockOrNot = new BlockUserModel();

  Future checkThatCurrentUserBlcokOrNot(
      BuildContext context, String uid) async {
    await checkConnection();
    if (isConnected == true) {
      isLoading = true;

      try {
        currentUserIsBlockOrNot =
            await ApiProvider().checkThatCurrentUserBlcokOrNot(uid);
      } catch (e) {
        print(e);
        isLoading = false;
      } finally {
        isLoading = false;
      }
    } else {
      ScaffoldSnackbar.of(context).show("Turn on the data and retry again");
    }
    notifyListeners();
  }

  List<BlockUserModel> lstofAllBlockUser = [];
  List<BlockUserModel> searchList = [];
  getListOfBlockUsers(
    BuildContext context,
  ) async {
    await checkConnection();
    if (isConnected == true) {
      isLoading = true;
      try {
        lstofAllBlockUser = await ApiProvider().getListOfBlockUsers();
       
        print(
            "lstofAllEvents======================>${lstofAllBlockUser.length}");
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
