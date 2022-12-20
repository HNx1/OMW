import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import 'package:intl/intl.dart';
import 'package:omw/api/apiProvider.dart';
import 'package:omw/constant/constants.dart';
import 'package:omw/notifier/AllChatingFunctions.dart';
import 'package:omw/model/user_model.dart';
import 'package:omw/utils/colorUtils.dart';
import 'package:provider/provider.dart';

import '../../../constant/theme.dart';
import '../../../utils/textUtils.dart';
import '../../notifier/event_notifier.dart';
import '../../preference/preference.dart';
import '../../notifier/group_notifier.dart';
import '../../widget/commonButton.dart';
import '../Chat/IndividualChat/individual_chat_Room.dart';
import '../../widget/commonOutLineButton.dart';
import '../Events/event/eventDetails_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  final String name;
  final String profile;
  final bool isOwnProfile;
  final String fcmtoken;
  final String? conversationId;
  const ProfileScreen(
      {Key? key,
      required this.userId,
      required this.name,
      required this.profile,
      required this.isOwnProfile,
      required this.fcmtoken,
      this.conversationId})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _userStream;
  late CollectionReference<Map<String, dynamic>> conversationsCollection;
  late CollectionReference<Map<String, dynamic>> usersCollection;
  List<AllChat> chats = [];
  AllChat? chat = AllChat("");
  Future<void> updateChats(QuerySnapshot<Map<String, dynamic>> data) async {
    print("=========================>datadoc${data.docChanges}");
    if (data.docChanges.isEmpty) {
      if (mounted) {
        setState(() {
          isLoading2 = false;
        });
      }
    }
    for (DocumentChange<Map<String, dynamic>> doc in data.docChanges) {
      chat = chats.firstWhereOrNull((e) => e.conversationId == doc.doc.id);
      if (mounted) {
        setState(() {
          conversationId = doc.doc.id;
        });
      }
      print("conversationId=========>${doc.doc.id}");

      Map<String, dynamic> data = doc.doc.data()!;
      if (chat != null) {
        chat!.updatedAt = (data['updatedAt'] as Timestamp).toDate();

        chat!.fetchMessages().then((value) {
          if (mounted) {
            setState(() {});
          }
        });
        print("====================>${chat!.messages!.length}");
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

  String conversationId = "";
  @override
  void initState() {
    setState(() {
      isLoading1 = true;
      isLoading2 = true;
    });

    getUserName();
    getAllContactList();
    super.initState();
    conversationsCollection =
        FirebaseFirestore.instance.collection('conversations');

    initStream();
  }

  getUserName() async {
    currentuser = await PrefServices().getCurrentUserName();
    var objCreateEventNotifier =
        Provider.of<CreateEventNotifier>(context, listen: false);
    if (mounted) {
      objCreateEventNotifier.isLoading = true;
    }
    await objCreateEventNotifier.getListOfProfilePastEvent(
        context, widget.userId);
    objCreateEventNotifier.isLoading = false;
  }

  getAllContactList() async {
    print('getAllContacts running');
    var objGroupNotifier = Provider.of<GroupNotifier>(context, listen: false);

    await objGroupNotifier.getData(context, "");

    var contacts = objGroupNotifier.selectedUserList;
    List cIds = [for (var i in contacts) i.uid];
    print('contacts: ${cIds}');
    setState(() {
      contactIds = cIds;
    });

    var data = await ApiProvider().getUserDetail(widget.userId);
    var pId = data.uid;
    print('currentProfile: ${pId}');
    setState(() {
      profile = data;
    });
    setState(() {
      isLoading1 = false;
    });
  }

  UserModel profile = new UserModel();
  List contactIds = [];
  bool isLoading1 = true;
  bool isLoading2 = true;

  void addContact(UserModel contact) async {
    final newContact = Contact()
      ..name.first = contact.firstName ?? ""
      ..name.last = contact.lastName ?? ""
      ..phones = [Phone(contact.phoneNumber!)];
    await newContact.insert();
    print('new contact added');
    getAllContactList();
  }

  String currentuser = "";
  bool isread = false;
  int maxline = 4;
  double ratio = width / height;
  List<AllChat> allChat = [];
  Future<void> initStream() async {
    _userStream = conversationsCollection
        .where("isGroup", isEqualTo: false)
        .where('members', arrayContainsAny: [widget.userId]).snapshots();
    if (mounted) {
      setState(() {
        isLoading2 = true;
      });
    }
    _userStream.listen((data) {
      updateChats(data);
      print(data.docs.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    final objCreateEventNotifier = context.watch<CreateEventNotifier>();
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
          left: width * 0.03,
          right: width * 0.03,
        ),
        child: Column(
          children: [
            AppBar(
              elevation: 0,
              backgroundColor: AppTheme.getTheme().backgroundColor,
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: ConstColor.primaryColor,
                  size: width * 0.06,
                ),
              ),
              leadingWidth: height * 0.034,
              title: Text(
                TextUtils.Omw,
                style: AppTheme.getTheme().textTheme.subtitle1!.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: width * 0.09,
                    ),
              ),
              centerTitle: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    EdgeInsets.only(top: height * 0.027, bottom: height * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //----------------image of profile-----------------

                        ClipRRect(
                          borderRadius: BorderRadius.circular(height * 0.006),
                          child: CachedNetworkImage(
                            imageUrl: widget.profile,
                            height: height * 0.1,
                            width: height * 0.1,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(
                              color: primaryColor,
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),

                        ///-----------------Name text---------------
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                left: width * 0.04, right: width * 0.02),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ///---------------- Name  ---------------
                                Text(
                                  toBeginningOfSentenceCase(widget.name)
                                      .toString(),
                                  style: AppTheme.getTheme()
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(
                                          decoration: TextDecoration.none,
                                          color: ConstColor.white_Color,
                                          fontSize: width * 0.046),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    ///----------------- message Button   --------------
                    widget.isOwnProfile == true
                        ? Container()
                        : isLoading1 == true || isLoading2 == true
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: CircularProgressIndicator(
                                    color: secondaryColor,
                                  ),
                                ),
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: GestureDetector(
                                        onTap: () {
                                          AllChat? chat =
                                              chats.firstWhereOrNull((e) =>
                                                  e.friendId == conversationId);

                                          if (conversationId != null &&
                                              conversationId != "") {
                                            chat = chats.firstWhereOrNull((e) =>
                                                e.conversationId ==
                                                conversationId);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        IndividualChatRoom(
                                                          chat: chat!,
                                                        )));
                                          } else {
                                            chat = AllChat(
                                              widget.userId,
                                              friendFCMToken: widget.fcmtoken,
                                              UserProfile: widget.profile,
                                              friendUsername: widget.name,
                                              // userPhone: widget.ph,
                                              isgroup: false,
                                              messages: [],
                                            );
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        IndividualChatRoom(
                                                            chat: chat!)));
                                          }
                                        },
                                        child: CommonOutLineButton(
                                          name: TextUtils.Message,
                                        ),
                                      ),
                                    ),
                                  ),
                                  contactIds.contains(profile.uid)
                                      ? SizedBox.shrink()
                                      : Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: GestureDetector(
                                                onTap: () =>
                                                    addContact(profile),
                                                child:
                                                    CommonButton(name: 'Add')),
                                          ),
                                        )
                                ],
                              ),

                    ///---------------- Events we both text---------------
                    Container(
                      margin: EdgeInsets.only(top: height * 0.03),
                      child: Text(
                        //TextUtils.myPastEvent,
                        widget.isOwnProfile == true
                            ? TextUtils.myPastEvent
                            : TextUtils.Eventswe,
                        style: AppTheme.getTheme()
                            .textTheme
                            .bodyText2!
                            .copyWith(
                                decoration: TextDecoration.none,
                                color: ConstColor.white_Color,
                                fontSize: width * 0.058),
                      ),
                    ),

                    ///-------------------------- List Of Events-------------
                    objCreateEventNotifier.isLoading == true &&
                            objCreateEventNotifier.getMyPastEventList.isEmpty
                        ? Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : objCreateEventNotifier.getMyPastEventList.isEmpty
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
                            : ListView.builder(
                                padding: EdgeInsets.only(bottom: height * 0.04),
                                itemCount: objCreateEventNotifier
                                    .getMyPastEventList.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        objCreateEventNotifier.setEventData =
                                            objCreateEventNotifier
                                                .getMyPastEventList[index];
                                      });
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation1,
                                                  animation2) =>
                                              EventDetailsScreen(
                                            eventId: objCreateEventNotifier
                                                .getMyPastEventList[index]
                                                .docId!,
                                            hostId: objCreateEventNotifier
                                                .getMyPastEventList[index]
                                                .lstUser!
                                                .uid!,
                                            isPastEvent: false,
                                            isFromMyeventScreen: true,
                                            ismyPastEvent: true,
                                          ),
                                          transitionDuration: Duration.zero,
                                          reverseTransitionDuration:
                                              Duration.zero,
                                        ),
                                      ).whenComplete(() async {
                                        setState(() {});
                                        await getUserName();
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        top: height * 0.02,
                                        left: width * 0.03,
                                        right: width * 0.03,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            height * 0.015),
                                                    border: Border.all(
                                                        width: 2,
                                                        color: Color.fromARGB(
                                                            255, 58, 51, 51))),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            height * 0.015),
                                                    child: CachedNetworkImage(
                                                        imageUrl:
                                                            objCreateEventNotifier
                                                                .getMyPastEventList[
                                                                    index]
                                                                .eventPhoto!,
                                                        height: height * 0.18,
                                                        width: height * 0.18,
                                                        fit: BoxFit.cover,
                                                        placeholder:
                                                            (context, url) =>
                                                                Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    CircularProgressIndicator(
                                                                      color:
                                                                          primaryColor,
                                                                    ),
                                                                  ],
                                                                ))),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                    top: height * 0.01,
                                                    left: width * 0.03,
                                                    right: width * 0.02,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      ///------------- event name------------------
                                                      Text(
                                                        objCreateEventNotifier
                                                            .getMyPastEventList[
                                                                index]
                                                            .eventname!,
                                                        style: AppTheme
                                                                .getTheme()
                                                            .textTheme
                                                            .bodyText2!
                                                            .copyWith(
                                                                fontSize:
                                                                    width *
                                                                        0.048,
                                                                color: ConstColor
                                                                    .white_Color),
                                                      ),

                                                      ///-------------- image and  create by --------------
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: height * 0.01),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        height *
                                                                            0.1),
                                                                child:
                                                                    CachedNetworkImage(
                                                                        imageUrl: objCreateEventNotifier
                                                                            .getMyPastEventList[
                                                                                index]
                                                                            .lstUser!
                                                                            .userProfile!,
                                                                        height: height *
                                                                            0.05,
                                                                        width: height *
                                                                            0.05,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        placeholder: (context,
                                                                                url) =>
                                                                            CircularProgressIndicator(
                                                                              color: primaryColor,
                                                                            ))),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: width *
                                                                          0.02),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "Hosted by",
                                                                    style: AppTheme
                                                                            .getTheme()
                                                                        .textTheme
                                                                        .bodyText1!
                                                                        .copyWith(
                                                                            fontSize: width *
                                                                                0.032,
                                                                            color:
                                                                                ConstColor.white_Color.withOpacity(0.37)),
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets.only(
                                                                        top: height *
                                                                            0.005),
                                                                    child: Text(
                                                                      objCreateEventNotifier
                                                                              .getMyPastEventList[
                                                                                  index]
                                                                              .lstUser!
                                                                              .firstName! +
                                                                          " " +
                                                                          objCreateEventNotifier
                                                                              .getMyPastEventList[index]
                                                                              .lstUser!
                                                                              .lastName!,
                                                                      style: AppTheme
                                                                              .getTheme()
                                                                          .textTheme
                                                                          .bodyText1!
                                                                          .copyWith(
                                                                              fontSize: width * 0.043,
                                                                              color: ConstColor.white_Color),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      ///------------------------- event time-----------------
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                            ConstantData.watch2,
                                                            height:
                                                                height * 0.023,
                                                            color: ConstColor
                                                                .white_Color,
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: width *
                                                                          0.02,
                                                                      left: width *
                                                                          0.02),
                                                              child: Text(
                                                                '${DateFormat('EEE, MMM dd, h:mm aa -').format(objCreateEventNotifier.getMyPastEventList[index].eventStartDate!)[0].toUpperCase()}${(DateFormat('EEE, MMM dd, h:mm aa -').format(objCreateEventNotifier.getMyPastEventList[index].eventStartDate!).substring(1)).toLowerCase()}' +
                                                                    DateFormat(
                                                                            ' h:mm aa')
                                                                        .format(objCreateEventNotifier
                                                                            .getMyPastEventList[index]
                                                                            .eventEndDate!)
                                                                        .toLowerCase(),
                                                                style: AppTheme
                                                                        .getTheme()
                                                                    .textTheme
                                                                    .bodyText1!
                                                                    .copyWith(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .none,
                                                                        color: ConstColor
                                                                            .white_Color,
                                                                        fontSize:
                                                                            width *
                                                                                0.036),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),

                                                      ///------------------------- event location--------------------
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: height * 0.01),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Image.asset(
                                                              ConstantData
                                                                  .location2,
                                                              height: height *
                                                                  0.023,
                                                              color: ConstColor
                                                                  .white_Color,
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                margin: EdgeInsets.only(
                                                                    left: width *
                                                                        0.02),
                                                                child: Text(
                                                                  objCreateEventNotifier
                                                                      .getMyPastEventList[
                                                                          index]
                                                                      .location!,
                                                                  maxLines: 2,
                                                                  style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                                                                      height:
                                                                          1.2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      decoration:
                                                                          TextDecoration
                                                                              .none,
                                                                      color: ConstColor
                                                                          .white_Color,
                                                                      fontSize:
                                                                          width *
                                                                              0.036),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          objCreateEventNotifier
                                                      .getMyPastEventList
                                                      .last !=
                                                  objCreateEventNotifier
                                                      .getMyPastEventList[index]
                                              ? Container(
                                                  margin: EdgeInsets.only(
                                                      top: height * 0.02,
                                                      bottom: height * 0.005),
                                                  height: 1,
                                                  width: width,
                                                  color: Colors.white
                                                      .withOpacity(0.3),
                                                )
                                              : Container()
                                        ],
                                      ),
                                    ),
                                  );

                                  // GestureDetector(
                                  //   onTap: () {
                                  //     setState(() {

                                  //       objProviderNotifier.setevenImage =
                                  //           objCreateEventNotifier
                                  //               .getMyPastEventList[index].eventPhoto!;
                                  //       objProviderNotifier.seteventName =
                                  //           objCreateEventNotifier
                                  //               .getMyPastEventList[index].eventname!;
                                  //       objProviderNotifier.seteventUserProfile =
                                  //           objCreateEventNotifier.getMyPastEventList[index]
                                  //               .lstUser!.userProfile!;
                                  //       objProviderNotifier.seteventCreateBy =
                                  //           objCreateEventNotifier.getMyPastEventList[index]
                                  //                   .lstUser!.firstName! +
                                  //               " " +
                                  //               objCreateEventNotifier
                                  //                   .getMyPastEventList[index]
                                  //                   .lstUser!
                                  //                   .lastName!;
                                  //       objProviderNotifier.seteventDescription =
                                  //           objCreateEventNotifier
                                  //               .getMyPastEventList[index].description!;
                                  //       objProviderNotifier.seteventLocation =
                                  //           objCreateEventNotifier
                                  //               .getMyPastEventList[index].location!;
                                  //       objProviderNotifier.seteventDayTime =
                                  //           '${DateFormat('EEE, MMM dd, hh:mm aa -').format(objCreateEventNotifier.getMyPastEventList[index].eventStartDate!)[0].toUpperCase()}${(DateFormat('EEE, MMM dd, hh:mm aa -').format(objCreateEventNotifier.getMyPastEventList[index].eventStartDate!).substring(1)).toLowerCase()}' +
                                  //               DateFormat(' hh:mm aa')
                                  //                   .format(objCreateEventNotifier
                                  //                       .getMyPastEventList[index]
                                  //                       .eventEndDate!)
                                  //                   .toLowerCase();
                                  //     });
                                  //      Navigator.push(
                                  //         context,
                                  //         MaterialPageRoute(
                                  //           builder: (contex) => EventDetailsScreen(
                                  //             getEventListData: objCreateEventNotifier
                                  //                 .getMyPastEventList[index],
                                  //             isPastEvent: false,
                                  //             isFromMyeventScreen: true,
                                  //             ismyPastEvent: true,
                                  //           ),
                                  //         ),
                                  //       );

                                  //   },
                                  //   child: Container(
                                  //     decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.circular(height * 0.02),
                                  //       border: Border.all(
                                  //         color:  ConstColor.textFormFieldColor,
                                  //       ),
                                  //     ),
                                  //     margin: EdgeInsets.only(top: height * 0.02),
                                  //     child: Column(
                                  //       children: [
                                  //         Container(
                                  //           decoration: BoxDecoration(),
                                  //           child: Stack(
                                  //             alignment: Alignment.bottomCenter,
                                  //             children: [
                                  //               Stack(
                                  //                 alignment: Alignment.bottomLeft,
                                  //                 children: [
                                  //                   //--------------------event image  ------------
                                  //                   ClipRRect(
                                  //                       borderRadius: BorderRadius.only(
                                  //                         topLeft:
                                  //                             Radius.circular(height * 0.02),
                                  //                         topRight:
                                  //                             Radius.circular(height * 0.02),
                                  //                       ),
                                  //                       child: CachedNetworkImage(
                                  //                         imageUrl: objCreateEventNotifier
                                  //                             .getMyPastEventList[index]
                                  //                             .eventPhoto!,
                                  //                         height: height * 0.16,
                                  //                         width: width,
                                  //                         fit: BoxFit.cover,
                                  //                         placeholder: (context, url) =>
                                  //                             Column(
                                  //                           mainAxisAlignment:
                                  //                               MainAxisAlignment.center,
                                  //                           crossAxisAlignment:
                                  //                               CrossAxisAlignment.center,
                                  //                           children: [
                                  //                             CircularProgressIndicator(
                                  //                               color: primaryColor,
                                  //                             ),
                                  //                           ],
                                  //                         ),
                                  //                         errorWidget:
                                  //                             (context, url, error) =>
                                  //                                 Icon(Icons.error),
                                  //                       )),

                                  //                   ///------------ name-------------
                                  //                   Container(
                                  //                     padding: EdgeInsets.only(
                                  //                         left: width * 0.04,
                                  //                         bottom: height * 0.02),
                                  //                     child: Text(
                                  //                       objCreateEventNotifier
                                  //                           .getMyPastEventList[index]
                                  //                           .eventname!,
                                  //                       style: AppTheme.getTheme()
                                  //                           .textTheme
                                  //                           .bodyText2!
                                  //                           .copyWith(
                                  //                               decoration:
                                  //                                   TextDecoration.none,
                                  //                               color: ConstColor.white_Color,
                                  //                               fontSize: width * 0.048),
                                  //                     ),
                                  //                   ),
                                  //                 ],
                                  //               ),

                                  //               ///------------- shadow--------------
                                  //               Container(
                                  //                 decoration: BoxDecoration(
                                  //                   color: ConstColor.black_Color,
                                  //                   boxShadow: [
                                  //                     BoxShadow(
                                  //                       blurRadius: 20,
                                  //                       spreadRadius: 15,
                                  //                       color: ConstColor.black_Color
                                  //                           .withOpacity(0.4),
                                  //                     )
                                  //                   ],
                                  //                 ),
                                  //               )
                                  //             ],
                                  //           ),
                                  //         ),
                                  //         Container(
                                  //           margin: EdgeInsets.zero,
                                  //           padding: EdgeInsets.fromLTRB(width * 0.04,
                                  //               height * 0.015, width * 0.04, height * 0.02),
                                  //           decoration: BoxDecoration(
                                  //             color: Color(0xff131313),
                                  //             border: Border.all(
                                  //               color:Colors.transparent,
                                  //             ),
                                  //             borderRadius: BorderRadius.only(
                                  //               bottomLeft: Radius.circular(height * 0.019),
                                  //               bottomRight: Radius.circular(height * 0.019),
                                  //             ),
                                  //           ),
                                  //           width: width,
                                  //           child: Column(
                                  //             crossAxisAlignment: CrossAxisAlignment.start,
                                  //             children: [
                                  //               Row(
                                  //                 mainAxisAlignment: MainAxisAlignment.start,
                                  //                 children: [
                                  //                   /// --------------------- profile image---------------
                                  //                   ClipRRect(
                                  //                       borderRadius: BorderRadius.circular(
                                  //                           height * 0.1),
                                  //                       child: CachedNetworkImage(
                                  //                         imageUrl: objCreateEventNotifier
                                  //                             .getMyPastEventList[index]
                                  //                             .lstUser!
                                  //                             .userProfile!,
                                  //                         height: height * 0.045,
                                  //                         width: height * 0.045,
                                  //                         fit: BoxFit.cover,
                                  //                         placeholder: (context, url) =>
                                  //                             CircularProgressIndicator(
                                  //                           color: primaryColor,
                                  //                         ),
                                  //                         errorWidget:
                                  //                             (context, url, error) =>
                                  //                                 Icon(Icons.error),
                                  //                       )),
                                  //                   Container(
                                  //                     margin:
                                  //                         EdgeInsets.only(left: width * 0.02),
                                  //                     child: Text(
                                  //                       objCreateEventNotifier
                                  //                               .getMyPastEventList[index]
                                  //                               .lstUser!
                                  //                               .firstName! +
                                  //                           " " +
                                  //                           objCreateEventNotifier
                                  //                               .getMyPastEventList[index]
                                  //                               .lstUser!
                                  //                               .lastName!,
                                  //                       style: AppTheme.getTheme()
                                  //                           .textTheme
                                  //                           .bodyText2!
                                  //                           .copyWith(
                                  //                               decoration:
                                  //                                   TextDecoration.none,
                                  //                               color:  ConstColor.white_Color,
                                  //                               fontSize: width * 0.04),
                                  //                     ),
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //               Container(
                                  //                 margin: EdgeInsets.only(top: height * 0.01),
                                  //                 child: Row(
                                  //                   mainAxisAlignment:
                                  //                       MainAxisAlignment.start,
                                  //                   children: [
                                  //                     Image.asset(
                                  //                       ConstantData.watch2,
                                  //                       height: height * 0.023,
                                  //                       color:ConstColor.white_Color,
                                  //                     ),
                                  //                     Container(
                                  //                       margin: EdgeInsets.only(
                                  //                           left: width * 0.02),
                                  //                       child: Text(
                                  //                         '${DateFormat('EEE, MMM dd, hh:mm aa -').format(objCreateEventNotifier.getMyPastEventList[index].eventStartDate!)[0].toUpperCase()}${(DateFormat('EEE, MMM dd, hh:mm aa -').format(objCreateEventNotifier.getMyPastEventList[index].eventStartDate!).substring(1)).toLowerCase()}' +
                                  //                             DateFormat(' hh:mm aa')
                                  //                                 .format(
                                  //                                     objCreateEventNotifier
                                  //                                         .getMyPastEventList[
                                  //                                             index]
                                  //                                         .eventEndDate!)
                                  //                                 .toLowerCase(),
                                  //                         style: AppTheme.getTheme()
                                  //                             .textTheme
                                  //                             .bodyText1!
                                  //                             .copyWith(
                                  //                                 decoration:
                                  //                                     TextDecoration.none,
                                  //                                 color:  ConstColor
                                  //                                         .white_Color,
                                  //                                 fontSize: width * 0.036),
                                  //                       ),
                                  //                     ),
                                  //                   ],
                                  //                 ),
                                  //               )
                                  //             ],
                                  //           ),
                                  //         )
                                  //       ],
                                  //     ),
                                  //   ),
                                  // );
                                },
                              ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
