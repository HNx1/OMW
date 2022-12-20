import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:omw/utils/colorUtils.dart';
import 'package:provider/provider.dart';

import '../../../../constant/constants.dart';
import '../../../../constant/theme.dart';
import '../../../../notifier/changenotifier.dart';
import '../../../../utils/textUtils.dart';

class settingNotificationScreen extends StatefulWidget {
  const settingNotificationScreen({Key? key}) : super(key: key);

  @override
  State<settingNotificationScreen> createState() =>
      _settingNotificationScreenState();
}

class _settingNotificationScreenState extends State<settingNotificationScreen> {
  var items = [
    'Brizinger 2018',
    'Brizinger 2019',
    'Brizinger 2020',
    'Brizinger 2021',
    'Brizinger 2022',
  ];
  var reminderList = [
    '1 hour before',
    '2 hour before',
    '4 hour before',
    '6 hour before',
    '8 hour before',
  ];
  bool isExpanded = false;
  bool isReminderExpanded = false;

  int? selectedIndex;

  String dropdownvalue = 'Brizinger 2018';
  String remindervalue = '1 hour before';

  @override
  Widget build(BuildContext context) {
    final objProviderNotifier = context.watch<ProviderNotifier>();
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

            ///-------------------- Notification Text   ---------------------
            Text(
          TextUtils.Notification,
          style: AppTheme.getTheme().textTheme.bodyText2!.copyWith(
              color: ConstColor.primaryColor,
              height: 1.4,
              fontSize: width * 0.052),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: height * 0.03),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: height * 0.026,
                left: width * 0.03,
                right: width * 0.03,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///-------------------------- First Selection--------------

                  Theme(
                    data: ThemeData(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.05,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: isExpanded
                            ? BorderRadius.circular(height * 0.02)
                            : BorderRadius.circular(height * 0.1),
                        border: Border.all(
                          color: ConstColor.textFormFieldColor,
                        ),
                      ),
                      child: ExpansionTile(
                          title: Container(),
                          collapsedBackgroundColor: Colors.transparent,
                          tilePadding: EdgeInsets.zero,
                          onExpansionChanged: (val) {
                            setState(() {
                              isExpanded = val;
                            });
                          },
                          leading: Text(
                            dropdownvalue,
                            style: AppTheme.getTheme()
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    decoration: TextDecoration.none,
                                    color: ConstColor.white_Color,
                                    fontSize: width * 0.044),
                          ),
                          trailing: Icon(
                            isExpanded == true
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_right_sharp,
                            size: width * 0.07,
                            color: isExpanded
                                ? primaryColor
                                : ConstColor.white_Color,
                          ),
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: height * 0.02),
                              child: Column(
                                  children:
                                      List.generate(items.length, (index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = index;
                                      dropdownvalue = items[index];
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: height * 0.01),
                                    child: Text(
                                      items[index],
                                      style: AppTheme.getTheme()
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                            color: ConstColor.white_Color,
                                            height: 1.4,
                                            fontSize: width * 0.046,
                                          ),
                                    ),
                                  ),
                                );
                              })),
                            )
                          ]),
                    ),
                  ),

                  ///--------- Chat Notification-------------
                  Container(
                    margin: EdgeInsets.only(
                        top: height * 0.04, bottom: height * 0.04),
                    alignment: Alignment.centerLeft,
                    width: width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          TextUtils.ChatNotifications,
                          style:
                              AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                                    fontSize: width * 0.046,
                                    color: ConstColor.white_Color,
                                  ),
                        ),
                        FlutterSwitch(
                          activeColor: ConstColor.primaryColor,
                          width: width * 0.08,
                          height: height * 0.028,
                          toggleSize: width * 0.036,
                          value: objProviderNotifier.isChatNotification,
                          borderRadius: 30.0,
                          padding: 4.0,
                          activeToggleColor: ConstColor.black_Color,
                          onToggle:
                              objProviderNotifier.isisChatNotificationtoggole,
                        ),
                      ],
                    ),
                  ),

                  //----------- Divider------------------
                  Container(
                    height: 1,
                    width: width,
                    color:
                        ConstColor.term_condition_grey_color.withOpacity(0.5),
                  ),

                  ///--------- Event Notification-------------
                  Container(
                    margin: EdgeInsets.only(
                        top: height * 0.04, bottom: height * 0.04),
                    alignment: Alignment.centerLeft,
                    width: width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          TextUtils.EventNotifications,
                          style:
                              AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                                    fontSize: width * 0.046,
                                    color: ConstColor.white_Color,
                                  ),
                        ),
                        FlutterSwitch(
                          activeColor: ConstColor.primaryColor,
                          width: width * 0.08,
                          height: height * 0.028,
                          toggleSize: width * 0.036,
                          value: objProviderNotifier.isEventNotification,
                          borderRadius: 30.0,
                          padding: 4.0,
                          activeToggleColor: ConstColor.black_Color,
                          onToggle:
                              objProviderNotifier.isisEventNotificationtoggole,
                        ),
                      ],
                    ),
                  ),
                  //----------- Divider------------------
                  Container(
                    height: 1,
                    width: width,
                    color:
                        ConstColor.term_condition_grey_color.withOpacity(0.5),
                  ),

                  ///------------------ set reminder-----------------
                  Container(
                    margin: EdgeInsets.only(
                        top: height * 0.04, bottom: height * 0.01),
                    child: Text(
                      TextUtils.SetReminder,
                      style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                            fontSize: width * 0.046,
                            color: ConstColor.white_Color,
                          ),
                    ),
                  ),

                  ///-------------------------- First Selection--------------

                  Theme(
                    data: ThemeData(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.05,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: isReminderExpanded
                            ? BorderRadius.circular(height * 0.02)
                            : BorderRadius.circular(height * 0.1),
                        border: Border.all(
                          color: ConstColor.textFormFieldColor,
                        ),
                      ),
                      child: ExpansionTile(
                          title: Container(),
                          collapsedBackgroundColor: Colors.transparent,
                          tilePadding: EdgeInsets.zero,
                          onExpansionChanged: (val) {
                            setState(() {
                              isReminderExpanded = val;
                            });
                          },
                          leading: Text(
                            remindervalue,
                            style: AppTheme.getTheme()
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    fontSize: width * 0.044,
                                    color: Color(0xff6C6C6C),
                                    fontWeight: FontWeight.w400),
                          ),
                          trailing: Icon(
                            isReminderExpanded == true
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_right_sharp,
                            size: width * 0.07,
                            color: isReminderExpanded
                                ? primaryColor
                                : ConstColor.white_Color,
                          ),
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: height * 0.02),
                              child: Column(
                                children:
                                    List.generate(reminderList.length, (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = index;
                                        remindervalue = reminderList[index];
                                      });
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(top: height * 0.01),
                                      child: Text(
                                        reminderList[index],
                                        style: AppTheme.getTheme()
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                              color: ConstColor.white_Color,
                                              height: 1.4,
                                              fontSize: width * 0.046,
                                            ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            )
                         
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
