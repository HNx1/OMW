import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:omw/utils/colorUtils.dart';
import 'package:omw/widget/scaffoldSnackbar.dart';
import 'package:provider/provider.dart';

import '../../constant/constants.dart';
import '../../constant/theme.dart';
import '../../model/createEvent_model.dart';
import '../../notifier/authenication_notifier.dart';
import '../../notifier/event_notifier.dart';
import '../../notifier/notication_notifier.dart';
import '../../utils/textUtils.dart';
import '../../widget/commonButton.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class MultiSelection extends StatefulWidget {
  final String eventId;
  final String eventHostUserId;

  const MultiSelection(
      {super.key, required this.eventId, required this.eventHostUserId});
  @override
  _MultiSelectionState createState() => _MultiSelectionState();
}

String newDate = '';

class _MultiSelectionState extends State<MultiSelection> {
  getResponse() async {
    var objCreateEventNotifier =
        Provider.of<CreateEventNotifier>(context, listen: false);
    await objCreateEventNotifier.geteventDeatisl(
        context, widget.eventId, widget.eventHostUserId);
    lstAlldate = objCreateEventNotifier.getEventDetails.allDates!;
    setState(() {
      isLoading = false;
    });
  }

  List<AllDates> lstAlldate = [];
  List allResponse = [];
  List stackofAnswerIsFull = [];
  List lstofgoingresponse = [];
  bool isLoad = false;
  chnageResponse() async {
    stackofAnswerIsFull = [];
    lstofgoingresponse = [];
    try {
      setState(() {
        isLoad = true;
      });
      var objCreateEventNotifier =
          Provider.of<CreateEventNotifier>(context, listen: false);

      objCreateEventNotifier
          .changeResponse(context, widget.eventId, lstAlldate)
          .then((value) async {
        ScaffoldSnackbar.of(context).show("Event response has been updated");

        await getResponse();
        setState(() {
          isLoad = false;
        });
        setState(() {
          objCreateEventNotifier.setEventData =
              objCreateEventNotifier.getEventDetails;
        });
        if (objCreateEventNotifier.getEventDetails.isNotificationSent ==
            false) {
          objCreateEventNotifier.getEventDetails.allDates!.forEach((element) {
            element.guestResponse!.forEach((element2) {
              allResponse.add(element2.status);
            });
            setState(() {});
            stackofAnswerIsFull.add(allResponse);
            allResponse = [];
          });
          stackofAnswerIsFull.forEach((element) {
            if (element.every((e) => e == 0)) {
              lstofgoingresponse.addAll([element]);
            }
          });
          print("stackofAnswerIsFull=>$stackofAnswerIsFull");

          print("lstofgoingresponse===>$lstofgoingresponse");
          if (lstofgoingresponse.isNotEmpty) {
            await sendNotificationToCoHost();
            await objCreateEventNotifier.sendnotificationtotheHost(
                context, objCreateEventNotifier.getEventDetails.docId!, true);
            print("notificaton send ");
          }
        }
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoad = false;
      });
    }
  }

  sendNotificationToCoHost() async {
    var objNotificationNotifier =
        Provider.of<NotificationNotifier>(context, listen: false);

    var objCreateEventNotifier =
        Provider.of<CreateEventNotifier>(context, listen: false);
    if (objCreateEventNotifier.getEventDetails.lstUser!.fcmToken != "") {
      await objNotificationNotifier.sendPushNotification(
          context,
          objCreateEventNotifier.getEventDetails.lstUser!.fcmToken!,
          "All participants are coming",
          "All participants are coming on $newDate for ${objCreateEventNotifier.getEventDetails.eventname}",
          "multiDate",
          "",
          objCreateEventNotifier.getEventDetails.docId!,
          objCreateEventNotifier.getEventDetails.lstUser!.uid!);
      await objNotificationNotifier.pushNotification(
        context: context,
        title: "All participants are coming",
        description:
            "All participants are coming on $newDate for ${objCreateEventNotifier.getEventDetails.eventname}",
        userId: objCreateEventNotifier.getEventDetails.lstUser!.uid,
        type: "multiDate",
        typeOfData: [
          {"eventId": objCreateEventNotifier.getEventDetails.docId!}
        ],
      );
    }
  }

  @override
  void initState() {
    getResponse();

    super.initState();
  }

  bool isLoading = true;
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
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  )
                : objCreateEventNotifier.getEventDetails.allDates!.isEmpty
                    ? Container(
                        margin: EdgeInsets.all(height * 0.05),
                        child: Center(
                          child: Text(
                            "No data found",
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
                    : SingleChildScrollView(
                        padding: EdgeInsets.all(height * 0.02),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: height * 0.04),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: ConstColor.textFormFieldColor,
                                    width: 1.2),
                                borderRadius:
                                    BorderRadius.circular(height * 0.02),
                              ),
                              child: Table(
                                border: TableBorder.symmetric(
                                  inside: BorderSide(
                                      color: ConstColor.textFormFieldColor,
                                      width: 1.2),
                                ),
                                columnWidths: {
                                  0: FlexColumnWidth(50),
                                  1: FlexColumnWidth(20),
                                  2: FlexColumnWidth(20),
                                  3: FlexColumnWidth(20),
                                },
                                children: [
                                  for (var i = 0;
                                      i <
                                          objCreateEventNotifier
                                              .getEventDetails.allDates!.length;
                                      i++)
                                    TableRow(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.all(
                                            height * 0.03,
                                          ),
                                          child: Text(
                                            "${DateFormat('d MMM - yyyy').format(
                                              objCreateEventNotifier
                                                  .getEventDetails
                                                  .allDates![i]
                                                  .selectedDate!,
                                            )}",
                                            style: AppTheme.getTheme()
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                  fontSize: width * 0.045,
                                                  color: Colors.white,
                                                ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (objCreateEventNotifier
                                                    .getEventDetails
                                                    .lstUser!
                                                    .uid ==
                                                _auth.currentUser!.uid) {
                                            } else {
                                              setState(() {
                                                newDate = DateFormat(
                                                        'd MMM - yyyy')
                                                    .format(
                                                        objCreateEventNotifier
                                                            .getEventDetails
                                                            .allDates![i]
                                                            .selectedDate!);
                                              });
                                              setState(() {
                                                objCreateEventNotifier
                                                    .getEventDetails
                                                    .allDates![i]
                                                    .objguest!
                                                    .status = 0;
                                              });
                                              objCreateEventNotifier
                                                  .getEventDetails
                                                  .allDates![i]
                                                  .guestResponse!
                                                  .forEach((element) {
                                                if (element.guestID ==
                                                    _auth.currentUser!.uid) {
                                                  element.status = 0;
                                                }
                                              });
                                            }
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.all(
                                              height * 0.023,
                                            ),
                                            child: Image.asset(
                                              ConstantData.check,
                                              height: height * 0.04,
                                              color: objCreateEventNotifier
                                                          .getEventDetails
                                                          .allDates![i]
                                                          .objguest!
                                                          .status ==
                                                      0
                                                  ? primaryColor
                                                  : ConstColor.white_Color,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (objCreateEventNotifier
                                                    .getEventDetails
                                                    .lstUser!
                                                    .uid ==
                                                _auth.currentUser!.uid) {
                                              ScaffoldSnackbar.of(context).show(
                                                  "As a host, you can not change your response.");
                                            } else {
                                              setState(() {
                                                objCreateEventNotifier
                                                    .getEventDetails
                                                    .allDates![i]
                                                    .objguest!
                                                    .status = 2;
                                              });
                                              objCreateEventNotifier
                                                  .getEventDetails
                                                  .allDates![i]
                                                  .guestResponse!
                                                  .forEach((element) {
                                                if (element.guestID ==
                                                    _auth.currentUser!.uid) {
                                                  element.status = 2;
                                                }
                                              });
                                            }
                                          },
                                          child: Container(
                                              color: Colors.transparent,
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.all(
                                                height * 0.023,
                                              ),
                                              child: Image.asset(
                                                ConstantData.minus,
                                                height: height * 0.04,
                                                color: objCreateEventNotifier
                                                            .getEventDetails
                                                            .allDates![i]
                                                            .objguest!
                                                            .status ==
                                                        2
                                                    ? primaryColor
                                                    : ConstColor.white_Color,
                                              )),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (objCreateEventNotifier
                                                    .getEventDetails
                                                    .lstUser!
                                                    .uid ==
                                                _auth.currentUser!.uid) {
                                              ScaffoldSnackbar.of(context).show(
                                                  "As a host, you can not change your response.");
                                            } else {
                                              setState(() {
                                                objCreateEventNotifier
                                                    .getEventDetails
                                                    .allDates![i]
                                                    .objguest!
                                                    .status = 1;
                                              });
                                              objCreateEventNotifier
                                                  .getEventDetails
                                                  .allDates![i]
                                                  .guestResponse!
                                                  .forEach((element) {
                                                if (element.guestID ==
                                                    _auth.currentUser!.uid) {
                                                  element.status = 1;
                                                }
                                              });
                                            }
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.all(
                                              height * 0.023,
                                            ),
                                            child: Image.asset(
                                              ConstantData.close,
                                              color: objCreateEventNotifier
                                                          .getEventDetails
                                                          .allDates![i]
                                                          .objguest!
                                                          .status ==
                                                      1
                                                  ? Colors.red
                                                  : Colors.white,
                                              height: height * 0.04,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
          ),
          Stack(
            children: [
              isLoad
                  ? Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    )
                  : Container(),
              Container(
                margin: EdgeInsets.only(
                    bottom: height * 0.02, top: isLoad ? height * 0.02 : 0.0),
                child: GestureDetector(
                  onTap: () {
                    if (objCreateEventNotifier.getEventDetails.lstUser!.uid ==
                        _auth.currentUser!.uid) {
                      ScaffoldSnackbar.of(context)
                          .show("As a host, you can not change your response.");
                    } else {
                      chnageResponse();
                    }
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        bottom: height * 0.02,
                        left: width * 0.03,
                        right: width * 0.03),
                    child: CommonButton(name: "Submit"),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
