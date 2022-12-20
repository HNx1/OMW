import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constant/constants.dart';
import '../constant/theme.dart';
import '../notifier/authenication_notifier.dart';
import '../utils/colorUtils.dart';
import '../utils/textUtils.dart';
import '../widget/commonButton.dart';
import '../widget/commonTextFromField.dart';
import '../widget/routesFile.dart';
import '../widget/validation.dart';

class ForgotPassword extends StatefulWidget {
  final bool isSignUp;
  const ForgotPassword({
    Key? key,
    required this.isSignUp,
  }) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var formKey = GlobalKey<FormState>();
  TextEditingController _EmailController = TextEditingController();

  bool isTappedWay = false;
  bool isRetun = true;
  @override
  Widget build(BuildContext context) {
    final objAuthrovider = context.watch<AuthenicationNotifier>();
    return WillPopScope(
      onWillPop: () async {
        widget.isSignUp
            ? Navigator.pushReplacementNamed(context, Routes.SignUp)
            : Navigator.pushReplacementNamed(context, Routes.Login);

        return widget.isSignUp;
      },
      child: Scaffold(
        //--------------------Arrow back Icon------------------------------
        appBar: AppBar(
          backgroundColor: AppTheme.getTheme().scaffoldBackgroundColor,
          leading: GestureDetector(
            onTap: () {
              widget.isSignUp
                  ? Navigator.pushReplacementNamed(context, Routes.SignUp)
                  : Navigator.pushReplacementNamed(context, Routes.Login);
            },
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: ConstColor.primaryColor,
              size: width * 0.06,
            ),
          ),
          leadingWidth: width * 0.1,
          title:

              ///-------------------- Forgot Password text  ---------------------
              Text(
            TextUtils.Forgot,
            style: AppTheme.getTheme().textTheme.bodyText2!.copyWith(
                color: ConstColor.primaryColor,
                height: 1.4,
                fontSize: width * 0.052),
          ),
          centerTitle: true,
        ),

        body: Container(
          margin: EdgeInsets.only(
              bottom: height * 0.04, left: width * 0.04, right: width * 0.04),
          child: Stack(
            alignment: Alignment.center,
            children: [
              objAuthrovider.isLoading == true
                  ? CircularProgressIndicator(
                      color: primaryColor,
                    )
                  : Container(),
              Column(
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        ///-------------------- Lock Image  ---------------------
                        Container(
                          margin: EdgeInsets.only(top: height * 0.04),
                          child: Image.asset(
                            ConstantData.forgot,
                            height: height * 0.26,
                            fit: BoxFit.contain,
                          ),
                        ),

                        ///-------------------- Please Enter Email Text ---------------------
                        Container(
                          margin: EdgeInsets.only(
                              top: height * 0.1, bottom: height * 0.07),
                          child: Text(
                            TextUtils.Email,
                            style: AppTheme.getTheme()
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    color: ConstColor.white_Color,
                                    height: 1.5,
                                    fontSize: width * 0.043),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        ///-------------------- email TextField ---------------------
                        Form(
                          key: formKey,
                          child: CommonTextFromField(
                            textCapitalization: TextCapitalization.none,
                            inputType: TextInputType.emailAddress,

                            controller: _EmailController,
                            txt: TextUtils.enterEmail,

                            // validator: isTappedWay ? isValidEmail : validateMobile,
                            validator: isValidEmail,
                          ),
                        ),

                        ///-------------------- Try another way---------------------
                       
                      ],
                    ),
                  ),

                  ///-------------------- send Button ---------------------
                  GestureDetector(
                    onTap: () {
                      final isValid = formKey.currentState!.validate();
                      if (isValid) {
                        objAuthrovider.resetPassword(
                            context, _EmailController.text);
                        
                      }
                    },
                    child: CommonButton(
                      name: TextUtils.Send,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
