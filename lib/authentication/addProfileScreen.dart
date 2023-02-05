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

class AddProfileScreen extends StatefulWidget {
  const AddProfileScreen({Key? key}) : super(key: key);

  @override
  State<AddProfileScreen> createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends State<AddProfileScreen> {
  final CurrentYear = DateFormat('yyyy').format(DateTime.now());
  String selectBirthDate = "";
  var formKey = GlobalKey<FormState>();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _LastNameController = TextEditingController();
  TextEditingController _PhoneController = TextEditingController();
  // TextEditingController _descriptionController = TextEditingController();

  String phone = "";
  bool isValidatePhone = false;
  bool isBirthdateSelected = false;
  bool isProfileUploaded = false;
  String imageUrl = "";
  File? imageFile;
  CountryCode? pickedCountryCode;

  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        imageUrl = pickedFile.path;
      });
    }
  }

  _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        imageUrl = pickedFile.path;
      });
    }
  }

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
        leadingWidth: height * 0.034,
        title:
            //--------------------Profile ------------------------------
            Text(
          "Fill out your Profile",
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
                              ///-----------------First name Textfrom field---------------
                              CommonTextFromField(
                                textCapitalization: TextCapitalization.words,
                                controller: _firstNameController,
                                txt: TextUtils.FirstName,
                                validator: validatFirstName,
                              ),

                              ///-----------------Last name Textfrom field---------------
                              CommonTextFromField(
                                textCapitalization: TextCapitalization.words,
                                controller: _LastNameController,
                                txt: TextUtils.LastName,
                                validator: validatLastName,
                              ),

                              ///---------------------------phone number textfrom field------------------

                              ///-----------------Birthday ---------------
                              GestureDetector(
                                onTap: () async {
                                  var datePicked =
                                      await DatePicker.showSimpleDatePicker(
                                          context,
                                          backgroundColor:
                                              Color.fromARGB(255, 12, 12, 12),
                                          initialDate: DateTime(1994),
                                          firstDate: DateTime(1960),
                                          lastDate: DateTime(
                                            int.parse(CurrentYear),
                                          ),
                                          dateFormat: "dd-MMMM-yyyy",
                                          pickerMode: DateTimePickerMode.date,
                                          textColor: ConstColor.primaryColor,
                                          locale: DateTimePickerLocale.en_us,
                                          looping: false,
                                          itemTextStyle: AppTheme.getTheme()
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(
                                                  color:
                                                      ConstColor.white_Color));

                                  setState(() {
                                    selectBirthDate =
                                        '${DateFormat('MMM dd, yyyy').format(datePicked!)}';
                                  });
                                },
                                child: Container(
                                  height: height * 0.075,
                                  margin: EdgeInsets.only(top: height * 0.026),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.05,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(height * 0.1),
                                    border: Border.all(
                                      color: ConstColor.textFormFieldColor,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        selectBirthDate.isEmpty
                                            ? TextUtils.EnterYourBirthday
                                            : selectBirthDate,
                                        style: AppTheme.getTheme()
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                                fontSize: width * 0.038,
                                                color: ConstColor.white_Color,
                                                fontWeight: FontWeight.w400),
                                      ),
                                      Image.asset(
                                        ConstantData.calender,
                                        height: height * 0.03,
                                        fit: BoxFit.cover,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              selectBirthDate == "" &&
                                      isBirthdateSelected == true
                                  ? Container(
                                      margin: EdgeInsets.only(
                                          top: height * 0.011,
                                          left: width * 0.055),
                                      child: Text(
                                        TextUtils.selectYourBirthday,
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

                              ///-----------------Photo ---------------
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    context: context,
                                    builder: (context) {
                                      return Wrap(
                                        children: [
                                          Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  _getFromGallery();
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.all(
                                                      height * 0.02),
                                                  child: Text(
                                                    'GALLERY',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2!
                                                        .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              Divider(
                                                thickness: 2,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  _getFromCamera();
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.all(
                                                      height * 0.02),
                                                  child: Text(
                                                    'CAMERA',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2!
                                                        .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                  ),
                                                ),
                                              ),
                                              Divider(
                                                thickness: 2,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.all(
                                                      height * 0.02),
                                                  child: Text(
                                                    'Cancel',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2!
                                                        .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .errorColor),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  height: height * 0.075,
                                  margin: EdgeInsets.only(top: height * 0.026),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.05,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(height * 0.1),
                                    border: Border.all(
                                      color: ConstColor.textFormFieldColor,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          imageFile == null
                                              ? TextUtils.UploadPhoto
                                              : imageUrl,
                                          style: AppTheme.getTheme()
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(
                                                  fontSize: width * 0.038,
                                                  color: ConstColor.white_Color,
                                                  fontWeight: FontWeight.w400),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Image.asset(
                                        ConstantData.camera,
                                        height: height * 0.036,
                                        fit: BoxFit.cover,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              imageUrl == "" && isProfileUploaded == true
                                  ? Container(
                                      margin: EdgeInsets.only(
                                          top: height * 0.011,
                                          left: width * 0.055),
                                      child: Text(
                                        TextUtils.SelectProfile,
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
                    setState(() {
                      isBirthdateSelected = true;
                      isProfileUploaded = true;
                    });
                    setState(() {
                      isValidatePhone = true;
                    });

                    final isValid = formKey.currentState!.validate();

                    if (isValid && imageUrl != "" && selectBirthDate != "") {
                      objAuthProvider.createProfile(
                        context: context,
                        firstName: _firstNameController.text,
                        lastName: _LastNameController.text,
                        birthdate: selectBirthDate,
                        imageUrl: imageUrl,
                        imageFile: imageFile!,
                      );
                    }
                  },
                  child: Container(
                    alignment: Alignment.bottomCenter,
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
