import 'package:flutter/material.dart';
import 'package:omw/setting/blockUser_List.dart';

import 'package:provider/provider.dart';

import '../../../../constant/constants.dart';
import '../../../../constant/theme.dart';
import '../../../../utils/colorUtils.dart';
import '../../../../utils/textUtils.dart';
import '../../../notifier/authenication_notifier.dart';

import 'change_myEmail_screen.dart';
import 'change_my_Name.dart';
import 'changemyPhone_screen.dart';
import 'chnageUserProflie.dart';
import 'chnage_mypassword_screen.dart';
import 'cookiPolicy_screen.dart';
import 'privacyPolicy_screen.dart';
import 'termsAndCondition_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    final objAuthProvider = context.watch<AuthenicationNotifier>();
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

            ///-------------------- Setting text  ---------------------
            Text(
          TextUtils.Settings,
          style: AppTheme.getTheme().textTheme.bodyText2!.copyWith(
              color: ConstColor.primaryColor,
              height: 1.4,
              fontSize: width * 0.052),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
          padding: EdgeInsets.all(height * 0.02),
          child: Column(
            children: [
              ///-------------Change Name, PhoneNumber & Password-------------
              Theme(
                data: ThemeData(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                ),
                child: ExpansionTile(
                  collapsedBackgroundColor: Colors.transparent,
                  tilePadding: EdgeInsets.zero,
                  onExpansionChanged: (val) {
                    setState(() {
                      isExpanded = val;
                    });
                  },
                  leading: Image.asset(
                    ConstantData.user,
                    height: height * 0.065,
                  ),
                  trailing: Icon(
                    isExpanded == true
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right_sharp,
                    size: width * 0.07,
                    color: ConstColor.white_Color,
                  ),
                  title: Text(
                    "Edit Profile",
                    style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                        decoration: TextDecoration.none,
                        color: ConstColor.white_Color,
                        fontSize: width * 0.044),
                  ),
                  children: [
                    ///------------------- change Name-------------------
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const ChangeMyName())));
                        },
                        child: CoomanNameText(TextUtils.ChangeMyName)),

                    ///------------------- change phone number-------------------
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => const ChangeMyPhoneNoScreen()),
                            ),
                          );
                        },
                        child: CoomanNameText(TextUtils.ChangeMyPhoneNumber)),

                    ///------------------- change Email-------------------
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) =>
                                      const ChangeMyEmailScreen())));
                        },
                        child: CoomanNameText(TextUtils.ChangeMyEmail)),

                    ///------------ Change Password ------------
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const ChnageMyPassword())));
                        },
                        child: CoomanNameText(TextUtils.ChangeMypassword)),

                    ///------------ Change profile picture ------------
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const ChangeUserProfile())));
                        },
                        child: CoomanNameText(TextUtils.updateProfile)),
                  ],
                ),
              ),

              Container(
                height: 0.8,
                width: width,
                color: const Color(0xff5B5B5B).withOpacity(0.56),
                margin: EdgeInsets.only(
                    top: height * 0.026, bottom: height * 0.026),
              ),

              // ///--------------Block User List --------------
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => const BlockUserList()),
                    ),
                  );
                },
                child: commanSetting(
                  ConstantData.block,
                  TextUtils.BlockUser,
                  true,
                ),
              ),

              ///-------------- terms and Conditions --------------
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => const TermsAndCondition(
                            isfromWelcome: false,
                          )),
                    ),
                  );
                },
                child: commanSetting(
                  ConstantData.script,
                  TextUtils.Terms,
                  true,
                ),
              ),

              ///-------------- Privacy Policy --------------
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => const PrivacyPolicyScreen(
                            isfromWelcome: false,
                          )),
                    ),
                  );
                },
                child: commanSetting(
                  ConstantData.privacy,
                  TextUtils.Privacy,
                  true,
                ),
              ),

              ///-------------- Cookies Policy --------------
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const CookiesPolicy(
                                isfromWelcome: false,
                              ))));
                },
                child: commanSetting(
                  ConstantData.cookie,
                  TextUtils.Cookies,
                  true,
                ),
              ),

              ///-------------- Push Notification --------------
              // GestureDetector(
              //   onTap: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: ((context) => NotificationSettings(
              //                   isfromWelcome: false,
              //                 ))));
              //   },
              //   child: commanSetting(
              //     ConstantData.notifiaction,
              //     TextUtils.notificationSettings,
              //     true,
              //   ),
              // ),

              ///-------------- Log Out  --------------
              GestureDetector(
                onTap: () async {
                  await objAuthProvider.signOut(context);
                },
                child: commanSetting(
                  ConstantData.logout,
                  TextUtils.LogOut,
                  true,
                ),
              ),

              ///-------------- Delete Account  --------------
              GestureDetector(
                onTap: () {
                  print('tapped');
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: const Color.fromARGB(255, 15, 15, 15),
                        title: Container(
                          margin: EdgeInsets.only(
                              left: width * 0.03, right: width * 0.03),
                          child: Text(
                            "Are you sure you want to permanently delete your account?",
                            style: AppTheme.getTheme()
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    color: ConstColor.white_Color,
                                    height: 1.4,
                                    fontSize: width * 0.043),
                          ),
                        ),
                        actions: [
                          GestureDetector(
                            onTap: () {
                              //setState(() {
                              //  currentIndex = 0;
                              //  lastIndex = 0;
                              //});
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Cancel",
                              style: AppTheme.getTheme()
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                      color: ConstColor.primaryColor,
                                      height: 1.4,
                                      fontSize: width * 0.04),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: width * 0.03, right: width * 0.03),
                            child: GestureDetector(
                              onTap: () async {
                                await objAuthProvider.deleteUser(context);
                              },
                              child: Text(
                                "Yes",
                                style: AppTheme.getTheme()
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                        color: ConstColor.primaryColor,
                                        height: 1.4,
                                        fontSize: width * 0.04),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: commanSetting(
                  ConstantData.delete,
                  TextUtils.DeleteAccount,
                  false,
                ),
              ),
            ],
          )),
    );
  }

  Widget commanSetting(String image, String text, bool wantDivider) {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    image,
                    height: height * 0.065,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: width * 0.05),
                    child: Text(
                      text,
                      style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                          decoration: TextDecoration.none,
                          color: ConstColor.white_Color,
                          fontSize: width * 0.044),
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.keyboard_arrow_right_sharp,
                size: width * 0.07,
                color: ConstColor.white_Color,
              )
            ],
          ),
          wantDivider == true
              ? Container(
                  height: 1,
                  width: width,
                  color: const Color(0xff5B5B5B).withOpacity(0.56),
                  margin: EdgeInsets.only(
                      top: height * 0.026, bottom: height * 0.026),
                )
              : Container()
        ],
      ),
    );
  }

  Widget CoomanNameText(String text) {
    return Container(
      margin: EdgeInsets.only(top: height * 0.01, bottom: height * 0.02),
      child: Text(
        text, //TextUtils.ChangeMyName,
        style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
            decoration: TextDecoration.none,
            color: ConstColor.primaryColor,
            fontSize: width * 0.044),
      ),
    );
  }
}
