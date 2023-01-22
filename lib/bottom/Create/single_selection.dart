import 'package:flutter/material.dart';
import 'package:omw/constant/theme.dart';
import 'package:omw/utils/colorUtils.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../constant/constants.dart';

bool isEndDate = false;

class SingleDateSelection extends StatefulWidget {
  // final bool isFromEvent;
  final void Function(DateRangePickerSelectionChangedArgs)?
      onStartDateViewChanged;
  final void Function(DateRangePickerSelectionChangedArgs)?
      onEndDateViewChanged;
  final Function(Object?)? onStartDateSubmit;
  final DateTime? initialStartDate;
  final Function()? onStartDateCancel;
  final Function(Object?)? onEndDateSubmit;
  final DateTime? initialEndDate;
  final Function()? onEndDateCancel;
  final bool isToggleDisable;
  const SingleDateSelection(
      {Key? key,
      this.onStartDateViewChanged,
      this.onStartDateSubmit,
      this.onStartDateCancel,
      this.initialStartDate,
      // required this.isFromEvent,
      this.onEndDateSubmit,
      this.initialEndDate,
      this.onEndDateCancel,
      this.onEndDateViewChanged,
      required this.isToggleDisable})
      : super(key: key);

  @override
  State<SingleDateSelection> createState() => _SingleDateSelectionState();
}

class _SingleDateSelectionState extends State<SingleDateSelection> {
  final DateRangePickerController _controller = DateRangePickerController();
  @override
  void initState() {
    _controller.view = DateRangePickerView.month;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: AppBar().preferredSize.height / 1.4,
              left: width * 0.02,
              right: width * 0.02),
          padding: EdgeInsets.all(height * 0.01),
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                  blurRadius: 0.7,
                  spreadRadius: 0.7,
                  color: ConstColor.textFormFieldColor),
            ],
            border: Border.all(
              color: ConstColor.textFormFieldColor,
            ),
            borderRadius: BorderRadius.circular(20),
            color: const Color.fromARGB(255, 15, 15, 15),
          ),
          width: width,
          child: Column(
            children: [
              // Container(
              //   margin: EdgeInsets.only(
              //       left: width * 0.05,
              //       right: width * 0.05,
              //       top: height * 0.02,
              //       bottom: height * 0.03),
              //   padding: EdgeInsets.all(height * 0.006),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       FlutterSwitch(
              //         disabled: widget.isToggleDisable ? true : false,
              //         activeColor: ConstColor.primaryColor,
              //         width: width * 0.1,
              //         height: height * 0.028,
              //         toggleSize: width * 0.036,
              //         value: isEndDate,
              //         borderRadius: 30.0,
              //         padding: 4.0,
              //         activeToggleColor: ConstColor.black_Color,
              //         onToggle: (val) {
              //           setState(() {
              //             isEndDate = val;
              //           });
              //         },
              //       ),
              //       Container(
              //         margin: EdgeInsets.only(left: width * 0.02),
              //         child: Text(
              //           "End Date",
              //           style: Theme.of(context).textTheme.bodyText2!.copyWith(
              //                 fontSize: width * 0.05,
              //                 color: widget.isToggleDisable
              //                     ? ConstColor.Text_grey_color
              //                     : primaryColor,
              //               ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isEndDate == false
                      ? Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: height * 0.02),
                              child: Text(
                                "Select Date",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                      fontSize: width * 0.042,
                                      color: ConstColor.white_Color,
                                    ),
                              ),
                            ),
                            Container(
                              height: 1,
                              width: width * 0.2,
                              color: primaryColor,
                            )
                          ],
                        )
                      : Column(
                          children: [
                            Text(
                              "End Date",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                    fontSize: width * 0.042,
                                    color: ConstColor.white_Color,
                                  ),
                            ),
                            Container(
                              height: 1,
                              width: width * 0.2,
                              color: primaryColor,
                            )
                          ],
                        ),
                ],
              ),
              isEndDate == false
                  ? SfDateRangePicker(
                      showActionButtons: true,
                      selectionShape: DateRangePickerSelectionShape.rectangle,
                      monthViewSettings: DateRangePickerMonthViewSettings(
                        weekNumberStyle: DateRangePickerWeekNumberStyle(
                          textStyle:
                              AppTheme.getTheme().textTheme.bodyText2!.copyWith(
                                    fontSize: width * 0.033,
                                    color: ConstColor.black_Color,
                                  ),
                        ),
                        firstDayOfWeek: 1,
                        dayFormat: 'E',
                        viewHeaderHeight: height * 0.03,
                        showTrailingAndLeadingDates: true,
                        viewHeaderStyle: DateRangePickerViewHeaderStyle(
                          backgroundColor: Colors.transparent,
                          textStyle: AppTheme.getTheme()
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.white),
                        ),
                        enableSwipeSelection: false,
                      ),
                      minDate: DateTime.now(),
                      todayHighlightColor: primaryColor,
                      selectionColor: primaryColor,
                      selectionTextStyle:
                          AppTheme.getTheme().textTheme.bodyText2!.copyWith(
                                fontSize: width * 0.033,
                                color: ConstColor.black_Color,
                              ),
                      selectionMode: DateRangePickerSelectionMode.single,
                      initialSelectedDate: widget.initialStartDate,
                      enablePastDates: false,
                      allowViewNavigation: false,
                      headerHeight: height * 0.1,
                      showNavigationArrow: true,
                      headerStyle: DateRangePickerHeaderStyle(
                          textStyle:
                              AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                                    fontSize: width * 0.05,
                                    color: ConstColor.primaryColor,
                                  ),
                          textAlign: TextAlign.left),
                      rangeTextStyle: AppTheme.getTheme()
                          .textTheme
                          .bodyText2!
                          .copyWith(color: Colors.black),
                      enableMultiView: false,
                      onSelectionChanged: widget.onStartDateViewChanged,
                      cancelText: "CANCEL",
                      confirmText: "SELECT",
                      onCancel: widget.onStartDateCancel,
                      onSubmit: widget.onStartDateSubmit,
                    )
                  : SfDateRangePicker(
                      showActionButtons: true,
                      minDate: DateTime.now(),
                      selectionShape: DateRangePickerSelectionShape.rectangle,
                      monthViewSettings: DateRangePickerMonthViewSettings(
                        weekNumberStyle: DateRangePickerWeekNumberStyle(
                          textStyle:
                              AppTheme.getTheme().textTheme.bodyText2!.copyWith(
                                    fontSize: width * 0.033,
                                    color: ConstColor.black_Color,
                                  ),
                        ),
                        firstDayOfWeek: 1,
                        dayFormat: 'E',
                        viewHeaderHeight: height * 0.03,
                        showTrailingAndLeadingDates: true,
                        viewHeaderStyle: DateRangePickerViewHeaderStyle(
                          backgroundColor: Colors.transparent,
                          textStyle: AppTheme.getTheme()
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.white),
                        ),
                        enableSwipeSelection: false,
                      ),
                      todayHighlightColor: primaryColor,
                      selectionColor: primaryColor,
                      selectionTextStyle:
                          AppTheme.getTheme().textTheme.bodyText2!.copyWith(
                                fontSize: width * 0.033,
                                color: ConstColor.black_Color,
                              ),
                      selectionMode: DateRangePickerSelectionMode.single,
                      initialSelectedDate: widget.initialEndDate,
                      enablePastDates: false,
                      allowViewNavigation: false,
                      headerHeight: height * 0.1,
                      showNavigationArrow: true,
                      headerStyle: DateRangePickerHeaderStyle(
                          textStyle:
                              AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                                    fontSize: width * 0.05,
                                    color: ConstColor.primaryColor,
                                  ),
                          textAlign: TextAlign.left),
                      rangeTextStyle: AppTheme.getTheme()
                          .textTheme
                          .bodyText2!
                          .copyWith(color: Colors.black),
                      enableMultiView: false,
                      onSelectionChanged: widget.onEndDateViewChanged,
                      cancelText: "CANCEL",
                      confirmText: "SELECT",
                      onCancel: widget.onEndDateCancel,
                      onSubmit: widget.onEndDateSubmit,
                    )
            ],
          ),
        )
      ],
    );
  }
}
