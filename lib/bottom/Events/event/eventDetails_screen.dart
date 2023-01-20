import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:omw/bottom/Events/event/edit_event_screen.dart';
import 'package:omw/bottom/Events/event/event_chat_page.dart';
import 'package:omw/bottom/Profile/profile_screen.dart';
import 'package:omw/bottom/bottomtab.dart';
import 'package:omw/bottom/common_BottomTab.dart';
import 'package:omw/notifier/event_notifier.dart';
import 'package:provider/provider.dart';
import '../../../constant/constants.dart';
import '../../../constant/theme.dart';
import '../../../model/createEvent_model.dart';
import '../../../model/user_model.dart';
import '../../../notifier/authenication_notifier.dart';
import '../../../notifier/notication_notifier.dart';
import '../../../preference/preference.dart';
import '../../../utils/colorUtils.dart';
import '../../../utils/textUtils.dart';
import '../../../widget/commonButton.dart';
import '../InviteFriends/invite_friends_screen.dart';

import '../../Create/multiSelectionDate.dart';

import '../../Create/seeMutiSelectedDate_screen.dart';
import '../guestList/guestList_screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class EventDetailsScreen extends StatefulWidget {
  final bool isFromMyeventScreen;
  final bool isPastEvent;
  final bool ismyPastEvent;
  final String eventId;
  final String hostId;

  const EventDetailsScreen({
    Key? key,
    required this.isFromMyeventScreen,
    required this.isPastEvent,
    required this.ismyPastEvent,
    required this.eventId,
    required this.hostId,
  }) : super(key: key);

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  int index = 0;
  int panIndex = 0;
  double panEnd = 0.0;
  double verticalPanStart = 0.0;
  double verticalPan = 0.0;

  int? selectedIndex;
  List allResponse = [];
  bool isGoing = false;
  bool isnotgoinf = false;
  @override
  void initState() {
    getData();
    super.initState();
  }

  String currentuser = "";
  getData() async {
    setState(() {
      isDataLoad = true;
    });
    currentuser = await PrefServices().getCurrentUserName();
    var objCreateEventNotifier =
        Provider.of<CreateEventNotifier>(context, listen: false);
    allResponse = [];
    await objCreateEventNotifier.geteventDeatisl(
      context,
      widget.eventId,
      widget.hostId,
    );
    setState(() {
      isDataLoad = false;
    });
    setState(() {
      objCreateEventNotifier.setEventData =
          objCreateEventNotifier.getEventDetails;
    });

    if (widget.isFromMyeventScreen == true && widget.ismyPastEvent == false) {
      await objCreateEventNotifier.getinvitatedFriendData(
        context,
        objCreateEventNotifier.getEventDetails.docId!,
      );
    }

    addGuest = objCreateEventNotifier.getEventDetails.guest!;
    lstAlldate = objCreateEventNotifier.getEventDetails.allDates!;
    guestId = objCreateEventNotifier.getEventDetails.guestsID!;
    lstAlldate.forEach((element) {
      element.guestResponse!.forEach((element2) {
        if (element2.guestID == _auth.currentUser!.uid) {
          allResponse.add(element2.status);
        }
      });
    });
    print("allResponse===========>$allResponse");
    print(allResponse);
    if (allResponse.every((e) => e == 1)) {
      print("Notgoing");
      setState(() {
        index = 1;
        panIndex = 1;
      });
    } else if (allResponse.every((e) => e == 0)) {
      print("Going");
      setState(() {
        index = 0;
        panIndex = 0;
      });
    } else {
      print("maybe");
      setState(() {
        index = 2;
        panIndex = 2;
      });
    }

    var objAuthenicationNotifier =
        Provider.of<AuthenicationNotifier>(context, listen: false);
    objAuthenicationNotifier.getUserDetail();
    if (widget.isFromMyeventScreen == false &&
        widget.isPastEvent == false &&
        widget.ismyPastEvent == false) {
      getListOfGuestUser();
    }
  }

  List<GuestModel> addGuest = [];
  List<UserModel> lstofAddGuest = [];
  List guestId = [];

  // List lstOFChatName = [
  //   {"name": TextUtils.eventChat},
  //   // {"name": TextUtils.costSplit},
  // ];
  // List costSplit = [
  //   {"name": TextUtils.costSplit},
  // ];

  // List lstOFmyupcomingChatName = [
  //   {"name": TextUtils.eventChat},
  //   // {"name": TextUtils.costSplit},
  //   // {"name": "Invite Friends"},
  // ];
  List<UserModel> goingGuest = [];
  List<UserModel> maybeGuest = [];
  List<UserModel> notGoingGuest = [];
  List<int> attendance = [0, 0, 0];
  bool isDataLoad = false;
  Future getListOfGuestUser() async {
    goingGuest = [];
    maybeGuest = [];
    notGoingGuest = [];
    var objCreateEventNotifier =
        Provider.of<CreateEventNotifier>(context, listen: false);

    print("eventId :- ${objCreateEventNotifier.EventData.docId}");
    await objCreateEventNotifier.getAllGuestUserList(
        context, objCreateEventNotifier.getEventDetails.guestsID!);

    objCreateEventNotifier.getEventDetails.guest!.forEach((e) {
      setState(() {
        goingGuest.addAll(objCreateEventNotifier.retrievedGuestUserList
            .where((element) => element.uid == e.guestID && e.status == 0));
      });
    });

    objCreateEventNotifier.getEventDetails.guest!.forEach((e) {
      setState(() {
        maybeGuest.addAll(objCreateEventNotifier.retrievedGuestUserList
            .where((element) => element.uid == e.guestID && e.status == 2));
      });
    });

    objCreateEventNotifier.getEventDetails.guest!.forEach((e) {
      setState(() {
        notGoingGuest.addAll(
          objCreateEventNotifier.retrievedGuestUserList
              .where((element) => element.uid == e.guestID && e.status == 1),
        );
      });
    });
    setState(() {
      attendance = [goingGuest.length, maybeGuest.length, notGoingGuest.length];
    });

    print("Going :- $goingGuest");
    print("maybe :- $maybeGuest");
    print("notGoingGuest :- $notGoingGuest");
  }

  List<AllDates> lstAlldate = [];
  getStatusResponse(int Status) {
    var objCreateEventNotifier =
        Provider.of<CreateEventNotifier>(context, listen: false);
    if (lstofAddGuest.isNotEmpty) {
      addGuest = [];
      lstAlldate = [];
      lstofAddGuest.forEach((element) {
        objCreateEventNotifier.getEventDetails.guest!.forEach((element1) {
          if (element1.guestID == _auth.currentUser!.uid) {
            addGuest.add(
              GuestModel(
                  guestID: _auth.currentUser!.uid,
                  status: Status,
                  guestUserName: currentuser),
            );
            lstAlldate.forEach(
              (element2) {
                element2.guestResponse!.add(
                  GuestModel(
                      guestID: _auth.currentUser!.uid,
                      status: Status,
                      guestUserName: currentuser),
                );
              },
            );
          }
        });
        guestId = [];

        setState(() {
          guestId.add(element.uid);
        });
      });
    }
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final objCreateEventNotifier = context.watch<CreateEventNotifier>();
    bool isMyEvent = false;

    if (objCreateEventNotifier.getEventDetails.ownerID ==
        _auth.currentUser!.uid) {
      isMyEvent = true;
    } else if (objCreateEventNotifier.getEventDetails.cohostList != null) {
      if (objCreateEventNotifier.getEventDetails.cohostList!
          .contains(_auth.currentUser!.uid)) {
        isMyEvent = true;
      }
    }

    Future<void> _copyLocationToClipboard() async {
      await Clipboard.setData(
        ClipboardData(
          text: objCreateEventNotifier.getEventDetails.location!.toString(),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Copied location'),
      ));
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.getTheme().backgroundColor,

        ///------------------- back Arrow ------------------------

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
        leadingWidth: height * 0.055,

        ///------------------------ OMW title-------------------------
        actions: [
          isMyEvent == true
              ? GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => InviteFriendsScreen(
                              isFromAddEvent: false,
                            )),
                      ),
                    ).then((value) async {
                      await getListOfGuestUser();
                    });
                  },
                  child: Container(
                    color: Colors.transparent,
                    margin: EdgeInsets.only(right: width * 0.04),
                    child: Icon(
                      Icons.add,
                      color: primaryColor,
                    ),
                  ),
                )
              : Container(),
          isMyEvent ||
                  widget.isFromMyeventScreen == true &&
                      widget.ismyPastEvent == false
              ? GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditEventScreen(),
                        ));
                  },
                  child: Container(
                    color: Colors.transparent,
                    margin: EdgeInsets.only(right: width * 0.03),
                    child: Icon(
                      Icons.edit,
                      color: primaryColor,
                      size: width * 0.057,
                    ),
                  ))
              : Container(),
          widget.isPastEvent == true || widget.ismyPastEvent == true
              ? Container()
              : Container(
                  margin:
                      EdgeInsets.only(right: width * 0.03, left: width * 0.02),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventChatPage(),
                        ),
                      );
                    },
                    child: Image.asset(
                      ConstantData.message,
                      height: height * 0.026,
                      width: height * 0.026,
                      fit: BoxFit.contain,
                      color: primaryColor,
                    ),
                  ),
                ),
        ],
        title: Image.asset(
          ConstantData.logo,
          height: height * 0.12,
          width: height * 0.12,
          fit: BoxFit.contain,
        ),
        // Text(
        //   TextUtils.Omw,
        //   style: AppTheme.getTheme().textTheme.subtitle1!.copyWith(
        //         color: primaryColor,
        //         fontWeight: FontWeight.w700,
        //         fontSize: width * 0.09,
        //       ),
        // ),
        centerTitle: true,
      ),
      bottomNavigationBar: widget.isFromMyeventScreen == true
          ? Text("")
          : PersistanceBottomTab(
              lastIndex: 1,
              index: 1,
              onSuccess: (val) {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        BottomNavBarScreen(
                      index: val,
                      lastIndex: val,
                    ),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
            ),
      body: isDataLoad
          ? Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            )
          : Container(
              margin: EdgeInsets.only(
                top: height * 0.02,
                left: width * 0.03,
                right: width * 0.03,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        height * 0.015,
                      ),
                      child: CachedNetworkImage(
                        imageUrl:
                            objCreateEventNotifier.getEventDetails.eventPhoto!,
                        height: height * 0.22,
                        width: width,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: height * 0.014),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ///------------- event name------------------
                                Text(
                                  objCreateEventNotifier
                                      .getEventDetails.eventname!,
                                  style: AppTheme.getTheme()
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(
                                          fontSize: width * 0.048,
                                          color: ConstColor.white_Color),
                                ),

                                ///-------------- Date----------
                                Column(
                                  children: [
                                    (objCreateEventNotifier
                                                    .EventData.isDatePoll ==
                                                null
                                            ? false
                                            : objCreateEventNotifier
                                                .EventData.isDatePoll!)
                                        ? widget.isPastEvent == false &&
                                                widget.ismyPastEvent == false
                                            ? isMyEvent
                                                ? //Future event, hosted by me, with a date poll
                                                GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              SeeMultiSelectedDate(
                                                            eventId:
                                                                objCreateEventNotifier
                                                                    .EventData
                                                                    .docId!,
                                                            eventHostUserId:
                                                                objCreateEventNotifier
                                                                    .EventData
                                                                    .lstUser!
                                                                    .uid!,
                                                            guestId:
                                                                objCreateEventNotifier
                                                                    .EventData
                                                                    .guestsID!,
                                                          ),
                                                        ),
                                                      ).then((value) async {
                                                        await getData();
                                                      });
                                                    },
                                                    child: Text(
                                                      "View date poll",
                                                      style: AppTheme.getTheme()
                                                          .textTheme
                                                          .bodyText1!
                                                          .copyWith(
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline,
                                                              color: ConstColor
                                                                  .white_Color,
                                                              fontSize: width *
                                                                  0.036),
                                                    ),
                                                  )
                                                : //Future event, not hosted by me, with a date poll
                                                GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              MultiSelection(
                                                            eventId:
                                                                objCreateEventNotifier
                                                                    .EventData
                                                                    .docId!,
                                                            eventHostUserId:
                                                                objCreateEventNotifier
                                                                    .EventData
                                                                    .lstUser!
                                                                    .uid!,

                                                            // guestId: guestId,
                                                          ),
                                                        ),
                                                      ).then((value) async {
                                                        await getData();
                                                        if (addGuest
                                                            .isNotEmpty) {
                                                          addGuest.forEach(
                                                              (element) {
                                                            if (element
                                                                    .guestID ==
                                                                _auth
                                                                    .currentUser!
                                                                    .uid) {
                                                              element.status =
                                                                  index;
                                                            }
                                                          });

                                                          await objCreateEventNotifier
                                                              .addGuestList(
                                                                  context,
                                                                  addGuest,
                                                                  objCreateEventNotifier
                                                                      .EventData
                                                                      .docId!,
                                                                  guestId,
                                                                  lstAlldate)
                                                              .whenComplete(
                                                                  () async {
                                                            isLoading = false;
                                                            await getListOfGuestUser();
                                                          });
                                                        }
                                                      });
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          top: height * 0.005,
                                                          bottom:
                                                              height * 0.005),
                                                      child: Text(
                                                        "See date poll",
                                                        style: AppTheme
                                                                .getTheme()
                                                            .textTheme
                                                            .bodyText1!
                                                            .copyWith(
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
                                                                color: ConstColor
                                                                    .white_Color,
                                                                fontSize:
                                                                    width *
                                                                        0.036),
                                                      ),
                                                    ),
                                                  )
                                            : //Past event, with a date poll
                                            Text(
                                                "Past Date Poll",
                                                style: AppTheme.getTheme()
                                                    .textTheme
                                                    .bodyText1!
                                                    .copyWith(
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        color: ConstColor
                                                            .white_Color,
                                                        fontSize:
                                                            width * 0.036),
                                              )
                                        : //Events without a date poll
                                        Text(
                                            '${DateFormat(TextUtils.dateFormat).format(objCreateEventNotifier.EventData.eventStartDate!)[0].toUpperCase()}${(DateFormat(TextUtils.dateFormat).format(objCreateEventNotifier.EventData.eventStartDate!).substring(1, 4)).toLowerCase()}${DateFormat(TextUtils.dateFormat).format(objCreateEventNotifier.EventData.eventStartDate!)[4].toUpperCase()}${(DateFormat(TextUtils.dateFormat).format(objCreateEventNotifier.EventData.eventStartDate!).substring(5)).toLowerCase()}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTheme.getTheme()
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                    decoration:
                                                        TextDecoration.none,
                                                    color:
                                                        ConstColor.white_Color,
                                                    fontSize: width * 0.032),
                                          ),
                                  ],
                                ),

                                ///------------------------- event location--------------------

                                Container(
                                  margin: EdgeInsets.only(top: height * 0.01),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        ConstantData.location2,
                                        height: height * 0.023,
                                        color: ConstColor.white_Color,
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.only(left: width * 0.02),
                                        child: Text(
                                          objCreateEventNotifier
                                              .getEventDetails.location!,
                                          maxLines: 2,
                                          style: AppTheme.getTheme()
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(
                                                  height: 1.2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  decoration:
                                                      TextDecoration.none,
                                                  color: ConstColor.white_Color,
                                                  fontSize: width * 0.036),
                                        ),
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(
                                              left: width * 0.02),
                                          child: GestureDetector(
                                            onTap: _copyLocationToClipboard,
                                            child: Icon(
                                              Icons.content_copy_outlined,
                                              size: 14,
                                              color: ConstColor.primaryColor,
                                            ),
                                          ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                          userId: objCreateEventNotifier
                                              .getEventDetails.lstUser!.uid!,
                                          name: objCreateEventNotifier.getEventDetails.lstUser!.firstName! +
                                              " " +
                                              objCreateEventNotifier
                                                  .getEventDetails
                                                  .lstUser!
                                                  .lastName!,
                                          profile: objCreateEventNotifier
                                              .getEventDetails
                                              .lstUser!
                                              .userProfile!,
                                          isOwnProfile: objCreateEventNotifier
                                                      .getEventDetails
                                                      .lstUser!
                                                      .uid ==
                                                  FirebaseAuth
                                                      .instance.currentUser!.uid
                                              ? true
                                              : false,
                                          fcmtoken: objCreateEventNotifier
                                              .getEventDetails
                                              .lstUser!
                                              .fcmToken!),
                                    ),
                                  );
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  margin: EdgeInsets.only(top: height * 0.01),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              height * 0.1),
                                          child: CachedNetworkImage(
                                              imageUrl: objCreateEventNotifier
                                                  .getEventDetails
                                                  .lstUser!
                                                  .userProfile!,
                                              height: height * 0.045,
                                              width: height * 0.045,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  CircularProgressIndicator(
                                                    color: primaryColor,
                                                  ))),
                                      Container(
                                        margin:
                                            EdgeInsets.only(left: width * 0.02),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Hosted by",
                                              style: AppTheme.getTheme()
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(
                                                      fontSize: width * 0.032,
                                                      color: ConstColor
                                                          .white_Color
                                                          .withOpacity(0.37)),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: height * 0.005),
                                              child: Text(
                                                objCreateEventNotifier
                                                        .getEventDetails
                                                        .lstUser!
                                                        .firstName! +
                                                    " " +
                                                    objCreateEventNotifier
                                                        .EventData
                                                        .lstUser!
                                                        .lastName!,
                                                style: AppTheme.getTheme()
                                                    .textTheme
                                                    .bodyText1!
                                                    .copyWith(
                                                        fontSize: width * 0.043,
                                                        color: ConstColor
                                                            .white_Color),
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
                                margin: EdgeInsets.only(top: height * 0.02),
                                child: isMyEvent
                                    ? Text(
                                        "You are hosting",
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        style: AppTheme.getTheme()
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                                height: 1.2,
                                                overflow: TextOverflow.ellipsis,
                                                decoration: TextDecoration.none,
                                                color: ConstColor.primaryColor,
                                                fontSize: width * 0.036),
                                      )
                                    : Container(),
                              )
                            ],
                          ),

                          ///-------------- image and  create by --------------
                        ],
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(
                          top: height * 0.018,
                        ),
                        child: widget.isFromMyeventScreen == true ||
                                widget.ismyPastEvent == true
                            ? isMyeventDetails(objCreateEventNotifier)
                            : isNotMyEventDetails(objCreateEventNotifier))
                  ],
                ),
              ),
            ),
    );
  }

  Widget isMyeventDetails(CreateEventNotifier objCreateEventNotifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            margin: EdgeInsets.only(bottom: height * 0.02, top: height * 0.007),
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    objCreateEventNotifier.setEventData =
                        objCreateEventNotifier.getEventDetails;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => GuestListScreen(
                            isMyEvent: true,
                            index: 0,
                            eventId:
                                objCreateEventNotifier.getEventDetails.docId!,
                            eventHostUserId:
                                objCreateEventNotifier.EventData.lstUser!.uid!,
                          )),
                    ),
                  );
                },
                child: CommonButton(name: TextUtils.GuestList))),
        Text(
          objCreateEventNotifier.getEventDetails.description!,
          style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
              color: ConstColor.white_Color.withOpacity(0.7),
              height: 1.4,
              fontSize: width * 0.041),
        ),
      ],
    );
  }

  Widget isNotMyEventDetails(CreateEventNotifier objCreateEventNotifier) {
    bool isMyEvent = false;

    if (objCreateEventNotifier.getEventDetails.ownerID ==
        _auth.currentUser!.uid) {
      isMyEvent = true;
    } else if (objCreateEventNotifier.getEventDetails.cohostList!
        .contains(_auth.currentUser!.uid)) {
      isMyEvent = true;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///---------------- Selection-----------
        widget.isFromMyeventScreen == false &&
                // widget.isPastEvent == false &&
                widget.ismyPastEvent == false
            ? isMyEvent
                ? Container(
                    margin: EdgeInsets.only(
                        bottom: height * 0.02, top: height * 0.007),
                    child: GestureDetector(
                        onTap: () {
                          setState(() {
                            objCreateEventNotifier.setEventData =
                                objCreateEventNotifier.getEventDetails;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => GuestListScreen(
                                    isMyEvent: true,
                                    index: 0,
                                    eventId: objCreateEventNotifier
                                        .getEventDetails.docId!,
                                    eventHostUserId: objCreateEventNotifier
                                        .EventData.lstUser!.uid!,
                                  )),
                            ),
                          );
                        },
                        child: CommonButton(name: TextUtils.GuestList)))
                : Container(
                    margin: EdgeInsets.only(
                        bottom: height * 0.015, top: height * 0.007),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(height * 0.1),
                      border: Border.all(
                        color: ConstColor.textFormFieldColor,
                      ),
                    ),
                    child: GestureDetector(
                      onPanStart: (DragStartDetails details) {
                        verticalPanStart = details.globalPosition.dy;
                      },
                      onPanUpdate: (DragUpdateDetails details) {
                        verticalPan =
                            (verticalPanStart - details.globalPosition.dy)
                                .abs();
                        if (verticalPan > height * 0.1) {
                          setState(() {
                            panIndex = index;
                          });
                          return;
                        }

                        panEnd = details.globalPosition.dx;
                        print("panEnd: ${panEnd}");
                        if (panEnd <= width * 0.35) {
                          setState(() {
                            panIndex = 0;
                          });
                        } else if (panEnd > width * 0.35 &&
                            panEnd <= width * 0.65) {
                          setState(() {
                            panIndex = 2;
                          });
                        } else if (panEnd > width * 0.65) {
                          setState(() {
                            panIndex = 1;
                          });
                        }
                      },
                      onPanEnd: (DragEndDetails details) {
                        if (verticalPan > height * 0.1) {
                          setState(() {
                            panIndex = index;
                          });
                          return;
                        }
                        int panResponse = 0;
                        if (panEnd > width * 0.35 && panEnd < width * 0.65) {
                          panResponse = 2;
                        } else if (panEnd > width * 0.65) {
                          panResponse = 1;
                        }
                        if (panResponse != index) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (BuildContext context, setState) {
                                  return CommanDialog(
                                      panResponse, objCreateEventNotifier);
                                },
                              );
                            },
                          ).then((value) {
                            setState(() {
                              index = value;
                            });
                          });
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ///------------------------------- Going ----------------------
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => GuestListScreen(
                                            isMyEvent: false,
                                            index: 0,
                                            eventHostUserId:
                                                objCreateEventNotifier
                                                    .EventData.lstUser!.uid!,
                                            eventId: objCreateEventNotifier
                                                .getEventDetails.docId!)));
                              },
                              child: Container(
                                width: width * 0.29,
                                margin: EdgeInsets.all(height * 0.006),
                                padding: EdgeInsets.all(height * 0.014),
                                decoration: BoxDecoration(
                                  color: panIndex != 0
                                      ? Colors.transparent
                                      : primaryColor,
                                  borderRadius:
                                      BorderRadius.circular(height * 0.1),
                                ),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        attendance[0].toString(),
                                        style: AppTheme.getTheme()
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                                color: panIndex != 0
                                                    ? Color(0xffA5A5A5)
                                                    : ConstColor.black_Color,
                                                fontSize: width * 0.05,
                                                fontWeight: panIndex != 0
                                                    ? FontWeight.normal
                                                    : FontWeight.w700),
                                      ),
                                      Text(
                                        TextUtils.coming,
                                        style: AppTheme.getTheme()
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                                color: panIndex != 0
                                                    ? Color(0xffA5A5A5)
                                                    : ConstColor.black_Color,
                                                fontSize: width * 0.043,
                                                fontWeight: panIndex != 0
                                                    ? FontWeight.normal
                                                    : FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          ///------------------------------- Maybe----------------------
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => GuestListScreen(
                                            isMyEvent: false,
                                            eventHostUserId:
                                                objCreateEventNotifier
                                                    .EventData.lstUser!.uid!,
                                            index: 1,
                                            eventId: objCreateEventNotifier
                                                .getEventDetails.docId!)));
                              },
                              child: Container(
                                width: width * 0.29,
                                margin: EdgeInsets.all(height * 0.006),
                                padding: EdgeInsets.all(height * 0.014),
                                decoration: BoxDecoration(
                                  color: panIndex != 2
                                      ? Colors.transparent
                                      : primaryColor,
                                  borderRadius:
                                      BorderRadius.circular(height * 0.1),
                                ),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        attendance[1].toString(),
                                        style: AppTheme.getTheme()
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                                color: panIndex != 2
                                                    ? Color(0xffA5A5A5)
                                                    : ConstColor.black_Color,
                                                fontSize: width * 0.05,
                                                fontWeight: panIndex != 2
                                                    ? FontWeight.normal
                                                    : FontWeight.w700),
                                      ),
                                      Text(
                                        TextUtils.Maybe,
                                        style: AppTheme.getTheme()
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(
                                                color: panIndex != 2
                                                    ? Color(0xffA5A5A5)
                                                    : ConstColor.black_Color,
                                                fontSize: width * 0.043,
                                                fontWeight: panIndex != 2
                                                    ? FontWeight.normal
                                                    : FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          ///------------------------------- NO----------------------
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => GuestListScreen(
                                            isMyEvent: false,
                                            eventHostUserId:
                                                objCreateEventNotifier
                                                    .EventData.lstUser!.uid!,
                                            index: 2,
                                            eventId: objCreateEventNotifier
                                                .getEventDetails.docId!)));
                              },
                              child: Container(
                                width: width * 0.29,
                                margin: EdgeInsets.all(height * 0.007),
                                padding: EdgeInsets.all(height * 0.014),
                                decoration: BoxDecoration(
                                  color: panIndex != 1
                                      ? Colors.transparent
                                      : primaryColor,
                                  borderRadius:
                                      BorderRadius.circular(height * 0.1),
                                ),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        attendance[2].toString(),
                                        style: AppTheme.getTheme()
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                                color: panIndex != 1
                                                    ? Color(0xffA5A5A5)
                                                    : ConstColor.black_Color,
                                                fontSize: width * 0.05,
                                                fontWeight: panIndex != 1
                                                    ? FontWeight.normal
                                                    : FontWeight.w700),
                                      ),
                                      Text(
                                        TextUtils.No,
                                        style: AppTheme.getTheme()
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                              color: panIndex != 1
                                                  ? Color(0xffA5A5A5)
                                                  : ConstColor.black_Color,
                                              fontSize: width * 0.043,
                                              fontWeight: panIndex != 1
                                                  ? FontWeight.normal
                                                  : FontWeight.w700,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ))
            : Container(),

        // Center(
        //   child: InkWell(
        //     borderRadius: BorderRadius.circular(height * 0.02),
        //     focusColor: Color.fromARGB(255, 20, 20, 20),
        //     onTap: () => {
        //       showDialog(
        //         context: context,
        //         builder: (BuildContext context) {
        //           return StatefulBuilder(
        //             builder: (BuildContext context, setState) {
        //               return CommanDialog(1, objCreateEventNotifier);
        //             },
        //           );
        //         },
        //       ).then((value) {
        //         setState(() {
        //           index = value;
        //         });
        //       })
        //     },
        //     child: isMyEvent
        //         ? Container()
        //         : Container(
        //             padding: EdgeInsets.all(height * 0.016),
        //             margin: EdgeInsets.only(bottom: height * 0.02),
        //             decoration: BoxDecoration(
        //               color: Color.fromARGB(255, 26, 26, 26),
        //               borderRadius: BorderRadius.circular(height * 0.02),
        //             ),
        //             child: Container(
        //               child: Text(
        //                 "Change Response",
        //                 style: AppTheme.getTheme()
        //                     .textTheme
        //                     .bodyText2!
        //                     .copyWith(
        //                         color: ConstColor.white_Color,
        //                         fontSize: width * 0.04,
        //                         fontWeight: FontWeight.bold),
        //               ),
        //             ),
        //           ),
        //   ),
        // ),

        Text(
          // "diplomas, smuggling stereo equipment, and stealing tombstones to resell. Escobar also stole cars, and it was this offense that resulted in his first arrest, in 1974. As the cocaine industry grew in Colombia—thanks in part to its proximity to Peru, Ecuador, and Bolivia, major growers of coca, from which cocaine is derived—Escobar became involved in drug smuggling. In the mid-1970s he helped found the crime organization that later became known as the Medellín cartel. His notable partners included the Ochoa brothers: Juan David, Jorge Luis, and Fabio. Escobar served as head of the organization, which focused largely on the production, transport, and sale of cocaine.",
          objCreateEventNotifier.getEventDetails.description!,
          style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
              color: ConstColor.white_Color.withOpacity(0.7),
              height: 1.4,
              fontSize: width * 0.041),
        ),
      ],
    );
  }

  Widget chat(String text) {
    return Container(
      padding: EdgeInsets.only(
          left: width * 0.04,
          right: width * 0.04,
          top: height * 0.015,
          bottom: height * 0.015),
      margin: EdgeInsets.all(height * 0.01),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            height * 0.1,
          ),
          color: ConstColor.white_Color),
      child: Text(
        text,
        style: AppTheme.getTheme().textTheme.bodyText2!.copyWith(
            color: ConstColor.black_Color,
            height: 1.4,
            fontSize: width * 0.041),
      ),
    );
  }

  Widget CommanDialog(int indexs, CreateEventNotifier objCreateEventNotifier) {
    final objProviderNotifier = context.watch<AuthenicationNotifier>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(left: width * 0.04, right: width * 0.04),
          padding: EdgeInsets.only(
              top: height * 0.02,
              left: width * 0.036,
              right: width * 0.036,
              bottom: height * 0.01),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height * 0.016),
            color: Color.fromARGB(255, 15, 15, 15),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: width * 0.03),
                      child: Text(
                        "Change your response to ${indexs == 0 ? "Going" : indexs == 1 ? "Not Going" : "Maybe"}?",
                        style: AppTheme.getTheme()
                            .textTheme
                            .bodyText2!
                            .copyWith(
                                color: ConstColor.white_Color,
                                height: 1.4,
                                fontSize: width * 0.04),
                      ),
                    ),
                  ),

                  ///------------------- Close Icon--------------------
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        indexs = index;
                        panIndex = index;
                      });
                      Navigator.pop(context, indexs);
                    },
                    child: Image.asset(
                      ConstantData.close,
                      color: Colors.white,
                      height: height * 0.03,
                      width: height * 0.03,
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),

              ///------------------- Divider --------------------
              Container(
                margin:
                    EdgeInsets.only(top: height * 0.022, bottom: height * 0.01),
                height: 1,
                width: width,
                color: Color.fromARGB(255, 187, 171, 171).withOpacity(0.2),
              ),

              ///------------------- yes--------------------
              GestureDetector(
                onTap: () async {
                  setState(() {
                    attendance[index] -= 1;
                    attendance[indexs] += 1;
                    index = indexs;
                    panIndex = indexs;
                  });
                  Navigator.pop(context, indexs);
                  var objNotificationNotifier =
                      Provider.of<NotificationNotifier>(context, listen: false);

                  await getStatusResponse(index);

                  if (addGuest.isNotEmpty) {
                    addGuest.forEach((element) {
                      if (element.guestID == _auth.currentUser!.uid) {
                        element.status = index;
                      }
                    });
                    lstAlldate.forEach((element) {
                      element.guestResponse!.forEach((element2) {
                        if (element2.guestID == _auth.currentUser!.uid) {
                          element2.status = index;
                        }
                      });
                    });
                    await objCreateEventNotifier
                        .addGuestList(
                            context,
                            addGuest,
                            objCreateEventNotifier.EventData.docId!,
                            guestId,
                            lstAlldate)
                        .whenComplete(() async {
                      isLoading = false;
                      await getListOfGuestUser();
                    });
                  }

                  setState(() {
                    isLoading = false;
                  });
                  // await objNotificationNotifier.sendPushNotification(
                  //     context,
                  //     objCreateEventNotifier.getEventDetails.lstUser!.fcmToken!,
                  //     "Response to your Invitation",
                  //     "${objProviderNotifier.objUsers.firstName! + " " + objProviderNotifier.objUsers.lastName!} responded ${indexs == 0 ? "Yes" : indexs == 1 ? "No" : "Maybe"} to your event ${objCreateEventNotifier.getEventDetails.eventname}",
                  //     "eventInvite",
                  //     "",
                  //     "",
                  //     "");
                  await objNotificationNotifier.pushNotification(
                      context: context,
                      title: "Response to your Invitation",
                      description:
                          "${objProviderNotifier.objUsers.firstName! + " " + objProviderNotifier.objUsers.lastName!} responded ${indexs == 0 ? "Yes" : indexs == 1 ? "No" : "Maybe"} to your event ${objCreateEventNotifier.getEventDetails.eventname}",
                      userId:
                          objCreateEventNotifier.getEventDetails.lstUser!.uid,
                      type: "eventInvite",
                      typeOfData: [
                        {
                          "notificationType": "Invitation Response",
                          "responseSender":
                              "${objProviderNotifier.objUsers.firstName! + " " + objProviderNotifier.objUsers.lastName!}",
                          "eventId":
                              objCreateEventNotifier.getEventDetails.docId,
                          "eventName":
                              objCreateEventNotifier.getEventDetails.eventname,
                          "eventResponse": indexs == 0
                              ? "Yes"
                              : indexs == 1
                                  ? "No"
                                  : "Maybe"
                        }
                      ]);
                },
                child: Container(
                  margin: EdgeInsets.only(
                    top: height * 0.01,
                    bottom: height * 0.01,
                  ),
                  child: Text(
                    "Yes",
                    style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                        color: ConstColor.white_Color,
                        height: 1.4,
                        fontSize: width * 0.046),
                  ),
                ),
              ),

              ///------------------- no --------------------
              GestureDetector(
                onTap: () {
                  setState(() {
                    indexs = index;
                    panIndex = index;
                  });
                  Navigator.pop(context, indexs);
                },
                child: Container(
                  margin: EdgeInsets.only(
                    top: height * 0.01,
                    bottom: height * 0.01,
                  ),
                  child: Text(
                    "No",
                    style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                        color: ConstColor.white_Color,
                        height: 1.4,
                        fontSize: width * 0.046),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
