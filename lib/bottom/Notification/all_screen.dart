import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:omw/api/apiProvider.dart';
import 'package:omw/bottom/Create/seeMutiSelectedDate_screen.dart';
import 'package:omw/bottom/Events/event/eventDetails_screen.dart';
import 'package:omw/bottom/payment/payment_screen.dart';
import 'package:omw/constant/constants.dart';
import 'package:omw/constant/theme.dart';
import 'package:omw/notifier/AllChatingFunctions.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import '../../notifier/event_notifier.dart';
import '../../notifier/notication_notifier.dart';
import '../../preference/preference.dart';
import '../../utils/colorUtils.dart';
import '../../utils/textUtils.dart';
import '../Chat/IndividualChat/individual_chat_Room.dart';
import '../Profile/profile_screen.dart';

class AllScreen extends StatefulWidget {
  const AllScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AllScreen> createState() => _AllScreenState();
}

class _AllScreenState extends State<AllScreen> {
  AllChat chat = AllChat("");
  String ConversationId = "";
  getListOfNotification() async {
    currentuser = await PrefServices().getCurrentUserName();
    if (mounted) {
      setState(() {
        notificationCounterValueNotifer.value = 0;
      });
    }
    var objNotificationNotifier =
        Provider.of<NotificationNotifier>(context, listen: false);

    if (mounted) {
      setState(() {
        objNotificationNotifier.isLoading = true;
      });
    }
    await objNotificationNotifier.getListOfAllNotifications(context);
  }

  @override
  void initState() {
    isloading();
    var objNotificationNotifier =
        Provider.of<NotificationNotifier>(context, listen: false);
    objNotificationNotifier.lstNotificationModel = [];

    getListOfNotification();

    super.initState();
  }

  isloading() {
    setState(() {
      lastDocument = null;
    });
  }

  String currentuser = "";
  @override
  Widget build(BuildContext context) {
    final objCreateEventNotifier = context.watch<CreateEventNotifier>();
    final objNotificationNotifier = context.watch<NotificationNotifier>();

    return Container(
      margin: EdgeInsets.only(
        left: width * 0.01,
        right: width * 0.01,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ///---------- List OF Today's Data ------------
          objNotificationNotifier.isLoading &&
                  objNotificationNotifier.lstNotificationModel.isEmpty
              ? Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                )
              : objNotificationNotifier.lstNotificationModel.isEmpty
                  ? Container(
                      margin: EdgeInsets.only(
                          top: AppBar().preferredSize.height * 2),
                      child: Center(
                        child: Text(
                          TextUtils.noResultFound,
                          style:
                              AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                                    fontSize: width * 0.041,
                                    color: ConstColor.white_Color,
                                  ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: Consumer<NotificationNotifier>(
                        builder: (BuildContext context, value, Widget? child) {
                          return NotificationListener<ScrollEndNotification>(
                            onNotification: (scrollEnd) {
                              if (scrollEnd.metrics.atEdge &&
                                  scrollEnd.metrics.pixels > 0) {
                                print("scrollEnd");
                                getListOfNotification();
                              }
                              return true;
                            },
                            child: Stack(
                              children: [
                                objNotificationNotifier.isLoading
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: primaryColor,
                                        ),
                                      )
                                    : Container(),
                                ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: objNotificationNotifier
                                      .lstNotificationModel.length,
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        if (objNotificationNotifier
                                                .lstNotificationModel[index]
                                                .type ==
                                            "eventInvite") {
                                          setState(() {});
                                          await objCreateEventNotifier
                                              .getNotificationEventDetails(
                                                  objNotificationNotifier
                                                      .lstNotificationModel[
                                                          index]
                                                      .typeOfData!
                                                      .first["eventId"])
                                              .whenComplete(() {
                                            objCreateEventNotifier
                                                    .setEventData =
                                                objCreateEventNotifier.objEvent;
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (context,
                                                        animation1,
                                                        animation2) =>
                                                    EventDetailsScreen(
                                                  eventId:
                                                      objCreateEventNotifier
                                                          .objEvent.docId!,
                                                  hostId: objCreateEventNotifier
                                                      .objEvent.lstUser!.uid!,
                                                  isPastEvent: objCreateEventNotifier
                                                              .EventData
                                                              .eventEndDate!
                                                              .millisecondsSinceEpoch >
                                                          DateTime.now()
                                                              .toUtc()
                                                              .millisecondsSinceEpoch
                                                      ? false
                                                      : true,
                                                  isFromMyeventScreen: false,
                                                  ismyPastEvent: false,
                                                ),
                                                transitionDuration:
                                                    Duration.zero,
                                                reverseTransitionDuration:
                                                    Duration.zero,
                                              ),
                                            );
                                          });
                                        } else if (objNotificationNotifier
                                                .lstNotificationModel[index]
                                                .type ==
                                            "money transaction") {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: ((context) =>
                                                  PaymentScreen()),
                                            ),
                                          );
                                        } else if (objNotificationNotifier
                                                .lstNotificationModel[index]
                                                .type ==
                                            "Chatting") {
                                          if (mounted) {
                                            setState(
                                              () {
                                                chat = AllChat(
                                                  objNotificationNotifier
                                                      .lstNotificationModel[
                                                          index]
                                                      .createdBy!,
                                                  conversationId:
                                                      objNotificationNotifier
                                                              .lstNotificationModel[
                                                                  index]
                                                              .typeOfData![0]
                                                          ["conversationId"],
                                                );
                                              },
                                            );
                                          }
                                          chat.fetchMessages().then((value) {
                                            if (mounted) {
                                              setState(() {});
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          IndividualChatRoom(
                                                              chat: chat)));
                                            }
                                          });
                                        } else if (objNotificationNotifier
                                                .lstNotificationModel[index]
                                                .type ==
                                            "multiDate") {
                                          setState(() {});
                                          await objCreateEventNotifier
                                              .getNotificationEventDetails(
                                                  objNotificationNotifier
                                                      .lstNotificationModel[
                                                          index]
                                                      .typeOfData!
                                                      .first["eventId"])
                                              .whenComplete(() {
                                            objCreateEventNotifier
                                                    .setEventData =
                                                objCreateEventNotifier.objEvent;
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) => SeeMultiSelectedDate(
                                                        eventId:
                                                            objCreateEventNotifier
                                                                .objEvent
                                                                .docId!,
                                                        guestId:
                                                            objCreateEventNotifier
                                                                .objEvent
                                                                .guestsID!,
                                                        eventHostUserId:
                                                            objCreateEventNotifier
                                                                .objEvent
                                                                .lstUser!
                                                                .uid!)));
                                          });
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: height * 0.012,
                                            bottom: height * 0.012),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        ((context) =>
                                                            ProfileScreen(
                                                              conversationId:
                                                                  ConversationId,
                                                              fcmtoken: objNotificationNotifier
                                                                  .lstNotificationModel[
                                                                      index]
                                                                  .userDetails!
                                                                  .fcmToken!,
                                                              userId: objNotificationNotifier
                                                                  .lstNotificationModel[
                                                                      index]
                                                                  .userDetails!
                                                                  .uid!,
                                                              isOwnProfile: objNotificationNotifier
                                                                          .lstNotificationModel[
                                                                              index]
                                                                          .type ==
                                                                      "multiDate"
                                                                  ? true
                                                                  : false,
                                                              name: objNotificationNotifier
                                                                      .lstNotificationModel[
                                                                          index]
                                                                      .userDetails!
                                                                      .firstName! +
                                                                  " " +
                                                                  objNotificationNotifier
                                                                      .lstNotificationModel[
                                                                          index]
                                                                      .userDetails!
                                                                      .lastName!,
                                                              profile: objNotificationNotifier
                                                                  .lstNotificationModel[
                                                                      index]
                                                                  .userDetails!
                                                                  .userProfile!,
                                                            )),
                                                  ),
                                                );
                                              },
                                              child: Stack(
                                                alignment:
                                                    Alignment.bottomRight,
                                                children: [
                                                  ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              height * 0.1),
                                                      child: CachedNetworkImage(
                                                          imageUrl:
                                                              objNotificationNotifier
                                                                  .lstNotificationModel[
                                                                      index]
                                                                  .userDetails!
                                                                  .userProfile!,
                                                          height:
                                                              height * 0.068,
                                                          width: height * 0.068,
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
                                                ],
                                              ),
                                            ),
                                            objNotificationNotifier.lstNotificationModel[index].typeOfData![0]["notificationType"] != null &&
                                                    objNotificationNotifier
                                                                .lstNotificationModel[
                                                                    index]
                                                                .typeOfData![0][
                                                            "notificationType"] ==
                                                        "Invitation Response"
                                                ? Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: width * 0.03),
                                                      child: RichText(
                                                        text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text: objNotificationNotifier
                                                                        .lstNotificationModel[
                                                                            index]
                                                                        .typeOfData![0]
                                                                    [
                                                                    "responseSender"]!,
                                                                style: AppTheme.getTheme()
                                                                    .textTheme
                                                                    .bodyText1!
                                                                    .copyWith(
                                                                        color: ConstColor
                                                                            .primaryColor,
                                                                        height:
                                                                            1.4,
                                                                        fontSize:
                                                                            width *
                                                                                0.036),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    " responded ",
                                                                style: AppTheme.getTheme()
                                                                    .textTheme
                                                                    .bodyText1!
                                                                    .copyWith(
                                                                        color: ConstColor
                                                                            .white_Color,
                                                                        height:
                                                                            1.4,
                                                                        fontSize:
                                                                            width *
                                                                                0.036),
                                                              ),
                                                              TextSpan(
                                                                text: objNotificationNotifier
                                                                        .lstNotificationModel[
                                                                            index]
                                                                        .typeOfData![0]
                                                                    [
                                                                    "eventResponse"]!,
                                                                style: AppTheme
                                                                        .getTheme()
                                                                    .textTheme
                                                                    .bodyText1!
                                                                    .copyWith(
                                                                        color: objNotificationNotifier.lstNotificationModel[index].typeOfData![0]["eventResponse"]! ==
                                                                                "Yes"
                                                                            ? ConstColor.primaryColor
                                                                            : objNotificationNotifier.lstNotificationModel[index].typeOfData![0]["eventResponse"]! == "No"
                                                                                ? ConstColor.failColor
                                                                                : ConstColor.white_Color,
                                                                        height: 1.4,
                                                                        fontSize: width * 0.036),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    " to your event ",
                                                                style: AppTheme.getTheme()
                                                                    .textTheme
                                                                    .bodyText1!
                                                                    .copyWith(
                                                                        color: ConstColor
                                                                            .white_Color,
                                                                        height:
                                                                            1.4,
                                                                        fontSize:
                                                                            width *
                                                                                0.036),
                                                              ),
                                                              TextSpan(
                                                                text: objNotificationNotifier
                                                                        .lstNotificationModel[
                                                                            index]
                                                                        .typeOfData![0]
                                                                    [
                                                                    "eventName"]!,
                                                                style: AppTheme.getTheme()
                                                                    .textTheme
                                                                    .bodyText1!
                                                                    .copyWith(
                                                                        color: ConstColor
                                                                            .primaryColor,
                                                                        height:
                                                                            1.4,
                                                                        fontSize:
                                                                            width *
                                                                                0.036),
                                                              ),
                                                              TextSpan(
                                                                  text: "\n"),
                                                              TextSpan(
                                                                text: toBeginningOfSentenceCase(
                                                                        "${DateFormat('EEE MMM d, h:mm aa ').format(objNotificationNotifier.lstNotificationModel[index].time!)}")
                                                                    .toString()
                                                                    .replaceAll(
                                                                        "PM",
                                                                        "pm")
                                                                    .replaceAll(
                                                                        "AM",
                                                                        "am"),
                                                                // '${DateFormat('EEE, MMM dd, hh:mm aa ').format(objNotificationNotifier.lstNotificationModel[index].time!)[0].toUpperCase()}${(DateFormat('EEE, MMM d, h:m aa ').format(objNotificationNotifier.lstNotificationModel[index].time!).substring(1)).replaceAll("PM", "pm").replaceAll("AM", "am")}',
                                                                style: AppTheme
                                                                        .getTheme()
                                                                    .textTheme
                                                                    .bodyText1!
                                                                    .copyWith(
                                                                        color: Color(
                                                                            0xffCECECE),
                                                                        height:
                                                                            1.4,
                                                                        fontSize:
                                                                            width *
                                                                                0.036),
                                                              ),
                                                            ]),
                                                      ),
                                                    ),
                                                  )
                                                : objNotificationNotifier.lstNotificationModel[index].typeOfData![0]["notificationType"] !=
                                                            null &&
                                                        objNotificationNotifier.lstNotificationModel[index].typeOfData![0]["notificationType"] ==
                                                            "Invitation"
                                                    ? Expanded(
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: width *
                                                                      0.03),
                                                          child: RichText(
                                                            text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text: objNotificationNotifier
                                                                        .lstNotificationModel[
                                                                            index]
                                                                        .typeOfData![0]["eventHost"]!,
                                                                    style: AppTheme
                                                                            .getTheme()
                                                                        .textTheme
                                                                        .bodyText1!
                                                                        .copyWith(
                                                                            color: ConstColor
                                                                                .primaryColor,
                                                                            height:
                                                                                1.4,
                                                                            fontSize:
                                                                                width * 0.036),
                                                                  ),
                                                                  TextSpan(
                                                                    text:
                                                                        " invited you to the event ",
                                                                    style: AppTheme
                                                                            .getTheme()
                                                                        .textTheme
                                                                        .bodyText1!
                                                                        .copyWith(
                                                                            color: ConstColor
                                                                                .white_Color,
                                                                            height:
                                                                                1.4,
                                                                            fontSize:
                                                                                width * 0.036),
                                                                  ),
                                                                  TextSpan(
                                                                    text: objNotificationNotifier
                                                                        .lstNotificationModel[
                                                                            index]
                                                                        .typeOfData![0]["eventName"]!,
                                                                    style: AppTheme
                                                                            .getTheme()
                                                                        .textTheme
                                                                        .bodyText1!
                                                                        .copyWith(
                                                                            color: ConstColor
                                                                                .primaryColor,
                                                                            height:
                                                                                1.4,
                                                                            fontSize:
                                                                                width * 0.036),
                                                                  ),
                                                                  TextSpan(
                                                                      text:
                                                                          "\n"),
                                                                  TextSpan(
                                                                    text: toBeginningOfSentenceCase(
                                                                            "${DateFormat('EEE MMM d, h:mm aa ').format(objNotificationNotifier.lstNotificationModel[index].time!)}")
                                                                        .toString()
                                                                        .replaceAll(
                                                                            "PM",
                                                                            "pm")
                                                                        .replaceAll(
                                                                            "AM",
                                                                            "am"),
                                                                    // '${DateFormat('EEE, MMM dd, hh:mm aa ').format(objNotificationNotifier.lstNotificationModel[index].time!)[0].toUpperCase()}${(DateFormat('EEE, MMM d, h:m aa ').format(objNotificationNotifier.lstNotificationModel[index].time!).substring(1)).replaceAll("PM", "pm").replaceAll("AM", "am")}',
                                                                    style: AppTheme
                                                                            .getTheme()
                                                                        .textTheme
                                                                        .bodyText1!
                                                                        .copyWith(
                                                                            color: Color(
                                                                                0xffCECECE),
                                                                            height:
                                                                                1.4,
                                                                            fontSize:
                                                                                width * 0.036),
                                                                  ),
                                                                ]),
                                                          ),
                                                        ),
                                                      )
                                                    : objNotificationNotifier.lstNotificationModel[index].typeOfData![0]["notificationType"] !=
                                                                null &&
                                                            objNotificationNotifier
                                                                    .lstNotificationModel[index]
                                                                    .typeOfData![0]["notificationType"] ==
                                                                "Message"
                                                        ? Expanded(
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: width *
                                                                          0.03),
                                                              child: RichText(
                                                                text: TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                        text: objNotificationNotifier
                                                                            .lstNotificationModel[index]
                                                                            .typeOfData![0]["sender"]!,
                                                                        style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                                                                            color: ConstColor
                                                                                .primaryColor,
                                                                            height:
                                                                                1.4,
                                                                            fontSize:
                                                                                width * 0.036),
                                                                      ),
                                                                      TextSpan(
                                                                        text:
                                                                            " sent you a message",
                                                                        style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                                                                            color: ConstColor
                                                                                .white_Color,
                                                                            height:
                                                                                1.4,
                                                                            fontSize:
                                                                                width * 0.036),
                                                                      ),
                                                                      TextSpan(
                                                                          text:
                                                                              "\n"),
                                                                      TextSpan(
                                                                        text: toBeginningOfSentenceCase("${DateFormat('EEE MMM d, h:mm aa ').format(objNotificationNotifier.lstNotificationModel[index].time!)}")
                                                                            .toString()
                                                                            .replaceAll("PM",
                                                                                "pm")
                                                                            .replaceAll("AM",
                                                                                "am"),
                                                                        // '${DateFormat('EEE, MMM dd, hh:mm aa ').format(objNotificationNotifier.lstNotificationModel[index].time!)[0].toUpperCase()}${(DateFormat('EEE, MMM d, h:m aa ').format(objNotificationNotifier.lstNotificationModel[index].time!).substring(1)).replaceAll("PM", "pm").replaceAll("AM", "am")}',
                                                                        style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                                                                            color: Color(
                                                                                0xffCECECE),
                                                                            height:
                                                                                1.4,
                                                                            fontSize:
                                                                                width * 0.036),
                                                                      ),
                                                                    ]),
                                                              ),
                                                            ),
                                                          )
                                                        : Expanded(
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: width *
                                                                          0.03),
                                                              child: RichText(
                                                                text: TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                        text: objNotificationNotifier
                                                                            .lstNotificationModel[index]
                                                                            .description,
                                                                        style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                                                                            color: ConstColor
                                                                                .white_Color,
                                                                            height:
                                                                                1.4,
                                                                            fontSize:
                                                                                width * 0.036),
                                                                      ),
                                                                      TextSpan(
                                                                          text:
                                                                              "\n"),
                                                                      TextSpan(
                                                                        text: toBeginningOfSentenceCase("${DateFormat('EEE MMM d, h:mm aa ').format(objNotificationNotifier.lstNotificationModel[index].time!)}")
                                                                            .toString()
                                                                            .replaceAll("PM",
                                                                                "pm")
                                                                            .replaceAll("AM",
                                                                                "am"),
                                                                        // '${DateFormat('EEE, MMM dd, hh:mm aa ').format(objNotificationNotifier.lstNotificationModel[index].time!)[0].toUpperCase()}${(DateFormat('EEE, MMM d, h:m aa ').format(objNotificationNotifier.lstNotificationModel[index].time!).substring(1)).replaceAll("PM", "pm").replaceAll("AM", "am")}',
                                                                        style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                                                                            color: Color(
                                                                                0xffCECECE),
                                                                            height:
                                                                                1.4,
                                                                            fontSize:
                                                                                width * 0.036),
                                                                      ),
                                                                    ]),
                                                              ),
                                                            ),
                                                          )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
        ],
      ),
    );
  }
}
