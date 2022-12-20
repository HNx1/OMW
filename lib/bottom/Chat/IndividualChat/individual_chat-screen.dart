import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:intl/intl.dart';
import 'package:omw/constant/constants.dart';
import 'package:omw/notifier/AllChatingFunctions.dart';
import 'package:omw/utils/colorUtils.dart';

import '../../../constant/theme.dart';
import '../../../utils/textUtils.dart';
import '../../Profile/profile_screen.dart';
import 'findFriends.dart';
import 'individual_chat_Room.dart';

class IndividualChatScreen extends StatefulWidget {
  const IndividualChatScreen({Key? key}) : super(key: key);

  @override
  State<IndividualChatScreen> createState() => _IndividualChatScreenState();
}

class _IndividualChatScreenState extends State<IndividualChatScreen> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _userStream;
  late CollectionReference<Map<String, dynamic>> conversationsCollection;
  late CollectionReference<Map<String, dynamic>> usersCollection;
  List<AllChat> chats = [];

  Future<void> updateChats(QuerySnapshot<Map<String, dynamic>> data) async {
    print("=========================>datadoc${data.docChanges}");
    if (data.docChanges.isEmpty) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
    for (DocumentChange<Map<String, dynamic>> doc in data.docChanges) {
      AllChat? chat =
          chats.firstWhereOrNull((e) => e.conversationId == doc.doc.id);
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
        chats.add(newChat);
        newChat.fetchMessages().then((value) {
          if (mounted) {
            setState(() {});
          }
        });
      }
      chats.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));
    }
  }

  @override
  void initState() {
    super.initState();
    conversationsCollection =
        FirebaseFirestore.instance.collection('conversations');
    usersCollection = FirebaseFirestore.instance.collection('users');
    initStream();
  }

  Future<void> initStream() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    _userStream = conversationsCollection
        .where("isGroup", isEqualTo: false)
        .where('members', arrayContainsAny: [userId]).snapshots();
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    _userStream.listen((data) {
      updateChats(data);
      print("====++++++====${data.docs.length}");
    });
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
                    ? Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : chats.isEmpty
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
                              padding: EdgeInsets.only(
                                bottom: height * 0.02,
                              ),
                              itemCount: chats.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                AllChat item = chats[index];
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                IndividualChatRoom(chat: item),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                item.UserProfile != null
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  ((context) =>
                                                                      ProfileScreen(
                                                                        conversationId:
                                                                            item.conversationId,
                                                                        fcmtoken:
                                                                            item.friendFCMToken!,
                                                                        userId:
                                                                            item.friendId,
                                                                        isOwnProfile:
                                                                            false,
                                                                        name: item
                                                                            .friendUsername!,
                                                                        profile:
                                                                            item.UserProfile!,
                                                                      )),
                                                            ),
                                                          );
                                                        },
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      height *
                                                                          0.1),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: item
                                                                .UserProfile!,
                                                            height:
                                                                height * 0.068,
                                                            width:
                                                                height * 0.068,
                                                            fit: BoxFit.cover,
                                                            placeholder: (context,
                                                                    url) =>
                                                                CircularProgressIndicator(
                                                              color:
                                                                  primaryColor,
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Icon(Icons
                                                                        .error),
                                                          ),
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
                                                                ? Icon(
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
                                                                            color: Color(
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
                                                              item
                                                                          .messages!
                                                                          .last
                                                                          .createdAt
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
                                                                      color: Color(
                                                                          0xff6C6C6C),
                                                                      height:
                                                                          1.4,
                                                                      fontSize:
                                                                          width *
                                                                              0.037),
                                                            ),
                                                          )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            chats.last == chats[index]
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
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: height * 0.02),
            child: FloatingActionButton(
              heroTag: "btn1",
              backgroundColor: primaryColor,
              child: Icon(
                Icons.add,
                size: width * 0.09,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        FindFriendPage(chats),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
