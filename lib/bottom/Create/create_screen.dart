import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:omw/bottom/Create/single_selection.dart';
import 'package:omw/bottom/Create/time_range_picker.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:omw/notifier/group_notifier.dart';

import '../../../api/apiProvider.dart';
import '../../constant/constants.dart';
import '../../constant/theme.dart';
import '../../model/createEvent_model.dart';
import '../../model/user_model.dart';
import '../../notifier/changenotifier.dart';
import '../../notifier/event_notifier.dart';
import '../../preference/preference.dart';
import '../../utils/colorUtils.dart';
import '../../utils/textUtils.dart';
import '../../widget/commonButton.dart';
import '../../widget/validation.dart';
import '../Events/InviteFriends/invite_friends_screen.dart';
import '../Profile/drawer.dart';
import 'co-splite/co_splite_dialog.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class CreateScreen extends StatefulWidget {
  const CreateScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final Set _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
  );

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

  String co_host = "";
  List<UserModel> cohostList = [];

  onStartDateSubmit(val) {
    setState(() {
      selectedStartDate = '${DateFormat('MMM d, yyyy').format(val)}';
      eventStartDate = val;
      FocusManager.instance.primaryFocus?.unfocus();

      print(eventStartDate);
    });
    Navigator.pop(context);

    print('================>$eventStartDate');
  }

  void onStartDateChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      selectedStartDate = '${DateFormat('MMM d, yyyy').format(args.value)}';
      eventStartDate = args.value;
      FocusManager.instance.primaryFocus?.unfocus();
      print('Changed start date $selectedStartDate');
    });
  }

  void onEndDateChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      selectedEndDate = '${DateFormat('MMM d, yyyy').format(args.value)}';
      eventEndDate = args.value;
      print('Changed end date $selectedEndDate');
    });
  }

  onStartDateCancel() {
    Navigator.pop(context);
    FocusManager.instance.primaryFocus?.unfocus();

    print('================> $selectedStartDate');
  }

  onEndDateSubmit(val) {
    setState(() {
      selectedEndDate = '${DateFormat('MMM d, yyyy').format(val)}';
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
      setState(() {});
      eventStartDate = DateTime(
          allChoosingDates.first.year,
          allChoosingDates.first.month,
          allChoosingDates.first.day,
          currentTime.hour,
          currentTime.minute,
          currentTime.second,
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
          currentTime2 == null || currentTime2 == "" ? 23 : currentTime2!.hour,
          currentTime2 == null || currentTime2 == ""
              ? 59
              : currentTime2!.minute,
          currentTime2 == null || currentTime2 == ""
              ? 00
              : currentTime2!.second,
          0,
          0);
      setState(() {});
      print("=============> currentTime2 :- $currentTime2");
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
  List allChoosingDates = [];
  _onDaySelected(DateTime selectedDays, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
      var allSelectedDates = selectedDays;

      if (_selectedDays.contains(selectedDays)) {
        _selectedDays.remove(selectedDays);
        allChoosingDates.remove(allSelectedDates);
        lstAlldate.remove(
          AllDates(selectedDate: selectedDays, guestResponse: [
            GuestModel(
                guestID: FirebaseAuth.instance.currentUser!.uid,
                status: 0,
                guestUserName: currentuser)
          ]),
        );
        print(allChoosingDates);
      } else {
        _selectedDays.add(selectedDays);
        lstAlldate.add(
          AllDates(selectedDate: selectedDays, guestResponse: [
            GuestModel(
                guestID: FirebaseAuth.instance.currentUser!.uid,
                status: 0,
                guestUserName: currentuser)
          ]),
        );
        allChoosingDates.add(allSelectedDates);

        allChoosingDates.sort((a, b) => a.compareTo(b));
        lstAlldate.sort((a, b) => a.selectedDate!.compareTo(b.selectedDate!));
        setState(() {});
        print(allChoosingDates);
      }
    });
  }

  bool isAlreadyTapped = false;
  List<AllDates> lstAlldate = [];
  bool isOpenDate = false;
  String imageUrl = '';
  File? imageFile;
  bool defaultImage = true;
  File? dummyFile = File('');
  String dummyUrl =
      "https://images.unsplash.com/photo-1492684223066-81342ee5ff30?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8ZXZlbnR8ZW58MHx8MHx8&w=1000&q=80";
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

  bool isLoading = true;

  @override
  void initState() {
    var objCreateEventNotifier =
        Provider.of<CreateEventNotifier>(context, listen: false);
    getCurrentUser();
    objCreateEventNotifier.getAllUserList(context);
    objCreateEventNotifier.isLoading = false;
    _getContactsData();
    isLoading = false;

    super.initState();
  }

  String currentuser = "";
  UserModel currentUserModel = new UserModel();
  getCurrentUser() async {
    currentuser = await PrefServices().getCurrentUserName();
    currentUserModel =
        await ApiProvider().getUserDetail(_auth.currentUser!.uid);
    cohostList = [currentUserModel];
  }

  List<UserModel> searchList = [];
  List<UserModel> contactsList = [];

  bool _IsSearching = false;
  String _searchText = "";
  bool isSearch = false;

  _CreateScreenState() {
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
      _scrollController.animateTo(height * 0.75,
          curve: Curves.linear, duration: Duration(milliseconds: 500));
    });
  }
  _getContactsData() async {
    var objGroupNotifier = Provider.of<GroupNotifier>(context, listen: false);
    await objGroupNotifier.getData(context, "");
    contactsList = objGroupNotifier.selectedUserList;
  }

  _buildSearchList() {
    print("Calling Search List");
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
      print('Contacts List ====>${contactsList}');
      print('Search Text =======> ${_searchText}');
      print('Search List ====>${searchList}');
      return searchList;
    }
  }

  @override
  Widget build(BuildContext context) {
    final objProviderNotifier = context.watch<ProviderNotifier>();
    final objCreateEventNotifier = context.watch<CreateEventNotifier>();

    return Column(
      children: [
        AppBar(
          backgroundColor: AppTheme.getTheme().scaffoldBackgroundColor,
          leading: Container(
            margin: EdgeInsets.only(left: width * 0.03),
            child: GestureDetector(
              onTap: () {
                _openDrawer();
              },
              child: Image.asset(
                ConstantData.menu2,
                fit: BoxFit.contain,
              ),
            ),
          ),
          leadingWidth: height * 0.055,
          title: Image.asset(
            ConstantData.logo,
            height: height * 0.12,
            width: height * 0.12,
            fit: BoxFit.contain,
          ),
          // Text(
          //   TextUtils.Omw,
          //   style: AppTheme.getTheme().textTheme.subtitle1!.copyWith(
          //         color: primaryColor,
          //         fontWeight: FontWeight.w700,
          //         fontSize: width * 0.09,
          //       ),
          // ),
          centerTitle: true,
        ),
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              objCreateEventNotifier.isLoading == true || isLoading == true
                  ? CircularProgressIndicator(
                      color: primaryColor,
                    )
                  : Container(),
              Container(
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
                        ///------------ event name textfield----------

                        Container(
                          margin: EdgeInsets.only(top: height * 0.026),
                          child: TextFormField(
                            autofocus: true,
                            textCapitalization: TextCapitalization.sentences,
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
                                                            ? selectedStartDate +
                                                                " -\n" +
                                                                selectedEndDate
                                                            : TextUtils
                                                                .Enterdate,
                                                  )
                                                : CommanLabeltext2(
                                                    '${DateFormat('MMM d, yyyy').format(allChoosingDates.first)}  -\n${DateFormat('MMM d, yyyy').format(allChoosingDates.last)}'),
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
                                        showDialog(
                                          barrierDismissible: true,
                                          barrierColor: Colors.black54,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return buildCustomTimer(context);
                                          },
                                        ).then((value) {
                                          setState(() {
                                            isEndTime = false;
                                          });
                                        });
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
                                        lstAlldate = [];
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

                                          print(
                                              "lstAlldate========>$lstAlldate");
                                        }
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
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
                        isOpenDate && allChoosingDates.length <= 1
                            ? Container(
                                margin: EdgeInsets.only(
                                    top: height * 0.011, left: width * 0.055),
                                child: Text(
                                  "please select more than one date",
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

                        ///------------------location -----------------

                        Container(
                          margin: EdgeInsets.only(top: height * 0.026),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
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
                            textCapitalization: TextCapitalization.sentences,
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
                            FocusManager.instance.primaryFocus?.unfocus();
                            showModalBottomSheet(
                              backgroundColor: Colors.transparent,
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
                                            width: width,
                                            height: height * 0.08,
                                            decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 40, 40, 40),
                                                borderRadius:
                                                    new BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            height * 0.03),
                                                        bottom: Radius.circular(
                                                            0))),
                                            child: Center(
                                              child: Container(
                                                margin: EdgeInsets.all(
                                                    height * 0.02),
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
                                          ),
                                        ),
                                        Divider(
                                          thickness: 2,
                                          height: 1,
                                          color: Colors.black,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            _getFromCamera();
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            width: width,
                                            height: height * 0.08,
                                            color:
                                                Color.fromARGB(255, 40, 40, 40),
                                            child: Center(
                                              child: Container(
                                                margin: EdgeInsets.all(
                                                    height * 0.02),
                                                child: Text(
                                                  'CAMERA',
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
                                          ),
                                        ),
                                        Divider(
                                          thickness: 2,
                                          height: 1,
                                          color: Colors.black,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            width: width,
                                            height: height * 0.08,
                                            color:
                                                Color.fromARGB(255, 40, 40, 40),
                                            child: Center(
                                              child: Container(
                                                margin: EdgeInsets.all(
                                                    height * 0.02),
                                                child: Text(
                                                  'CANCEL',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2!
                                                      .copyWith(
                                                        color: Theme.of(context)
                                                            .errorColor,
                                                      ),
                                                ),
                                              ),
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
                                    imageFile == null
                                        ? "Upload event photo"
                                        : "Image selected",
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
                        //           "Co-splittig amout is " +
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
                                      bottom: height * 0.01),
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
                        Container(
                          margin: EdgeInsets.only(
                              bottom: height * 0.02, top: height * 0.02),
                          child: GestureDetector(
                            onTap: () async {
                              setState(
                                () {
                                  isselectTime = true;
                                  isDateSelected = true;
                                },
                              );
                              bool ismultidate = false;

                              final isValid = formKey.currentState!.validate();

                              if (isOpenDate == true &&
                                  allChoosingDates.length <= 1) {
                                print("dfd");
                              } else if (isValid &&
                                  selectStartTime != "" &&
                                  isAlreadyTapped == false) {
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
                                //         guestResponse: [
                                //           GuestModel(
                                //               guestID: FirebaseAuth
                                //                   .instance.currentUser!.uid,
                                //               status: 0,
                                //               guestUserName: currentuser)
                                //         ]),
                                //   );
                                //   lstAlldate.add(
                                //     AllDates(
                                //         selectedDate: eventEndDate,
                                //         guestResponse: [
                                //           GuestModel(
                                //               guestID: FirebaseAuth
                                //                   .instance.currentUser!.uid,
                                //               status: 0,
                                //               guestUserName: currentuser)
                                //         ]),
                                //   );
                                //   print(allChoosingDates);
                                // } else
                                if (allChoosingDates.isEmpty &&
                                    selectedStartDate != "") {
                                  allChoosingDates.add(eventStartDate);
                                  lstAlldate.add(
                                    AllDates(
                                        selectedDate: eventStartDate,
                                        guestResponse: [
                                          GuestModel(
                                              guestID: FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              status: 0,
                                              guestUserName: currentuser)
                                        ]),
                                  );
                                } else if (allChoosingDates.isEmpty &&
                                    selectedStartDate == "") {
                                  allChoosingDates.add(DateTime.now());
                                  lstAlldate.add(
                                    AllDates(
                                        selectedDate: DateTime.now(),
                                        guestResponse: [
                                          GuestModel(
                                              guestID: FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              status: 0,
                                              guestUserName: currentuser)
                                        ]),
                                  );
                                }
                                var endTime = selectEndTime == ""
                                    ? "11:59 PM"
                                    : selectEndTime;
                                var selectedTime =
                                    selectStartTime + " - " + endTime;

                                await geteventStartDateFromString();
                                await geteventEndDateFromString();
                                setState(() {
                                  isAlreadyTapped = true;
                                });
                                print(
                                    "Co host list ====> ${cohostList.map((el) => el.uid).toList()}");
                                objCreateEventNotifier
                                    .createEvents(
                                        context,
                                        _eventnameController.text,
                                        allChoosingDates,
                                        selectedTime,
                                        _descriptionController.text,
                                        _LocationController.text,
                                        imageUrl == "" ? dummyUrl : imageUrl,
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
                                        "",
                                        imageFile == null || imageFile == ""
                                            ? dummyFile!
                                            : imageFile!,
                                        eventStartDate,
                                        eventEndDate,
                                        lstAlldate,
                                        cohostList
                                            .map((el) => el.uid!.toString())
                                            .toList(),
                                        currentuser)
                                    .whenComplete(() {
                                  objCreateEventNotifier.isLoading = false;
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
                                    setState(() {
                                      isAlreadyTapped = false;
                                    });
                                    selectedStartDate = "";
                                    selectedEndDate = "";
                                    isselectTime = false;
                                    isDateSelected = false;
                                    isOpenDate = false;
                                    _selectedDays.clear();
                                    currentTime2 = null;
                                    co_host = "";
                                    lstAlldate = [];
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: ((context) =>
                                            InviteFriendsScreen(
                                              isFromAddEvent: true,
                                            )),
                                      ),
                                    );
                                  });
                                });
                              }
                            },
                            child: CommonButton(
                              name: TextUtils.Create,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildSingleSelectionPopupDialog() {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return SingleDateSelection(
          // isFromEvent: false,
          onStartDateSubmit: onStartDateSubmit,
          onStartDateCancel: onStartDateCancel,
          onStartDateViewChanged: onStartDateChanged,
          initialStartDate:
              selectedStartDate == "" ? DateTime.now() : eventStartDate,
          initialEndDate: selectedEndDate == "" ? eventEndDate : eventEndDate,
          onEndDateCancel: onEndDateCancel,
          onEndDateSubmit: onEndDateSubmit,
          onEndDateViewChanged: onEndDateChanged,
          isToggleDisable: selectedStartDate == "" ? true : false,
        );
      },
    );
  }

  _openDrawer() {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return CommonDrawer();
      },
    );
  }

  buildCustomTimer(BuildContext context) {
    return TimeRangePicker(
      isToggleDisable: false,
      currentTime2: currentTime2 == "" || currentTime2 == null
          ? DateTime.now()
          : currentTime2!,
      currentTime: currentTime,
      selectToTime: selectEndTime,
      selectFromTime: selectStartTime,
      onFromCancelTap: () {
        // if (selectStartTime != "") {
        //   selectStartTime;
        // } else {
        //   setState(() {
        //     selectStartTime = "";
        //   });
        // }
        setState(() {
          // selectStartTime = '${DateFormat('h:mm aa').format(DateTime.now())}';
          // selectEndTime = "";
        });
        Navigator.pop(context);
        FocusManager.instance.primaryFocus?.unfocus();

        print('================>${selectStartTime}');
      },
      onFromOKTap: () {
        if (selectStartTime == "") {
          setState(() {
            selectStartTime = '${DateFormat('h:mm aa').format(DateTime.now())}';
          });
        }
        setState(() {
          selectStartTime;
        });
        Navigator.pop(context);
        FocusManager.instance.primaryFocus?.unfocus();
        print('================>${selectStartTime}');
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
        FocusManager.instance.primaryFocus?.unfocus();
        print('================>${selectEndTime}');
      },
      onToCancelTap: () {
        // if (selectEndTime != "") {
        //   selectEndTime;
        // } else {
        //   setState(() {
        //     selectEndTime = "";
        //   });
        // }
        setState(() {
          // selectEndTime = "";
        });
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
