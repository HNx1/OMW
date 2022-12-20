import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:omw/constant/theme.dart';
import 'package:omw/utils/colorUtils.dart';
import 'package:omw/widget/commonButton.dart';

import '../constant/constants.dart';
import '../setting/cookiPolicy_screen.dart';
import '../setting/privacyPolicy_screen.dart';
import '../setting/termsAndCondition_screen.dart';
import '../utils/textUtils.dart';
import '../widget/commonOutLineButton.dart';
import '../widget/routesFile.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppTheme.getTheme().scaffoldBackgroundColor,
      body: Container(
        margin: EdgeInsets.only(
            top: AppBar().preferredSize.height / 2,
            left: width * 0.03,
            right: width * 0.03),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ///-------------------- OMW---------------------
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, Routes.Admin);
              },
              child: Center(
                child: Image.asset(
                  ConstantData.logo,
                  height: height * 0.2,
                  width: height * 0.2,
                  fit: BoxFit.contain,
                ),
              ),

              // Center(
              //   child:
              //    Text(
              //     TextUtils.Omw,
              //     style: AppTheme.getTheme().textTheme.subtitle1!.copyWith(
              //           color: primaryColor,
              //           fontWeight: FontWeight.w700,
              //           fontSize: width * 0.14,
              //         ),
              //     textAlign: TextAlign.center,
              //   ),
              // ),
            ),

            ///-------------------- Sub text ---------------------
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  margin:
                      EdgeInsets.only(left: width * 0.04, right: width * 0.04),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text:
                          "By tapping “Create account ” or “Sign in”, you agree to our ",
                      style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                            color: ConstColor.white_Color,
                            height: 1.4,
                            fontWeight: FontWeight.w400,
                            fontSize: width * 0.043,
                          ),
                      children: [
                        TextSpan(
                          text: "Terms",
                          style:
                              AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                                    color: ConstColor.white_Color,
                                    decoration: TextDecoration.underline,
                                    height: 1.4,
                                    fontWeight: FontWeight.w400,
                                    fontSize: width * 0.04,
                                  ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TermsAndCondition(
                                    isfromWelcome: true,
                                  ),
                                ),
                              );
                            },
                        ),
                        TextSpan(
                          text: ". Learn how we process your data in our ",
                          style:
                              AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                                    color: ConstColor.white_Color,
                                    height: 1.4,
                                    fontWeight: FontWeight.w400,
                                    fontSize: width * 0.04,
                                  ),
                        ),
                        TextSpan(
                          text: "Privacy Policy",
                          style:
                              AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                                    color: ConstColor.white_Color,
                                    height: 1.4,
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.underline,
                                    fontSize: width * 0.04,
                                  ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PrivacyPolicyScreen(
                                    isfromWelcome: true,
                                  ),
                                ),
                              );
                            },
                        ),
                        TextSpan(
                          text: " and ",
                          style:
                              AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                                    color: ConstColor.white_Color,
                                    height: 1.4,
                                    fontWeight: FontWeight.w400,
                                    fontSize: width * 0.04,
                                  ),
                        ),
                        TextSpan(
                          text: "Cookies Policy",
                          style:
                              AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                                    color: ConstColor.white_Color,
                                    height: 1.4,
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.underline,
                                    fontSize: width * 0.04,
                                  ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CookiesPolicy(
                                    isfromWelcome: true,
                                  ),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),

                ///--------------------  Create Account Button ---------------------
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, Routes.SignUp);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: height * 0.068),
                    child: CommonButton(name: TextUtils.createAccount),
                  ),
                ),

                ///--------------------  Sign In Button ---------------------
                Container(
                  margin: EdgeInsets.only(bottom: height * 0.05),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, Routes.Login);
                    },
                    child: CommonOutLineButton(
                      name: TextUtils.signin,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
