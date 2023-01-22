import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lazy_data_table/lazy_data_table.dart';

import 'package:provider/provider.dart';

import '../../constant/constants.dart';
import '../../constant/theme.dart';

import '../../model/createEvent_model.dart';
import '../../model/user_model.dart';
import '../../notifier/authenication_notifier.dart';
import '../../notifier/event_notifier.dart';
import '../../notifier/notication_notifier.dart';
import '../../utils/colorUtils.dart';

import 'package:intl/intl.dart';

class SeeMultiSelectedDate extends StatefulWidget {
  final String eventHostUserId;

  final String eventId;
  final List guestId;

  const SeeMultiSelectedDate({
    Key? key,
    required this.eventId,
    required this.guestId,
    required this.eventHostUserId,
  }) : super(key: key);

  @override
  State<SeeMultiSelectedDate> createState() => _SeeMultiSelectedDateState();
}

DateTime currentTime = DateTime.now();
List<dynamic> allChoosingDates = [];
DateTime eventStartDate = DateTime.now();
DateTime eventEndDate = DateTime.now();
List<AllDates> lstAlldate = [];
bool isLoading = true;

class _SeeMultiSelectedDateState extends State<SeeMultiSelectedDate> {
  List<UserModel> guestUser = [];
  getResponse() async {
    guestUser = [];
    setState(() {
      isLoading = true;
    });
    var objCreateEventNotifier =
        Provider.of<CreateEventNotifier>(context, listen: false);
    await objCreateEventNotifier.geteventDeatisl(
        context, widget.eventId, widget.eventHostUserId);
    var objAuthenicationNotifier =
        Provider.of<AuthenicationNotifier>(context, listen: false);
    await objAuthenicationNotifier.getUserDetail();
    if (widget.guestId.isNotEmpty) {
      await objCreateEventNotifier
          .getAllGuestUserList(
        context,
        widget.guestId,
      )
          .whenComplete(() {
        for (var element in objCreateEventNotifier.getEventDetails.guest!) {
          guestUser = objCreateEventNotifier.retrievedGuestUserList;
          guestUser.sort((a, b) => a.lastName!.compareTo(b.lastName!));

          print("==============>$element");
        }
      });
    }

    print("guestUserResponse==============>${guestUser.length}");
    setState(
      () {
        isLoading = false;
      },
    );
  }

  sendNotification(String date) {
    var objNotificationNotifier =
        Provider.of<NotificationNotifier>(context, listen: false);
    var objAuthenicationNotifier =
        Provider.of<AuthenicationNotifier>(context, listen: false);
    var objCreateEventNotifier =
        Provider.of<CreateEventNotifier>(context, listen: false);
    guestUser.forEach((element) async {
      print(element.firstName);
      if (element.uid == FirebaseAuth.instance.currentUser!.uid) {
        print("Not Send");
      } else {
        try {
          if (element.fcmToken != "") {
            await objNotificationNotifier.sendPushNotification(
                context,
                element.fcmToken!,
                "Event date changed",
                "${objCreateEventNotifier.getEventDetails.eventname}'s date has been changed to new date $date",
                "eventInvite",
                "",
                objCreateEventNotifier.getEventDetails.docId!,
                objCreateEventNotifier.getEventDetails.lstUser!.uid!);
            await objNotificationNotifier.pushNotification(
                context: context,
                title: "Event date changed",
                description:
                    "${objCreateEventNotifier.getEventDetails.eventname}'s date has been changed to new date $date",
                userId: element.uid,
                type: "eventInvite",
                typeOfData: [
                  {
                    "NotificationSendBy":
                        "${objAuthenicationNotifier.objUsers.firstName!} ${objAuthenicationNotifier.objUsers.lastName!}",
                    "eventId": objCreateEventNotifier.getEventDetails.docId!
                  }
                ]);
          }
        } catch (e) {
          print(e);
        }
      }
    });
  }

  @override
  void initState() {
    getResponse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

              ///-------------------- Omw Text ---------------------
              //     Text(
              //   TextUtils.Omw,
              //   style: AppTheme.getTheme().textTheme.subtitle1!.copyWith(
              //         color: primaryColor,
              //         fontWeight: FontWeight.w700,
              //         fontSize: width * 0.09,
              //       ),
              // ),
              Image.asset(
            ConstantData.logo,
            height: height * 0.12,
            width: height * 0.12,
            fit: BoxFit.contain,
          ),
          centerTitle: true,
        ),
        body: Consumer<CreateEventNotifier>(
          builder: (BuildContext context, value, Widget? child) {
            return isLoading == true
                ? const Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  )
                : widget.guestId.isEmpty
                    ? Center(
                        child: Container(
                          child: Text(
                            "No friends invited",
                            style: AppTheme.getTheme()
                                .textTheme
                                .bodyText2!
                                .copyWith(
                                  decoration: TextDecoration.none,
                                  color: ConstColor.white_Color,
                                  fontSize: width * 0.045,
                                  overflow: TextOverflow.ellipsis,
                                ),
                          ),
                        ),
                      )
                    : Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(height * 0.015),
                        child: LazyDataTable(
                          tableTheme: const LazyDataTableTheme(
                            columnHeaderBorder: Border(
                              top: BorderSide(
                                color: ConstColor.textFormFieldColor,
                              ),
                            ),
                            columnHeaderColor: Colors.black,
                            rowHeaderBorder: Border(
                              bottom: BorderSide(
                                  color: ConstColor.textFormFieldColor),
                              left: BorderSide(
                                color: ConstColor.textFormFieldColor,
                              ),
                            ),
                            rowHeaderColor: Colors.black,
                            cornerBorder: Border(
                              top: BorderSide(
                                color: ConstColor.textFormFieldColor,
                              ),
                              left: BorderSide(
                                color: ConstColor.textFormFieldColor,
                              ),
                              bottom: BorderSide(
                                  color: ConstColor.textFormFieldColor),
                            ),
                            cornerColor: Colors.black,
                            cellBorder: Border(
                              right: BorderSide(
                                  color: ConstColor.textFormFieldColor),
                              bottom: BorderSide(
                                  color: ConstColor.textFormFieldColor),
                            ),
                            cellColor: Colors.transparent,
                            alternateRow: false,
                            alternateColumn: false,
                          ),
                          rows: value.getEventDetails.guest!.length,
                          columns: value.getEventDetails.allDates!.length,
                          tableDimensions: LazyDataTableDimensions(
                            cellHeight: height * 0.1,
                            cellWidth: width * 0.13,
                            leftHeaderWidth: width * 0.4,
                            topHeaderHeight: height * 0.09,
                          ),
                          topHeaderBuilder: (k) => GestureDetector(
                            onTap: () {
                              if (value.getEventDetails.allDates!.length > 1) {
                                allChoosingDates = [];
                                lstAlldate = [];
                                allChoosingDates.add(value.getEventDetails
                                    .allDates![k].selectedDate!);
                                lstAlldate.add(
                                  AllDates(
                                      selectedDate: value.getEventDetails
                                          .allDates![k].selectedDate!,
                                      guestResponse:
                                          value.getEventDetails.guest!),
                                );
                                DateTime? startEl =
                                    value.getEventDetails.eventStartDate;
                                DateTime? endEl =
                                    value.getEventDetails.eventEndDate;
                                setState(() {
                                  eventStartDate = DateTime(
                                      allChoosingDates.first.year,
                                      allChoosingDates.first.month,
                                      allChoosingDates.first.day,
                                      startEl == null
                                          ? currentTime.hour
                                          : startEl.hour,
                                      startEl == null
                                          ? currentTime.minute
                                          : startEl.minute,
                                      startEl == null
                                          ? currentTime.second
                                          : startEl.second,
                                      0,
                                      0);
                                });
                                eventEndDate = DateTime(
                                    allChoosingDates.last.year,
                                    allChoosingDates.last.month,
                                    allChoosingDates.last.day,
                                    endEl == null ? 23 : endEl.hour,
                                    endEl == null ? 59 : endEl.minute,
                                    00,
                                    0,
                                    0);
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return dialog(value);
                                  },
                                );
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: const BorderSide(
                                      color: ConstColor.textFormFieldColor),
                                  right: value.getEventDetails.allDates!.last ==
                                          value.getEventDetails.allDates![k]
                                      ? const BorderSide(
                                          color: ConstColor.textFormFieldColor,
                                        )
                                      : BorderSide.none,
                                ),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                ),
                                child: Text(
                                  DateFormat('d MMM')
                                      .format(
                                        value.getEventDetails.allDates![k]
                                            .selectedDate!,
                                      )
                                      .toString(),
                                  style: AppTheme.getTheme()
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        fontSize: width * 0.044,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          leftHeaderBuilder: (i) => Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.zero,
                            margin: EdgeInsets.zero,
                            decoration: const BoxDecoration(
                              border: Border(
                                  right: BorderSide(
                                color: ConstColor.textFormFieldColor,
                              )),
                            ),
                            child: Text(
                              value.getEventDetails.guest![i].guestUserName!,
                              style: AppTheme.getTheme()
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                    decoration: TextDecoration.none,
                                    color: ConstColor.white_Color,
                                    fontSize: width * 0.045,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                            ),
                          ),
                          dataCellBuilder: (j, k) => Center(
                            child: Image.asset(
                              value.getEventDetails.allDates![k]
                                          .guestResponse![j].status ==
                                      0
                                  ? ConstantData.check
                                  : value.getEventDetails.allDates![k]
                                              .guestResponse![j].status ==
                                          1
                                      ? ConstantData.close
                                      : ConstantData.minus,
                              color: value.getEventDetails.allDates![k]
                                          .guestResponse![j].status ==
                                      0
                                  ? ConstColor.primaryColor
                                  : value.getEventDetails.allDates![k]
                                              .guestResponse![j].status ==
                                          1
                                      ? Colors.red
                                      : ConstColor.white_Color,
                              height: height * 0.04,
                            ),
                          ),
                          topLeftCornerWidget: Container(
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                              border: Border(),
                            ),
                            child: Container(),
                          ),
                        ),
                      );
          },
        ));
  }

  Widget dialog(
    CreateEventNotifier objCreateEventNotifier,
  ) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 15, 15, 15),
      title: Container(
        margin: EdgeInsets.only(
          left: width * 0.02,
          right: width * 0.02,
        ),
        child: Text(
          "Are you sure you want to pick ${DateFormat('d MMM').format(
            eventStartDate,
          )} as the date of this event?",
          style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                color: ConstColor.white_Color,
                height: 1.4,
                fontSize: width * 0.043,
              ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            setState(() {});
            Navigator.pop(context);
          },
          child: Text(
            "No",
            style: AppTheme.getTheme().textTheme.bodyText2!.copyWith(
                color: ConstColor.primaryColor,
                height: 1.4,
                fontSize: width * 0.04),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02),
          child: GestureDetector(
            onTap: () async {
              Navigator.pop(context);
              if (allChoosingDates.isNotEmpty) {
                await objCreateEventNotifier
                    .updateEventDetails(
                  context,
                  objCreateEventNotifier.getEventDetails.docId!,
                  objCreateEventNotifier.getEventDetails.eventname!,
                  allChoosingDates,
                  objCreateEventNotifier.getEventDetails.selectedTime!,
                  objCreateEventNotifier.getEventDetails.description!,
                  objCreateEventNotifier.getEventDetails.location!,
                  objCreateEventNotifier.getEventDetails.eventPhoto!,
                  objCreateEventNotifier.getEventDetails.inviteFriends!,
                  objCreateEventNotifier.getEventDetails.enableCostSplite!,
                  objCreateEventNotifier.getEventDetails.costAmount,
                  objCreateEventNotifier.getEventDetails.coHost,
                  eventStartDate,
                  eventEndDate,
                  objCreateEventNotifier.getEventDetails.guest,
                  objCreateEventNotifier.getEventDetails.guestsID,
                  objCreateEventNotifier.getEventDetails.lstUser,
                  objCreateEventNotifier.getEventDetails.ownerID,
                  objCreateEventNotifier.getEventDetails.cohostList,
                  lstAlldate,
                )
                    .whenComplete(() async {
                  await sendNotification(DateFormat('d MMM - yyyy').format(
                    eventStartDate,
                  ));
                  Navigator.pop(context);
                });
              }
            },
            child: Text(
              "Yes",
              style: AppTheme.getTheme().textTheme.bodyText2!.copyWith(
                  color: ConstColor.primaryColor,
                  height: 1.4,
                  fontSize: width * 0.04),
            ),
          ),
        ),
      ],
    );
  }
}
