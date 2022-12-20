import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:omw/bottom/bottomtab.dart';

import '../../../constant/constants.dart';
import '../../../constant/theme.dart';
import '../../../utils/colorUtils.dart';
import '../../../utils/textUtils.dart';
import 'myPastEvent_screen.dart';
import 'myUpcoming_screen.dart';

class MyEventScreen extends StatefulWidget {
  const MyEventScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MyEventScreen> createState() => _MyEventScreenState();
}

class _MyEventScreenState extends State<MyEventScreen> {
  int index = 0;
  bool shouldPop = true;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        shouldPop
            ? Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => BottomNavBarScreen(
                          index: 1,
                          lastIndex: 1,
                        )))
            : Navigator.pop(context);
        return shouldPop;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppTheme.getTheme().backgroundColor,

          ///------------------- Drawer------------------------
          leading: Container(
            margin: EdgeInsets.only(left: width * 0.03),
            child: GestureDetector(
              onTap: () {
                // Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BottomNavBarScreen(
                              index: 1,
                              lastIndex: 1,
                            )));
              },
              child: Icon(
                Icons.arrow_back_ios_rounded,
                color: ConstColor.primaryColor,
                size: width * 0.06,
              ),
            ),
          ),
          leadingWidth: width * 0.1,

          ///------------------------ my Events title-------------------------
          title: Text(
            TextUtils.myEvent,
            style: AppTheme.getTheme().textTheme.subtitle1!.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: width * 0.055,
                ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                    top: height * 0.018,
                    left: width * 0.03,
                    right: width * 0.03),
                child: Column(
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ///------------------------------- UpComing ----------------------
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                index = 0;
                              });
                            },
                            child: Container(
                              width: width * 0.36,
                              padding: EdgeInsets.all(height * 0.014),
                              decoration: BoxDecoration(
                                color: index != 0
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
                                          color: index != 0
                                              ? Color(0xffA5A5A5)
                                              : ConstColor.black_Color,
                                          fontSize: width * 0.043,
                                          fontWeight: index != 0
                                              ? FontWeight.normal
                                              : FontWeight.w700),
                                ),
                              ),
                            ),
                          ),

                          ///------------------------------- Past ----------------------
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                index = 1;
                              });
                            },
                            child: Container(
                              width: width * 0.29,
                              padding: EdgeInsets.all(height * 0.014),
                              decoration: BoxDecoration(
                                color: index != 1
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
                                          color: index != 1
                                              ? Color(0xffA5A5A5)
                                              : ConstColor.black_Color,
                                          fontSize: width * 0.043,
                                          fontWeight: index != 1
                                              ? FontWeight.normal
                                              : FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    index == 0
                        ? MyUpcomingScreen()
                        : index == 1
                            ? MyPastEvents()
                            : Container()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
