import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:intl/intl.dart';
import 'package:omw/constant/constants.dart';

import 'package:omw/utils/colorUtils.dart';

import '../../../constant/theme.dart';
import '../../../notifier/AllChatingFunctions.dart';
import '../../../utils/textUtils.dart';
import '../Group_Chat/Group_chatRoom.dart';
import '../IndividualChat/individual_chat_Room.dart';

class AllChatScreen extends StatefulWidget {
  const AllChatScreen({Key? key}) : super(key: key);

  @override
  State<AllChatScreen> createState() => _AllChatScreenState();
}

class _AllChatScreenState extends State<AllChatScreen> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _userStream;
  late CollectionReference<Map<String, dynamic>> conversationsCollection;
  late CollectionReference<Map<String, dynamic>> usersCollection;
  List<AllChat> allChats = [];

  Future<void> updateChats(QuerySnapshot<Map<String, dynamic>> data) async {
    print("=========================>datadoc${data.docChanges}");
    if (data.docChanges.isEmpty) {
      setState(() {
        isLoading = false;
      });
    }
    for (DocumentChange<Map<String, dynamic>> doc in data.docChanges) {
      AllChat? chat =
          allChats.firstWhereOrNull((e) => e.conversationId == doc.doc.id);
      Map<String, dynamic> data = doc.doc.data()!;
      if (chat != null) {
        chat.updatedAt = (data['updatedAt'] as Timestamp).toDate();

        chat.fetchMessages().then((value) {
          if (mounted) {
            setState(() {});
          }
        });
        print("====================>${chat.messages!.length}");
      } else {
        String friendId = (data['members'] as List)
            .firstWhere((e) => e != FirebaseAuth.instance.currentUser!.uid);
        AllChat newChat = AllChat(friendId,
            conversationId: doc.doc.id,
            updatedAt: (data['updatedAt'] as Timestamp).toDate());
        allChats.add(newChat);
        newChat.fetchMessages().then((value) {
          if (mounted) {
            setState(() {});
          }
        });
      }
      allChats.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));
    }
  }

  @override
  void initState() {
    super.initState();
    conversationsCollection =
        FirebaseFirestore.instance.collection('conversations');
    initStream();
  }

  Future<void> initStream() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    _userStream = conversationsCollection
        .where('members', arrayContainsAny: [userId]).snapshots();
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    _userStream.listen((data) async {
      await updateChats(data);
      print(data.docs.length);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            margin: EdgeInsets.only(
                left: width * 0.01, right: width * 0.01, top: height * 0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///---------- List OF chating's Data ------------
                isLoading == true
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : allChats.isEmpty
                        ? Container(
                            margin: EdgeInsets.only(
                                top: AppBar().preferredSize.height * 2),
                            child: Center(
                              child: Text(
                                TextUtils.noResultFound,
                                style: AppTheme.getTheme()
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      fontSize: width * 0.041,
                                      color: ConstColor.white_Color,
                                    ),
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.only(bottom: height * 0.02),
                              itemCount: allChats.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                AllChat item = allChats[index];
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (item.isgroup == true) {
                                          AllChat? allChat =
                                              allChats.firstWhereOrNull((e) =>
                                                  e.friendId ==
                                                  allChats[index].friendId);

                                          if (allChat != null) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => GropChatPage(
                                                  chat: item,
                                                  groupChats: allChats,
                                                ),
                                              ),
                                            );
                                          } else {
                                            allChat = AllChat(
                                                allChats[index].friendId,
                                                userPhone:
                                                    allChats[index].userPhone,
                                                UserProfile:
                                                    allChats[index].UserProfile,
                                                friendUsername: allChats[index]
                                                    .friendUsername,
                                                messages: []);

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => GropChatPage(
                                                  chat: item,
                                                  groupChats: allChats,
                                                ),
                                              ),
                                            );
                                          }
                                        } else if (item.isgroup == false) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  IndividualChatRoom(
                                                      chat: item),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                item.UserProfile != null
                                                    ? ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    height *
                                                                        0.1),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              item.UserProfile!,
                                                          height:
                                                              height * 0.068,
                                                          width: height * 0.068,
                                                          fit: BoxFit.cover,
                                                          placeholder: (context,
                                                                  url) =>
                                                              const CircularProgressIndicator(
                                                            color: primaryColor,
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Icon(Icons.error),
                                                        ),
                                                      )
                                                    : Container(),
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        left: width * 0.06),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        ///------------------name-------------
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom:
                                                                      height *
                                                                          0.005),
                                                          child: Text(
                                                            item.friendUsername !=
                                                                    null
                                                                ? item
                                                                    .friendUsername!
                                                                : "",
                                                            style: AppTheme
                                                                    .getTheme()
                                                                .textTheme
                                                                .bodyText2!
                                                                .copyWith(
                                                                    color: ConstColor
                                                                        .white_Color,
                                                                    height: 1.4,
                                                                    fontSize:
                                                                        width *
                                                                            0.043),
                                                          ),
                                                        ),

                                                        ///------------------message -------------
                                                        item.messages == null ||
                                                                item.messages!
                                                                    .isEmpty
                                                            ? Container()
                                                            : item.messages!.last
                                                                        .imageUrl !=
                                                                    ""
                                                                ? const Icon(
                                                                    Icons.image,
                                                                    color: Colors
                                                                        .grey,
                                                                  )
                                                                : Text(
                                                                    item
                                                                        .messages!
                                                                        .last
                                                                        .message,
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: AppTheme
                                                                            .getTheme()
                                                                        .textTheme
                                                                        .bodyText1!
                                                                        .copyWith(
                                                                            color: const Color(
                                                                                0xff6C6C6C),
                                                                            height:
                                                                                1.4,
                                                                            fontSize:
                                                                                width * 0.037),
                                                                  )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    ///------------- unreaded message------------------------
                                                    item.unreadMessagesCount > 0
                                                        ? CircleAvatar(
                                                            radius:
                                                                height * 0.018,
                                                            backgroundColor:
                                                                primaryColor,
                                                            child: Text(
                                                              item.unreadMessagesCount
                                                                  .toString(),
                                                              style: AppTheme.getTheme()
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                      color: ConstColor
                                                                          .black_Color,
                                                                      height:
                                                                          1.4,
                                                                      fontSize:
                                                                          width *
                                                                              0.037),
                                                            ))
                                                        : CircleAvatar(
                                                            radius:
                                                                height * 0.02,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                          ),

                                                    ///------------------- time--------------
                                                    item.messages == null ||
                                                            item.messages!
                                                                .isEmpty
                                                        ? Container()
                                                        : Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                              top:
                                                                  height * 0.01,
                                                              right:
                                                                  width * 0.01,
                                                            ),
                                                            child: Text(
                                                              item.messages!
                                                                          .isEmpty ||
                                                                      item.messages ==
                                                                          null
                                                                  ? ""
                                                                  : item.messages!.last.createdAt
                                                                              .day ==
                                                                          DateTime.now()
                                                                              .day
                                                                      ? DateFormat(
                                                                              'h:mm aa')
                                                                          .format(item
                                                                              .messages!
                                                                              .last
                                                                              .createdAt)
                                                                          .toLowerCase()
                                                                      : DateFormat(
                                                                              'dd/M/yyyy')
                                                                          .format(item
                                                                              .messages!
                                                                              .last
                                                                              .createdAt)
                                                                          .toLowerCase(),
                                                              style: AppTheme
                                                                      .getTheme()
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                      color: const Color(
                                                                          0xff6C6C6C),
                                                                      height:
                                                                          1.4,
                                                                      fontSize:
                                                                          width *
                                                                              0.037),
                                                            ),
                                                          )
                                                  ],
                                                )
                                              ],
                                            ),
                                            allChats.last == allChats[index]
                                                ? Container()
                                                : Container(
                                                    margin: EdgeInsets.only(
                                                        top: height * 0.022,
                                                        bottom: height * 0.022),
                                                    height: 1,
                                                    width: width,
                                                    color: ConstColor
                                                        .term_condition_grey_color
                                                        .withOpacity(0.6),
                                                  )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
