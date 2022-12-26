import 'package:flutter/material.dart';

import '../constant/constants.dart';
import '../constant/theme.dart';
import '../utils/colorUtils.dart';
import '../widget/routesFile.dart';

class VerifyEmailPopUp extends StatefulWidget {
  const VerifyEmailPopUp({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPopUp> createState() => _VerifyEmailPopUpState();
}

class _VerifyEmailPopUpState extends State<VerifyEmailPopUp> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(left: width * 0.04, right: width * 0.04),
          padding: EdgeInsets.only(
              top: height * 0.02,
              left: width * 0.036,
              right: width * 0.036,
              bottom: height * 0.01),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height * 0.016),
            color: Color.fromARGB(255, 15, 15, 15),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: width * 0.03),
                child: Text(
                  "Please verify your email using the link we just sent to you. \n\n Then you can log in with your new account.",
                  style: AppTheme.getTheme().textTheme.bodyText2!.copyWith(
                      color: ConstColor.white_Color,
                      height: 1.4,
                      fontSize: width * 0.043),
                ),
              ),

              ///------------------- Divider --------------------
              Container(
                margin:
                    EdgeInsets.only(top: height * 0.022, bottom: height * 0.01),
                height: 1,
                width: width,
                color: Color.fromARGB(255, 187, 171, 171).withOpacity(0.2),
              ),

              ///------------------- Message David--------------------
              GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, Routes.Login);
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      top: height * 0.030,
                    ),
                    padding: EdgeInsets.only(
                        left: width * 0.05,
                        right: width * 0.05,
                        top: height * 0.01,
                        bottom: height * 0.01),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(height * 0.1),
                      color: ConstColor.primaryColor,
                    ),
                    child: Text(
                      "Okay",
                      style: AppTheme.getTheme().textTheme.bodyText2!.copyWith(
                            fontSize: width * 0.055,
                            color: ConstColor.black_Color,
                          ),
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
