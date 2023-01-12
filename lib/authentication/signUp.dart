import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:omw/constant/constants.dart';
import 'package:provider/provider.dart';

import '../constant/theme.dart';
import '../notifier/authenication_notifier.dart';
import '../notifier/changenotifier.dart';
import '../utils/colorUtils.dart';
import '../utils/textUtils.dart';
import '../widget/commonButton.dart';
import '../widget/routesFile.dart';
import '../widget/validation.dart';
import 'emailVerify.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool obscure = true;
  bool creatingPassword = false;
  bool lengthBool = false;
  bool letterBool = false;
  bool numberBool = false;
  bool charBool = false;
  Pattern letterPattern = r"^(?=.*[A-Za-z])";
  Pattern numberPattern = r"^(?=.*\d)";
  Pattern charPattern = r"^(?=.*[@$!%*#?&_-])";

  viewPassword() {
    setState(() {
      obscure = !obscure;
    });
  }

  @override
  void initState() {
    var objProviderNotifier =
        Provider.of<AuthenicationNotifier>(context, listen: false);
    objProviderNotifier.isLoading = false;
    super.initState();
  }

  var formKey = GlobalKey<FormState>();
  var formKey1 = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final objAuthProvider = context.watch<AuthenicationNotifier>();
    final objProviderNotifier = context.watch<ProviderNotifier>();
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(
            left: width * 0.035,
            right: width * 0.035,
            top: AppBar().preferredSize.height / 2,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              objAuthProvider.isLoading == true
                  ? CircularProgressIndicator(
                      color: primaryColor,
                    )
                  : Container(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(children: [
                    Visibility(
                        visible: creatingPassword,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          padding: EdgeInsets.zero,
                          child: Form(
                            key: formKey1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //------------------------------OMW Logo--------------------------
                                // Center(
                                //   child: Image.asset(
                                //     ConstantData.logo,
                                //     height: height * 0.2,
                                //     width: height * 0.2,
                                //     fit: BoxFit.contain,
                                //   ),
                                // ),
                                // Center(
                                //   child: Text(
                                //     TextUtils.Omw,
                                //     style: AppTheme.getTheme()
                                //         .textTheme
                                //         .subtitle1!
                                //         .copyWith(
                                //           color: primaryColor,
                                //           fontWeight: FontWeight.w700,
                                //           fontSize: width * 0.14,
                                //         ),
                                //     textAlign: TextAlign.center,
                                //   ),
                                // ),
                                //------------------------------Sign Up Text-----------------------
                                Container(
                                  margin: EdgeInsets.only(
                                      bottom: height * 0.04,
                                      top: height * 0.05),
                                  child: Text(
                                    "Password",
                                    style: AppTheme.getTheme()
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                            fontSize: width * 0.08,
                                            color: ConstColor.primaryColor),
                                  ),
                                ),
                                //------------------------------Email textfield-----------------------

                                ///--------------------password textfield --------------
                                Container(
                                  child: TextFormField(
                                    onChanged: (value) {
                                      RegExp letterRegex =
                                          new RegExp(letterPattern as String);
                                      RegExp numberRegex =
                                          new RegExp(numberPattern as String);
                                      RegExp charRegex =
                                          new RegExp(charPattern as String);
                                      setState(() {
                                        lengthBool =
                                            value.length >= 8 ? true : false;
                                        letterBool = letterRegex.hasMatch(value)
                                            ? true
                                            : false;
                                        numberBool = numberRegex.hasMatch(value)
                                            ? true
                                            : false;
                                        charBool = charRegex.hasMatch(value)
                                            ? true
                                            : false;
                                      });
                                    },
                                    autofocus: true,
                                    // scrollPadding: EdgeInsets.only(bottom: 40),
                                    autovalidateMode: AutovalidateMode.disabled,
                                    style: AppTheme.getTheme()
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          fontSize: width * 0.038,
                                          color: ConstColor.white_Color,
                                        ),
                                    obscureText: obscure,
                                    controller: _passwordController,
                                    decoration: InputDecoration(
                                      errorMaxLines: 2,
                                      errorStyle: AppTheme.getTheme()
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                            fontSize: width * 0.036,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.red,
                                          ),
                                      suffixIcon: GestureDetector(
                                        onTap: viewPassword,
                                        child: Icon(
                                          obscure
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: ConstColor.white_Color,
                                          size: width * 0.04,
                                        ),
                                      ),
                                      border: InputBorder.none,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(height * 0.1),
                                        borderSide: BorderSide(
                                          color: ConstColor.textFormFieldColor,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(height * 0.1),
                                        borderSide: BorderSide(
                                          color: ConstColor.textFormFieldColor,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(height * 0.1),
                                        borderSide: BorderSide(
                                          color: ConstColor.textFormFieldColor,
                                        ),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(height * 0.1),
                                        borderSide: BorderSide(
                                          color: ConstColor.textFormFieldColor,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(height * 0.1),
                                        borderSide: BorderSide(
                                          color: ConstColor.textFormFieldColor,
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: width * 0.05,
                                          vertical: height * 0.024),
                                      hintText: TextUtils.EnterPassword,
                                      hintStyle: AppTheme.getTheme()
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                            fontSize: width * 0.041,
                                            color: ConstColor.white_Color,
                                          ),
                                    ),
                                    validator: isValidpassword,
                                  ),
                                ),
                                // Checklists
                                Container(
                                    margin: EdgeInsets.only(top: height * 0.01),
                                    child: Row(children: [
                                      // Checkbox(
                                      //   onChanged: (value) {},
                                      //   value: lengthBool,
                                      //   checkColor: ConstColor.primaryColor,
                                      //   activeColor: ConstColor.black_Color,
                                      // ),
                                      Center(
                                          child: Image.asset(
                                        lengthBool
                                            ? ConstantData.check
                                            : ConstantData.close,
                                        color: lengthBool
                                            ? ConstColor.primaryColor
                                            : Colors.red,
                                        height: height * 0.04,
                                      )),
                                      Text("At least 8 characters",
                                          style: AppTheme.getTheme()
                                              .textTheme
                                              .bodyText2!
                                              .copyWith(
                                                color: ConstColor.white_Color,
                                                fontWeight: FontWeight.w700,
                                                fontSize: width * 0.038,
                                              )),
                                      Center(
                                          child: Image.asset(
                                        letterBool
                                            ? ConstantData.check
                                            : ConstantData.close,
                                        color: letterBool
                                            ? ConstColor.primaryColor
                                            : Colors.red,
                                        height: height * 0.04,
                                      )),
                                      Text("A letter",
                                          style: AppTheme.getTheme()
                                              .textTheme
                                              .bodyText2!
                                              .copyWith(
                                                color: ConstColor.white_Color,
                                                fontWeight: FontWeight.w700,
                                                fontSize: width * 0.038,
                                              )),
                                    ])),
                                Container(
                                    margin: EdgeInsets.only(top: height * 0.01),
                                    child: Row(children: [
                                      Center(
                                          child: Image.asset(
                                        numberBool
                                            ? ConstantData.check
                                            : ConstantData.close,
                                        color: numberBool
                                            ? ConstColor.primaryColor
                                            : Colors.red,
                                        height: height * 0.04,
                                      )),
                                      Text("A number",
                                          style: AppTheme.getTheme()
                                              .textTheme
                                              .bodyText2!
                                              .copyWith(
                                                color: ConstColor.white_Color,
                                                fontWeight: FontWeight.w700,
                                                fontSize: width * 0.038,
                                              )),
                                      Center(
                                          child: Image.asset(
                                        charBool
                                            ? ConstantData.check
                                            : ConstantData.close,
                                        color: charBool
                                            ? ConstColor.primaryColor
                                            : Colors.red,
                                        height: height * 0.04,
                                      )),
                                      Text("A special character (@\$!%*#?&-_)",
                                          style: AppTheme.getTheme()
                                              .textTheme
                                              .bodyText2!
                                              .copyWith(
                                                color: ConstColor.white_Color,
                                                fontWeight: FontWeight.w700,
                                                fontSize: width * 0.038,
                                              )),
                                    ])),
                                // Signup button
                                Container(
                                  margin:
                                      EdgeInsets.only(bottom: height * 0.03),
                                  child: GestureDetector(
                                      onTap: () async {
                                        final isValid =
                                            formKey1.currentState!.validate();

                                        if (isValid) {
                                          objProviderNotifier.setemail =
                                              _emailController.text;
                                          setState(() {});

                                          await objAuthProvider
                                              .fireBaseSignUp(
                                                  context,
                                                  _emailController.text,
                                                  _passwordController.text)
                                              .then((value) {
                                            if (objAuthProvider.isSignUp ==
                                                true) {
                                              showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return VerifyEmailPopUp();
                                                  });
                                            }
                                          });
                                        }
                                      },
                                      child: CommonButton(
                                        name: TextUtils.Signup,
                                      )),
                                )
                              ],
                            ),
                          ),
                        )),
                    Visibility(
                      visible: !creatingPassword,
                      child: SingleChildScrollView(
                          controller: _scrollController,
                          padding: EdgeInsets.zero,
                          child: Column(children: [
                            Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //------------------------------OMW Logo--------------------------
                                  // Center(
                                  //   child: Image.asset(
                                  //     ConstantData.logo,
                                  //     height: height * 0.2,
                                  //     width: height * 0.2,
                                  //     fit: BoxFit.contain,
                                  //   ),
                                  // ),

                                  //------------------------------Sign Up Text-----------------------
                                  Container(
                                    margin: EdgeInsets.only(
                                        bottom: height * 0.04,
                                        top: height * 0.05),
                                    child: Text(
                                      "Email",
                                      style: AppTheme.getTheme()
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(
                                              fontSize: width * 0.08,
                                              color: ConstColor.primaryColor),
                                    ),
                                  ),
                                  //------------------------------Email textfield-----------------------

                                  TextFormField(
                                    autofocus: true,
                                    scrollPadding:
                                        EdgeInsets.only(bottom: height * 0.5),
                                    textCapitalization: TextCapitalization.none,
                                    controller: _emailController,
                                    style: AppTheme.getTheme()
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          fontSize: width * 0.041,
                                          color: ConstColor.white_Color,
                                        ),
                                    decoration: InputDecoration(
                                      errorMaxLines: 2,
                                      border: InputBorder.none,
                                      errorStyle: AppTheme.getTheme()
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                            fontSize: width * 0.036,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.red,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(height * 0.1),
                                        borderSide: BorderSide(
                                          color: ConstColor.textFormFieldColor,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(height * 0.1),
                                        borderSide: BorderSide(
                                          color: ConstColor.textFormFieldColor,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(height * 0.1),
                                        borderSide: BorderSide(
                                          color: ConstColor.textFormFieldColor,
                                        ),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(height * 0.1),
                                        borderSide: BorderSide(
                                          color: ConstColor.textFormFieldColor,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(height * 0.1),
                                        borderSide: BorderSide(
                                          color: ConstColor.textFormFieldColor,
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: width * 0.05,
                                          vertical: height * 0.028),
                                      hintText: TextUtils.enterEmailMessage,
                                      hintStyle: AppTheme.getTheme()
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                            fontSize: width * 0.041,
                                            color: ConstColor.white_Color,
                                          ),
                                    ),
                                    validator: isValidEmail,
                                  ),

                                  ///--------------------Signup--------------
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: height * 0.03),
                              child: GestureDetector(
                                  onTap: () async {
                                    final isValid =
                                        formKey.currentState!.validate();

                                    if (isValid) {
                                      setState(() {
                                        creatingPassword = true;
                                        print("creating password");
                                      });
                                    }
                                  },
                                  child: CommonButton(
                                    name: "Continue",
                                  )),
                            ),

                            ///------------ already have account------------------

                            Container(
                              margin: EdgeInsets.only(bottom: height * 0.04),
                              alignment: Alignment.center,
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: TextUtils.Already + " ",
                                  style: AppTheme.getTheme()
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: ConstColor.white_Color,
                                        height: 1.4,
                                        fontWeight: FontWeight.w400,
                                        fontSize: width * 0.038,
                                      ),
                                  children: [
                                    TextSpan(
                                      text: TextUtils.signin,
                                      style: AppTheme.getTheme()
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                            color: ConstColor.primaryColor,
                                            decoration:
                                                TextDecoration.underline,
                                            height: 1.4,
                                            fontWeight: FontWeight.w400,
                                            fontSize: width * 0.038,
                                          ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.pushReplacementNamed(
                                              context, Routes.Login);
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ])),
                    )
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
