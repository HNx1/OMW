import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:omw/model/createEvent_model.dart';
import 'package:paged_vertical_calendar/paged_vertical_calendar.dart';
import 'package:provider/provider.dart';

import '../../../constant/constants.dart';
import '../../../constant/theme.dart';
import '../../../notifier/authenication_notifier.dart';
import '../../../notifier/event_notifier.dart';
import '../../../utils/colorUtils.dart';
import '../../../utils/textUtils.dart';
import '../../Profile/drawer.dart';
import '../../bottomtab.dart';
import '../../common_BottomTab.dart';
import 'package:intl/intl.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class CalenderFilterScreen extends StatefulWidget {
  const CalenderFilterScreen({Key? key}) : super(key: key);

  @override
  State<CalenderFilterScreen> createState() => _CalenderFilterScreenState();
}

class _CalenderFilterScreenState extends State<CalenderFilterScreen> {
  @override
  void initState() {
    geteventData();

    super.initState();
  }

  List<CreateEventModel> items = [];
  List<CreateEventModel> getupcomingEventList = [];
  List listofMorningWithGoing = [];
  List resultoflistofMorningWithGoing = [];
  List listofeveningWithGoing = [];
  List resultoflistofeveningWithGoing = [];
  List listofMorningWithNotGoing = [];
  List resultoflistofMorningWithNotGoing = [];
  List listofEveningWithNotGoing = [];
  List resultoflistofEveningWithNotGoing = [];
  List<CreateEventModel> eventList = [];
  List finalEventList = [];
  geteventData() async {
    var objCreateEventNotifier =
        Provider.of<CreateEventNotifier>(context, listen: false);
    await objCreateEventNotifier.getAllEvent(
      context,
    );

    await fetchNewEvents(1, 1);
  }

  DateTime helightedDay = DateTime.now().subtract(const Duration(days: 50));
  fetchNewEvents(int year, int month) async {
    setState(() {});

    var objCreateEventNotifier =
        Provider.of<CreateEventNotifier>(context, listen: false);
    items = [];
    for (var element in objCreateEventNotifier.lstofAllEvents) {
      items.add(element);
    }
    setState(() {});
    print(items);
  }

  getevent(DateTime date) {
    var objCreateEventNotifier =
        Provider.of<CreateEventNotifier>(context, listen: false);
    listofMorningWithGoing = [];
    resultoflistofMorningWithGoing = [];
    listofeveningWithGoing = [];
    resultoflistofeveningWithGoing = [];
    listofMorningWithNotGoing = [];
    resultoflistofMorningWithNotGoing = [];
    listofEveningWithNotGoing = [];
    resultoflistofEveningWithNotGoing = [];
    finalEventList = [];
    for (var element in objCreateEventNotifier.lstofAllEvents) {
      for (var guestElement in element.guest!) {
        if (DateFormat('aa').format(element.eventStartDate!).toLowerCase() ==
                "am" &&
            element.eventStartDate!.day == date.day &&
            element.eventStartDate!.month == date.month &&
            element.eventStartDate!.year == date.year &&
            guestElement.guestID == _auth.currentUser!.uid &&
            guestElement.status == 0) {
          listofMorningWithGoing.add("YellowSun");
        }
      }
    }
    resultoflistofMorningWithGoing = listofMorningWithGoing.toSet().toList();
    if (resultoflistofMorningWithGoing.isNotEmpty) {
      finalEventList.addAll(resultoflistofMorningWithGoing);
    }

    for (var element in objCreateEventNotifier.lstofAllEvents) {
      for (var guestElement in element.guest!) {
        if ((DateFormat('aa').format(element.eventStartDate!).toLowerCase() ==
                "pm") &&
            guestElement.guestID == _auth.currentUser!.uid &&
            element.eventStartDate!.day == date.day &&
            element.eventStartDate!.month == date.month &&
            element.eventStartDate!.year == date.year &&
            guestElement.status == 0) {
          listofeveningWithGoing.add("YellowMoon");
        }
      }
    }
    resultoflistofeveningWithGoing = listofeveningWithGoing.toSet().toList();
    if (resultoflistofeveningWithGoing.isNotEmpty) {
      finalEventList.addAll(resultoflistofeveningWithGoing);
    }
    print(
        "-------------------------------------------------------------------------------------");

    for (var element in objCreateEventNotifier.lstofAllEvents) {
      for (var guestElement in element.guest!) {
        if (DateFormat('aa').format(element.eventStartDate!).toLowerCase() ==
                "am" &&
            guestElement.guestID == _auth.currentUser!.uid &&
            element.eventStartDate!.day == date.day &&
            element.eventStartDate!.month == date.month &&
            element.eventStartDate!.year == date.year &&
            guestElement.status != 0) {
          listofMorningWithNotGoing.add("GreySun");
        }
      }
    }
    // print("listofMorningWithNotGoing==> $listofMorningWithNotGoing");
    resultoflistofMorningWithNotGoing =
        listofMorningWithNotGoing.toSet().toList();
    // print(
    // "resultoflistofMorningWithNotGoing :- $resultoflistofMorningWithNotGoing");
    if (resultoflistofMorningWithNotGoing.isNotEmpty) {
      finalEventList.addAll(resultoflistofMorningWithNotGoing);
      // print("finalEventList :- $finalEventList");
    }
    for (var element in objCreateEventNotifier.lstofAllEvents) {
      for (var guestElement in element.guest!) {
        if (DateFormat('aa').format(element.eventStartDate!).toLowerCase() ==
                "pm" &&
            element.eventStartDate!.day == date.day &&
            element.eventStartDate!.month == date.month &&
            element.eventStartDate!.year == date.year &&
            guestElement.guestID == _auth.currentUser!.uid &&
            guestElement.status != 0) {
          listofEveningWithNotGoing.add("GreyMoon");
        }
      }
    }

    resultoflistofEveningWithNotGoing =
        listofEveningWithNotGoing.toSet().toList();
    if (resultoflistofEveningWithNotGoing.isNotEmpty) {
      finalEventList.addAll(resultoflistofEveningWithNotGoing);
    }
    items = [];
    for (var element in objCreateEventNotifier.lstofAllEvents) {
      items.add(element);
    }
  }

  bool iseventSelected = false;

  @override
  Widget build(BuildContext context) {
    final objAuthNotifier = context.watch<AuthenicationNotifier>();
    final objCreateEventNotifier = context.watch<CreateEventNotifier>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.getTheme().backgroundColor,

        ///------------------- Drawer------------------------
        leading: Container(
          margin: EdgeInsets.only(left: width * 0.03),
          child: GestureDetector(
            onTap: () async {
              await objAuthNotifier.getUserDetail();
              _openDrawer();
            },
            child: Image.asset(
              ConstantData.menu2,
              fit: BoxFit.contain,
            ),
          ),
        ),
        leadingWidth: height * 0.055,

        ///------------------------ OMW title-------------------------
        title: Image.asset(
          ConstantData.logo,
          height: height * 0.12,
          width: height * 0.12,
          fit: BoxFit.contain,
        ),
        //  Text(
        //   TextUtils.Omw,
        //   style: AppTheme.getTheme().textTheme.subtitle1!.copyWith(
        //         color: primaryColor,
        //         fontWeight: FontWeight.w700,
        //         fontSize: width * 0.09,
        //       ),
        // ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        const BottomNavBarScreen(
                      index: 1,
                      lastIndex: 1,
                    ),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ));
            },
            child: Container(
              margin: EdgeInsets.only(right: width * 0.03),
              color: Colors.transparent,
              child: Row(
                children: [
                  Image.asset(ConstantData.menu,
                      height: height * 0.037,
                      fit: BoxFit.cover,
                      color: primaryColor),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: PersistanceBottomTab(
        lastIndex: 1,
        index: 1,
        onSuccess: (val) {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  BottomNavBarScreen(index: val, lastIndex: val),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        },
      ),
      body: Stack(
        children: [
          objCreateEventNotifier.isLoading == true && items.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                )
              : Container(),
          PagedVerticalCalendar(
            addAutomaticKeepAlives: true,
            // minDate: DateTime.now(),
            onMonthLoaded: fetchNewEvents,
            monthBuilder: (context, month, year) {
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: height * 0.02),
                    child: Text(
                      DateFormat('MMMM yyyy').format(DateTime(year, month)),
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: Colors.white, fontSize: width * 0.055),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        weekText('Mon'),
                        weekText('Tue'),
                        weekText('Wed'),
                        weekText('Thu'),
                        weekText('Fri'),
                        weekText('Sat'),
                        weekText('Sun'),
                      ],
                    ),
                  ),
                ],
              );
            },
            dayBuilder: (context, date) {
              getevent(date);
              DateTime now = DateTime.now();

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  helightedDay.day == date.day &&
                          helightedDay.month == date.month &&
                          helightedDay.year == date.year
                      ? Container(
                          padding: EdgeInsets.all(width * 0.015),
                          decoration: BoxDecoration(
                              border: Border.all(color: primaryColor),
                              borderRadius:
                                  BorderRadius.circular(height * 0.008)),
                          child: Text(
                            DateFormat('d').format(date),
                            style: AppTheme.getTheme()
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    fontSize: width * 0.038,
                                    color: ConstColor.white_Color,
                                    fontWeight: FontWeight.w400),
                          ),
                        )
                      : Text(
                          DateFormat('d').format(date),
                          style:
                              AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                                    fontSize: width * 0.038,
                                    color: now.day == date.day &&
                                            now.month == date.month &&
                                            now.year == date.year
                                        ? ConstColor.primaryColor
                                        : ConstColor.white_Color,
                                  ),
                        ),
                  Expanded(
                    child: Wrap(
                      children: finalEventList.map((event) {
                        return Container(
                          margin: EdgeInsets.all(height * 0.001),
                          child: event == "YellowSun"
                              ? Icon(
                                  Icons.sunny,
                                  color: primaryColor,
                                  size: height * 0.019,
                                )
                              : event == "YellowMoon"
                                  ? Icon(
                                      Icons.mode_night_rounded,
                                      color: primaryColor,
                                      size: height * 0.019,
                                    )
                                  : event == "GreySun"
                                      ? Icon(
                                          Icons.sunny,
                                          color: Colors.grey[400],
                                          size: height * 0.019,
                                        )
                                      : Icon(
                                          Icons.mode_night_rounded,
                                          color: Colors.grey[400],
                                          size: height * 0.019,
                                        ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            },
            onDayPressed: (day) {
              setState(() {
                iseventSelected = true;
              });
              eventList = [];

              eventList.addAll(items.where((e) =>
                  e.eventStartDate!.day == day.day &&
                  e.eventStartDate!.month == day.month &&
                  e.eventStartDate!.year == day.year));

              setState(() {
                helightedDay = day;
              });
              setState(() {});
              print('items this day: $eventList');
            },
          ),
          iseventSelected == true && eventList.isNotEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          top: height * 0.02, bottom: height * 0.02),
                      color: Colors.black,
                      height: height * 0.33,
                      child: SingleChildScrollView(
                        child: ListView.builder(
                          itemCount: eventList.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(height * 0.015),
                                  border: Border.all(color: Colors.grey)),
                              margin: EdgeInsets.only(
                                  top: height * 0.005,
                                  bottom: height * 0.005,
                                  left: width * 0.03,
                                  right: width * 0.03),
                              padding: EdgeInsets.all(height * 0.01),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(height * 0.015),
                                    child: CachedNetworkImage(
                                      imageUrl: eventList[index].eventPhoto!,
                                      height: height * 0.13,
                                      width: height * 0.13,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: const [
                                          CircularProgressIndicator(
                                            color: primaryColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(left: width * 0.03),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            eventList[index].eventname!,
                                            style: AppTheme.getTheme()
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                    fontSize: width * 0.035,
                                                    color:
                                                        ConstColor.white_Color,
                                                    fontWeight:
                                                        FontWeight.w400),
                                          ),

                                          ///-------------- image and  create by --------------
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: height * 0.01),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            height * 0.1),
                                                    child: CachedNetworkImage(
                                                        imageUrl:
                                                            eventList[index]
                                                                .lstUser!
                                                                .userProfile!,
                                                        height: height * 0.035,
                                                        width: height * 0.035,
                                                        fit: BoxFit.cover,
                                                        placeholder: (context,
                                                                url) =>
                                                            const CircularProgressIndicator(
                                                              color:
                                                                  primaryColor,
                                                            ))),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: width * 0.02),
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
                                                                fontSize:
                                                                    width *
                                                                        0.032,
                                                                color: ConstColor
                                                                    .white_Color
                                                                    .withOpacity(
                                                                        0.37)),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top:
                                                                height * 0.005),
                                                        child: Text(
                                                          "${eventList[index]
                                                                  .lstUser!
                                                                  .firstName!} ${eventList[index]
                                                                  .lstUser!
                                                                  .lastName!}",
                                                          style: AppTheme
                                                                  .getTheme()
                                                              .textTheme
                                                              .bodyText1!
                                                              .copyWith(
                                                                  fontSize:
                                                                      width *
                                                                          0.036,
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

                                          ///------------------------- event time-----------------
                                          Row(
                                            children: [
                                              Image.asset(
                                                ConstantData.watch2,
                                                height: height * 0.015,
                                                color: ConstColor.white_Color,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      top: width * 0.02,
                                                      left: width * 0.02),
                                                  child: Text(
                                                    '${DateFormat(TextUtils.dateFormat).format(eventList[index].eventStartDate!)[0].toUpperCase()}${(DateFormat(TextUtils.dateFormat).format(eventList[index].eventStartDate!).substring(1, 4)).toLowerCase()}${DateFormat(TextUtils.dateFormat).format(eventList[index].eventStartDate!)[4].toUpperCase()}${DateFormat(TextUtils.dateFormat).format(eventList[index].eventStartDate!).substring(5).toLowerCase()}${DateFormat(' - h:mm aa')
                                                            .format(eventList[
                                                                    index]
                                                                .eventEndDate!)
                                                            .toLowerCase()}',
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: AppTheme.getTheme()
                                                        .textTheme
                                                        .bodyText1!
                                                        .copyWith(
                                                            decoration:
                                                                TextDecoration
                                                                    .none,
                                                            color: ConstColor
                                                                .white_Color,
                                                            fontSize:
                                                                width * 0.032),
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
                                                  MainAxisAlignment.start,
                                              children: [
                                                Image.asset(
                                                  ConstantData.location2,
                                                  height: height * 0.02,
                                                  color: ConstColor.white_Color,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        left: width * 0.02),
                                                    child: Text(
                                                      eventList[index]
                                                          .location!,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                                                  .white_Color,
                                                              fontSize: width *
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
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Widget weekText(String text) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        text,
        style: AppTheme.getTheme()
            .textTheme
            .bodyText2!
            .copyWith(color: Colors.grey, fontSize: width * 0.03),
      ),
    );
  }

  _openDrawer() {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 0),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return const CommonDrawer();
      },
    );
  }
}
