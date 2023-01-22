import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/api_provider.dart';
import '../../constant/constants.dart';
import '../../constant/theme.dart';
import '../../notifier/AllChatingFunctions.dart';
import '../../notifier/event_notifier.dart';
import '../../notifier/notication_notifier.dart';
import '../../preference/preference.dart';
import '../../utils/colorUtils.dart';
import '../../utils/textUtils.dart';
import '../Events/event/eventDetails_screen.dart';
import 'package:intl/intl.dart';

import '../Profile/profile_screen.dart';

class InvitationsScreen extends StatefulWidget {
  const InvitationsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<InvitationsScreen> createState() => _InvitationsScreenState();
}

class _InvitationsScreenState extends State<InvitationsScreen> {
  List<AllChat> chats = [];
  AllChat chat = AllChat("");
  getListOfinvitationsNotification() async {
    currentuser = PrefServices().getCurrentUserName();
    var objNotificationNotifier =
        Provider.of<NotificationNotifier>(context, listen: false);

    if (mounted) {
      setState(() {
        objNotificationNotifier.isLoading = true;
      });
    }
    objNotificationNotifier.getListOfInvitationsNotifications(context);
  }

  @override
  void initState() {
    isloading();
    var objNotificationNotifier =
        Provider.of<NotificationNotifier>(context, listen: false);
    objNotificationNotifier.lstInvitationsNotificationModel = [];
    getListOfinvitationsNotification();

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
                  objNotificationNotifier
                      .lstInvitationsNotificationModel.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                )
              : objNotificationNotifier.lstInvitationsNotificationModel.isEmpty
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
                                getListOfinvitationsNotification();
                              }
                              return true;
                            },
                            child: Stack(
                              children: [
                                objNotificationNotifier.isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: primaryColor,
                                        ),
                                      )
                                    : Container(),
                                ListView.builder(
                                  // controller: scrollController,
                                  padding: EdgeInsets.zero,
                                  itemCount: objNotificationNotifier
                                      .lstInvitationsNotificationModel.length,
                                  shrinkWrap: true,

                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        setState(() {});
                                        await objCreateEventNotifier
                                            .getNotificationEventDetails(
                                                objNotificationNotifier
                                                    .lstInvitationsNotificationModel[
                                                        index]
                                                    .typeOfData!
                                                    .first["eventId"])
                                            .whenComplete(() {
                                          objCreateEventNotifier.setEventData =
                                              objCreateEventNotifier.objEvent;
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation1,
                                                      animation2) =>
                                                  EventDetailsScreen(
                                                eventId: objCreateEventNotifier
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
                                              transitionDuration: Duration.zero,
                                              reverseTransitionDuration:
                                                  Duration.zero,
                                            ),
                                          );
                                        });
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
                                                    builder: ((context) =>
                                                        ProfileScreen(
                                                          fcmtoken:
                                                              objNotificationNotifier
                                                                  .lstInvitationsNotificationModel[
                                                                      index]
                                                                  .userDetails!
                                                                  .fcmToken!,
                                                          userId: objNotificationNotifier
                                                              .lstInvitationsNotificationModel[
                                                                  index]
                                                              .userDetails!
                                                              .uid!,
                                                          isOwnProfile: false,
                                                          name:
                                                              "${objNotificationNotifier.lstInvitationsNotificationModel[index].userDetails!.firstName!} ${objNotificationNotifier.lstInvitationsNotificationModel[index].userDetails!.lastName!}",
                                                          profile:
                                                              objNotificationNotifier
                                                                  .lstInvitationsNotificationModel[
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
                                                                  .lstInvitationsNotificationModel[
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
                                                                    children: const [
                                                                      CircularProgressIndicator(
                                                                        color:
                                                                            primaryColor,
                                                                      ),
                                                                    ],
                                                                  ))),
                                                ],
                                              ),
                                            ),
                                            objNotificationNotifier.lstInvitationsNotificationModel[index].typeOfData![0]["notificationType"] != null &&
                                                    objNotificationNotifier
                                                                .lstInvitationsNotificationModel[
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
                                                                        .lstInvitationsNotificationModel[
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
                                                                        .lstInvitationsNotificationModel[
                                                                            index]
                                                                        .typeOfData![0]
                                                                    [
                                                                    "eventResponse"]!,
                                                                style: AppTheme
                                                                        .getTheme()
                                                                    .textTheme
                                                                    .bodyText1!
                                                                    .copyWith(
                                                                        color: objNotificationNotifier.lstInvitationsNotificationModel[index].typeOfData![0]["eventResponse"]! ==
                                                                                "Yes"
                                                                            ? ConstColor.primaryColor
                                                                            : objNotificationNotifier.lstInvitationsNotificationModel[index].typeOfData![0]["eventResponse"]! == "No"
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
                                                                        .lstInvitationsNotificationModel[
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
                                                              const TextSpan(
                                                                  text: "\n"),
                                                              TextSpan(
                                                                text: toBeginningOfSentenceCase(DateFormat('EEE MMM d, h:mm aa ').format(objNotificationNotifier
                                                                        .lstInvitationsNotificationModel[
                                                                            index]
                                                                        .time!))
                                                                    .toString()
                                                                    .replaceAll(
                                                                        "PM",
                                                                        "pm")
                                                                    .replaceAll(
                                                                        "AM",
                                                                        "am"),
                                                                // '${DateFormat('EEE, MMM dd, hh:mm aa ').format(objNotificationNotifier.lstInvitationsNotificationModel[index].time!)[0].toUpperCase()}${(DateFormat('EEE, MMM d, h:m aa ').format(objNotificationNotifier.lstInvitationsNotificationModel[index].time!).substring(1)).replaceAll("PM", "pm").replaceAll("AM", "am")}',
                                                                style: AppTheme
                                                                        .getTheme()
                                                                    .textTheme
                                                                    .bodyText1!
                                                                    .copyWith(
                                                                        color: const Color(
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
                                                : objNotificationNotifier.lstInvitationsNotificationModel[index].typeOfData![0]["notificationType"] !=
                                                            null &&
                                                        objNotificationNotifier.lstInvitationsNotificationModel[index].typeOfData![0]["notificationType"] ==
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
                                                                        .lstInvitationsNotificationModel[
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
                                                                        .lstInvitationsNotificationModel[
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
                                                                  const TextSpan(
                                                                      text:
                                                                          "\n"),
                                                                  TextSpan(
                                                                    text: toBeginningOfSentenceCase(DateFormat('EEE MMM d, h:mm aa ').format(objNotificationNotifier
                                                                            .lstInvitationsNotificationModel[
                                                                                index]
                                                                            .time!))
                                                                        .toString()
                                                                        .replaceAll(
                                                                            "PM",
                                                                            "pm")
                                                                        .replaceAll(
                                                                            "AM",
                                                                            "am"),
                                                                    // '${DateFormat('EEE, MMM dd, hh:mm aa ').format(objNotificationNotifier.lstInvitationsNotificationModel[index].time!)[0].toUpperCase()}${(DateFormat('EEE, MMM d, h:m aa ').format(objNotificationNotifier.lstInvitationsNotificationModel[index].time!).substring(1)).replaceAll("PM", "pm").replaceAll("AM", "am")}',
                                                                    style: AppTheme
                                                                            .getTheme()
                                                                        .textTheme
                                                                        .bodyText1!
                                                                        .copyWith(
                                                                            color: const Color(
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
                                                    : objNotificationNotifier.lstInvitationsNotificationModel[index].typeOfData![0]["notificationType"] !=
                                                                null &&
                                                            objNotificationNotifier
                                                                    .lstInvitationsNotificationModel[index]
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
                                                                            .lstInvitationsNotificationModel[index]
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
                                                                      const TextSpan(
                                                                          text:
                                                                              "\n"),
                                                                      TextSpan(
                                                                        text: toBeginningOfSentenceCase(DateFormat('EEE MMM d, h:mm aa ').format(objNotificationNotifier.lstInvitationsNotificationModel[index].time!))
                                                                            .toString()
                                                                            .replaceAll("PM",
                                                                                "pm")
                                                                            .replaceAll("AM",
                                                                                "am"),
                                                                        // '${DateFormat('EEE, MMM dd, hh:mm aa ').format(objNotificationNotifier.lstInvitationsNotificationModel[index].time!)[0].toUpperCase()}${(DateFormat('EEE, MMM d, h:m aa ').format(objNotificationNotifier.lstInvitationsNotificationModel[index].time!).substring(1)).replaceAll("PM", "pm").replaceAll("AM", "am")}',
                                                                        style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                                                                            color: const Color(
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
                                                                            .lstInvitationsNotificationModel[index]
                                                                            .description,
                                                                        style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                                                                            color: ConstColor
                                                                                .white_Color,
                                                                            height:
                                                                                1.4,
                                                                            fontSize:
                                                                                width * 0.036),
                                                                      ),
                                                                      const TextSpan(
                                                                          text:
                                                                              "\n"),
                                                                      TextSpan(
                                                                        text: toBeginningOfSentenceCase(DateFormat('EEE MMM d, h:mm aa ').format(objNotificationNotifier.lstInvitationsNotificationModel[index].time!))
                                                                            .toString()
                                                                            .replaceAll("PM",
                                                                                "pm")
                                                                            .replaceAll("AM",
                                                                                "am"),
                                                                        // '${DateFormat('EEE, MMM dd, hh:mm aa ').format(objNotificationNotifier.lstInvitationsNotificationModel[index].time!)[0].toUpperCase()}${(DateFormat('EEE, MMM d, h:m aa ').format(objNotificationNotifier.lstInvitationsNotificationModel[index].time!).substring(1)).replaceAll("PM", "pm").replaceAll("AM", "am")}',
                                                                        style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                                                                            color: const Color(
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
