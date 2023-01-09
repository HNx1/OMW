import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:omw/authentication/loginScreen.dart';
import 'package:omw/bottom/Events/event/pastFilter.dart';
import 'package:omw/bottom/Events/event/past_screen.dart';
import 'package:omw/bottom/Events/event/searchEvent_screen.dart';
import 'package:omw/bottom/Events/event/upcomingFilter.dart';
import 'package:omw/bottom/Events/event/upcoming_screen.dart';
import 'package:omw/main.dart';
import 'package:omw/notifier/authenication_notifier.dart';
import 'package:omw/preference/preference.dart';
import 'package:provider/provider.dart';

import '../../../api/apiProvider.dart';
import '../../../constant/constants.dart';
import '../../../constant/theme.dart';
import '../../../model/createEvent_model.dart';
import '../../../model/user_model.dart';
import '../../../notifier/event_notifier.dart';
import '../../../setting/change_myEmail_screen.dart';
import '../../../utils/colorUtils.dart';
import '../../../utils/textUtils.dart';
import '../../../widget/routesFile.dart';
import '../../Profile/drawer.dart';
import 'calenderFilter.dart';
import 'eventDetails_screen.dart';

class EventsSceen extends StatefulWidget {
  final DynamicLinkArguments? dynamicLinkArguments;
  const EventsSceen({Key? key, this.dynamicLinkArguments}) : super(key: key);

  @override
  State<EventsSceen> createState() => _EventsSceenState();
}

class _EventsSceenState extends State<EventsSceen> {
  String currentuser = "";
  bool isDeepLinkLoaded = false;
  List<AllDates> lstAlldate = [];
  List<GuestModel> lstguesData = [];
  List guestsID = [];
  getFilterUpComingEvents() async {
    if (FirebaseAuth.instance.currentUser == null) {
      await initDynamicLinks();
      print("Loading here");
    }
    var objProviderNotifier =
        Provider.of<AuthenicationNotifier>(context, listen: false);
    await objProviderNotifier.getUserDetail();
    PrefServices().setCurrentUserName(objProviderNotifier.objUsers.firstName! +
        " " +
        objProviderNotifier.objUsers.lastName!);

    currentuser = await PrefServices().getCurrentUserName();
    print("currentuser=========>$currentuser");
    await initDynamicLinks();

    await FlutterContacts.requestPermission();

    var objCreateEventNotifier =
        Provider.of<CreateEventNotifier>(context, listen: false);

    await objCreateEventNotifier.getListOfPastEvent(
      context,
    );
    print("Bool: ${isDeepLinkLoaded}");
  }

  String isCreateby = "";

  Future<void> initDynamicLinks() async {
    try {
      print("event_screen_link_========>$link");
      if (link != null && link != "") {
        var objCreateEventNotifier =
            Provider.of<CreateEventNotifier>(context, listen: false);
        lstAlldate = [];
        guestsID = [];
        lstguesData = [];
        setState(() {
          isDeepLinkLoaded = true;
        });

        var eventid = link!.substring(link!.lastIndexOf("=") + 1);
        print(eventid);

        try {
          await ApiProvider().eventDetails(eventid).then((value) async {
            setState(() {
              isCreateby = value.ownerID!;
            });
            try {
              QuerySnapshot result = await FirebaseFirestore.instance
                  .collection('users')
                  .where("uid", isEqualTo: value.ownerID)
                  .get();
              if (result.docs.length > 0) {
                for (var docData in result.docs) {
                  value.lstUser = UserModel.parseSnapshot(docData);
                }
              }
              print("value=========>");
              value.allDates!.forEach((element) async {
                element.guestResponse!.forEach((element2) async {
                  if (element2.guestID ==
                      FirebaseAuth.instance.currentUser!.uid) {
                    element.objguest = element2;
                  }
                });
              });
              print(value);
              setState(() {
                objCreateEventNotifier.setEventData = value;
                lstguesData = value.guest!;
                lstAlldate = value.allDates!;
                guestsID = value.guestsID!;
              });

              if (FirebaseAuth.instance.currentUser == null) {
                Navigator.pushNamed(context, Routes.Login);
              } else {
                if (isCreateby != "" &&
                    isCreateby != FirebaseAuth.instance.currentUser!.uid) {
                  await objCreateEventNotifier.getinvitatedFriendData(
                      context, eventid);

                  setState(() {});

                  if (value.guestsID!.isEmpty) {
                    lstguesData.add(
                      GuestModel(
                          guestID: FirebaseAuth.instance.currentUser!.uid,
                          status: 2,
                          guestUserName: currentuser),
                    );
                    guestsID.add(
                      FirebaseAuth.instance.currentUser!.uid,
                    );

                    lstAlldate.forEach(
                      (element2) {
                        element2.guestResponse!.add(
                          GuestModel(
                              guestID: FirebaseAuth.instance.currentUser!.uid,
                              status: 2,
                              guestUserName: currentuser),
                        );
                      },
                    );
                    await objCreateEventNotifier
                        .addGuestList(
                            context, lstguesData, eventid, guestsID, lstAlldate)
                        .whenComplete(() async {
                      await objCreateEventNotifier.getListOfUpcomingEvent(
                        context,
                      );
                    });
                  } else {
                    if (value.guestsID!
                        .contains(FirebaseAuth.instance.currentUser!.uid)) {
                      print("djfhrut rytruytyt5yty5");
                    } else {
                      print("Data Add");
                      lstguesData.add(
                        GuestModel(
                            guestID: FirebaseAuth.instance.currentUser!.uid,
                            status: 2,
                            guestUserName: currentuser),
                      );
                      guestsID.add(FirebaseAuth.instance.currentUser!.uid);

                      lstAlldate.forEach(
                        (element2) {
                          element2.guestResponse!.add(
                            GuestModel(
                                guestID: FirebaseAuth.instance.currentUser!.uid,
                                status: 2,
                                guestUserName: currentuser),
                          );
                        },
                      );
                      await objCreateEventNotifier
                          .addGuestList(context, lstguesData, eventid, guestsID,
                              lstAlldate)
                          .then((value) async {
                        await objCreateEventNotifier.getListOfUpcomingEvent(
                          context,
                        );
                      });
                    }
                  }
                  print("Goto eventDetailsScreen");
                  Navigator.push(
                    navigatorKey.currentContext!,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          EventDetailsScreen(
                        eventId: value.docId!,
                        hostId: value.lstUser!.uid!,
                        isPastEvent: false,
                        isFromMyeventScreen: false,
                        ismyPastEvent: false,
                      ),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  ).whenComplete(() {
                    setState(() {
                      link = "";
                    });
                  });
                } else {
                  print("Goto eventDetailsScreen");
                  Navigator.push(
                    navigatorKey.currentContext!,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          EventDetailsScreen(
                        isPastEvent: false,
                        isFromMyeventScreen: true,
                        ismyPastEvent: false,
                        eventId: value.docId!,
                        hostId: value.lstUser!.uid!,
                      ),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  ).whenComplete(() {
                    setState(() {
                      link = "";
                    });
                  });
                }
              }
            } catch (e) {
              print(e);
            }
          });
        } catch (e) {
          print(e);
          setState(() {
            isDeepLinkLoaded = false;
          });
        } finally {
          setState(() {
            isDeepLinkLoaded = false;
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  bool isFilteredData = false;

  @override
  void initState() {
    getFilterUpComingEvents();

    super.initState();
  }

  @override
  void dispose() {
    tabIndex = 0;
    super.dispose();
  }

  int tabIndex = 0;
  bool isAppclose = true;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    final objAuthNotifier = context.watch<AuthenicationNotifier>();
    final objCreateEventNotifier = context.watch<CreateEventNotifier>();

    return WillPopScope(
      onWillPop: () async {
        if (isAppclose = true) {
          exit(0);
        }
        return isAppclose;
      },
      child: Column(
        children: [
          ///--------------------------- Appbar----------------------------
          AppBar(
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
            title: Center(
                child: Image.asset(
              ConstantData.logo,
              height: height * 0.12,
              width: height * 0.12,
              fit: BoxFit.contain,
            )),
            // Text(
            //   TextUtils.Omw,
            //   style: AppTheme.getTheme().textTheme.subtitle1!.copyWith(
            //         color: primaryColor,
            //         fontWeight: FontWeight.w700,
            //         fontSize: width * 0.09,
            //       ),
            // ),
            centerTitle: true,

            actions: [
              ///----------------------- Calender ---------------------------
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CalenderFilterScreen()));
                },
                child: Container(
                  margin: EdgeInsets.only(
                    right: width * 0.04,
                  ),
                  child: Image.asset(
                    ConstantData.calender,
                    width: height * 0.022,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              ///------------------------ Search---------------------
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => SearchEvent())));
                },
                child: Container(
                  margin: EdgeInsets.only(right: width * 0.03),
                  child: Image.asset(
                    ConstantData.search,
                    width: height * 0.024,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),

          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                  top: height * 0.018, left: width * 0.03, right: width * 0.03),
              child: Stack(
                children: [
                  isDeepLinkLoaded == true
                      ? Center(
                          child: CircularProgressIndicator(
                          color: primaryColor,
                        ))
                      : Container(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///---------------- Selection-----------
                      Container(
                        padding: EdgeInsets.all(height * 0.01),
                        margin: EdgeInsets.only(bottom: height * 0.02),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(height * 0.1),
                          border: Border.all(
                            color: ConstColor.textFormFieldColor,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ///------------------------------- UpComing ----------------------
                            GestureDetector(
                              onTap: () {
                                if (mounted) {
                                  setState(() {
                                    tabIndex = 0;
                                  });
                                }
                              },
                              child: Container(
                                width: width * 0.36,
                                padding: EdgeInsets.all(height * 0.014),
                                decoration: BoxDecoration(
                                  color: tabIndex != 0
                                      ? Colors.transparent
                                      : primaryColor,
                                  borderRadius:
                                      BorderRadius.circular(height * 0.1),
                                ),
                                child: Center(
                                  child: Text(
                                    TextUtils.upcoming,
                                    style: AppTheme.getTheme()
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                            decoration: TextDecoration.none,
                                            color: tabIndex != 0
                                                ? Color(0xffA5A5A5)
                                                : ConstColor.black_Color,
                                            fontSize: width * 0.043,
                                            fontWeight: tabIndex != 0
                                                ? FontWeight.normal
                                                : FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),

                            ///------------------------------- Past ----------------------
                            GestureDetector(
                              onTap: () {
                                if (mounted) {
                                  setState(() {
                                    tabIndex = 1;
                                  });
                                }
                              },
                              child: Container(
                                width: width * 0.29,
                                padding: EdgeInsets.all(height * 0.014),
                                decoration: BoxDecoration(
                                  color: tabIndex != 1
                                      ? Colors.transparent
                                      : primaryColor,
                                  borderRadius:
                                      BorderRadius.circular(height * 0.1),
                                ),
                                child: Center(
                                  child: Text(
                                    TextUtils.past,
                                    style: AppTheme.getTheme()
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                            decoration: TextDecoration.none,
                                            color: tabIndex != 1
                                                ? Color(0xffA5A5A5)
                                                : ConstColor.black_Color,
                                            fontSize: width * 0.043,
                                            fontWeight: tabIndex != 1
                                                ? FontWeight.normal
                                                : FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),

                            ///------------------------------- Filter ----------------------
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    barrierDismissible: true,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return tabIndex == 0
                                          ? upcomingfilterDialog()
                                          : PastfilterDialog();
                                    });
                              },
                              child: Container(
                                child: Center(
                                    child: Image.asset(
                                  ConstantData.filter,
                                  height: height * 0.06,
                                  width: height * 0.06,
                                  fit: BoxFit.fill,
                                )),
                              ),
                            )
                          ],
                        ),
                      ),
                      tabIndex == 0
                          ? UpComingScreen(
                              currentuser: currentuser,
                              getList:
                                  objCreateEventNotifier.getUpcomingFilterList,
                              isLoading: objCreateEventNotifier.isLoading,
                              isFilteredData: objCreateEventNotifier
                                  .isUpcommingFilteredData,
                            )
                          : tabIndex == 1
                              ? PastScreen(
                                  currentuser: currentuser,
                                  getList:
                                      objCreateEventNotifier.getPastFilterList,
                                  isLoading: objCreateEventNotifier.isLoading,
                                  isFilteredData:
                                      objCreateEventNotifier.isPastFilteredData,
                                )
                              : Container()
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
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
        return CommonDrawer();
      },
    );
  }

  Widget upcomingfilterDialog() {
    return UpComingFilterDialog();
  }

  Widget PastfilterDialog() {
    return PastFilterDialog();
  }
}

class DynamicLinkArguments {
  final String route;

  final String link;
  final String eventId;

  DynamicLinkArguments(this.route, this.link, this.eventId);
}
