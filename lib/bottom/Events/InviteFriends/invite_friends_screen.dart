import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:omw/bottom/Events/Myevents/myEvent_screen.dart';
import 'package:omw/constant/theme.dart';
import 'package:omw/utils/colorUtils.dart';
import 'package:omw/widget/commonButton.dart';
import 'package:omw/widget/scaffoldSnackbar.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:omw/notifier/group_notifier.dart';

import '../../../constant/constants.dart';
import '../../../model/createEvent_model.dart';
import '../../../model/user_model.dart';
import '../../../notifier/authenication_notifier.dart';
import '../../../notifier/event_notifier.dart';
import '../../../notifier/notication_notifier.dart';
import '../../../utils/textUtils.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class InviteFriendsScreen extends StatefulWidget {
  final bool isFromAddEvent;
  const InviteFriendsScreen({
    Key? key,
    required this.isFromAddEvent,
  }) : super(key: key);

  @override
  State<InviteFriendsScreen> createState() => _InviteFriendsScreenState();
}

class _InviteFriendsScreenState extends State<InviteFriendsScreen> {
  @override
  void initState() {
    getListOfGuests();

    super.initState();
  }

  bool isLoading = true;
  List<UserModel> searchList = [];
  List<UserModel> contactsList = [];
  List<UserModel> lstofAddGuest = [];
  List guestId = [];
  List<String> oldCohostList = [];
  List<UserModel> cohostList = [];

  getListOfGuests() async {
    setState(() {
      isLoading = true;
    });
    var objCreateEventNotifier =
        Provider.of<CreateEventNotifier>(context, listen: false);
    var objAuthenicationNotifier =
        Provider.of<AuthenicationNotifier>(context, listen: false);
    await objCreateEventNotifier.getinvitatedFriendData(
        context, objCreateEventNotifier.getEventData.docId!);
    var objGroupNotifier = Provider.of<GroupNotifier>(context, listen: false);

    await objAuthenicationNotifier.getUserDetail();
    await objGroupNotifier.getData(context, "");
    await _createDynamicLink(false, objCreateEventNotifier.getEventData.docId!);
    setState(() {
      contactsList = objGroupNotifier.selectedUserList.toList();
      contactsList.sort((a, b) => a.lastName!.compareTo(b.lastName!));
      searchList = contactsList;
      addGuest = objCreateEventNotifier.getEventData.guest!;
      guestId = objCreateEventNotifier.getEventData.guestsID!;
      lstAlldate = objCreateEventNotifier.getEventData.allDates!;
      oldCohostList = objCreateEventNotifier.getEventData.cohostList!;
      cohostList = objCreateEventNotifier.retrieveduserList
          .where((e) =>
              oldCohostList.contains(e.uid) || e.uid == _auth.currentUser!.uid)
          .toList();
      cohostList.forEach((element) {
        element.isInvite = true;
      });
      lstofAddGuest.addAll(cohostList.where(
        (element) => element.uid != _auth.currentUser!.uid,
      ));
    });

    setState(() {
      isLoading = false;
    });
    print("all  friends list ${searchList.length}");
  }

  String? _linkMessage;
  bool _isCreatingLink = false;

  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  Future<void> _createDynamicLink(bool short, String id) async {
    setState(() {
      _isCreatingLink = true;
    });
    String urlsss = "https://croelabs.com?ul=$id";
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://croelabs.com',
        longDynamicLink: Uri.parse(
          'https://croelabs.com?ul=$id',
        ),
        link: Uri.parse(urlsss),
        androidParameters: AndroidParameters(
          packageName: 'h.omw',
          minimumVersion: 0,
        ),
        iosParameters: IOSParameters(
            bundleId: 'h.omw', minimumVersion: '0', appStoreId: '6443660731'),
        navigationInfoParameters:
            NavigationInfoParameters(forcedRedirectEnabled: true));

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await dynamicLinks.buildShortLink(
        parameters,
      );
      url = shortLink.shortUrl;
    } else {
      url = await dynamicLinks.buildLink(
        parameters,
      );
    }

    setState(() {
      _linkMessage = url.toString();
      _isCreatingLink = false;

      print("_linkMessage============>${_linkMessage}");
    });
  }

  addItem(String userId) {
    final int index = searchList.indexWhere((item) => item.uid == userId);

    setState(() {
      searchList[index].isInvite = true;
    });
    print(searchList[index].firstName);
    lstofAddGuest.addAll(searchList.where((element) => element.uid == userId));

    setState(() {});

    print(lstofAddGuest.length);
  }

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(
      ClipboardData(
        text: _linkMessage.toString(),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Copied link'),
    ));
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Example share',
        linkUrl: _linkMessage.toString(),
        chooserTitle: 'event share');
  }

  void removeItem(String userId) {
    final int index = searchList.indexWhere((item) => item.uid == userId);

    setState(() {
      searchList[index].isInvite = false;
    });
    print(searchList[index].firstName);
    setState(() {
      lstofAddGuest
          .removeWhere((element) => element.uid == searchList[index].uid);
    });
    print(lstofAddGuest.length);
  }

  getdata() {
    var objNotificationNotifier =
        Provider.of<NotificationNotifier>(context, listen: false);
    var objCreateEventNotifier =
        Provider.of<CreateEventNotifier>(context, listen: false);
    var objAuthenicationNotifier =
        Provider.of<AuthenicationNotifier>(context, listen: false);
    if (lstofAddGuest.isNotEmpty) {
      lstofAddGuest.forEach((element) {
        addGuest.add(
          GuestModel(
              guestID: element.uid,
              status: oldCohostList.contains(element.uid) ? 0 : 2,
              guestUserName: element.firstName! + " " + element.lastName!),
        );
        lstAlldate.forEach((element2) {
          element2.guestResponse!.add(
            GuestModel(
                guestID: element.uid,
                status: oldCohostList.contains(element.uid) ? 0 : 2,
                guestUserName: element.firstName! + " " + element.lastName!),
          );
        });
        if (element.isAlreadyinvited != true && element.isInvite) {
          print(element.firstName);
          objNotificationNotifier.sendPushNotification(
              context,
              element.fcmToken!,
              "Event Invitation",
              "${objAuthenicationNotifier.objUsers.firstName! + " " + objAuthenicationNotifier.objUsers.lastName!} has invited you to an event",
              "eventInvite",
              "",
              "",
              "");
          objNotificationNotifier.pushNotification(
              context: context,
              title: "Event Invitation",
              description:
                  "${objAuthenicationNotifier.objUsers.firstName! + " " + objAuthenicationNotifier.objUsers.lastName!} has invited you to an event",
              userId: element.uid,
              type: "eventInvite",
              typeOfData: [
                {
                  "notificationType": "Invitation",
                  "responseSender":
                      "${objAuthenicationNotifier.objUsers.firstName! + " " + objAuthenicationNotifier.objUsers.lastName!}",
                  "eventId": objCreateEventNotifier.EventData.docId!,
                  "eventHost": objAuthenicationNotifier.objUsers.firstName! +
                      " " +
                      objAuthenicationNotifier.objUsers.lastName!,
                  "eventName": objCreateEventNotifier.getEventData.eventname!
                }
              ]);
        } else {
          print("=================>AlreadyInvited");
        }

        setState(() {
          guestId.add(element.uid);
        });
      });
    }
  }

  bool isShareClick = false;
  List<GuestModel> addGuest = [];
  List<AllDates> lstAlldate = [];

  final TextEditingController _searchEvent = TextEditingController();

  bool _IsSearching = false;
  String _searchText = "";
  bool isSearch = false;
  _InviteFriendsScreenState() {
    _searchEvent.addListener(() {
      if (_searchEvent.text.isEmpty) {
        setState(
          () {
            _IsSearching = false;
            _searchText = "";
            _buildSearchList();
          },
        );
      } else {
        setState(
          () {
            _IsSearching = true;
            _searchText = _searchEvent.text;
            _buildSearchList();
          },
        );
      }
    });
  }

  _buildSearchList() {
    var objCreateEventNotifier =
        Provider.of<CreateEventNotifier>(context, listen: false);
    searchList = contactsList
        .where(
          (element) =>
              element.firstName!.toLowerCase().startsWith(
                    _searchText.toLowerCase(),
                  ) ||
              element.lastName!.toLowerCase().startsWith(
                    _searchText.toLowerCase(),
                  ),
        )
        .toList();
    setState(() {});
    print('${searchList.length}');
  }

  @override
  Widget build(BuildContext context) {
    final objCreateEventNotifier = context.watch<CreateEventNotifier>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.getTheme().scaffoldBackgroundColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: widget.isFromAddEvent
              ? Container()
              : Icon(
                  Icons.arrow_back_ios_rounded,
                  color: ConstColor.primaryColor,
                  size: width * 0.06,
                ),
        ),
        leadingWidth: width * 0.1,
        title:

            ///-------------------- Chat Text   ---------------------
            Text(
          TextUtils.inviteFriends,
          style: AppTheme.getTheme().textTheme.bodyText2!.copyWith(
              color: ConstColor.primaryColor,
              height: 1.4,
              fontSize: width * 0.052),
        ),
        centerTitle: true,
        actions: [
          // widget.isFromAddEvent
          false
              ? GestureDetector(
                  onTap: () {
                    widget.isFromAddEvent
                        ? Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyEventScreen()))
                        : Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.only(right: width * 0.02),
                    child: Center(
                      child: Text(
                        "Later",
                        style: AppTheme.getTheme()
                            .textTheme
                            .bodyText2!
                            .copyWith(
                                color: ConstColor.primaryColor,
                                height: 1.4,
                                decoration: TextDecoration.underline,
                                fontSize: width * 0.042),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
      body: Stack(
        children: [
          isShareClick
              ? Center(
                  child: CircularProgressIndicator(
                  color: primaryColor,
                ))
              : Container(),
          Container(
            margin: EdgeInsets.only(
                left: width * 0.03, right: width * 0.03, top: height * 0.01),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///------------- search field------------------------
                      Container(
                        margin: EdgeInsets.only(bottom: height * 0.015),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.disabled,
                          style:
                              AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                                    fontSize: width * 0.041,
                                    color: ConstColor.white_Color,
                                  ),
                          controller: _searchEvent,
                          decoration: InputDecoration(
                            prefixIcon: Container(
                              margin: EdgeInsets.only(
                                  left: height * 0.02,
                                  right: height * 0.02,
                                  bottom: height * 0.002),
                              child: Image.asset(
                                ConstantData.search,
                                width: height * 0.025,
                                height: height * 0.025,
                                fit: BoxFit.contain,
                              ),
                            ),
                            border: InputBorder.none,
                            errorStyle: AppTheme.getTheme()
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                  fontSize: width * 0.036,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(height * 0.1),
                              borderSide: BorderSide(
                                color: ConstColor.textFormFieldColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(height * 0.1),
                              borderSide: BorderSide(
                                color: ConstColor.textFormFieldColor,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(height * 0.1),
                              borderSide: BorderSide(
                                color: ConstColor.textFormFieldColor,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(height * 0.1),
                              borderSide: BorderSide(
                                color: ConstColor.textFormFieldColor,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(height * 0.1),
                              borderSide: BorderSide(
                                color: ConstColor.textFormFieldColor,
                              ),
                            ),
                            isDense: true,
                            hintText: TextUtils.name,
                            hintStyle: AppTheme.getTheme()
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                  fontSize: width * 0.045,
                                  color: Color(0xff6C6C6C),
                                ),
                          ),
                        ),
                      ),

                      ///------------------ invite friends------------------
                      !_searchEvent.text.isEmpty
                          ? Container()
                          : Row(children: [
                              GestureDetector(
                                onTap: share,
                                child: Container(
                                  padding: EdgeInsets.all(height * 0.02),
                                  margin: EdgeInsets.only(
                                      bottom: height * 0.02,
                                      top: height * 0.01,
                                      right: width * 0.033),
                                  width: width * 0.83,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 26, 26, 26),
                                    borderRadius:
                                        BorderRadius.circular(height * 0.02),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.file_upload_outlined,
                                              color: ConstColor.white_Color,
                                            ),
                                            // ClipRRect(
                                            //   borderRadius:
                                            //       BorderRadius.circular(height * 0.1),
                                            //   child: Image.network(
                                            //     objCreateEventNotifier
                                            //         .EventData.eventPhoto!,
                                            //     height: height * 0.055,
                                            //     width: height * 0.055,
                                            //     fit: BoxFit.cover,
                                            //   ),
                                            // ),
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    left: width * 0.02,
                                                    top: height * 0.005),

                                                child: Text(
                                                  "Share event link",
                                                  style: AppTheme.getTheme()
                                                      .textTheme
                                                      .bodyText2!
                                                      .copyWith(
                                                          color: ConstColor
                                                              .white_Color,
                                                          fontSize:
                                                              width * 0.05,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                // Text(
                                                //   _linkMessage == null ||
                                                //           _linkMessage == ""
                                                //       ? ""
                                                //       : _linkMessage.toString(),
                                                //   style: AppTheme.getTheme()
                                                //       .textTheme
                                                //       .bodyText2!
                                                //       .copyWith(
                                                //           height: 1.4,
                                                //           color: ConstColor
                                                //               .white_Color
                                                //               .withOpacity(0.7),
                                                //           fontSize: width * 0.045,
                                                //           fontWeight:
                                                //               FontWeight.normal),
                                                //   overflow: TextOverflow.ellipsis,
                                                // ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                  margin:
                                      EdgeInsets.only(bottom: height * 0.005),
                                  child: GestureDetector(
                                    onTap: _copyToClipboard,
                                    child: Icon(
                                      Icons.content_copy_outlined,
                                      color: ConstColor.white_Color,
                                    ),
                                  ))
                            ]),

                      isLoading == true && searchList.isEmpty
                          ? Center(
                              child: CircularProgressIndicator(
                              color: primaryColor,
                            ))
                          : searchList.isEmpty
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
                                  )),
                                )
                              //// -------------- list of Data--------
                              : Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: searchList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return searchList[index]
                                                      .isAlreadyinvited ==
                                                  true ||
                                              oldCohostList.contains(
                                                  searchList[index].uid)
                                          ? Container()
                                          // Column(
                                          //     children: [
                                          //       Container(
                                          //         color: Colors.transparent,
                                          //         margin: EdgeInsets.only(
                                          //             top: height * 0.017,
                                          //             bottom: height * 0.017,
                                          //             left: width * 0.03,
                                          //             right: width * 0.03),
                                          //         child: Row(
                                          //           children: [
                                          //             ClipRRect(
                                          //               borderRadius:
                                          //                   BorderRadius
                                          //                       .circular(
                                          //                           height *
                                          //                               0.1),
                                          //               child:
                                          //                   CachedNetworkImage(
                                          //                 imageUrl:
                                          //                     searchList[index]
                                          //                         .userProfile!,
                                          //                 height: height * 0.06,
                                          //                 width: height * 0.06,
                                          //                 fit: BoxFit.cover,
                                          //                 placeholder: (context,
                                          //                         url) =>
                                          //                     CircularProgressIndicator(
                                          //                   color: primaryColor,
                                          //                 ),
                                          //                 errorWidget: (context,
                                          //                         url, error) =>
                                          //                     Icon(Icons.error),
                                          //               ),
                                          //             ),
                                          //             Expanded(
                                          //               child: Container(
                                          //                 margin:
                                          //                     EdgeInsets.only(
                                          //                         left: width *
                                          //                             0.05),
                                          //                 child: Text(
                                          //                   searchList[index]
                                          //                           .firstName! +
                                          //                       " " +
                                          //                       searchList[
                                          //                               index]
                                          //                           .lastName!,
                                          //                   style: AppTheme
                                          //                           .getTheme()
                                          //                       .textTheme
                                          //                       .bodyText2!
                                          //                       .copyWith(
                                          //                         color: ConstColor
                                          //                             .white_Color,
                                          //                         fontSize:
                                          //                             width *
                                          //                                 0.042,
                                          //                       ),
                                          //                 ),
                                          //               ),
                                          //             ),
                                          //             Text(
                                          //               "Invited",
                                          //               style:
                                          //                   AppTheme.getTheme()
                                          //                       .textTheme
                                          //                       .bodyText2!
                                          //                       .copyWith(
                                          //                         color: ConstColor
                                          //                             .white_Color,
                                          //                         fontSize:
                                          //                             width *
                                          //                                 0.042,
                                          //                       ),
                                          //             )
                                          //           ],
                                          //         ),
                                          //       ),
                                          //       searchList.last ==
                                          //               searchList[index]
                                          //           ? Container()
                                          //           : Container(
                                          //               margin: EdgeInsets.only(
                                          //                   top: height * 0.012,
                                          //                   bottom:
                                          //                       height * 0.012),
                                          //               height: 1,
                                          //               width: width,
                                          //               color: ConstColor
                                          //                   .term_condition_grey_color
                                          //                   .withOpacity(0.6),
                                          //             )
                                          //     ],
                                          //   )
                                          : GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  searchList[index].isInvite =
                                                      !searchList[index]
                                                          .isInvite;
                                                });
                                                if (searchList[index]
                                                        .isInvite ==
                                                    true) {
                                                  addItem(
                                                      searchList[index].uid!);
                                                } else {
                                                  removeItem(
                                                      searchList[index].uid!);
                                                }
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                    color: Colors.transparent,
                                                    margin: EdgeInsets.only(
                                                        top: height * 0.017,
                                                        bottom: height * 0.017,
                                                        left: width * 0.03,
                                                        right: width * 0.03),
                                                    child: Row(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      height *
                                                                          0.1),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: searchList[
                                                                    index]
                                                                .userProfile!,
                                                            height:
                                                                height * 0.06,
                                                            width:
                                                                height * 0.06,
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
                                                        Expanded(
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: width *
                                                                        0.05),
                                                            child: Text(
                                                              searchList[index]
                                                                      .firstName! +
                                                                  " " +
                                                                  searchList[
                                                                          index]
                                                                      .lastName!,
                                                              style: AppTheme
                                                                      .getTheme()
                                                                  .textTheme
                                                                  .bodyText2!
                                                                  .copyWith(
                                                                    color: ConstColor
                                                                        .white_Color,
                                                                    fontSize:
                                                                        width *
                                                                            0.042,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          height:
                                                              height * 0.032,
                                                          width: height * 0.032,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: searchList[
                                                                            index]
                                                                        .isInvite ==
                                                                    true
                                                                ? primaryColor
                                                                : Colors
                                                                    .transparent,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        height *
                                                                            0.009),
                                                            border: Border.all(
                                                                color: ConstColor
                                                                    .white_Color
                                                                    .withOpacity(
                                                                        0.36),
                                                                width: 1.2),
                                                          ),
                                                          child: searchList[
                                                                          index]
                                                                      .isInvite ==
                                                                  true
                                                              ? Icon(
                                                                  Icons.check,
                                                                  size: height *
                                                                      0.02,
                                                                  color: ConstColor
                                                                      .black_Color,
                                                                )
                                                              : Container(),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  searchList.last ==
                                                          searchList[index]
                                                      ? Container()
                                                      : Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: height *
                                                                      0.012,
                                                                  bottom:
                                                                      height *
                                                                          0.012),
                                                          height: 1,
                                                          width: width,
                                                          color: ConstColor
                                                              .term_condition_grey_color
                                                              .withOpacity(0.6),
                                                        )
                                                ],
                                              ),
                                            );
                                    },
                                  ),
                                ),
                    ],
                  ),
                ),

                ///------------share button --------------------
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          isShareClick = true;
                        });
                        await getdata();
                        if (addGuest.isNotEmpty) {
                          setState(() {
                            isLoading = true;
                          });
                          await objCreateEventNotifier
                              .addGuestList(
                                  context,
                                  addGuest,
                                  objCreateEventNotifier.EventData.docId!,
                                  guestId,
                                  lstAlldate)
                              .then((value) {
                            widget.isFromAddEvent
                                ? Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyEventScreen()))
                                : Navigator.pop(context);
                          });
                          setState(() {
                            isShareClick = false;
                          });
                        } else {
                          ScaffoldSnackbar.of(context)
                              .show("Please select your guest first");
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: height * 0.02),
                        child: CommonButton(name: "Done"),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
