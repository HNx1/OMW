import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../constant/constants.dart';
import '../../../constant/theme.dart';
import '../../../notifier/changenotifier.dart';
import '../../../notifier/event_notifier.dart';
import '../../../utils/colorUtils.dart';
import '../../../utils/textUtils.dart';
import '../../../widget/commonButton.dart';
import '../../../widget/validation.dart';

class CoHostEditEventScreen extends StatefulWidget {
  const CoHostEditEventScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CoHostEditEventScreen> createState() => _CoHostEditEventScreenState();
}

class _CoHostEditEventScreenState extends State<CoHostEditEventScreen> {
  @override
  void initState() {
    getEventData();
    super.initState();
  }

  getEventData() async {
    var objCreateEventNotifier =
        Provider.of<CreateEventNotifier>(context, listen: false);
    await objCreateEventNotifier.getAllUserList(context);
    var objProviderNotifier =
        Provider.of<ProviderNotifier>(context, listen: false);
    setState(() {
      _eventnameController.text =
          objCreateEventNotifier.getEventData.eventname!;
      _LocationController.text = objCreateEventNotifier.getEventData.location!;
      _descriptionController.text =
          objCreateEventNotifier.getEventData.description!;
      _addCoHostController.text = objCreateEventNotifier.getEventData.coHost!;
      selectedStartDate =
          '${DateFormat('MMM dd, yyyy').format(objCreateEventNotifier.getEventData.eventStartDate!)}';
      selectedEndDate =
          '${DateFormat('MMM dd, yyyy').format(objCreateEventNotifier.getEventData.eventEndDate!)}';
      eventStartDate = objCreateEventNotifier.getEventData.eventStartDate!;
      eventEndDate = objCreateEventNotifier.getEventData.eventEndDate!;
      inviteFriends = objCreateEventNotifier.getEventData.inviteFriends!;
      isCostSplite = objCreateEventNotifier.getEventData.enableCostSplite!;
      objProviderNotifier.setamount =
          objCreateEventNotifier.getEventData.costAmount!;
      allChoosingDates = objCreateEventNotifier.getEventData.selectedDate!;

      selectStartTime = DateFormat('hh:mm aa')
          .format(objCreateEventNotifier.getEventData.eventStartDate!);
      selectEndTime = DateFormat('hh:mm aa')
          .format(objCreateEventNotifier.getEventData.eventEndDate!);
      imageUrl = objCreateEventNotifier.getEventData.eventPhoto!;
    });
  }

  var formKey = GlobalKey<FormState>();
  TextEditingController _eventnameController = TextEditingController();
  TextEditingController _LocationController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _addCoHostController = TextEditingController();

  DateTime eventStartDate = DateTime.now();
  DateTime eventEndDate = DateTime.now();
  String selectedStartDate = "";
  String selectedEndDate = "";
  bool isDateSelected = false;

  String selectEndTime = "";
  String selectStartTime = "";
  DateTime currentTime = DateTime.now();
  DateTime? currentTime2;

  bool isselectTime = false;

  bool isCostSplite = false;
  bool isuploadImage = false;
  String co_host = "";

  ScrollController? _isScolling;

  bool inviteFriends = false;
  List allChoosingDates = [];

  bool isOpenDate = false;
  String imageUrl = "";
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    final objProviderNotifier = context.watch<ProviderNotifier>();
    final objCreateEventNotifier = context.watch<CreateEventNotifier>();
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppTheme.getTheme().backgroundColor,

          ///------------------- Drawer------------------------
          leading: Container(
            margin: EdgeInsets.only(left: width * 0.03),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios_rounded,
                color: ConstColor.primaryColor,
                size: width * 0.06,
              ),
            ),
          ),
          leadingWidth: width * 0.1,

          ///------------------------ my Events title-------------------------
          title: Text(
            TextUtils.editEvent,
            style: AppTheme.getTheme().textTheme.subtitle1!.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: width * 0.055,
                ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  left: width * 0.03,
                  right: width * 0.03,
                ),
                child: SingleChildScrollView(
                  controller: _isScolling,
                  padding: EdgeInsets.only(top: height * 0.02),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ///------------ Description textfield----------

                        Container(
                          margin: EdgeInsets.only(top: height * 0.026),
                          child: TextFormField(
                            maxLines: 6,
                            autovalidateMode: AutovalidateMode.disabled,
                            style: AppTheme.getTheme()
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                  fontSize: width * 0.038,
                                  color: ConstColor.white_Color,
                                ),
                            controller: _descriptionController,
                            decoration: InputDecoration(
                              errorStyle: AppTheme.getTheme()
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    fontSize: width * 0.036,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red,
                                  ),
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(height * 0.03),
                                borderSide: BorderSide(
                                  color: ConstColor.textFormFieldColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(height * 0.03),
                                borderSide: BorderSide(
                                  color: ConstColor.textFormFieldColor,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(height * 0.03),
                                borderSide: BorderSide(
                                  color: ConstColor.textFormFieldColor,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(height * 0.03),
                                borderSide: BorderSide(
                                  color: ConstColor.textFormFieldColor,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(height * 0.03),
                                borderSide: BorderSide(
                                  color: ConstColor.textFormFieldColor,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: width * 0.05,
                                  vertical: height * 0.026),
                              hintText: TextUtils.desc,
                              hintStyle: AppTheme.getTheme()
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    fontSize: width * 0.038,
                                    color: Color(0xff6C6C6C),
                                  ),
                            ),
                            validator: validateDescription,
                          ),
                        ),

                        ///------------- invite friends---------------
                        Container(
                          margin: EdgeInsets.only(top: height * 0.026),
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.04,
                              vertical: height * 0.024),
                          alignment: Alignment.centerLeft,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(height * 0.1),
                            border: Border.all(
                              color: ConstColor.textFormFieldColor,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CommanLabeltext(
                                TextUtils.guests,
                              ),
                              FlutterSwitch(
                                activeColor: ConstColor.primaryColor,
                                width: width * 0.08,
                                height: height * 0.028,
                                toggleSize: width * 0.036,
                                value: inviteFriends,
                                borderRadius: 30.0,
                                padding: 4.0,
                                activeToggleColor: ConstColor.black_Color,
                                onToggle: (val) {
                                  setState(() {
                                    inviteFriends = val;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),

                        ///-------- Creta Button---------------
                        Container(
                          margin: EdgeInsets.only(
                              bottom: height * 0.02, top: height * 0.02),
                          child: GestureDetector(
                            onTap: () async {
                              setState(
                                () {
                                  isselectTime = true;
                                  isDateSelected = true;

                                  isuploadImage = true;
                                },
                              );

                              final isValid = formKey.currentState!.validate();

                              if (isValid && selectStartTime != "") {
                                if (allChoosingDates.isEmpty &&
                                    selectedStartDate != "" &&
                                    selectedEndDate != "") {
                                  allChoosingDates.add(eventStartDate);
                                  allChoosingDates.add(eventEndDate);
                                  allChoosingDates
                                      .sort((a, b) => a.compareTo(b));
                                  print(allChoosingDates);
                                } else if (allChoosingDates.isEmpty &&
                                    selectedStartDate != "" &&
                                    selectedEndDate == "") {
                                  allChoosingDates.add(eventStartDate);
                                } else if (allChoosingDates.isEmpty &&
                                    selectedStartDate == "") {
                                  allChoosingDates.add(DateTime.now());
                                }
                                var endTime = selectEndTime == ""
                                    ? "11:59 PM"
                                    : selectEndTime;
                                var selectedTime =
                                    selectStartTime + " - " + endTime;

                                if (imageFile != null && imageFile != "") {
                                  var imageName =
                                      imageFile!.path.split('/').last;
                                  print(imageName);
                                  var snapshot = await FirebaseStorage.instance
                                      .ref()
                                      .child(imageName)
                                      .putFile(imageFile!);
                                  var downloadUrl =
                                      await snapshot.ref.getDownloadURL();
                                  imageUrl = downloadUrl;
                                }
                                print(imageUrl);
                                setState(() {});
                                await objCreateEventNotifier
                                    .updateEventDetails(
                                        context,
                                        objCreateEventNotifier
                                            .getEventData.docId!,
                                        _eventnameController.text,
                                        allChoosingDates,
                                        selectedTime,
                                        _descriptionController.text,
                                        _LocationController.text,
                                        imageUrl,
                                        inviteFriends,
                                        objProviderNotifier.getamount == 0 ||
                                                objProviderNotifier.getamount ==
                                                    0.0
                                            ? false
                                            : isCostSplite,
                                        objProviderNotifier.getamount == 0 ||
                                                objProviderNotifier.getamount ==
                                                    0.0 ||
                                                objProviderNotifier.getamount ==
                                                    null
                                            ? 0
                                            : objProviderNotifier.getamount,
                                        _addCoHostController.text,
                                        eventStartDate,
                                        eventEndDate,
                                        objCreateEventNotifier
                                            .getEventData.guest,
                                        objCreateEventNotifier
                                            .getEventData.guestsID,
                                        objCreateEventNotifier
                                            .getEventData.lstUser,
                                        objCreateEventNotifier
                                            .getEventData.ownerID,
                                        [],
                                        objCreateEventNotifier
                                            .getEventData.allDates)
                                    .whenComplete(() async {
                                  setState(() {
                                    objCreateEventNotifier.setEventData =
                                        objCreateEventNotifier
                                            .objCreateEventModel;
                                    _eventnameController.clear();
                                    allChoosingDates = [];
                                    selectEndTime = "";
                                    selectStartTime = "";
                                    _descriptionController.clear();
                                    _LocationController.clear();
                                    imageUrl = "";
                                    inviteFriends = false;
                                    isCostSplite = false;
                                    objProviderNotifier.setamount = 0;
                                    _addCoHostController.clear();
                                    imageFile = null;
                                    isuploadImage = false;
                                    selectedStartDate = "";
                                    selectedEndDate = "";
                                    isselectTime = false;
                                    isDateSelected = false;
                                    isOpenDate = false;
                                    currentTime2 = null;

                                    Navigator.pop(context);
                                  });
                                });
                              }
                            },
                            child: CommonButton(
                              name: "Update",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Widget CommanLabeltext(String text) {
    return Text(
      text,
      style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
            fontSize: width * 0.046,
            color: ConstColor.white_Color,
          ),
    );
  }
}
