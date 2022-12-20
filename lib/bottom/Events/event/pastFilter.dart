import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constant/constants.dart';
import '../../../constant/theme.dart';
import '../../../notifier/changenotifier.dart';
import '../../../notifier/event_notifier.dart';
import '../../../utils/colorUtils.dart';
import '../../../utils/textUtils.dart';

class PastFilterDialog extends StatefulWidget {
  const PastFilterDialog({Key? key}) : super(key: key);

  @override
  State<PastFilterDialog> createState() => _PastFilterDialogState();
}

class _PastFilterDialogState extends State<PastFilterDialog> {
  @override
  Widget build(BuildContext context) {
    final objProviderNotifier = context.watch<ProviderNotifier>();
    final objCreateEventNotifier = context.watch<CreateEventNotifier>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(left: width * 0.04, right: width * 0.04),
          padding: EdgeInsets.only(
              top: height * 0.023,
              left: width * 0.036,
              right: width * 0.036,
              bottom: height * 0.026),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height * 0.016),
            color: Color.fromARGB(255, 15, 15, 15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      ///------------------- image of Contact --------------------
                      Image.asset(
                        ConstantData.filter2,
                        height: height * 0.054,
                        width: height * 0.054,
                        fit: BoxFit.fill,
                        color: Colors.white,
                      ),

                      ///------------------- Add new Contact Text--------------------
                      Container(
                        margin: EdgeInsets.only(left: width * 0.03),
                        child: Text(
                          TextUtils.filterByResponse,
                          style: AppTheme.getTheme()
                              .textTheme
                              .bodyText2!
                              .copyWith(
                                  color: Colors.white,
                                  height: 1.4,
                                  fontSize: width * 0.052),
                        ),
                      )
                    ],
                  ),

                  ///------------------- Close Icon--------------------
                  GestureDetector(
                    onTap: () {
                      setState(() {});
                      Navigator.pop(
                        context,
                      );
                    },
                    child: Image.asset(
                      ConstantData.close,
                      height: height * 0.032,
                      width: height * 0.032,
                      fit: BoxFit.fill,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              ///------------------- Divider --------------------
              Container(
                margin: EdgeInsets.only(
                  top: height * 0.022,
                ),
                height: 1,
                width: width,
                color: Color.fromARGB(255, 182, 172, 172).withOpacity(0.2),
              ),

              ///--------------- List Of filter----------
              Wrap(
                  alignment: WrapAlignment.start,
                  children: List.generate(
                      objProviderNotifier.lstOfPastFilters.length, (index) {
                    return GestureDetector(
                      onTap: () async {
                        setState(() {
                          objProviderNotifier.lstOfPastFilters[index]
                                  ["isSelect"] =
                              !objProviderNotifier.lstOfPastFilters[index]
                                  ["isSelect"];
                        });
                        if (objProviderNotifier.lstOfPastFilters[index]
                                ["name"] ==
                            TextUtils.removeFilter) {
                          objCreateEventNotifier.getPastFilterList = [];

                          objProviderNotifier.lstOfPastFilters[0]["isSelect"] =
                              false;
                          objProviderNotifier.lstOfPastFilters[1]["isSelect"] =
                              false;
                          objProviderNotifier.lstOfPastFilters[2]["isSelect"] =
                              false;
                          objProviderNotifier.lstOfPastFilters[3]["isSelect"] =
                              false;

                          objCreateEventNotifier.getPastYesandMaybeandNotGoing(
                              objCreateEventNotifier);
                          setState(() {
                            objCreateEventNotifier.isPastFilteredData = false;
                          });
                          objCreateEventNotifier.getPastFilterList = [];

                          print(objCreateEventNotifier.getPastFilterList);
                          Navigator.pop(context);
                        } else if (objProviderNotifier.lstOfPastFilters[0]
                                    ["isSelect"] ==
                                false &&
                            objProviderNotifier.lstOfPastFilters[1]
                                    ["isSelect"] ==
                                false &&
                            objProviderNotifier.lstOfPastFilters[2]
                                    ["isSelect"] ==
                                false) {
                          objCreateEventNotifier.getPastFilterList = [];

                          objCreateEventNotifier.getPastYesandMaybeandNotGoing(
                              objCreateEventNotifier);
                          objCreateEventNotifier.getPastFilterList.addAll(
                              objCreateEventNotifier.goingandmaybeandNotGoing);

                          print(objCreateEventNotifier.getPastFilterList);
                        } else if (objProviderNotifier.lstOfPastFilters[0]
                                    ["isSelect"] ==
                                true &&
                            objProviderNotifier.lstOfPastFilters[1]
                                    ["isSelect"] ==
                                true &&
                            objProviderNotifier.lstOfPastFilters[2]
                                    ["isSelect"] ==
                                true) {
                          objCreateEventNotifier.getPastFilterList = [];

                          objCreateEventNotifier.getPastYesandMaybeandNotGoing(
                              objCreateEventNotifier);
                          objCreateEventNotifier.getPastFilterList.addAll(
                              objCreateEventNotifier.goingandmaybeandNotGoing);

                          print(objCreateEventNotifier.getPastFilterList);
                        } else if (objProviderNotifier.lstOfPastFilters[0]
                                    ["isSelect"] ==
                                true &&
                            objProviderNotifier.lstOfPastFilters[1]
                                    ["isSelect"] ==
                                true &&
                            objProviderNotifier.lstOfPastFilters[2]
                                    ["isSelect"] ==
                                false) {
                          objCreateEventNotifier.getPastFilterList = [];

                          objCreateEventNotifier
                              .getPastYesandNotGoing(objCreateEventNotifier);

                          objCreateEventNotifier.getPastFilterList
                              .addAll(objCreateEventNotifier.goingandNotGoing);

                          print(objCreateEventNotifier.getPastFilterList);
                        } else if (objProviderNotifier.lstOfPastFilters[1]
                                    ["isSelect"] ==
                                true &&
                            objProviderNotifier.lstOfPastFilters[2]
                                    ["isSelect"] ==
                                true &&
                            objProviderNotifier.lstOfPastFilters[0]
                                    ["isSelect"] ==
                                false) {
                          objCreateEventNotifier.getPastFilterList = [];
                          objCreateEventNotifier
                              .getPastmaybeandNotGoing(objCreateEventNotifier);
                          objCreateEventNotifier.getPastFilterList
                              .addAll(objCreateEventNotifier.maybeandNotGoing);

                          print(objCreateEventNotifier.getPastFilterList);
                        } else if (objProviderNotifier.lstOfPastFilters[0]
                                    ["isSelect"] ==
                                true &&
                            objProviderNotifier.lstOfPastFilters[2]
                                    ["isSelect"] ==
                                true &&
                            objProviderNotifier.lstOfPastFilters[1]
                                    ["isSelect"] ==
                                false) {
                          objCreateEventNotifier.getPastFilterList = [];

                          objCreateEventNotifier
                              .getPastYesandMaybeGuest(objCreateEventNotifier);
                          objCreateEventNotifier.getPastFilterList.addAll(
                              objCreateEventNotifier.goingandMaybeGuest);

                          print(objCreateEventNotifier.getPastFilterList);
                        } else if (objProviderNotifier.lstOfPastFilters[0]
                                    ["isSelect"] ==
                                true &&
                            objProviderNotifier.lstOfPastFilters[1]
                                    ["isSelect"] ==
                                false &&
                            objProviderNotifier.lstOfPastFilters[2]
                                    ["isSelect"] ==
                                false) {
                          objCreateEventNotifier.getPastFilterList = [];

                          objCreateEventNotifier
                              .getPastYesData(objCreateEventNotifier);
                          objCreateEventNotifier.getPastFilterList
                              .addAll(objCreateEventNotifier.goingGuest);

                          print(objCreateEventNotifier.getPastFilterList);
                        } else if (objProviderNotifier.lstOfPastFilters[1]
                                    ["isSelect"] ==
                                true &&
                            objProviderNotifier.lstOfPastFilters[0]
                                    ["isSelect"] ==
                                false &&
                            objProviderNotifier.lstOfPastFilters[2]
                                    ["isSelect"] ==
                                false) {
                          objCreateEventNotifier.getPastFilterList = [];

                          objCreateEventNotifier
                              .getPastNoData(objCreateEventNotifier);
                          objCreateEventNotifier.getPastFilterList
                              .addAll(objCreateEventNotifier.notGoingGuest);

                          print(objCreateEventNotifier.getPastFilterList);
                        } else if (objProviderNotifier.lstOfPastFilters[2]
                                    ["isSelect"] ==
                                true &&
                            objProviderNotifier.lstOfPastFilters[1]
                                    ["isSelect"] ==
                                false &&
                            objProviderNotifier.lstOfPastFilters[0]
                                    ["isSelect"] ==
                                false) {
                          objCreateEventNotifier.getPastFilterList = [];

                          objCreateEventNotifier
                              .getPastMaybeData(objCreateEventNotifier);
                          objCreateEventNotifier.getPastFilterList
                              .addAll(objCreateEventNotifier.maybeGuest);

                          print(objCreateEventNotifier.getPastFilterList);
                        } else {
                          setState(() {
                            objCreateEventNotifier.isUpcommingFilteredData =
                                false;
                          });

                          objProviderNotifier.lstOfPastFilters[0]["isSelect"] =
                              false;
                          objProviderNotifier.lstOfPastFilters[1]["isSelect"] =
                              false;
                          objProviderNotifier.lstOfPastFilters[2]["isSelect"] =
                              false;
                          objProviderNotifier.lstOfPastFilters[3]["isSelect"] =
                              false;
                          objCreateEventNotifier.getPastFilterList = [];
                          print(objCreateEventNotifier.getPastFilterList);
                          objCreateEventNotifier.getPastYesandMaybeandNotGoing(
                              objCreateEventNotifier);
                        }
                       
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            left: width * 0.015,
                            top: height * 0.022,
                            right: width * 0.015),
                        padding: EdgeInsets.all(height * 0.015),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(height * 0.02),
                          border: Border.all(
                              color: objProviderNotifier.lstOfPastFilters[index]
                                          ["isSelect"] ==
                                      true
                                  ? primaryColor
                                  : Colors.transparent),
                          color: Color(0xff515151).withOpacity(0.07),
                        ),
                        child: Text(
                          objProviderNotifier.lstOfPastFilters[index]["name"],
                          style:
                              AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                                    color: ConstColor.white_Color,
                                    height: 1.4,
                                    fontSize: width * 0.046,
                                  ),
                        ),
                      ),
                    );
                  }))
            ],
          ),
        ),
      ],
    );
  }
}
