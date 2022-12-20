import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constant/constants.dart';
import '../../../../constant/theme.dart';
import '../../../../model/user_model.dart';
import '../../../../notifier/event_notifier.dart';
import '../../../../utils/colorUtils.dart';
import '../../../../utils/textUtils.dart';
import 'myevent_going_screen.dart';
import 'myevent_maybe.dart';
import 'myevent_no.dart';

class MyEvetnCo_SplitScreen extends StatefulWidget {
  final String eventId;
  final String eventHostUserId;

  const MyEvetnCo_SplitScreen({Key? key, required this.eventId, required this.eventHostUserId})
      : super(key: key);

  @override
  State<MyEvetnCo_SplitScreen> createState() => _MyEvetnCo_SplitScreenState();
}

class _MyEvetnCo_SplitScreenState extends State<MyEvetnCo_SplitScreen> {
  List<UserModel> goingGuest = [];
  List<UserModel> maybeGuest = [];
  List<UserModel> notGoingGuest = [];

  @override
  void initState() {
    getListOfGuestUser();
    super.initState();
  }

  bool isDataLoad = false;
  getListOfGuestUser() async {
    setState(() {
      isDataLoad = true;
    });
    goingGuest = [];
    maybeGuest = [];
    notGoingGuest = [];
    var objCreateEventNotifier =
        Provider.of<CreateEventNotifier>(context, listen: false);
    await objCreateEventNotifier.geteventDeatisl(context, widget.eventId,widget.eventHostUserId);

    await objCreateEventNotifier.getAllGuestUserList(
        context, objCreateEventNotifier.getEventDetails.guestsID!);
    setState(() {
      objCreateEventNotifier.getEventDetails.guest!.forEach((e) {
        setState(() {
          goingGuest.addAll(objCreateEventNotifier.retrievedGuestUserList
              .where((element) => element.uid == e.guestID && e.status == 0));
        });
      });
    });
    setState(() {
      objCreateEventNotifier.getEventDetails.guest!.forEach((e) {
        setState(() {
          maybeGuest.addAll(objCreateEventNotifier.retrievedGuestUserList
              .where((element) => element.uid == e.guestID && e.status == 2));
        });
      });
    });
    setState(() {
      objCreateEventNotifier.getEventDetails.guest!.forEach((e) {
        setState(() {
          notGoingGuest.addAll(objCreateEventNotifier.retrievedGuestUserList
              .where((element) => element.uid == e.guestID && e.status == 1));
        });
      });
    });
    setState(() {
      isDataLoad = false;
    });
    print("Going :- $goingGuest");
    print("maybe :- $maybeGuest");
    print("notGoingGuest :- $notGoingGuest");
  }

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //--------------------Arrow back Icon------------------------------
        appBar: AppBar(
          backgroundColor: AppTheme.getTheme().scaffoldBackgroundColor,
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
          leadingWidth: width * 0.1,
          title:

              ///--------------------Guest List text  ---------------------
              Text(
            "My Event " + TextUtils.GuestList,
            style: AppTheme.getTheme().textTheme.bodyText2!.copyWith(
                color: ConstColor.primaryColor,
                height: 1.4,
                fontSize: width * 0.052),
          ),
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.only(
              top: height * 0.018, left: width * 0.03, right: width * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///---------------- Selection-----------
              Container(
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
                    ///------------------------------- Going ----------------------
                    Expanded(
                      flex: 0,
                      child: GestureDetector(
                        onTap: () async {
                          if (isDataLoad == false) {
                            setState(() {
                              index = 0;
                            });
                            await getListOfGuestUser();
                          }
                        },
                        child: Container(
                          width: width * 0.25,
                          margin: EdgeInsets.all(height * 0.006),
                          padding: EdgeInsets.all(height * 0.014),
                          decoration: BoxDecoration(
                            color:
                                index != 0 ? Colors.transparent : primaryColor,
                            borderRadius: BorderRadius.circular(height * 0.1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                TextUtils.Going,
                                style: AppTheme.getTheme()
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        color: index != 0
                                            ? Color(0xffA5A5A5)
                                            : ConstColor.black_Color,
                                        fontSize: width * 0.043,
                                        fontWeight: index != 0
                                            ? FontWeight.normal
                                            : FontWeight.w700),
                              ),
                              Text(
                                " (" + goingGuest.length.toString() + ")",
                                style: AppTheme.getTheme()
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        color: index != 0
                                            ? Color(0xffA5A5A5)
                                            : ConstColor.black_Color,
                                        fontSize: width * 0.043,
                                        fontWeight: index != 0
                                            ? FontWeight.normal
                                            : FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    ///------------------------------- Maybe----------------------
                    Expanded(
                      flex: 0,
                      child: GestureDetector(
                        onTap: () async {
                          if (isDataLoad == false) {
                            setState(() {
                              index = 1;
                            });
                            await getListOfGuestUser();
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.all(height * 0.007),
                          padding: EdgeInsets.all(height * 0.014),
                          decoration: BoxDecoration(
                            color:
                                index != 1 ? Colors.transparent : primaryColor,
                            borderRadius: BorderRadius.circular(height * 0.1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                TextUtils.Maybe,
                                style: AppTheme.getTheme()
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                        color: index != 1
                                            ? Color(0xffA5A5A5)
                                            : ConstColor.black_Color,
                                        fontSize: width * 0.043,
                                        fontWeight: index != 1
                                            ? FontWeight.normal
                                            : FontWeight.w700),
                              ),
                              Text(
                                " (" + maybeGuest.length.toString() + ")",
                                style: AppTheme.getTheme()
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        color: index != 1
                                            ? Color(0xffA5A5A5)
                                            : ConstColor.black_Color,
                                        fontSize: width * 0.043,
                                        fontWeight: index != 1
                                            ? FontWeight.normal
                                            : FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    ///------------------------------- NO----------------------
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          if (isDataLoad == false) {
                            setState(() {
                              index = 2;
                            });
                            await getListOfGuestUser();
                          }
                        },
                        child: Container(
                          width: width * 0.29,
                          margin: EdgeInsets.all(height * 0.007),
                          padding: EdgeInsets.all(height * 0.014),
                          decoration: BoxDecoration(
                            color:
                                index != 2 ? Colors.transparent : primaryColor,
                            borderRadius: BorderRadius.circular(height * 0.1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                TextUtils.No,
                                style: AppTheme.getTheme()
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        color: index != 2
                                            ? Color(0xffA5A5A5)
                                            : ConstColor.black_Color,
                                        fontSize: width * 0.043,
                                        fontWeight: index != 2
                                            ? FontWeight.normal
                                            : FontWeight.w700),
                              ),
                              Text(
                                " (" + notGoingGuest.length.toString() + ")",
                                style: AppTheme.getTheme()
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        color: index != 2
                                            ? Color(0xffA5A5A5)
                                            : ConstColor.black_Color,
                                        fontSize: width * 0.043,
                                        fontWeight: index != 2
                                            ? FontWeight.normal
                                            : FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              Expanded(
                  child: SingleChildScrollView(
                child: index == 0
                    ? MyEvent_Going(
                        goingGuest: goingGuest,
                        isLoading: isDataLoad,
                      )
                    : index == 1
                        ? Myevent_Maybe_Screen(
                            maybeGuest: maybeGuest,
                            isLoading: isDataLoad,
                          )
                        : Myevent_No_screen(
                            notGoingGuest: notGoingGuest,
                            isLoading: isDataLoad,
                          ),
              ))
            ],
          ),
        ));
  }
}
