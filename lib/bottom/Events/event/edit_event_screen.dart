import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:omw/api/apiProvider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:omw/notifier/group_notifier.dart';

import '../../../constant/constants.dart';
import '../../../constant/theme.dart';
import '../../../model/createEvent_model.dart';
import '../../../model/user_model.dart';
import '../../../notifier/changenotifier.dart';
import '../../../notifier/event_notifier.dart';
import '../../../utils/colorUtils.dart';
import '../../../utils/textUtils.dart';
import '../../../widget/commonButton.dart';
import '../../../widget/errorButton.dart';
import '../../../widget/validation.dart';
import '../../../widget/routesFile.dart';
import '../../Create/single_selection.dart';
import '../../Create/time_range_picker.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class EditEventScreen extends StatefulWidget {
  const EditEventScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  @override
  void initState() {
    getEventData();
    _getContactsData();
    super.initState();
  }

  List<AllDates> lstAlldate = [];
  List allChoosingDates = [];

  getEventData() async {
    var objCreateEventNotifier =
        Provider.of<CreateEventNotifier>(context, listen: false);
    await objCreateEventNotifier.geteventDeatisl(
        context,
        objCreateEventNotifier.getEventData.docId!,
        objCreateEventNotifier.EventData.lstUser!.uid!);
    setState(() {
      objCreateEventNotifier.setEventData =
          objCreateEventNotifier.getEventDetails;
    });
    await objCreateEventNotifier.getAllUserList(context);
    var objProviderNotifier =
        Provider.of<ProviderNotifier>(context, listen: false);
    setState(() {
      _eventnameController.text =
          objCreateEventNotifier.getEventData.eventname!;
      _LocationController.text = objCreateEventNotifier.getEventData.location!;
      _descriptionController.text =
          objCreateEventNotifier.getEventData.description!;
      _addCoHostController.text = "";
      co_host = objCreateEventNotifier.getEventData.coHost!;
      oldCohostList = objCreateEventNotifier.getEventData.cohostList!;
      cohostList = objCreateEventNotifier.retrieveduserList
          .where((e) =>
              oldCohostList.contains(e.uid) || e.uid == _auth.currentUser!.uid)
          .toList();
      cohostList.sort((a, b) => a.uid == _auth.currentUser!.uid ? -1 : 1);
      print('Cohost list: ${oldCohostList}');
      print('Cohost list: ${cohostList.map((e) => e.firstName)}');
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
      lstAlldate = objCreateEventNotifier.getEventData.allDates!;
      selectStartTime = DateFormat('h:mm aa')
          .format(objCreateEventNotifier.getEventData.eventStartDate!);
      selectEndTime = DateFormat('h:mm aa')
          .format(objCreateEventNotifier.getEventData.eventEndDate!);
      imageUrl = objCreateEventNotifier.getEventData.eventPhoto!;
      allChoosingDates.clear();
      _selectedDays.clear();
      lstAlldate.clear();
    });
  }

  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
  );

  var formKey = GlobalKey<FormState>();
  bool isLoader = false;
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
  List<String> oldCohostList = [];
  List<UserModel> cohostList = [];

  onStartDateSubmit(val) {
    setState(() {
      selectedStartDate = '${DateFormat('MMM dd, yyyy').format(val)}';
      eventStartDate = val;

      print(eventStartDate);
    });
    Navigator.pop(context);

    print('================>$eventStartDate');
  }

  void onStartDateChanged(DateRangePickerSelectionChangedArgs args) {
    var objCreateEventNotifier =
        Provider.of<CreateEventNotifier>(context, listen: false);
    setState(() {
      selectedStartDate = '${DateFormat('MMM dd, yyyy').format(args.value)}';
      eventStartDate = args.value;
      if (selectedEndDate ==
          '${DateFormat('MMM dd, yyyy').format(objCreateEventNotifier.getEventData.eventEndDate!)}')
        selectedEndDate = "";
      print(eventStartDate);
    });
  }

  void onEndDateChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      selectedEndDate = '${DateFormat('MMM dd, yyyy').format(args.value)}';
      eventEndDate = args.value;
      print(eventEndDate);
    });
  }

  onStartDateCancel() {
    if (selectedStartDate != "") {
      selectedStartDate;
    } else {
      setState(() {
        selectedStartDate = "";
        selectedEndDate = "";
      });
    }
    Navigator.pop(context);

    print('================> $selectedStartDate');
  }

  onEndDateSubmit(val) {
    setState(() {
      selectedEndDate = '${DateFormat('MMM dd, yyyy').format(val)}';
      eventEndDate = val;

      print(eventEndDate);
    });
    Navigator.pop(context);

    print('================> $eventEndDate');
  }

  onEndDateCancel() {
    // if (selectedEndDate != "") {
    //   selectedEndDate;
    // } else {
    //   setState(() {
    //     selectedEndDate = "";
    //   });
    // }
    setState(() {
      selectedEndDate = "";
    });
    Navigator.pop(context);

    print('================> $selectedEndDate');
  }

  geteventStartDateFromString() {
    try {
      print(selectStartTime);
      setState(() {});
      eventStartDate = DateTime(
          allChoosingDates.first.year,
          allChoosingDates.first.month,
          allChoosingDates.first.day,
          int.parse(selectStartTime.split(" ")[0].split(":")[0]) +
              (selectStartTime.split(" ")[1] == "PM" ? 12 : 0),
          int.parse(selectStartTime.split(" ")[0].split(":")[1]),
          0,
          0,
          0);
      setState(() {});
      print("===========>eventStartDate : ${eventStartDate.toUtc()}");
    } catch (e) {
      print(e);
      return null;
    }
  }

  geteventEndDateFromString() {
    try {
      setState(() {});
      eventEndDate = DateTime(
          allChoosingDates.last.year,
          allChoosingDates.last.month,
          allChoosingDates.last.day,
          int.parse(selectEndTime.split(" ")[0].split(":")[0]) +
              (selectEndTime.split(" ")[1] == "PM" ? 12 : 0),
          int.parse(selectEndTime.split(" ")[0].split(":")[1]),
          0,
          0,
          0);
      setState(() {});
      print("===========>eventEndDate :${eventEndDate.toUtc()}");
    } catch (e) {
      print(e);
      return null;
    }
  }

  ScrollController _scrollController = ScrollController();
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();

  bool inviteFriends = false;
  _onDaySelected(DateTime selectedDays, DateTime focusedDay) {
    var objCreateEventNotifier =
        Provider.of<CreateEventNotifier>(context, listen: false);

    setState(() {
      _focusedDay = focusedDay;
      var allSelectedDates = selectedDays;

      if (_selectedDays.contains(selectedDays)) {
        _selectedDays.remove(selectedDays);
        allChoosingDates.remove(allSelectedDates);

        lstAlldate.remove(
          AllDates(
              selectedDate: selectedDays,
              guestResponse: objCreateEventNotifier.getEventData.guest!),
        );
        print(allChoosingDates);
      } else {
        _selectedDays.add(selectedDays);
        lstAlldate.add(
          AllDates(
              selectedDate: selectedDays,
              guestResponse: objCreateEventNotifier.getEventData.guest!),
        );
        allChoosingDates.add(allSelectedDates);

        allChoosingDates.sort((a, b) => a.compareTo(b));
        lstAlldate.sort((a, b) => a.selectedDate!.compareTo(b.selectedDate!));
        print(allChoosingDates);
      }
    });
  }

  bool isOpenDate = false;
  String imageUrl = "";
  File? imageFile;

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

  List<UserModel> searchList = [];
  List<UserModel> contactsList = [];

  bool _IsSearching = false;
  String _searchText = "";
  bool isSearch = false;

  _EditEventScreenState() {
    _addCoHostController.addListener(() {
      if (_addCoHostController.text.isEmpty) {
        setState(
          () {
            _IsSearching = false;
            _searchText = "";
            _buildSearchList();
          },
        );
      } else {
        setState(
          () {
            _IsSearching = true;
            _searchText = _addCoHostController.text;
            _buildSearchList();
          },
        );
      }
    });
  }

  _getContactsData() async {
    var objGroupNotifier = Provider.of<GroupNotifier>(context, listen: false);
    await objGroupNotifier.getData(context, "");
    contactsList = objGroupNotifier.selectedUserList;
  }

  _buildSearchList() {
    if (_searchText.isEmpty) {
      return searchList = [];
    } else {
      searchList = contactsList
          .where(
            (element) =>
                element.firstName!.toLowerCase().startsWith(
                      _searchText.toLowerCase(),
                    ) ||
                element.lastName!.toLowerCase().startsWith(
                      _searchText.toLowerCase(),
                    ),
          )
          .toList();
      print('${searchList.length}');
      return searchList;
    }
  }

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
                  controller: _scrollController,
                  padding: EdgeInsets.only(top: height * 0.02),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        objCreateEventNotifier.getEventData.ownerID ==
                                _auth.currentUser!.uid
                            //Delete event
                            ? GestureDetector(
                                onTap: () {
                                  print('tapped');
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor:
                                            Color.fromARGB(255, 15, 15, 15),
                                        title: Container(
                                          margin: EdgeInsets.only(
                                              left: width * 0.03,
                                              right: width * 0.03),
                                          child: Text(
                                            "Are you sure you want to delete this event?",
                                            style: AppTheme.getTheme()
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                    color:
                                                        ConstColor.white_Color,
                                                    height: 1.4,
                                                    fontSize: width * 0.043),
                                          ),
                                        ),
                                        actions: [
                                          GestureDetector(
                                            onTap: () {
                                              //setState(() {
                                              //  currentIndex = 0;
                                              //  lastIndex = 0;
                                              //});
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Cancel",
                                              style: AppTheme.getTheme()
                                                  .textTheme
                                                  .bodyText2!
                                                  .copyWith(
                                                      color: ConstColor
                                                          .primaryColor,
                                                      height: 1.4,
                                                      fontSize: width * 0.04),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: width * 0.03,
                                                right: width * 0.03),
                                            child: GestureDetector(
                                              onTap: () async {
                                                await FirebaseFirestore.instance
                                                    .collection('events')
                                                    .doc(objCreateEventNotifier
                                                        .getEventData.docId!)
                                                    .delete();

                                                Navigator.pushReplacementNamed(
                                                    context, Routes.HOME);
                                              },
                                              child: Text(
                                                "Yes",
                                                style: AppTheme.getTheme()
                                                    .textTheme
                                                    .bodyText2!
                                                    .copyWith(
                                                        color: ConstColor
                                                            .primaryColor,
                                                        height: 1.4,
                                                        fontSize: width * 0.04),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: ErrorButton(name: "Delete Event"))
                            : GestureDetector(
                                onTap: () async {
                                  cohostList.removeWhere((element) =>
                                      element.uid == _auth.currentUser!.uid);
                                  ApiProvider().removeCohost(
                                    objCreateEventNotifier.getEventData.docId!,
                                    cohostList
                                        .map((e) => e.uid.toString())
                                        .toList(),
                                  );
                                  Navigator.pop(context);
                                },
                                child: CommonButton(name: "Leave as Co-Host")),

                        ///------------ event name textfield----------

                        Container(
                          margin: EdgeInsets.only(top: height * 0.026),
                          child: TextFormField(
                            autovalidateMode: AutovalidateMode.disabled,
                            style: AppTheme.getTheme()
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                  fontSize: width * 0.038,
                                  color: ConstColor.white_Color,
                                ),
                            controller: _eventnameController,
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
                                  vertical: height * 0.026),
                              hintText: TextUtils.eventname,
                              hintStyle: AppTheme.getTheme()
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    fontSize: width * 0.038,
                                    color: Color(0xff6C6C6C),
                                  ),
                            ),
                            validator: validateName,
                          ),
                        ),

                        ///------------ date time----------
                        Container(
                          margin: EdgeInsets.only(
                            top: height * 0.026,
                          ),
                          child: Row(
                            children: [
                              ///-------------------------- Select date--------------
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        if (isOpenDate) {
                                        } else {
                                          allChoosingDates = [];
                                          showDialog(
                                            barrierDismissible: true,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return _buildSingleSelectionPopupDialog();
                                            },
                                          ).then((value) {
                                            setState(() {
                                              isEndDate = false;
                                            });
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: height * 0.075,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.05,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              height * 0.1),
                                          border: Border.all(
                                            color:
                                                ConstColor.textFormFieldColor,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            allChoosingDates.isEmpty
                                                ? CommanLabeltext2(
                                                    selectedStartDate != "" &&
                                                            selectedEndDate ==
                                                                ""
                                                        ? selectedStartDate
                                                        : selectedStartDate !=
                                                                    "" &&
                                                                selectedEndDate !=
                                                                    ""
                                                            ? (selectedStartDate ==
                                                                    selectedEndDate
                                                                ? selectedStartDate
                                                                : selectedStartDate +
                                                                    " -\n" +
                                                                    selectedEndDate)
                                                            : TextUtils
                                                                .Enterdate,
                                                  )
                                                : CommanLabeltext2(
                                                    '${DateFormat('MMM dd, yyyy').format(allChoosingDates.first)}' +
                                                        '-\n${DateFormat('MMM dd, yyyy').format(allChoosingDates.last)}'),
                                            // allChoosingDates.isEmpty ||
                                            //         allChoosingDates.length == 1
                                            //     ? CommanLabeltext2(
                                            //         selectedStartDate != "" &&
                                            //                 selectedEndDate ==
                                            //                     ""
                                            //             ? selectedStartDate
                                            //             : selectedStartDate !=
                                            //                         "" &&
                                            //                     selectedEndDate !=
                                            //                         ""
                                            //                 ? selectedStartDate +
                                            //                     " -\n" +
                                            //                     selectedEndDate
                                            //                 : TextUtils
                                            //                     .Enterdate,
                                            //       )
                                            //     : CommanLabeltext2(
                                            //         DateFormat('MMM dd, yyyy')
                                            //                 .format(
                                            //                     allChoosingDates
                                            //                         .first) +
                                            //             "- \n" +
                                            //             DateFormat(
                                            //                     'MMM dd, yyyy')
                                            //                 .format(
                                            //                     allChoosingDates
                                            //                         .last),
                                            //       ),
                                            Image.asset(
                                              ConstantData.calender,
                                              height: height * 0.027,
                                              fit: BoxFit.cover,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    selectedStartDate == "" &&
                                            isDateSelected == true &&
                                            allChoosingDates.isEmpty
                                        ? Container(
                                            margin: EdgeInsets.only(
                                                top: height * 0.011,
                                                left: width * 0.055),
                                            child: Text(
                                              TextUtils.SelecteDate,
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
                                ),
                              ),

                              ///-------------------------- Select Time--------------

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        if (isOpenDate) {
                                        } else {
                                          showDialog(
                                            barrierDismissible: true,
                                            barrierColor: Colors.black54,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return buildCustomTimer(context);
                                            },
                                          ).then((value) {
                                            setState(() {
                                              isEndDate = false;
                                            });
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: height * 0.075,
                                        margin: EdgeInsets.only(
                                            left: width * 0.035),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.05,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              height * 0.1),
                                          border: Border.all(
                                            color:
                                                ConstColor.textFormFieldColor,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: CommanLabeltext2(
                                                selectStartTime != "" &&
                                                        selectEndTime == ""
                                                    ? selectStartTime
                                                    : selectStartTime != "" &&
                                                            selectEndTime != ""
                                                        ? selectStartTime +
                                                            " -\n" +
                                                            selectEndTime
                                                        : TextUtils.time,
                                              ),
                                            ),
                                            Image.asset(
                                              ConstantData.watch,
                                              height: height * 0.03,
                                              fit: BoxFit.cover,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    selectStartTime == "" &&
                                            isselectTime == true
                                        ? Container(
                                            margin: EdgeInsets.only(
                                                top: height * 0.011,
                                                left: width * 0.055),
                                            child: Text(
                                              TextUtils.SelectTime,
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
                                ),
                              ),
                            ],
                          ),
                        ),

                        ///----------------- choose Multidate-----------------
                        Container(
                          margin: EdgeInsets.only(top: height * 0.026),
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.05,
                              vertical: height * 0.022),
                          decoration: BoxDecoration(
                            borderRadius: isOpenDate
                                ? BorderRadius.circular(height * 0.02)
                                : BorderRadius.circular(height * 0.1),
                            border: Border.all(
                              color: !isOpenDate
                                  ? ConstColor.textFormFieldColor
                                  : ConstColor.primaryColor,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    TextUtils.Choosemultidate,
                                    style: AppTheme.getTheme()
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                            fontSize: width * 0.038,
                                            color: !isOpenDate
                                                ? ConstColor.white_Color
                                                : ConstColor.primaryColor,
                                            fontWeight: FontWeight.w400),
                                  ),
                                  FlutterSwitch(
                                      activeColor: ConstColor.primaryColor,
                                      width: width * 0.08,
                                      height: height * 0.028,
                                      toggleSize: width * 0.036,
                                      value: isOpenDate,
                                      borderRadius: 30.0,
                                      padding: 4.0,
                                      activeToggleColor: ConstColor.black_Color,
                                      onToggle: (value) {
                                        setState(() {
                                          isOpenDate = value;
                                        });
                                        if (isOpenDate == false) {
                                          setState(() {
                                            allChoosingDates.clear();
                                            _selectedDays.clear();
                                            lstAlldate.clear();
                                            lstAlldate = [];
                                          });
                                        }
                                      }),
                                ],
                              ),
                              isOpenDate == true
                                  ? Container(
                                      margin:
                                          EdgeInsets.only(top: height * 0.023),
                                      color: Color.fromARGB(255, 15, 15, 15),
                                      child: TableCalendar(
                                        calendarStyle: CalendarStyle(
                                          isTodayHighlighted: true,
                                          cellPadding: EdgeInsets.zero,
                                          cellMargin:
                                              EdgeInsets.all(height * 0.014),
                                          selectedDecoration: BoxDecoration(
                                              color: primaryColor,
                                              shape: BoxShape.rectangle),
                                          selectedTextStyle: AppTheme.getTheme()
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(
                                                  fontSize: width * 0.038,
                                                  color: ConstColor.black_Color,
                                                  fontWeight: FontWeight.w400),
                                          todayTextStyle: AppTheme.getTheme()
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(
                                                  fontSize: width * 0.038,
                                                  color:
                                                      ConstColor.primaryColor,
                                                  fontWeight: FontWeight.w400),
                                          todayDecoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 15, 15, 15),
                                              shape: BoxShape.circle),
                                          disabledTextStyle: TextStyle(
                                            color: Colors.grey,
                                          ),
                                          defaultTextStyle: TextStyle(
                                            color: Colors.white,
                                          ),
                                          outsideTextStyle: TextStyle(
                                            color: Colors.grey,
                                          ),
                                          weekendTextStyle:
                                              TextStyle(color: Colors.white),
                                        ),
                                        startingDayOfWeek:
                                            StartingDayOfWeek.monday,
                                        daysOfWeekStyle: DaysOfWeekStyle(
                                          weekdayStyle:
                                              TextStyle(color: Colors.white),
                                          weekendStyle:
                                              TextStyle(color: Colors.white),
                                        ),
                                        headerStyle: HeaderStyle(
                                          formatButtonVisible: false,
                                          leftChevronVisible: true,
                                          rightChevronVisible: true,
                                          leftChevronIcon: Icon(
                                            Icons.keyboard_arrow_left,
                                            color: ConstColor.white_Color,
                                          ),
                                          titleCentered: true,
                                          rightChevronIcon: Icon(
                                            Icons.keyboard_arrow_right,
                                            color: ConstColor.white_Color,
                                          ),
                                          titleTextStyle: AppTheme.getTheme()
                                              .textTheme
                                              .bodyText2!
                                              .copyWith(
                                                  fontSize: width * 0.046,
                                                  color: primaryColor),
                                        ),
                                        firstDay: DateTime.now(),
                                        lastDay: DateTime.now().add(
                                          Duration(days: 500),
                                        ),
                                        focusedDay: _focusedDay,
                                        calendarFormat: _calendarFormat,
                                        selectedDayPredicate: (day) {
                                          return _selectedDays.contains(day);
                                        },
                                        onDaySelected: _onDaySelected,
                                        onFormatChanged: (format) {
                                          if (_calendarFormat != format) {
                                            setState(() {
                                              _calendarFormat = format;
                                            });
                                          }
                                        },
                                        onPageChanged: (focusedDay) {
                                          // _focusedDay = focusedDay;
                                          // objProviderNotifier.selectedDate =
                                          //     focusedDay;

                                          // print(
                                          //     '============>${objProviderNotifier.selectedDate}');
                                          // print(
                                          //     '++++++++++++++${objProviderNotifier.currentDate}');

                                          // setState(() {
                                          //   objProviderNotifier.days.clear();
                                          // });

                                          // objProviderNotifier.getWeek(
                                          //   DateFormat('dd MMMM-yyyy').format(
                                          //               objProviderNotifier
                                          //                   .selectedDate) ==
                                          //           DateFormat('dd MMMM-yyyy')
                                          //               .format(
                                          //                   objProviderNotifier
                                          //                       .currentDate)
                                          //       ? _focusedDay
                                          //       : _focusedDay.subtract(
                                          //           Duration(
                                          //             days:
                                          //                 (_focusedDay.weekday -
                                          //                     1),
                                          //           ),
                                          //         ),
                                          //   _focusedDay.add(
                                          //     Duration(
                                          //       days: DateTime.daysPerWeek -
                                          //           _focusedDay.weekday,
                                          //     ),
                                          //   ),
                                          // );
                                        },
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        ),

                        ///------------------location -----------------

                        Container(
                          margin: EdgeInsets.only(top: height * 0.026),
                          child: TextFormField(
                            validator: validateLocation,
                            autovalidateMode: AutovalidateMode.disabled,
                            style: AppTheme.getTheme()
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                  fontSize: width * 0.038,
                                  color: ConstColor.white_Color,
                                ),
                            controller: _LocationController,
                            decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.location_on,
                                color: primaryColor,
                                size: width * 0.076,
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
                                  vertical: height * 0.026),
                              hintText: TextUtils.Location,
                              hintStyle: AppTheme.getTheme()
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    fontSize: width * 0.038,
                                    color: Color(0xff6C6C6C),
                                  ),
                            ),
                          ),
                        ),

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

                        ///----------------- event Photo ---------------
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
                                            margin:
                                                EdgeInsets.all(height * 0.02),
                                            child: Text(
                                              'GALLERY',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2!
                                                  .copyWith(
                                                    color: Theme.of(context)
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
                                            margin:
                                                EdgeInsets.all(height * 0.02),
                                            child: Text(
                                              'CAMERA',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2!
                                                  .copyWith(
                                                      color: Theme.of(context)
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
                                            margin:
                                                EdgeInsets.all(height * 0.02),
                                            child: Text(
                                              'Cancel',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2!
                                                  .copyWith(
                                                      color: Theme.of(context)
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
                              borderRadius: BorderRadius.circular(height * 0.1),
                              border: Border.all(
                                color: ConstColor.textFormFieldColor,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    imageFile == null && imageUrl == null
                                        ? "Upload event photo"
                                        : "Image Selected",
                                    style: AppTheme.getTheme()
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          fontSize: width * 0.038,
                                          color: Color(0xff6C6C6C),
                                        ),
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
                        imageUrl == "" && isuploadImage == true
                            ? Container(
                                margin: EdgeInsets.only(
                                    top: height * 0.011, left: width * 0.055),
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

                        // ///--------- Enable Cost spliting-------------
                        // Container(
                        //   margin: EdgeInsets.only(top: height * 0.026),
                        //   padding: EdgeInsets.symmetric(
                        //       horizontal: width * 0.04,
                        //       vertical: height * 0.024),
                        //   alignment: Alignment.centerLeft,
                        //   width: width,
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(height * 0.1),
                        //     border: Border.all(
                        //       color: ConstColor.textFormFieldColor,
                        //     ),
                        //   ),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       CommanLabeltext(
                        //         TextUtils.costsplit,
                        //       ),
                        //       FlutterSwitch(
                        //         activeColor: ConstColor.primaryColor,
                        //         width: width * 0.08,
                        //         height: height * 0.028,
                        //         toggleSize: width * 0.036,
                        //         value: objProviderNotifier.getamount == null ||
                        //                 objProviderNotifier.getamount == 0
                        //             ? false
                        //             : isCostSplite,
                        //         borderRadius: 30.0,
                        //         padding: 4.0,
                        //         activeToggleColor: ConstColor.black_Color,
                        //         onToggle: (val) {
                        //           setState(() {
                        //             isCostSplite = val;
                        //           });

                        //           if (isCostSplite == true) {
                        //             showDialog(
                        //                 barrierDismissible: false,
                        //                 context: context,
                        //                 builder: (BuildContext context) {
                        //                   return CoSpliteDialog();
                        //                 }).whenComplete(() {
                        //               if (objProviderNotifier.getamount == 0 ||
                        //                   objProviderNotifier.getamount ==
                        //                       0.0 ||
                        //                   objProviderNotifier.getamount ==
                        //                       null) {
                        //                 isCostSplite = false;
                        //               }
                        //             });
                        //           } else {
                        //             objProviderNotifier.setamount = 0;
                        //           }
                        //         },
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // isCostSplite == true &&
                        //         objProviderNotifier.getamount != 0 &&
                        //         objProviderNotifier.getamount != null
                        //     ? Container(
                        //         margin: EdgeInsets.only(
                        //             top: height * 0.011, left: width * 0.055),
                        //         child: Text(
                        //           "Co-splite amout is " +
                        //               double.parse(objProviderNotifier.getamount
                        //                       .toString())
                        //                   .toStringAsFixed(2),
                        //           style: Theme.of(context)
                        //               .textTheme
                        //               .bodyText1!
                        //               .copyWith(
                        //                 fontSize: width * 0.036,
                        //                 color: ConstColor.Text_grey_color,
                        //               ),
                        //         ),
                        //       )
                        //     : Container(),

                        ///--------------------- add-co-host----------

                        Container(
                          padding: EdgeInsets.only(right: width * 0.03),
                          margin: EdgeInsets.only(top: height * 0.026),
                          alignment: Alignment.centerLeft,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(height * 0.1),
                            border: Border.all(
                              color: ConstColor.textFormFieldColor,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Focus(
                                onFocusChange: (hasFocus) {
                                  if (hasFocus) {
                                    _scrollController.animateTo(height * 1.6,
                                        curve: Curves.linear,
                                        duration: Duration(milliseconds: 500));
                                  }
                                },
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  style: AppTheme.getTheme()
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        fontSize: width * 0.046,
                                        color: ConstColor.white_Color,
                                      ),
                                  controller: _addCoHostController,
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
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: width * 0.05,
                                        vertical: height * 0.024),
                                    hintText: TextUtils.Addcohosts,
                                    hintStyle: AppTheme.getTheme()
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          fontSize: width * 0.046,
                                          color: ConstColor.white_Color,
                                        ),
                                  ),
                                ),
                              )),
                              Image.asset(
                                ConstantData.coHost,
                                height: height * 0.03,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),
                        // searchList.isNotEmpty
                        //     ? Container(
                        //         alignment: Alignment.center,
                        //         width: width,
                        //         color: primaryColor,
                        //         margin: EdgeInsets.only(
                        //           top: height * 0.011,
                        //         ),
                        //         padding: EdgeInsets.only(
                        //           top: height * 0.025,
                        //           bottom: height * 0.025,
                        //         ),
                        //         child: Text(
                        //           "Add a co-host",
                        //           style: Theme.of(context)
                        //               .textTheme
                        //               .bodyText2!
                        //               .copyWith(
                        //                 fontSize: width * 0.046,
                        //                 color: Colors.black,
                        //               ),
                        //         ),
                        //       )
                        //     : Container(),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: min(searchList.length, 5),
                          itemBuilder: (BuildContext context, int index) {
                            return cohostList.contains(searchList[index])
                                ? Container()
                                : Container(
                                    color: Color.fromARGB(255, 15, 15, 15),
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              print(searchList[index].uid);
                                              cohostList.add(searchList[index]);
                                              co_host += ", " +
                                                  searchList[index].firstName! +
                                                  " " +
                                                  searchList[index].lastName!;
                                              _addCoHostController.text = "";
                                            });
                                            print(
                                                "Co host list ====> ${cohostList}");

                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                              top: height * 0.025,
                                              bottom: height * 0.025,
                                            ),
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: width * 0.05),
                                              child: CommanLabeltext(
                                                searchList[index].firstName! +
                                                    " " +
                                                    searchList[index].lastName!,
                                              ),
                                            ),
                                          ),
                                        ),
                                        searchList.last == searchList[index]
                                            ? Container()
                                            : Container(
                                                height: 1,
                                                width: width,
                                                color: ConstColor
                                                    .term_condition_grey_color
                                                    .withOpacity(0.6),
                                              )
                                      ],
                                    ),
                                  );
                          },
                        ),
                        Container(
                          child: cohostList.length <= 1
                              ? Container()
                              : Container(
                                  padding: EdgeInsets.only(
                                      left: width * 0.05,
                                      right: width * 0.05,
                                      bottom: height * 0.01,
                                      top: height * 0.03),
                                  margin: EdgeInsets.only(top: height * 0.026),
                                  alignment: Alignment.centerLeft,
                                  width: width,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(height * 0.02),
                                    border: Border.all(
                                      color: ConstColor.textFormFieldColor,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: cohostList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Container(
                                              margin: EdgeInsets.only(
                                                  bottom: height * 0.02,
                                                  left: width * 0.02),
                                              child: index == 0
                                                  ? Text(
                                                      "Co-Host List",
                                                      style: AppTheme.getTheme()
                                                          .textTheme
                                                          .bodyText2!
                                                          .copyWith(
                                                              fontSize:
                                                                  width * 0.05,
                                                              color: ConstColor
                                                                  .primaryColor),
                                                    )
                                                  : Text(
                                                      cohostList[index]
                                                              .firstName! +
                                                          " " +
                                                          cohostList[index]
                                                              .lastName!,
                                                      style: AppTheme.getTheme()
                                                          .textTheme
                                                          .bodyText2!
                                                          .copyWith(
                                                              fontSize:
                                                                  width * 0.04,
                                                              color: ConstColor
                                                                  .white_Color),
                                                    ));
                                        },
                                      )
                                    ],
                                  )),
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
                        Stack(
                          children: [
                            isLoader == true
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: primaryColor,
                                    ),
                                  )
                                : Container(),
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

                                  final isValid =
                                      formKey.currentState!.validate();

                                  if (isValid && selectStartTime != "") {
                                    setState(() {
                                      isLoader = true;
                                    });
                                    // if (allChoosingDates.isEmpty &&
                                    //     selectedStartDate != "" &&
                                    //     selectedEndDate != "") {
                                    //   allChoosingDates.add(eventStartDate);
                                    //   allChoosingDates.add(eventEndDate);
                                    //   allChoosingDates
                                    //       .sort((a, b) => a.compareTo(b));
                                    //   lstAlldate.add(
                                    //     AllDates(
                                    //         selectedDate: eventStartDate,
                                    //         guestResponse:
                                    //             objCreateEventNotifier
                                    //                 .getEventData.guest!),
                                    //   );
                                    //   lstAlldate.add(
                                    //     AllDates(
                                    //         selectedDate: eventEndDate,
                                    //         guestResponse:
                                    //             objCreateEventNotifier
                                    //                 .getEventData.guest!),
                                    //   );
                                    //   print(allChoosingDates);
                                    // } else
                                    if (allChoosingDates.isEmpty &&
                                        selectedStartDate != "") {
                                      allChoosingDates.add(eventStartDate);
                                      lstAlldate.add(
                                        AllDates(
                                            selectedDate: eventStartDate,
                                            guestResponse:
                                                objCreateEventNotifier
                                                    .getEventData.guest!),
                                      );
                                    } else if (allChoosingDates.isEmpty &&
                                        selectedStartDate == "") {
                                      allChoosingDates.add(DateTime.now());
                                      lstAlldate.add(
                                        AllDates(
                                            selectedDate: DateTime.now(),
                                            guestResponse:
                                                objCreateEventNotifier
                                                    .getEventData.guest!),
                                      );
                                    }
                                    var endTime = selectEndTime == ""
                                        ? "11:59 PM"
                                        : selectEndTime;
                                    var selectedTime =
                                        selectStartTime + " - " + endTime;

                                    await geteventStartDateFromString();
                                    await geteventEndDateFromString();
                                    print(eventStartDate);
                                    print(eventEndDate);

                                    if (imageFile != null && imageFile != "") {
                                      var imageName =
                                          imageFile!.path.split('/').last;
                                      print(imageName);
                                      var snapshot = await FirebaseStorage
                                          .instance
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
                                      co_host,
                                      eventStartDate,
                                      eventEndDate,
                                      objCreateEventNotifier.getEventData.guest,
                                      objCreateEventNotifier
                                          .getEventData.guestsID,
                                      objCreateEventNotifier
                                          .getEventData.lstUser,
                                      objCreateEventNotifier
                                          .getEventData.ownerID,
                                      cohostList
                                          .map((e) => e.uid.toString())
                                          .toList(),
                                      lstAlldate,
                                    )
                                        .whenComplete(() async {
                                      setState(() {
                                        isLoader = false;
                                      });
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
                                        co_host = "";
                                        imageFile = null;
                                        isuploadImage = false;
                                        selectedStartDate = "";
                                        selectedEndDate = "";
                                        isselectTime = false;
                                        isDateSelected = false;
                                        isOpenDate = false;
                                        _selectedDays.clear();
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
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Widget _buildSingleSelectionPopupDialog() {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return SingleDateSelection(
          isToggleDisable: selectedStartDate == "" ? true : false,
          onStartDateSubmit: onStartDateSubmit,
          onStartDateCancel: onStartDateCancel,
          onStartDateViewChanged: onStartDateChanged,
          initialStartDate:
              selectedStartDate == "" ? DateTime.now() : eventStartDate,
          initialEndDate: selectedEndDate == "" ? eventEndDate : eventEndDate,
          onEndDateCancel: onEndDateCancel,
          onEndDateSubmit: onEndDateSubmit,
          onEndDateViewChanged: onEndDateChanged,
        );
      },
    );
  }

  buildCustomTimer(BuildContext context) {
    return TimeRangePicker(
      isToggleDisable: selectStartTime == "" ? true : false,
      currentTime2: currentTime2 == "" || currentTime2 == null
          ? DateTime.now()
          : currentTime2!,
      currentTime: currentTime,
      selectToTime: selectEndTime,
      selectFromTime: selectStartTime,
      onFromCancelTap: () {
        if (selectStartTime != "") {
          selectStartTime;
        } else {
          setState(() {
            selectStartTime = "";
          });
        }
        Navigator.pop(context);

        print('================>${selectStartTime.toString().split(" ")}');
      },
      onFromOKTap: () {
        if (selectStartTime == "") {
          setState(() {
            selectStartTime = '${DateFormat('h:mm aa').format(DateTime.now())}';
          });
        }
        Navigator.pop(context);
        setState(() {
          selectStartTime;
        });

        print('================>${selectStartTime.split(" ")[0].split(":")}');
      },
      onToOkTap: () {
        setState(() {
          if (selectEndTime == "") {
            selectEndTime = '${DateFormat('h:mm aa').format(DateTime.now())}';
          }
          setState(() {
            selectEndTime;
          });
        });
        Navigator.pop(context);
        print('================>${selectEndTime}');
      },
      onToCancelTap: () {
        if (selectEndTime != "") {
          selectEndTime;
        } else {
          setState(() {
            selectEndTime = "";
          });
        }
        Navigator.pop(context);

        print('================>${selectEndTime}');
      },
      onEndDateTimeChanged: (newDateTime) {
        setState(() {
          selectEndTime = '${DateFormat('h:mm aa').format(newDateTime)}';
          currentTime2 = newDateTime;
          print(newDateTime);
        });
      },
      onStartDateTimeChanged: (newDateTime) {
        setState(() {
          selectStartTime = '${DateFormat('h:mm aa').format(newDateTime)}';

          currentTime = newDateTime;
        });
      },
    );
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

  Widget CommanLabeltext2(String text) {
    return Text(
      text,
      style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
          fontSize: width * 0.038,
          color: ConstColor.white_Color,
          fontWeight: FontWeight.w400),
    );
  }
}
