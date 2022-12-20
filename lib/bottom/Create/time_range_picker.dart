import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:omw/constant/constants.dart';
import 'package:omw/utils/colorUtils.dart';

import '../../utils/textUtils.dart';

bool isEndTime = false;
// bool isToggleDisable = true;

class TimeRangePicker extends StatefulWidget {
  final String selectToTime, selectFromTime;
  final DateTime currentTime, currentTime2;

  final Function()? onToCancelTap;
  final Function()? onFromCancelTap;
  final Function()? onToOkTap;
  final Function()? onFromOKTap;
  final Function(DateTime)? onEndDateTimeChanged;
  final Function(DateTime)? onStartDateTimeChanged;
  final bool isToggleDisable;

  TimeRangePicker({
    Key? key,
    required this.selectToTime,
    required this.selectFromTime,
    required this.currentTime,
    required this.currentTime2,
    this.onToCancelTap,
    this.onFromCancelTap,
    this.onToOkTap,
    this.onFromOKTap,
    this.onStartDateTimeChanged,
    this.onEndDateTimeChanged,
    required this.isToggleDisable,
  }) : super(key: key);

  @override
  State<TimeRangePicker> createState() => _TimeRangePickerState();
}

class _TimeRangePickerState extends State<TimeRangePicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: height * 0.45,
          margin: EdgeInsets.only(
              left: width * 0.03,
              right: width * 0.03,
              top: AppBar().preferredSize.height / 1.4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: ConstColor.textFormFieldColor,
            ),
            color: Color.fromARGB(255, 15, 15, 15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        left: width * 0.05,
                        right: width * 0.05,
                        top: height * 0.02,
                        bottom: height * 0.01),
                    child: Text(
                      TextUtils.time,
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontSize: width * 0.05,
                            color: primaryColor,
                          ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: width * 0.05,
                        right: width * 0.05,
                        top: height * 0.02,
                        bottom: height * 0.01),
                    padding: EdgeInsets.all(height * 0.006),
                    child: Row(
                      children: [
                        FlutterSwitch(
                          disabled: widget.isToggleDisable ? true : false,
                          activeColor: ConstColor.primaryColor,
                          width: width * 0.1,
                          height: height * 0.028,
                          toggleSize: width * 0.036,
                          value: isEndTime,
                          borderRadius: 30.0,
                          padding: 4.0,
                          activeToggleColor: ConstColor.black_Color,
                          onToggle: (val) {
                            setState(() {
                              isEndTime = val;
                            });
                          },
                        ),
                        Container(
                          margin: EdgeInsets.only(left: width * 0.02),
                          child: Text(
                            "End Time",
                            style:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
                                      fontSize: width * 0.05,
                                      color: widget.isToggleDisable
                                          ? ConstColor.Text_grey_color
                                          : primaryColor,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(right: width * 0.1, top: height * 0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isEndTime == false
                        ? Column(
                            children: [
                              Text(
                                "Start Time",
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
                          )
                        : Column(
                            children: [
                              Text(
                                "End Time",
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
              ),
              isEndTime == false
                  ? Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: CupertinoTheme(
                              data: CupertinoThemeData(
                                brightness: Brightness.dark,
                              ),
                              child: CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.time,
                                backgroundColor: Colors.transparent,
                                initialDateTime: widget.selectFromTime == ""
                                    ? DateTime.now()
                                    : widget.currentTime,
                                onDateTimeChanged:
                                    widget.onStartDateTimeChanged!,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: width * 0.05,
                                right: width * 0.05,
                                bottom: height * 0.02),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: widget.onFromCancelTap,
                                  child: Text(
                                    "CANCEL",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                          fontSize: width * 0.038,
                                          color: primaryColor,
                                        ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: widget.onFromOKTap,
                                  child: Container(
                                    margin: EdgeInsets.only(left: width * 0.06),
                                    child: Text(
                                      "SELECT",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(
                                            fontSize: width * 0.038,
                                            color: primaryColor,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: CupertinoTheme(
                              data: CupertinoThemeData(
                                brightness: Brightness.dark,
                              ),
                              child: CupertinoDatePicker(
                                  mode: CupertinoDatePickerMode.time,
                                  backgroundColor: Colors.transparent,
                                  initialDateTime: widget.currentTime2 == ""
                                      ? DateTime.now()
                                      : widget.currentTime2,
                                  onDateTimeChanged:
                                      widget.onEndDateTimeChanged!),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: width * 0.05,
                                right: width * 0.05,
                                bottom: height * 0.02),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: widget.onToCancelTap,
                                  child: Text(
                                    "CANCEL",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                          fontSize: width * 0.038,
                                          color: primaryColor,
                                        ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: widget.onToOkTap,
                                  child: Container(
                                    margin: EdgeInsets.only(left: width * 0.06),
                                    child: Text(
                                      "SELECT",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(
                                            fontSize: width * 0.038,
                                            color: primaryColor,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
            ],
          ),
        ),
      ],
    );
  }
}
