import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:omw/model/groupModel.dart';
import 'package:omw/model/user_model.dart';

import '../model/chatMessage_model.dart';

User user = FirebaseAuth.instance.currentUser!;
bool isLoading = true;
String id = "";

class AllChat {
  String? conversationId;
  String friendId;
  String? friendUsername;
  String? userPhone;

  String? UserProfile;
  DateTime? updatedAt;
  String? friendFCMToken;
  List<Message>? messages;
  ValueNotifier<int> notifier = ValueNotifier(0);
  bool isOpen = false;
  List? Member;
  bool? isgroup;

  AllChat(
    this.friendId, {
    this.conversationId,
    this.updatedAt,
    this.friendUsername,
    this.userPhone,
    this.messages,
    this.UserProfile,
    this.friendFCMToken,
    this.isgroup,
  });

  int get unreadMessagesCount {
    return messages
            ?.where((e) => e.authorId != user.uid && e.readAt == null)
            .length ??
        0;
  }

  UserModel objUsers = new UserModel();
  getUserData() async {
    try {
      isLoading = true;
      QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where("uid", isEqualTo: friendId)
          .get();
      if (result.docs.length > 0) {
        for (var docData in result.docs) {
          objUsers = UserModel.parseSnapshot(docData);
          friendUsername = objUsers.firstName! + " " + objUsers.lastName!;
          UserProfile = objUsers.userProfile!;
          friendFCMToken = objUsers.fcmToken!;
          userPhone = objUsers.phoneNumber!;
          isgroup = false;
        }
      }
    } catch (e) {
      isLoading = false;
      print(e);
    } finally {
      isLoading = false;
    }
    try {
      isLoading = true;
      QuerySnapshot result = await FirebaseFirestore.instance
          .collection('groups')
          .where("docID", isEqualTo: conversationId)
          .get();
      if (result.docs.length > 0) {
        for (var docData in result.docs) {
          GroupModel objGroupModel = GroupModel.parseSnapshot(docData);
          friendUsername = objGroupModel.groupName;
          UserProfile = objGroupModel.gropuProfile;
          Member = objGroupModel.groupUser!;
          isgroup = true;
        }
      }
    } catch (e) {
      isLoading = false;
      print(e);
    } finally {
      isLoading = false;
    }
  }

  Future fetchMessages() async {
    CollectionReference<Map<String, dynamic>> collection =
        FirebaseFirestore.instance.collection('messages');
    late QuerySnapshot<Map<String, dynamic>> result;
    if (messages == null) {
      isLoading = true;
      result = await collection
          .where('conversationId', isEqualTo: conversationId)
          .get()
          .then((value) async {
        await getUserData();
        return value;
      });
      messages = result.docs.map((e) {
        Map data = e.data();
        return Message(
          id: e.id,
          message: data['message'],
          authorId: e['authorId'],
          createdAt: (e['createdAt'] as Timestamp).toDate(),
          readAt: (e['readAt'] as Timestamp?)?.toDate(),
          imageUrl: data['imageUrl'],
          isGroup: data['isGroup'],
          senderName: data['senderName'],
          senderProfile: data['senderProfile'],
          isBlock: data['isBlock'],
        );
      }).toList();

      messages!.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      isLoading = false;
    } else {
      isLoading = true;
      List<Message> toReadMessages =
          messages!.where((e) => e.fromMe && e.readAt == null).toList();
      if (toReadMessages.isNotEmpty) {
        result = await collection
            .where('conversationId', isEqualTo: conversationId)
            .where(FieldPath.documentId,
                whereIn: toReadMessages.map((e) => e.id).toList())
            .get()
            .then((value) async {
          await getUserData();
          return value;
        });
      } else {
        result = await collection
            .where('conversationId', isEqualTo: conversationId)
            .where('readAt', isNull: true)
            .get()
            .then((value) async {
          await getUserData();
          return value;
        });
      }

      result = await collection
          .where('conversationId', isEqualTo: conversationId)
          .get();
      messages = result.docs.map((e) {
        Map data = e.data();
        return Message(
          id: e.id,
          message: data['message'],
          authorId: e['authorId'],
          createdAt: (e['createdAt'] as Timestamp).toDate(),
          readAt: (e['readAt'] as Timestamp?)?.toDate(),
          imageUrl: data['imageUrl'],
          isGroup: data['isGroup'],
          senderName: data['senderName'],
          senderProfile: data['senderProfile'],
          isBlock: data['isBlock'],
        );
      }).toList();

      messages!.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      isLoading = false;
    }

    print(
        "===========> messs ${messages!.map((e) => '${e.message} | ${e.readAt == null}')}");
    if (isOpen) markAsRead();
    notifier.value = DateTime.now().millisecondsSinceEpoch;
  }

  Future sendMessage(
    String newMessage,
    bool isgroup,
    String imageUrl,
    List member,
    String senderName,
    String senderProfile,
    bool isBlock,
  ) async {
    Timestamp now = Timestamp.now();

    if (conversationId == null) {
      DocumentReference<Map<String, dynamic>> doc =
          await FirebaseFirestore.instance.collection('conversations').add({
        'members': member,
        'updatedAt': Timestamp.now(),
        "isGroup": isgroup
      });
      conversationId = doc.id;
    }
    DocumentReference<Map<String, dynamic>> doc =
        await FirebaseFirestore.instance.collection('messages').add({
      'message': newMessage,
      'authorId': user.uid,
      'createdAt': now,
      'readAt': null,
      'conversationId': conversationId,
      "imageUrl": imageUrl,
      "isGroup": isgroup,
      "senderName": senderName,
      "senderProfile": senderProfile,
      "isBlock": isBlock,
    });
    messages!.add(Message(
        id: doc.id,
        authorId: user.uid,
        message: newMessage,
        createdAt: now.toDate(),
        readAt: null,
        imageUrl: imageUrl,
        isBlock: isBlock,
        isGroup: isgroup,
        senderName: senderName,
        senderProfile: senderProfile));
    // doc.id, newMessage, user.uid, now.toDate(), null,
    //     imageUrl, isgroup, senderName, senderProfile, isBlock

    await conversationUpdated();
  }

  Future<void> markAsRead() async {
    if (unreadMessagesCount > 0) {
      CollectionReference<Map<String, dynamic>> collection =
          FirebaseFirestore.instance.collection('messages');
      Timestamp now = Timestamp.now();
      WriteBatch batch = FirebaseFirestore.instance.batch();
      QuerySnapshot<Map<String, dynamic>> snapshot = await collection
          .where('conversationId', isEqualTo: conversationId)
          .where('authorId', isNotEqualTo: user.uid)
          .where('readAt', isNull: true)
          .get();

      snapshot.docs.forEach((document) {
        batch.update(document.reference, {'readAt': now});
      });

      await batch.commit();
      await conversationUpdated();

      messages!.forEach((element) {
        element.readAt ??= now.toDate();
      });
    }
  }

  Future<void> conversationUpdated() async {
    await FirebaseFirestore.instance
        .collection('conversations')
        .doc(conversationId)
        .update({'updatedAt': Timestamp.now()});
  }

  Future<void> deleteMessage(String messageId) async {
    try {
      await FirebaseFirestore.instance
          .collection('messages')
          .doc(messageId)
          .delete();
      messages!.removeWhere((element) => element.id == messageId);
    } catch (e) {
      print(e);
    }
  }

  Future<void> leaveGroup(String groupId) async {
    try {
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .update({
        "groupUser": FieldValue.arrayRemove([user.uid])
      });

      FirebaseFirestore.instance
          .collection('conversations')
          .doc(conversationId)
          .update({
        "members": FieldValue.arrayRemove([user.uid])
      });

      await conversationUpdated();
    } catch (e) {
      print(e);
    }
  }
}
