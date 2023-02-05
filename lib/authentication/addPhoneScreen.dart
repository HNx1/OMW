import 'dart:io';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:omw/utils/textUtils.dart';
import 'package:omw/widget/validation.dart';
import 'package:provider/provider.dart';

import '../constant/constants.dart';
import '../constant/theme.dart';
import '../notifier/authenication_notifier.dart';
import '../notifier/changenotifier.dart';
import '../utils/colorUtils.dart';
import '../widget/commonButton.dart';
import '../widget/commonTextFromField.dart';
import 'package:intl/intl.dart';

class AddPhoneScreen extends StatefulWidget {
  const AddPhoneScreen({Key? key}) : super(key: key);

  @override
  State<AddPhoneScreen> createState() => _AddPhoneScreenState();
}

class _AddPhoneScreenState extends State<AddPhoneScreen> {
  final CurrentYear = DateFormat('yyyy').format(DateTime.now());
  String selectBirthDate = "";
  var formKey = GlobalKey<FormState>();
  TextEditingController _PhoneController = TextEditingController();
  // TextEditingController _descriptionController = TextEditingController();

  String phone = "";
  bool isValidatePhone = false;
  bool isBirthdateSelected = false;
  bool isProfileUploaded = false;
  String imageUrl = "";
  File? imageFile = File("");
  CountryCode? pickedCountryCode;

  late final FirebaseMessaging _messaging;
  String? token;

  @override
  void initState() {
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
      // PrefServices().setFcmToken(token!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final objProviderNotifier = context.watch<ProviderNotifier>();
    final objAuthProvider = context.watch<AuthenicationNotifier>();
    return Scaffold(
      //--------------------Arrow back Icon------------------------------
      appBar: AppBar(
        backgroundColor: AppTheme.getTheme().scaffoldBackgroundColor,
        leading: Container(),
        title:
            //--------------------Profile ------------------------------
            Text(
          "Add Phone Number",
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
          objAuthProvider.isLoading == true
              ? CircularProgressIndicator(
                  color: primaryColor,
                )
              : Container(),
          Container(
            margin: EdgeInsets.only(left: width * 0.04, right: width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.only(
                      top: AppBar().preferredSize.height * 0.4,
                    ),
                    shrinkWrap: true,
                    children: [
                      Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ///---------------------------phone number textfrom field------------------

                              Container(
                                margin: EdgeInsets.only(top: height * 0.026),
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
                                    ///--------------- Country Code---------------------
                                    CountryListPick(
                                      appBar: AppBar(
                                        backgroundColor: Colors.black,
                                        title: Text('Select Country '),
                                      ),
                                      theme: CountryTheme(
                                        isShowFlag: true,
                                        isShowTitle: false,
                                        isShowCode: true,
                                        isDownIcon: true,
                                        showEnglishName: true,
                                      ),
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
                                                  package: 'country_list_pick',
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
                                                      fontSize: width * 0.041,
                                                      color: ConstColor
                                                          .white_Color,
                                                    ),
                                              ),
                                            ),
                                            Icon(
                                              Icons.keyboard_arrow_down_sharp,
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
                                      onChanged: (CountryCode? code) {
                                        setState(() {
                                          pickedCountryCode = code;
                                        });
                                      },
                                      useUiOverlay: false,
                                      useSafeArea: true,
                                    ),

                                    ///--------------------- Enter phone Textfield----------------
                                    Expanded(
                                      child: TextFormField(
                                        textAlign: TextAlign.start,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        controller: _PhoneController,
                                        keyboardType: TextInputType.number,
                                        style: AppTheme.getTheme()
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                              fontSize: width * 0.041,
                                              color: ConstColor.white_Color,
                                            ),
                                        decoration: InputDecoration(
                                          hintText: TextUtils.EnterphoneNum,
                                          hintStyle: AppTheme.getTheme()
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(
                                                fontSize: width * 0.041,
                                                color: ConstColor.white_Color,
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

                              ///------------- validation Text--------------
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
                          ))
                    ],
                  ),
                ),

                ///--------------------------- save---------------
                GestureDetector(
                  onTap: () {
                    print("hello");
                    setState(() {
                      isBirthdateSelected = true;
                      isProfileUploaded = true;
                    });
                    setState(() {
                      isValidatePhone = true;
                    });
                    var code =
                        pickedCountryCode == "" || pickedCountryCode == null
                            ? "+44"
                            : pickedCountryCode.toString();
                    String phoneNo =
                        code + " " + "${_PhoneController.text.toString()}";
                    final isValid = formKey.currentState!.validate();

                    if (isValid && phone.length == 10 && phone != "") {
                      objProviderNotifier.setPhone = phoneNo;

                      objAuthProvider.registration(
                        context: context,
                        firstName: "",
                        lastname: "",
                        emailId: objProviderNotifier.getemail,
                        phoneNumber: phoneNo,
                        birthdate: "",
                        imageUrl: "",
                        role: "user",
                        fcmToken: token!,
                      );
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: height * 0.02),
                    child: CommonButton(
                      name: TextUtils.Save,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
