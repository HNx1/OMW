import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constant/constants.dart';
import '../../../constant/theme.dart';
import '../../../notifier/changenotifier.dart';
import '../../../notifier/event_notifier.dart';
import '../../../utils/colorUtils.dart';
import '../../../utils/textUtils.dart';

class UpComingFilterDialog extends StatefulWidget {
  const UpComingFilterDialog({Key? key}) : super(key: key);

  @override
  State<UpComingFilterDialog> createState() => _UpComingFilterDialogState();
}

class _UpComingFilterDialogState extends State<UpComingFilterDialog> {
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
            color: const Color.fromARGB(255, 15, 15, 15),
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
                color: const Color.fromARGB(255, 182, 172, 172).withOpacity(0.2),
              ),

              ///--------------- List Of filter----------
              Wrap(
                  alignment: WrapAlignment.start,
                  children: List.generate(
                      objProviderNotifier.lstOfUpcomingFilters.length, (index) {
                    return GestureDetector(
                      onTap: () async {
                        setState(() {
                          objProviderNotifier.lstOfUpcomingFilters[index]
                                  ["isSelect"] =
                              !objProviderNotifier.lstOfUpcomingFilters[index]
                                  ["isSelect"];
                        });
                        if (objProviderNotifier.lstOfUpcomingFilters[index]
                                ["name"] ==
                            TextUtils.removeFilter) {
                          objCreateEventNotifier.getUpcomingFilterList = [];

                          objProviderNotifier.lstOfUpcomingFilters[0]
                              ["isSelect"] = false;
                          objProviderNotifier.lstOfUpcomingFilters[1]
                              ["isSelect"] = false;
                          objProviderNotifier.lstOfUpcomingFilters[2]
                              ["isSelect"] = false;
                          objProviderNotifier.lstOfUpcomingFilters[3]
                              ["isSelect"] = false;

                          objCreateEventNotifier
                              .getUpcommingYesandMaybeandNotGoing(
                                  objCreateEventNotifier);
                          setState(() {
                            objCreateEventNotifier.isUpcommingFilteredData =
                                false;
                          });
                          objCreateEventNotifier.getUpcomingFilterList = [];

                          print(objCreateEventNotifier.getUpcomingFilterList);
                          Navigator.pop(context);
                        } else if (objProviderNotifier.lstOfUpcomingFilters[0]
                                    ["isSelect"] ==
                                false &&
                            objProviderNotifier.lstOfUpcomingFilters[1]
                                    ["isSelect"] ==
                                false &&
                            objProviderNotifier.lstOfUpcomingFilters[2]
                                    ["isSelect"] ==
                                false) {
                          objCreateEventNotifier.getUpcomingFilterList = [];

                          objCreateEventNotifier
                              .getUpcommingYesandMaybeandNotGoing(
                                  objCreateEventNotifier);
                          objCreateEventNotifier.getUpcomingFilterList.addAll(
                              objCreateEventNotifier.goingandmaybeandNotGoing);

                          print(objCreateEventNotifier.getUpcomingFilterList);
                        } else if (objProviderNotifier.lstOfUpcomingFilters[0]
                                    ["isSelect"] ==
                                true &&
                            objProviderNotifier.lstOfUpcomingFilters[1]
                                    ["isSelect"] ==
                                true &&
                            objProviderNotifier.lstOfUpcomingFilters[2]
                                    ["isSelect"] ==
                                true) {
                          objCreateEventNotifier.getUpcomingFilterList = [];

                          objCreateEventNotifier
                              .getUpcommingYesandMaybeandNotGoing(
                                  objCreateEventNotifier);
                          objCreateEventNotifier.getUpcomingFilterList.addAll(
                              objCreateEventNotifier.goingandmaybeandNotGoing);

                          print(objCreateEventNotifier.getUpcomingFilterList);
                        } else if (objProviderNotifier.lstOfUpcomingFilters[0]
                                    ["isSelect"] ==
                                true &&
                            objProviderNotifier.lstOfUpcomingFilters[1]
                                    ["isSelect"] ==
                                true &&
                            objProviderNotifier.lstOfUpcomingFilters[2]
                                    ["isSelect"] ==
                                false) {
                          objCreateEventNotifier.getUpcomingFilterList = [];

                          objCreateEventNotifier.getUpcommingYesandNotGoing(
                              objCreateEventNotifier);

                          objCreateEventNotifier.getUpcomingFilterList
                              .addAll(objCreateEventNotifier.goingandNotGoing);

                          print(objCreateEventNotifier.getUpcomingFilterList);
                        } else if (objProviderNotifier.lstOfUpcomingFilters[1]
                                    ["isSelect"] ==
                                true &&
                            objProviderNotifier.lstOfUpcomingFilters[2]
                                    ["isSelect"] ==
                                true &&
                            objProviderNotifier.lstOfUpcomingFilters[0]
                                    ["isSelect"] ==
                                false) {
                          objCreateEventNotifier.getUpcomingFilterList = [];
                          objCreateEventNotifier.getUpcommingmaybeandNotGoing(
                              objCreateEventNotifier);
                          objCreateEventNotifier.getUpcomingFilterList
                              .addAll(objCreateEventNotifier.maybeandNotGoing);

                          print(objCreateEventNotifier.getUpcomingFilterList);
                        } else if (objProviderNotifier.lstOfUpcomingFilters[0]
                                    ["isSelect"] ==
                                true &&
                            objProviderNotifier.lstOfUpcomingFilters[2]
                                    ["isSelect"] ==
                                true &&
                            objProviderNotifier.lstOfUpcomingFilters[1]
                                    ["isSelect"] ==
                                false) {
                          objCreateEventNotifier.getUpcomingFilterList = [];

                          objCreateEventNotifier.getUpcommingYesandMaybeGuest(
                              objCreateEventNotifier);
                          objCreateEventNotifier.getUpcomingFilterList.addAll(
                              objCreateEventNotifier.goingandMaybeGuest);

                          print(objCreateEventNotifier.getUpcomingFilterList);
                        } else if (objProviderNotifier.lstOfUpcomingFilters[0]
                                    ["isSelect"] ==
                                true &&
                            objProviderNotifier.lstOfUpcomingFilters[1]
                                    ["isSelect"] ==
                                false &&
                            objProviderNotifier.lstOfUpcomingFilters[2]
                                    ["isSelect"] ==
                                false) {
                          objCreateEventNotifier.getUpcomingFilterList = [];

                          objCreateEventNotifier
                              .getUpcommingYesData(objCreateEventNotifier);
                          objCreateEventNotifier.getUpcomingFilterList
                              .addAll(objCreateEventNotifier.goingGuest);

                          print(objCreateEventNotifier.getUpcomingFilterList);
                        } else if (objProviderNotifier.lstOfUpcomingFilters[1]
                                    ["isSelect"] ==
                                true &&
                            objProviderNotifier.lstOfUpcomingFilters[0]
                                    ["isSelect"] ==
                                false &&
                            objProviderNotifier.lstOfUpcomingFilters[2]
                                    ["isSelect"] ==
                                false) {
                          objCreateEventNotifier.getUpcomingFilterList = [];

                          objCreateEventNotifier
                              .getUpcommingNoData(objCreateEventNotifier);
                          objCreateEventNotifier.getUpcomingFilterList
                              .addAll(objCreateEventNotifier.notGoingGuest);

                          print(objCreateEventNotifier.getUpcomingFilterList);
                        } else if (objProviderNotifier.lstOfUpcomingFilters[2]
                                    ["isSelect"] ==
                                true &&
                            objProviderNotifier.lstOfUpcomingFilters[1]
                                    ["isSelect"] ==
                                false &&
                            objProviderNotifier.lstOfUpcomingFilters[0]
                                    ["isSelect"] ==
                                false) {
                          objCreateEventNotifier.getUpcomingFilterList = [];

                          objCreateEventNotifier
                              .getUpcommingMaybeData(objCreateEventNotifier);
                          objCreateEventNotifier.getUpcomingFilterList
                              .addAll(objCreateEventNotifier.maybeGuest);

                          print(objCreateEventNotifier.getUpcomingFilterList);
                        } else {
                          setState(() {
                            objCreateEventNotifier.isUpcommingFilteredData =
                                false;
                          });

                          objProviderNotifier.lstOfUpcomingFilters[0]
                              ["isSelect"] = false;
                          objProviderNotifier.lstOfUpcomingFilters[1]
                              ["isSelect"] = false;
                          objProviderNotifier.lstOfUpcomingFilters[2]
                              ["isSelect"] = false;
                          objProviderNotifier.lstOfUpcomingFilters[3]
                              ["isSelect"] = false;
                          objCreateEventNotifier.getUpcomingFilterList = [];
                          print(objCreateEventNotifier.getUpcomingFilterList);
                          objCreateEventNotifier
                              .getUpcommingYesandMaybeandNotGoing(
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
                              color: objProviderNotifier
                                              .lstOfUpcomingFilters[index]
                                          ["isSelect"] ==
                                      true
                                  ? primaryColor
                                  : Colors.transparent),
                          color: const Color(0xff515151).withOpacity(0.07),
                        ),
                        child: Text(
                          objProviderNotifier.lstOfUpcomingFilters[index]
                              ["name"],
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
