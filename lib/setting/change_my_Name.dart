import 'package:flutter/material.dart';
import 'package:omw/constant/theme.dart';
import 'package:provider/provider.dart';

import '../../../../constant/constants.dart';
import '../../../../utils/colorUtils.dart';
import '../../../../utils/textUtils.dart';
import '../../../../widget/commonButton.dart';
import '../../../../widget/commonTextFromField.dart';
import '../../../../widget/validation.dart';
import '../notifier/authenication_notifier.dart';

class ChangeMyName extends StatefulWidget {
  const ChangeMyName({Key? key}) : super(key: key);

  @override
  State<ChangeMyName> createState() => _ChangeMyNameState();
}

class _ChangeMyNameState extends State<ChangeMyName> {
  @override
  void initState() {
    var objProviderNotifier =
        Provider.of<AuthenicationNotifier>(context, listen: false);
    objProviderNotifier.getUserDetail();
    super.initState();
  }

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();

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

            ///--------------------Change My name text  ---------------------
            Text(
          TextUtils.ChangeMyName,
          style: AppTheme.getTheme().textTheme.bodyText2!.copyWith(
              color: ConstColor.primaryColor,
              height: 1.4,
              fontSize: width * 0.052),
        ),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          objProviderNotifier.isLoading == true ||
                 
                  objProviderNotifier.objUsers == ""
              ? const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(
                      top: height * 0.06,
                      left: width * 0.03,
                      right: width * 0.03,
                      bottom: height * 0.02),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
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

                                    ///-----------------Old name ---------------
                                    Text(
                                  "${objProviderNotifier.objUsers.firstName!} ${objProviderNotifier.objUsers.lastName!}",
                                  style: AppTheme.getTheme()
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(
                                        fontSize: width * 0.039,
                                        color: ConstColor.white_Color,
                                      ),
                                ),
                              ),

                              ///----------------- name Textfrom field---------------
                              Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    CommonTextFromField(
                                      textCapitalization: TextCapitalization.words,
                                      controller: _firstnameController,
                                      txt: TextUtils.newfirstName,
                                      validator: validatFirstName,
                                    ),
                                    CommonTextFromField(
                                      textCapitalization: TextCapitalization.words,

                                      controller: _lastnameController,
                                      txt: TextUtils.newlastName,
                                      validator: validatLastName,
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
                                objProviderNotifier.updateName(
                                    context,
                                    _firstnameController.text,
                                    _lastnameController.text);
                                if (objProviderNotifier.isConnected == true) {
                                  _firstnameController.clear();
                                  _lastnameController.clear();
                                }
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              }
                            },
                            child: const CommonButton(
                              name: TextUtils.SaveName,
                            )),
                      )
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
