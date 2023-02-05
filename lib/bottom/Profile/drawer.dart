import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:omw/authentication/addProfileScreen.dart';
import 'package:omw/authentication/tutorialScreen.dart';
import 'package:omw/bottom/Events/Myevents/myEvent_screen.dart';
import 'package:omw/bottom/Profile/profile_screen.dart';

import 'package:omw/constant/theme.dart';
import 'package:omw/setting/setting_screen.dart';
import 'package:provider/provider.dart';

import '../../../constant/constants.dart';
import '../../../utils/colorUtils.dart';
import '../../../utils/textUtils.dart';
import '../../notifier/authenication_notifier.dart';
import '../../setting/bugReport&suggestions_screen.dart';
import '../payment/payment_screen.dart';

class CommonDrawer extends StatefulWidget {
  const CommonDrawer({Key? key}) : super(key: key);

  @override
  State<CommonDrawer> createState() => _CommonDrawerState();
}

class _CommonDrawerState extends State<CommonDrawer> {
  @override
  void initState() {
    var objProviderNotifier =
        Provider.of<AuthenicationNotifier>(context, listen: false);
    objProviderNotifier.getUserDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final objProviderNotifier = context.watch<AuthenicationNotifier>();
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(
          top: AppBar().preferredSize.height * 1.5,
          right: width * 0.15,
          left: width * 0.03,
          bottom: height * 0.12),
      decoration: BoxDecoration(
        color: ConstColor.black_Color,
        borderRadius: BorderRadius.circular(
          height * 0.03,
        ),
        border: Border.all(
          color: ConstColor.textFormFieldColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              objProviderNotifier.objUsers == null ||
                      objProviderNotifier.objUsers == ""
                  ? Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    )
                  : Container(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => ProfileScreen(
                            fcmtoken: objProviderNotifier.objUsers.fcmToken!,
                            userId: objProviderNotifier.objUsers.uid!,
                            isOwnProfile: true,
                            profile: objProviderNotifier.objUsers.userProfile!,
                            name: "${objProviderNotifier.objUsers.firstName![0].toUpperCase()}${objProviderNotifier.objUsers.firstName!.substring(1).toLowerCase()}" +
                                " " +
                                "${objProviderNotifier.objUsers.lastName![0].toUpperCase()}${objProviderNotifier.objUsers.lastName!.substring(1).toLowerCase()}",
                          )),
                    ),
                  ).whenComplete(() {
                    Navigator.pop(context);
                  });
                  ;
                },
                child: Container(
                  margin: EdgeInsets.all(height * 0.03),
                  padding: EdgeInsets.all(height * 0.02),
                  decoration: BoxDecoration(
                    color: ConstColor.black_Color,
                    borderRadius: BorderRadius.circular(
                      height * 0.02,
                    ),
                    border: Border.all(color: ConstColor.textFormFieldColor),
                  ),
                  child: Row(
                    children: [
                      ///-------------Profile Image--------------
                      Container(
                        height: height * 0.07,
                        width: height * 0.07,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: primaryColor, width: height * 0.00)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(height * 0.1),
                          child: CachedNetworkImage(
                            imageUrl: objProviderNotifier.objUsers.userProfile!,
                            height: height * 0.06,
                            width: height * 0.06,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(
                              color: primaryColor,
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                              left: width * 0.02, right: width * 0.02),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ///---------------- Name  ---------------
                              Text(
                                "${objProviderNotifier.objUsers.firstName![0].toUpperCase()}${objProviderNotifier.objUsers.firstName!.substring(1).toLowerCase()}" +
                                    " " +
                                    (objProviderNotifier
                                            .objUsers.lastName!.isEmpty
                                        ? ""
                                        : "${objProviderNotifier.objUsers.lastName![0].toUpperCase()}${objProviderNotifier.objUsers.lastName!.substring(1).toLowerCase()}"),
                                style: AppTheme.getTheme()
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                        decoration: TextDecoration.none,
                                        color: ConstColor.white_Color,
                                        fontSize: width * 0.035),
                              ),

                              ///--------------------Email------------
                              // Container(
                              //   margin: EdgeInsets.only(top: height * 0.002),
                              //   child: Text(
                              //     objProviderNotifier.objUsers.emailId!,
                              //     style: AppTheme.getTheme()
                              //         .textTheme
                              //         .bodyText1!
                              //         .copyWith(
                              //             decoration: TextDecoration.none,
                              //             color: ConstColor.white_Color,
                              //             fontSize: width * 0.03),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      )

                      ///-------------- Arrow Icon------------
                      ,
                      Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: ConstColor.white_Color,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),

          Expanded(
            child: Column(
              children: [
                ///-------------- My Events Button ----------

                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => MyEventScreen()),
                        ),
                      );
                    },
                    child: ComanButton("Hosted Events", ConstantData.calender,
                        height * 0.028, width * 0.04)),

                ///-------------- payment button ----------

                // GestureDetector(
                //     onTap: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: ((context) => PaymentScreen()),
                //         ),
                //       ).whenComplete(() => Navigator.pop(context));
                //     },
                //     child: ComanButton(TextUtils.Payment, ConstantData.rs,
                //         height * 0.028, width * 0.04)),

                ///-------------- Complete Profile Button ----------

                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => SettingScreen()),
                        ),
                      );
                    },
                    child: ComanButton(TextUtils.Settings, ConstantData.setting,
                        height * 0.028, width * 0.03)),
                objProviderNotifier.objUsers.lastName!.isEmpty
                    ? GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => AddProfileScreen()),
                            ),
                          );
                        },
                        child: ComanButton("Complete your profile",
                            ConstantData.contact, height * 0.028, width * 0.03))
                    : Container(),

                // See tutorial
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => TutorialScreen()),
                        ),
                      );
                    },
                    child: ComanButton("How to Use OMW", ConstantData.menu,
                        height * 0.028, width * 0.03)),
              ],
            ),
          ),

          ///-------------- add bug report button ----------

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => BugReportScreen()),
                ),
              ).whenComplete(() => Navigator.pop(context));
            },
            child: Container(
              margin: EdgeInsets.only(
                  bottom: height * 0.02,
                  left: width * 0.03,
                  right: width * 0.03),
              alignment: Alignment.center,
              child: Text(
                TextUtils.bug,
                textAlign: TextAlign.center,
                style: AppTheme.getTheme().textTheme.bodyText2!.copyWith(
                      decoration: TextDecoration.none,
                      fontSize: width * 0.049,
                      color: ConstColor.white_Color,
                    ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget ComanButton(
      String name, String image, double imgheight, double leftMargin) {
    return Container(
      margin: EdgeInsets.only(
          top: height * 0.02, left: height * 0.03, right: height * 0.03),
      padding: EdgeInsets.fromLTRB(
          height * 0.015, height * 0.021, height * 0.01, height * 0.021),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height * 0.018),
        color: ConstColor.primaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: imgheight,
            fit: BoxFit.cover,
            color: ConstColor.black_Color,
          ),
          // ------------ Text View-----------
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: leftMargin, top: height * 0.003),
              child: Text(
                name,
                style: AppTheme.getTheme().textTheme.bodyText2!.copyWith(
                      decoration: TextDecoration.none,
                      fontSize: width * 0.045,
                      color: ConstColor.black_Color,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
