import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../constant/constants.dart';
import '../../../../constant/theme.dart';
import '../../../../utils/colorUtils.dart';
import '../../../../utils/textUtils.dart';
import '../../../../widget/commonButton.dart';
import '../notifier/authenication_notifier.dart';

class ChangeMyPhoneNoScreen extends StatefulWidget {
  const ChangeMyPhoneNoScreen({Key? key}) : super(key: key);

  @override
  State<ChangeMyPhoneNoScreen> createState() => _ChangeMyPhoneNoScreenState();
}

class _ChangeMyPhoneNoScreenState extends State<ChangeMyPhoneNoScreen> {
  @override
  void initState() {
    var objProviderNotifier =
        Provider.of<AuthenicationNotifier>(context, listen: false);
    objProviderNotifier.getUserDetail();
    super.initState();
  }

  final TextEditingController _PhoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  CountryCode? pickedCountryCode;

  String phone = "";
  bool isValidatePhone = false;

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

            ///--------------------Change My Phone number text  ---------------------
            Text(
          TextUtils.ChangeMyPhoneNumber,
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
              : Container(
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
                              borderRadius: BorderRadius.circular(height * 0.1),
                              border: Border.all(
                                color: ConstColor.textFormFieldColor,
                              ),
                            ),
                            child:

                                ///-----------------Old phone ---------------
                                Text(
                              objProviderNotifier.objUsers.phoneNumber!,
                              style: AppTheme.getTheme()
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                    fontSize: width * 0.039,
                                    color: ConstColor.white_Color,
                                  ),
                            ),
                          ),

                          ///----------------- phone Textfrom field---------------
                          Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.only(top: height * 0.026),
                                    height: height * 0.077,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(height * 0.1),
                                      border: Border.all(
                                        color: ConstColor.textFormFieldColor,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        ///--------------------- country Picker--------------
                                        CountryListPick(
                                          appBar: AppBar(
                                            backgroundColor: Colors.black,
                                            title: const Text('Select Country '),
                                          ),
                                          theme: CountryTheme(
                                            isShowFlag: true,
                                            isShowTitle: false,
                                            isShowCode: true,
                                            isDownIcon: true,
                                            showEnglishName: true,
                                          ),
                                          onChanged: (CountryCode? code) {
                                            setState(() {
                                              pickedCountryCode = code;
                                            });
                                          },
                                          pickerBuilder: (context, code) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: height * 0.01),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            height * 0.1),
                                                    child: Image.asset(
                                                      code!.flagUri!,
                                                      fit: BoxFit.fill,
                                                      width: width * 0.06,
                                                      height: width * 0.06,
                                                      package:
                                                          'country_list_pick',
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: width * 0.02,
                                                      right: width * 0.01),
                                                  child: Text(
                                                    code.dialCode!,
                                                    style: AppTheme.getTheme()
                                                        .textTheme
                                                        .bodyText1!
                                                        .copyWith(
                                                          fontSize:
                                                              width * 0.041,
                                                          color: ConstColor
                                                              .white_Color,
                                                        ),
                                                  ),
                                                ),
                                                const Icon(
                                                  Icons
                                                      .keyboard_arrow_down_sharp,
                                                  color: ConstColor.white_Color,
                                                ),
                                                //------- divider-------------------
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: height * 0.015,
                                                      left: height * 0.01),
                                                  height: height * 0.023,
                                                  width: 1,
                                                  color: ConstColor.white_Color,
                                                ),
                                              ],
                                            );
                                          },
                                          initialSelection: 'GB',
                                          useUiOverlay: false,
                                          useSafeArea: true,
                                        ),

                                        ///--------------------- Enter phone Textfield----------------
                                        Expanded(
                                          child: TextFormField(
                                            textAlign: TextAlign.start,
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            controller: _PhoneController,
                                            keyboardType: TextInputType.number,
                                            style: AppTheme.getTheme()
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                  fontSize: width * 0.038,
                                                  color: ConstColor.white_Color,
                                                ),
                                            decoration: InputDecoration(
                                              hintText: TextUtils.EnterphoneNum,
                                              hintStyle: AppTheme.getTheme()
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(
                                                    fontSize: width * 0.038,
                                                    color:
                                                        ConstColor.white_Color,
                                                  ),
                                              errorStyle: AppTheme.getTheme()
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(
                                                    fontSize: width * 0.036,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.red,
                                                  ),
                                              border: InputBorder.none,
                                            ),
                                            onChanged: (val) {
                                              setState(() {
                                                phone = val;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  ///------------------- validation text------------------
                                  phone == "" && isValidatePhone == true
                                      ? Container(
                                          margin: EdgeInsets.only(
                                              top: height * 0.011,
                                              left: width * 0.055),
                                          child: Text(
                                            TextUtils.entermobile,
                                            style: AppTheme.getTheme()
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                  fontSize: width * 0.036,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.red,
                                                ),
                                          ),
                                        )
                                      : phone.length != 10 &&
                                              isValidatePhone == true
                                          ? Container(
                                              margin: EdgeInsets.only(
                                                  top: height * 0.011,
                                                  left: width * 0.055),
                                              child: Text(
                                                TextUtils.validmobile,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .copyWith(
                                                      fontSize: width * 0.036,
                                                      color: Colors.red,
                                                    ),
                                              ),
                                            )
                                          : Container(),
                                ],
                              )),
                        ],
                      ),

                      ///------------ save name button------------
                      Container(
                        margin: EdgeInsets.only(bottom: height * 0.04),
                        child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isValidatePhone = true;
                              });
                              var code = pickedCountryCode == "" ||
                                      pickedCountryCode == null
                                  ? "+44"
                                  : pickedCountryCode.toString();
                              String phoneNo = "$code ${_PhoneController.text.toString()}";
                              final isValid = formKey.currentState!.validate();

                              if (isValid &&
                                  phone.length == 10 &&
                                  phone != "") {
                                objProviderNotifier.updatePhoneNumber(
                                    context, phoneNo);
                                if (objProviderNotifier.isConnected == true) {
                                  _PhoneController.clear();
                                }
                                FocusScope.of(context).requestFocus(
                                  FocusNode(),
                                );
                              }
                            },
                            child: const CommonButton(
                              name: TextUtils.SaveNumber,
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
