import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:omw/bottom/Events/event/eventDetails_screen.dart';
import 'package:omw/utils/colorUtils.dart';
import 'package:omw/utils/textUtils.dart';
import 'package:provider/provider.dart';

import '../../../api/apiProvider.dart';
import '../../../constant/constants.dart';
import '../../../constant/theme.dart';
import '../../../model/createEvent_model.dart';
import '../../../notifier/event_notifier.dart';
import 'package:intl/intl.dart';

class UpComingScreen extends StatefulWidget {
  final List<CreateEventModel> getList;
  final String currentuser;

  final bool isLoading;
  final bool isFilteredData;

  UpComingScreen(
      {Key? key,
      required this.getList,
      required this.isLoading,
      required this.isFilteredData,
      required this.currentuser})
      : super(key: key);

  @override
  State<UpComingScreen> createState() => _UpComingScreenState();
}

class _UpComingScreenState extends State<UpComingScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // isloading();
    getUpcomingEvents();
    super.initState();
  }

  getUpcomingEvents() async {
    var objCreateEventNotifier =
        Provider.of<CreateEventNotifier>(context, listen: false);
    if (mounted) {
      setState(() {
        objCreateEventNotifier.isLoading = true;
      });
    }
    await objCreateEventNotifier.getListOfUpcomingEvent(
      context,
    );
    if (mounted) {
      setState(() {
        objCreateEventNotifier.isLoading = false;
      });
    }
  }

  // isloading() {
  //   var objCreateEventNotifier =
  //       Provider.of<CreateEventNotifier>(context, listen: false);
  //   setState(() {
  //     lastUpComingEventsDocument = null;
  //   });
  //   objCreateEventNotifier.getupcomingEventList = [];
  // }

  @override
  Widget build(BuildContext context) {
    final objCreateEventNotifier = context.watch<CreateEventNotifier>();
    return widget.getList.isEmpty && widget.isFilteredData == false
        ? UpCommingList(objCreateEventNotifier)
        : filteredUpCommingList(objCreateEventNotifier);
  }

  Widget UpCommingList(CreateEventNotifier objCreateEventNotifier) {
    return Expanded(
      child: objCreateEventNotifier.isLoading == true &&
              objCreateEventNotifier.getupcomingEventList.isEmpty
          ? Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            )
          : objCreateEventNotifier.getupcomingEventList.isEmpty
              ? Container(
                  margin:
                      EdgeInsets.only(top: AppBar().preferredSize.height * 2),
                  child: Center(
                    child: Text(
                      "No Upcoming Result Found",
                      style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                            fontSize: width * 0.041,
                            color: ConstColor.white_Color,
                          ),
                    ),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.only(bottom: height * 0.04),
                  itemCount: objCreateEventNotifier.getupcomingEventList.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        for (var i = 0;
                            i <
                                objCreateEventNotifier
                                    .getupcomingEventList[index].guest!.length;
                            i++)
                          objCreateEventNotifier.getupcomingEventList[index]
                                      .guest![i].guestID ==
                                  _auth.currentUser!.uid
                              ? objCreateEventNotifier
                                          .getupcomingEventList[index]
                                          .guest![i]
                                          .status ==
                                      1
                                  ? Container()
                                  : GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          objCreateEventNotifier.setEventData =
                                              objCreateEventNotifier
                                                  .getupcomingEventList[index];
                                        });
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation1,
                                                    animation2) =>
                                                EventDetailsScreen(
                                              eventId: objCreateEventNotifier
                                                  .getupcomingEventList[index]
                                                  .docId!,
                                              hostId: objCreateEventNotifier
                                                  .getupcomingEventList[index]
                                                  .lstUser!
                                                  .uid!,
                                              isPastEvent: false,
                                              isFromMyeventScreen: false,
                                              ismyPastEvent: false,
                                            ),
                                            transitionDuration: Duration.zero,
                                            reverseTransitionDuration:
                                                Duration.zero,
                                          ),
                                        ).then((value) async {
                                          await objCreateEventNotifier
                                              .getListOfUpcomingEvent(context);
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              height * 0.015),
                                          border: Border.all(
                                              color: objCreateEventNotifier
                                                          .getupcomingEventList[
                                                              index]
                                                          .guest![i]
                                                          .status ==
                                                      0
                                                  ? primaryColor
                                                  : objCreateEventNotifier
                                                              .getupcomingEventList[
                                                                  index]
                                                              .guest![i]
                                                              .status ==
                                                          1
                                                      ? Colors.red
                                                      : Colors.grey.shade100),
                                        ),
                                        margin: EdgeInsets.only(
                                            top: height * 0.005,
                                            bottom: height * 0.005,
                                            left: width * 0.03,
                                            right: width * 0.03),
                                        padding: EdgeInsets.all(height * 0.01),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      height * 0.015),
                                              child: CachedNetworkImage(
                                                imageUrl: objCreateEventNotifier
                                                    .getupcomingEventList[index]
                                                    .eventPhoto!,
                                                height: height * 0.13,
                                                width: height * 0.13,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    CircularProgressIndicator(
                                                      color: primaryColor,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    left: width * 0.03,
                                                    top: height * 0.01,
                                                    bottom: height * 0.01),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      objCreateEventNotifier
                                                          .getupcomingEventList[
                                                              index]
                                                          .eventname!,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: AppTheme.getTheme()
                                                          .textTheme
                                                          .bodyText2!
                                                          .copyWith(
                                                            fontSize:
                                                                width * 0.037,
                                                            color: ConstColor
                                                                .white_Color,
                                                          ),
                                                    ),

                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: height * 0.01),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Hosted by",
                                                            style: AppTheme
                                                                    .getTheme()
                                                                .textTheme
                                                                .bodyText1!
                                                                .copyWith(
                                                                    fontSize:
                                                                        width *
                                                                            0.032,
                                                                    color: ConstColor
                                                                        .white_Color
                                                                        .withOpacity(
                                                                            0.37)),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: height *
                                                                          0.005),
                                                              child: Text(
                                                                "${objCreateEventNotifier.getupcomingEventList[index].lstUser!.firstName![0].toUpperCase()}${objCreateEventNotifier.getupcomingEventList[index].lstUser!.firstName!.substring(1).toLowerCase()}" +
                                                                    " " +
                                                                    (objCreateEventNotifier
                                                                            .getupcomingEventList[index]
                                                                            .lstUser!
                                                                            .lastName!
                                                                            .isEmpty
                                                                        ? ""
                                                                        : "${objCreateEventNotifier.getupcomingEventList[index].lstUser!.lastName![0].toUpperCase()}${objCreateEventNotifier.getupcomingEventList[index].lstUser!.lastName!.substring(1).toLowerCase()}"),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: AppTheme
                                                                        .getTheme()
                                                                    .textTheme
                                                                    .bodyText1!
                                                                    .copyWith(
                                                                        fontSize:
                                                                            width *
                                                                                0.035,
                                                                        color: ConstColor
                                                                            .white_Color),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    ///------------------------- event time-----------------
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                        top: width * 0.02,
                                                      ),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Image.asset(
                                                            ConstantData.watch2,
                                                            height:
                                                                height * 0.015,
                                                            color: ConstColor
                                                                .white_Color,
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: width *
                                                                          0.02),
                                                              child: Text(
                                                                (objCreateEventNotifier.getupcomingEventList[index].isDatePoll ==
                                                                            null
                                                                        ? false
                                                                        : objCreateEventNotifier
                                                                            .getupcomingEventList[
                                                                                index]
                                                                            .isDatePoll!)
                                                                    ? "Date Poll"
                                                                    : '${DateFormat(TextUtils.dateFormat).format(objCreateEventNotifier.getupcomingEventList[index].eventStartDate!)[0].toUpperCase()}${(DateFormat(TextUtils.dateFormat).format(objCreateEventNotifier.getupcomingEventList[index].eventStartDate!).substring(1, 4)).toLowerCase()}${DateFormat(TextUtils.dateFormat).format(objCreateEventNotifier.getupcomingEventList[index].eventStartDate!)[4].toUpperCase()}${(DateFormat(TextUtils.dateFormat).format(objCreateEventNotifier.getupcomingEventList[index].eventStartDate!).substring(5)).toLowerCase()}' +
                                                                        DateFormat(' - h:mm aa')
                                                                            .format(objCreateEventNotifier.getupcomingEventList[index].eventEndDate!)
                                                                            .toLowerCase(),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
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
                                                                                0.032),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    ///------------------------- event location--------------------

                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: height * 0.01),
                                                      child: Row(
                                                        children: [
                                                          Image.asset(
                                                            ConstantData
                                                                .location2,
                                                            height:
                                                                height * 0.02,
                                                            color: ConstColor
                                                                .white_Color,
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: width *
                                                                          0.02),
                                                              child: Text(
                                                                objCreateEventNotifier
                                                                    .getupcomingEventList[
                                                                        index]
                                                                    .location!,
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                                                                    height: 1.2,
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
                                            Container(
                                                height: height * 0.15,
                                                child: objCreateEventNotifier
                                                                .getupcomingEventList[
                                                                    index]
                                                                .cohostList ==
                                                            null ||
                                                        _auth.currentUser ==
                                                            null
                                                    ? Container()
                                                    : objCreateEventNotifier
                                                            .getupcomingEventList[
                                                                index]
                                                            .cohostList!
                                                            .contains(_auth
                                                                .currentUser!
                                                                .uid)
                                                        ? Text(
                                                            "Host",
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: AppTheme
                                                                    .getTheme()
                                                                .textTheme
                                                                .bodyText1!
                                                                .copyWith(
                                                                    height: 1.2,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .none,
                                                                    color: ConstColor
                                                                        .primaryColor,
                                                                    fontSize:
                                                                        width *
                                                                            0.036),
                                                          )
                                                        : Container()),
                                          ],
                                        ),
                                      ))
                              : Container(),
                      ],
                    );
                  },
                ),
    );
  }

  Widget filteredUpCommingList(CreateEventNotifier objCreateEventNotifier) {
    return Expanded(
      child: widget.isLoading == true && widget.getList.isEmpty
          ? Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            )
          : widget.getList.isEmpty
              ? Container(
                  margin:
                      EdgeInsets.only(top: AppBar().preferredSize.height * 2),
                  child: Center(
                    child: Text(
                      "No Upcoming Filtered Result Found",
                      style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                            fontSize: width * 0.041,
                            color: ConstColor.white_Color,
                          ),
                    ),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.only(bottom: height * 0.04),
                  itemCount: widget.getList.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        for (var i = 0;
                            i < widget.getList[index].guest!.length;
                            i++)
                          widget.getList[index].guest![i].guestID ==
                                  _auth.currentUser!.uid
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      objCreateEventNotifier.setEventData =
                                          widget.getList[index];
                                    });
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (context, animation1, animation2) =>
                                                EventDetailsScreen(
                                          eventId: widget.getList[index].docId!,
                                          hostId: widget
                                              .getList[index].lstUser!.uid!,
                                          isPastEvent: false,
                                          isFromMyeventScreen: false,
                                          ismyPastEvent: false,
                                        ),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration:
                                            Duration.zero,
                                      ),
                                    ).then((value) async {
                                      setState(() {});
                                      await objCreateEventNotifier
                                          .getListOfUpcomingEvent(context);
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(height * 0.015),
                                      border: Border.all(
                                          color: widget.getList[index].guest![i]
                                                      .status ==
                                                  0
                                              ? primaryColor
                                              : widget.getList[index].guest![i]
                                                          .status ==
                                                      1
                                                  ? Colors.red
                                                  : Colors.grey.shade100),
                                    ),
                                    margin: EdgeInsets.only(
                                        top: height * 0.005,
                                        bottom: height * 0.005,
                                        left: width * 0.03,
                                        right: width * 0.03),
                                    padding: EdgeInsets.all(height * 0.01),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              height * 0.015),
                                          child: CachedNetworkImage(
                                            imageUrl: widget
                                                .getList[index].eventPhoto!,
                                            height: height * 0.13,
                                            width: height * 0.13,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                CircularProgressIndicator(
                                                  color: primaryColor,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: width * 0.03),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [],
                                                ),
                                                Text(
                                                  widget.getList[index]
                                                      .eventname!,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: AppTheme.getTheme()
                                                      .textTheme
                                                      .bodyText2!
                                                      .copyWith(
                                                        fontSize: width * 0.037,
                                                        color: ConstColor
                                                            .white_Color,
                                                      ),
                                                ),

                                                ///-------------- image and  create by --------------

                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: height * 0.01),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "Hosted by",
                                                        style: AppTheme
                                                                .getTheme()
                                                            .textTheme
                                                            .bodyText1!
                                                            .copyWith(
                                                                fontSize:
                                                                    width *
                                                                        0.032,
                                                                color: ConstColor
                                                                    .white_Color
                                                                    .withOpacity(
                                                                        0.37)),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: height *
                                                                      0.005),
                                                          child: Text(
                                                            "${widget.getList[index].lstUser!.firstName![0].toUpperCase()}${widget.getList[index].lstUser!.firstName!.substring(1).toLowerCase()}" +
                                                                " " +
                                                                (widget
                                                                        .getList[
                                                                            index]
                                                                        .lstUser!
                                                                        .lastName!
                                                                        .isEmpty
                                                                    ? ""
                                                                    : "${widget.getList[index].lstUser!.lastName![0].toUpperCase()}${widget.getList[index].lstUser!.lastName!.substring(1).toLowerCase()}"),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: AppTheme
                                                                    .getTheme()
                                                                .textTheme
                                                                .bodyText1!
                                                                .copyWith(
                                                                    fontSize:
                                                                        width *
                                                                            0.035,
                                                                    color: ConstColor
                                                                        .white_Color),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                ///------------------------- event time-----------------
                                                Container(
                                                  margin: EdgeInsets.only(
                                                    top: width * 0.02,
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Image.asset(
                                                        ConstantData.watch2,
                                                        height: height * 0.015,
                                                        color: ConstColor
                                                            .white_Color,
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: width *
                                                                      0.02),
                                                          child: Text(
                                                            (widget.getList[index].isDatePoll ==
                                                                        null
                                                                    ? false
                                                                    : widget
                                                                        .getList[
                                                                            index]
                                                                        .isDatePoll!)
                                                                ? "Date Poll"
                                                                : '${DateFormat(TextUtils.dateFormat).format(widget.getList[index].eventStartDate!)[0].toUpperCase()}${(DateFormat(TextUtils.dateFormat).format(widget.getList[index].eventStartDate!).substring(1, 4)).toLowerCase()}${DateFormat(TextUtils.dateFormat).format(widget.getList[index].eventStartDate!)[4].toUpperCase()}${(DateFormat(TextUtils.dateFormat).format(widget.getList[index].eventStartDate!).substring(5)).toLowerCase()}' +
                                                                    DateFormat(
                                                                            ' - h:mm aa')
                                                                        .format(widget
                                                                            .getList[index]
                                                                            .eventEndDate!)
                                                                        .toLowerCase(),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
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
                                                                            0.032),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                ///------------------------- event location--------------------

                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: height * 0.01),
                                                  child: Row(
                                                    children: [
                                                      Image.asset(
                                                        ConstantData.location2,
                                                        height: height * 0.02,
                                                        color: ConstColor
                                                            .white_Color,
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: width *
                                                                      0.02),
                                                          child: Text(
                                                            widget
                                                                .getList[index]
                                                                .location!,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: AppTheme
                                                                    .getTheme()
                                                                .textTheme
                                                                .bodyText1!
                                                                .copyWith(
                                                                    height: 1.2,
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
                                        Container(
                                            height: height * 0.15,
                                            child: widget.getList[index]
                                                            .cohostList ==
                                                        null ||
                                                    _auth.currentUser == null
                                                ? Container()
                                                : widget.getList[index]
                                                        .cohostList!
                                                        .contains(_auth
                                                            .currentUser!.uid)
                                                    ? Text(
                                                        "Host",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: AppTheme.getTheme()
                                                            .textTheme
                                                            .bodyText1!
                                                            .copyWith(
                                                                height: 1.2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                decoration:
                                                                    TextDecoration
                                                                        .none,
                                                                color: ConstColor
                                                                    .primaryColor,
                                                                fontSize:
                                                                    width *
                                                                        0.036),
                                                      )
                                                    : Container()),
                                      ],
                                    ),
                                  ))
                              : Container(),
                      ],
                    );
                  },
                ),
    );
  }
}
