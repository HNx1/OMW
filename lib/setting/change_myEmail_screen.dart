import 'package:flutter/material.dart';
import 'package:omw/widget/validation.dart';
import 'package:provider/provider.dart';

import '../../../../constant/constants.dart';
import '../../../../constant/theme.dart';
import '../../../../utils/colorUtils.dart';
import '../../../../utils/textUtils.dart';
import '../../../../widget/commonButton.dart';
import '../../../../widget/commonTextFromField.dart';
import '../notifier/authenication_notifier.dart';

bool isupdateEmail = false;

class ChangeMyEmailScreen extends StatefulWidget {
  const ChangeMyEmailScreen({Key? key}) : super(key: key);

  @override
  State<ChangeMyEmailScreen> createState() => _ChangeMyEmailScreenState();
}

class _ChangeMyEmailScreenState extends State<ChangeMyEmailScreen> {
  @override
  void initState() {
    var objProviderNotifier =
        Provider.of<AuthenicationNotifier>(context, listen: false);
    objProviderNotifier.getUserDetail();
    super.initState();
  }

  bool isemailChnage = false;
  final TextEditingController _emailController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final objProviderNotifier = context.watch<AuthenicationNotifier>();

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

            ///--------------------Change My Email text  ---------------------
            Text(
          TextUtils.ChangeMyEmail,
          style: AppTheme.getTheme().textTheme.bodyText2!.copyWith(
              color: ConstColor.primaryColor,
              height: 1.4,
              fontSize: width * 0.052),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          objProviderNotifier.objUsers == ""
              ? const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                )
              : SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(
                        top: height * 0.06,
                        left: width * 0.03,
                        right: width * 0.03,
                        bottom: height * 0.02),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.05,
                                  vertical: height * 0.026),
                              alignment: Alignment.centerLeft,
                              width: width,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(height * 0.1),
                                border: Border.all(
                                  color: ConstColor.textFormFieldColor,
                                ),
                              ),
                              child:

                                  ///-----------------Old Email ---------------
                                  Text(
                                objProviderNotifier.objUsers.emailId!,
                                style: AppTheme.getTheme()
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      fontSize: width * 0.04,
                                      color: ConstColor.white_Color,
                                    ),
                              ),
                            ),

                            ///----------------- Email Textfrom field---------------
                            Form(
                              key: formKey,
                              child: CommonTextFromField(
                                textCapitalization: TextCapitalization.none,
                                controller: _emailController,
                                txt: TextUtils.newEmail,
                                validator: isValidEmail,
                              ),
                            ),
                          ],
                        ),

                        ///------------ save name button------------
                        Stack(
                          children: [
                            isemailChnage == true
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: primaryColor,
                                    ),
                                  )
                                : Container(),
                            Container(
                              margin: EdgeInsets.only(bottom: height * 0.04),
                              child: GestureDetector(
                                  onTap: () {
                                    final isValid =
                                        formKey.currentState!.validate();

                                    if (isValid) {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return _buildAddPopupDialog(
                                                objProviderNotifier);
                                          });
                                    }
                                  },
                                  child: const CommonButton(
                                    name: TextUtils.SaveEmail,
                                  )),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  _buildAddPopupDialog(AuthenicationNotifier objProviderNotifier) {
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
            color: const Color.fromARGB(255, 15, 15, 15),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: width * 0.03),
                child: Text(
                  "Are you okay to change?\n\nVerify your email link and you can sign in with your new email \n\nIf you are not verify your email then you have to login with old email.",
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
                color: const Color.fromARGB(255, 187, 171, 171).withOpacity(0.2),
              ),

              ///-------------------Button --------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: width * 0.26,
                        height: height * 0.05,
                        margin: EdgeInsets.only(
                          top: height * 0.030,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(height * 0.1),
                          color: ConstColor.Text_grey_color,
                        ),
                        child: Text(
                          "Cancel",
                          style:
                              AppTheme.getTheme().textTheme.bodyText2!.copyWith(
                                    fontSize: width * 0.055,
                                    color: ConstColor.black_Color,
                                  ),
                        ),
                      )),
                  GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);
                        await objProviderNotifier
                            .updateEmail(context, _emailController.text)
                            .then((value) {
                          setState(() {
                            isupdateEmail = true;
                          });
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            top: height * 0.030, left: width * 0.03),
                        width: width * 0.26,
                        height: height * 0.05,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(height * 0.1),
                          color: ConstColor.primaryColor,
                        ),
                        child: Text(
                          "Okay",
                          style:
                              AppTheme.getTheme().textTheme.bodyText2!.copyWith(
                                    fontSize: width * 0.055,
                                    color: ConstColor.black_Color,
                                  ),
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
