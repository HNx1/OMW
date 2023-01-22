import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constant/constants.dart';
import '../../../constant/theme.dart';
import '../../../utils/colorUtils.dart';
import '../../../utils/textUtils.dart';
import '../../../widget/commonButton.dart';
import '../../../widget/commonTextFromField.dart';
import '../../../widget/validation.dart';
import '../notifier/authenication_notifier.dart';
import '../widget/scaffold_snackbar.dart';

class ChnageMyPassword extends StatefulWidget {
  const ChnageMyPassword({Key? key}) : super(key: key);

  @override
  State<ChnageMyPassword> createState() => _ChnageMyPasswordState();
}

class _ChnageMyPasswordState extends State<ChnageMyPassword> {
  var formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _ConfirmPasswordController =
      TextEditingController();
  dynamic oldPassVerify;
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

            ///--------------------Change My password text  ---------------------
            Text(
          TextUtils.ChangeMypassword,
          style: AppTheme.getTheme().textTheme.bodyText2!.copyWith(
              color: ConstColor.primaryColor,
              height: 1.4,
              fontSize: width * 0.052),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(
            top: height * 0.06,
            left: width * 0.03,
            right: width * 0.03,
            bottom: height * 0.02),
        child: Stack(
          alignment: Alignment.center,
          children: [
            objProviderNotifier.isLoading == true
                ? const CircularProgressIndicator(
                    color: primaryColor,
                  )
                : Container(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ///----------------- name Textfrom field---------------
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              CommonTextFromField(
                                textCapitalization: TextCapitalization.none,
                                controller: _currentPasswordController,
                                txt: TextUtils.oldpwd,
                                validator: validateOldPassword,
                              ),
                              CommonTextFromField(
                                textCapitalization: TextCapitalization.none,
                                controller: _newPasswordController,
                                txt: TextUtils.newpwd,
                                validator: validateNewPassword,
                              ),
                              CommonTextFromField(
                                textCapitalization: TextCapitalization.none,
                                controller: _ConfirmPasswordController,
                                txt: TextUtils.confirmpwd,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return TextUtils.Validconfirmpwd;
                                  }
                                  if (_newPasswordController.text != val) {
                                    return "New password and confirmPassword must be same";
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                ///------------ save name button------------
                Container(
                  margin: EdgeInsets.only(bottom: height * 0.04),
                  child: GestureDetector(
                      onTap: () {
                        final isValid = formKey.currentState!.validate();

                        if (isValid) {
                          objProviderNotifier
                              .isOldpasswordVerify(
                                  context, _currentPasswordController.text)
                              .then((value) {
                            setState(() {
                              oldPassVerify = value;
                            });
                            if (oldPassVerify == false) {
                              ScaffoldSnackbar.of(context).show(
                                "Please Enter curret Old password",
                              );
                            }
                          }).whenComplete(() async {
                            if (oldPassVerify) {
                              await objProviderNotifier
                                  .updatePassword(
                                      context, _newPasswordController.text)
                                  .then((value) {
                                if (value) {
                                  objProviderNotifier.signOut(context);
                                } else {
                                  print("Wrong Data Added");
                                }
                              });
                            }
                          });

                          FocusScope.of(context).requestFocus(FocusNode());
                        }
                      },
                      child: const CommonButton(
                        name: TextUtils.Save,
                      )),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
