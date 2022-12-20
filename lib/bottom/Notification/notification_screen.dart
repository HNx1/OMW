import 'package:flutter/material.dart';
import 'package:omw/bottom/Notification/all_screen.dart';

import 'package:omw/bottom/Notification/hosting_screen.dart';
import 'package:omw/bottom/Notification/invitations_screen.dart';
import 'package:omw/constant/constants.dart';
import 'package:omw/constant/theme.dart';
import 'package:omw/utils/colorUtils.dart';
import 'package:omw/utils/textUtils.dart';

import '../Profile/drawer.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          backgroundColor: AppTheme.getTheme().scaffoldBackgroundColor,
          leading: Container(
            margin: EdgeInsets.only(left: width * 0.03),
            child: GestureDetector(
              onTap: () {
                _openDrawer();
              },
              child: Image.asset(
                ConstantData.menu2,
                fit: BoxFit.contain,
              ),
            ),
          ),
          leadingWidth: height * 0.055,
          title:

              ///-------------------- Notification Text   ---------------------
              Image.asset(
            ConstantData.logo,
            height: height * 0.12,
            width: height * 0.12,
            fit: BoxFit.contain,
          ),
          //     Text(
          //   TextUtils.Omw,
          //   style: AppTheme.getTheme().textTheme.subtitle1!.copyWith(
          //         color: primaryColor,
          //         fontWeight: FontWeight.w700,
          //         fontSize: width * 0.09,
          //       ),
          // ),
          centerTitle: true,
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(
              top: height * 0.018,
              left: width * 0.03,
              right: width * 0.03,
            ),
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
                      ///---------------- All ------------------------
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              index = 0;
                            });
                          },
                          child: Container(
                            width: width * 0.29,
                            margin: EdgeInsets.all(height * 0.006),
                            padding: EdgeInsets.all(height * 0.014),
                            decoration: BoxDecoration(
                              color: index != 0
                                  ? Colors.transparent
                                  : primaryColor,
                              borderRadius: BorderRadius.circular(height * 0.1),
                            ),
                            child: Center(
                              child: Text(
                                TextUtils.All,
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
                            ),
                          ),
                        ),
                      ),

                      ///---------------- Hosting --------------------
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              index = 1;
                            });
                          },
                          child: Container(
                            width: width * 0.29,
                            margin: EdgeInsets.all(height * 0.006),
                            padding: EdgeInsets.all(height * 0.014),
                            decoration: BoxDecoration(
                              color: index != 1
                                  ? Colors.transparent
                                  : primaryColor,
                              borderRadius: BorderRadius.circular(height * 0.1),
                            ),
                            child: Center(
                              child: Text(
                                TextUtils.Hosting,
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
                            ),
                          ),
                        ),
                      ),

                      ///---------------- Invitations --------------------
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              index = 2;
                            });
                          },
                          child: Container(
                            width: width * 0.29,
                            margin: EdgeInsets.all(height * 0.007),
                            padding: EdgeInsets.all(height * 0.014),
                            decoration: BoxDecoration(
                              color: index != 2
                                  ? Colors.transparent
                                  : primaryColor,
                              borderRadius: BorderRadius.circular(height * 0.1),
                            ),
                            child: Center(
                              child: Text(
                                TextUtils.Invitations,
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
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: index == 0
                        ? AllScreen()
                        : index == 1
                            ? HostingScreen()
                            : InvitationsScreen())
              ],
            ),
          ),
        ),
      ],
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
}
