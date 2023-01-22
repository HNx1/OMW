import 'package:flutter/material.dart';
import 'package:omw/constant/theme.dart';
import 'package:omw/Admin/bugReport&suggestions_screen.dart';
import 'package:omw/utils/colorUtils.dart';
import 'package:provider/provider.dart';

import '../constant/constants.dart';
import '../notifier/authenication_notifier.dart';
import '../utils/textUtils.dart';
import 'edit_cookiesPolicy.dart';
import 'edit_privacyPolicy_screen.dart';
import 'edit_termsAndConditions.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    final objAuthProvider = context.watch<AuthenicationNotifier>();
    return Scaffold(
      //--------------------Appbar ------------------------------
      appBar: AppBar(
        backgroundColor: AppTheme.getTheme().scaffoldBackgroundColor,
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
        child: Container(
          margin: EdgeInsets.only(
              top: height * 0.03, left: width * 0.03, right: width * 0.03),
          child: Column(
            children: [
              ///----------------- mail box-----------------
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => EditPrivacyPolicy())));
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
                          builder: ((context) => const EditCookiesPolicy())));
                },
                child: commanSetting(
                  ConstantData.cookie,
                  TextUtils.Cookies,
                  true,
                ),
              ),

              ///-------------- terms and Conditions --------------
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => EditTermAndConditions()),
                    ),
                  );
                },
                child: commanSetting(
                  ConstantData.script,
                  TextUtils.Terms,
                  true,
                ),
              ),

              ///-------------- terms and Conditions --------------
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => const EditBugReportAndSuggestion()),
                    ),
                  );
                },
                child: commanSetting(
                  ConstantData.mailBox,
                  TextUtils.bug,
                  true,
                ),
              ),

              ///---------------- log Out-------------------
              GestureDetector(
                onTap: () async {
                  await objAuthProvider.signOut(context);
                },
                child: commanSetting(
                  ConstantData.logout,
                  TextUtils.LogOut,
                  false,
                ),
              ),
            ],
          ),
        ),
      ),
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
                  height: 0.8,
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
}
