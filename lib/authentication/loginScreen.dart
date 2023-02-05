import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:omw/authentication/forgotPassword.dart';
import 'package:provider/provider.dart';

import '../constant/constants.dart';
import '../constant/theme.dart';
import '../notifier/authenication_notifier.dart';
import '../notifier/changenotifier.dart';
import '../preference/preference.dart';
import '../utils/colorUtils.dart';
import '../utils/textUtils.dart';
import '../widget/commonButton.dart';
import '../widget/routesFile.dart';
import '../widget/scaffold_snackbar.dart';
import '../widget/validation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscure = true;

  viewPassword() {
    setState(() {
      obscure = !obscure;
    });
  }

  dynamic passwordMatch;
  late final FirebaseMessaging _messaging;
  String? token;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  @override
  void initState() {
    var objProviderNotifier =
        Provider.of<AuthenicationNotifier>(context, listen: false);
    objProviderNotifier.isLoading = false;
    _messaging = FirebaseMessaging.instance;

    super.initState();
    getToken();
  }

  getToken() async {
    await _messaging.getToken().then((value) {
      print("========================== >Token :-$value");
      setState(() {
        token = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var objProviderNotifier = context.watch<AuthenicationNotifier>();
    var objemaildata = context.watch<ProviderNotifier>();
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(
                left: width * 0.035,
                right: width * 0.035,
                top: AppBar().preferredSize.height / 2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //------------------------------OMW Logo--------------------------

                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.zero,
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Image.asset(
                                ConstantData.logo,
                                height: height * 0.2,
                                width: height * 0.2,
                                fit: BoxFit.contain,
                              ),
                            ),
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
                            //------------------------------enter email View-----------------------
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: height * 0.05, top: height * 0.17),
                              child: Text(
                                TextUtils.Login,
                                style: AppTheme.getTheme()
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                        fontSize: width * 0.08,
                                        color: ConstColor.white_Color),
                              ),
                            ),
                            TextFormField(
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

                            ///--------------------password --------------
                            Container(
                              margin: EdgeInsets.only(top: height * 0.03),
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode.disabled,
                                style: AppTheme.getTheme()
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      fontSize: width * 0.041,
                                      color: ConstColor.white_Color,
                                    ),
                                obscureText: obscure,
                                controller: _passwordController,
                                decoration: InputDecoration(
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
                                      Icons.remove_red_eye,
                                      color: ConstColor.white_Color,
                                      size: width * 0.04,
                                    ),
                                  ),
                                  border: InputBorder.none,
                                  errorMaxLines: 2,
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
                                      vertical: height * 0.025),
                                  hintText: TextUtils.EnterPassword,
                                  hintStyle: AppTheme.getTheme()
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        fontSize: width * 0.041,
                                        color: ConstColor.white_Color,
                                      ),
                                ),
                                validator: isvalidPassword,
                              ),
                            ),

                            ///---------- Forgot Password-------------
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ForgotPassword(
                                              isSignUp: false,
                                            )));
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: height * 0.007),
                                alignment: Alignment.topRight,
                                child: Text(
                                  TextUtils.Forgotpassword,
                                  style: AppTheme.getTheme()
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: ConstColor.white_Color,
                                        height: 1.4,
                                        fontWeight: FontWeight.w400,
                                        fontSize: width * 0.038,
                                      ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  //-------------------------------Login Button View------------------------
                  objProviderNotifier.isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : Container(),
                  Container(
                    margin: EdgeInsets.only(bottom: height * 0.03),
                    child: GestureDetector(
                        onTap: () async {
                          final isValid = formKey.currentState!.validate();
                          if (isValid) {
                            objemaildata.setemail = _emailController.text;
                            await objProviderNotifier
                                .signInWithEmailAndPassword(
                                    context,
                                    _emailController.text.toLowerCase(),
                                    _passwordController.text,
                                    token!);
                            if (objProviderNotifier.isCurretPassword == true &&
                                objProviderNotifier.isSignUp == true) {
                              if (FirebaseAuth
                                      .instance.currentUser!.emailVerified ==
                                  false) {
                                ScaffoldSnackbar.of(context).show(
                                    "Click the verification link from your email");
                                objProviderNotifier.isSignUp = false;

                                objProviderNotifier.isLoading = false;
                              } else {
                                await objProviderNotifier.getUserDetail();
                                if (objProviderNotifier.objUsers.role ==
                                        "admin" &&
                                    objProviderNotifier.objUsers.emailId ==
                                        _emailController.text.toLowerCase()) {
                                  PrefServices().setIsUserLoggedIn(true);
                                  Navigator.pushReplacementNamed(
                                      context, Routes.Admin);
                                  PrefServices().setCurrentUserName(
                                      objProviderNotifier.objUsers.firstName! +
                                          " " +
                                          objProviderNotifier
                                              .objUsers.lastName!);
                                } else if (objProviderNotifier.objUsers.role ==
                                        "user" &&
                                    objProviderNotifier.objUsers.emailId ==
                                        _emailController.text.toLowerCase()) {
                                  PrefServices().setIsUserLoggedIn(true);
                                  PrefServices().setCurrentUserName(
                                      objProviderNotifier.objUsers.firstName! +
                                          " " +
                                          objProviderNotifier
                                              .objUsers.lastName!);
                                  PrefServices().setCurrentUserId(
                                      objProviderNotifier.objUsers.uid!);
                                  PrefServices().setCurrentPhoneNumber(
                                      objProviderNotifier
                                          .objUsers.phoneNumber!);
                                  Navigator.pushReplacementNamed(
                                      context, Routes.HOME);
                                } else {
                                  Navigator.pushReplacementNamed(
                                      context, Routes.Profile);
                                  objProviderNotifier.isLoading = false;
                                  objProviderNotifier.isSignUp = false;
                                }
                              }
                            }
                          }
                        },
                        child: CommonButton(
                          name: TextUtils.Login,
                        )),
                  )

                  ///------------ don't have account------------------
                  ,
                  Container(
                    margin: EdgeInsets.only(bottom: height * 0.04),
                    alignment: Alignment.center,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: TextUtils.DonthvAccount + " ",
                        style:
                            AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                                  color: ConstColor.white_Color,
                                  height: 1.4,
                                  fontWeight: FontWeight.w400,
                                  fontSize: width * 0.038,
                                ),
                        children: [
                          TextSpan(
                            text: TextUtils.Signup,
                            style: AppTheme.getTheme()
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                  color: ConstColor.primaryColor,
                                  decoration: TextDecoration.underline,
                                  height: 1.4,
                                  fontWeight: FontWeight.w400,
                                  fontSize: width * 0.038,
                                ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacementNamed(
                                    context, Routes.SignUp);
                              },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
