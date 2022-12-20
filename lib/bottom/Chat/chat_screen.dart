import 'package:flutter/material.dart';

import '../../constant/constants.dart';
import '../../constant/theme.dart';
import '../../utils/colorUtils.dart';
import '../../utils/textUtils.dart';
import '../Profile/drawer.dart';
import 'All_Chat/all_chat_screen.dart';
import 'IndividualChat/individual_chat-screen.dart';
import 'Group_Chat/group_chat_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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

              ///-------------------- Chat Text   ---------------------

              GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => IndividualChatScreen()));
            },
            child: Image.asset(
              ConstantData.logo,
              height: height * 0.12,
              width: height * 0.12,
              fit: BoxFit.contain,
            ),
            // Text(
            //   TextUtils.Omw,
            //   style: AppTheme.getTheme().textTheme.subtitle1!.copyWith(
            //         color: primaryColor,
            //         fontWeight: FontWeight.w700,
            //         fontSize: width * 0.09,
            //       ),
            // ),
          ),
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

                      ///---------------- Group --------------------
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
                                TextUtils.Group,
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

                      ///---------------- Individual  --------------------
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
                                TextUtils.Individual,
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
                index == 0
                    ? AllChatScreen()
                    : index == 1
                        ? GroupChatScreen()
                        : IndividualChatScreen()
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
