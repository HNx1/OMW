import 'package:flutter/material.dart';
import 'package:omw/bottom/Chat/chat_screen.dart';
import 'package:omw/bottom/Contacts/contact_screen.dart';
import 'package:omw/bottom/Create/create_screen.dart';
import 'package:omw/bottom/Notification/notification_screen.dart';

import '../constant/constants.dart';

import '../constant/theme.dart';
import '../utils/colorUtils.dart';
import 'Events/event/events_screen.dart';
import 'common_BottomTab.dart';

class BottomNavBarScreen extends StatefulWidget {
  final int index;
  final int lastIndex;
  const BottomNavBarScreen(
      {Key? key, required this.index, required this.lastIndex})
      : super(key: key);
  @override
  _BottomNavBarScreenState createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen>
    with TickerProviderStateMixin {
  int currentIndex = 1;
  int lastIndex = 1;

  @override
  void initState() {
    lastIndex = widget.lastIndex;
    currentIndex = widget.index;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      value: 1,
    );
    super.initState();
  }

  late final AnimationController _controller;

  ///------- tab screen  ----------
  final List<Widget> viewContainer = [
    const CreateScreen(),
    const EventsSceen(),
    const ContactScreen(),
    const NotificationScreen(),
    const ChatScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      bottomNavigationBar: PersistanceBottomTab(
        lastIndex: lastIndex,
        index: lastIndex,
        onSuccess: (val) {
          if (lastIndex == 0) {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: const Color.fromARGB(255, 15, 15, 15),
                  title: Container(
                    margin: EdgeInsets.only(
                        left: width * 0.02, right: width * 0.02),
                    child: Text(
                      "Are you sure you want to leave this event?",
                      style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                          color: ConstColor.white_Color,
                          height: 1.4,
                          fontSize: width * 0.043),
                    ),
                  ),
                  actions: [
                    // GestureDetector(
                    //   onTap: () {
                    //     setState(() {
                    //       currentIndex = 0;
                    //       lastIndex = 0;
                    //     });
                    //     Navigator.pop(context);
                    //   },
                    //   child: Text(
                    //     "No",
                    //     style: AppTheme.getTheme()
                    //         .textTheme
                    //         .bodyText2!
                    //         .copyWith(
                    //             color: ConstColor.primaryColor,
                    //             height: 2,
                    //             fontSize: width * 0.06),
                    //   ),
                    // ),
                    Container(
                      margin: EdgeInsets.only(
                          left: width * 0.02, right: width * 0.02),
                      child: GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          setState(() {
                            currentIndex = val;
                            lastIndex = currentIndex;
                          });
                        },
                        child: Text(
                          "Yes",
                          style: AppTheme.getTheme()
                              .textTheme
                              .bodyText2!
                              .copyWith(
                                  color: ConstColor.primaryColor,
                                  height: 2,
                                  fontSize: width * 0.06),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            setState(() {
              currentIndex = val;
              lastIndex = currentIndex;
            });
          }
        },
      ),

      ///------- tab screen view ----------
      body: viewContainer[currentIndex],
    );
  }
}
