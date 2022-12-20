import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constant/constants.dart';
import '../../../constant/theme.dart';
import '../../../model/createEvent_model.dart';
import '../../../notifier/event_notifier.dart';
import '../../../preference/preference.dart';
import '../../../utils/colorUtils.dart';
import '../../../utils/textUtils.dart';
import '../event/eventDetails_screen.dart';
import 'package:intl/intl.dart';

class MyPastEvents extends StatefulWidget {
  const MyPastEvents({Key? key}) : super(key: key);

  @override
  State<MyPastEvents> createState() => _MyPastEventsState();
}

class _MyPastEventsState extends State<MyPastEvents> {
  @override
  void initState() {
    getmyPastEvent();
    super.initState();
  }

  String currentuser = "";
  bool isLoading = false;
  List<CreateEventModel> FinalListOfMyPastEvents = [];
  getmyPastEvent() async {
    try {
      FinalListOfMyPastEvents = [];
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      currentuser = await PrefServices().getCurrentUserName();
      var objCreateEventNotifier =
          Provider.of<CreateEventNotifier>(context, listen: false);
      await objCreateEventNotifier.getListOfMyPastEvent(
        context,
      );
      objCreateEventNotifier.getMyPastEventList.forEach((element) {
        FinalListOfMyPastEvents.add(element);
        print(
            "FinalListOfMyPastEvents=====================>$FinalListOfMyPastEvents");
      });
      await objCreateEventNotifier.getListOfMyPastEventswithCoHost(
          context, currentuser);

      objCreateEventNotifier.getListOfPastEventswithCoHostList
          .forEach((element) {
        FinalListOfMyPastEvents.add(element);
        print(
            "FinalListOfMyPastEvents=====================>$FinalListOfMyPastEvents");
      });
    } catch (e) {
      print(e);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final objCreateEventNotifier = context.watch<CreateEventNotifier>();
    return Expanded(
      child: isLoading == true && FinalListOfMyPastEvents.isEmpty
          ? Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            )
          : FinalListOfMyPastEvents.isEmpty
              ? Container(
                  margin:
                      EdgeInsets.only(top: AppBar().preferredSize.height * 2),
                  child: Center(
                      child: Text(
                    TextUtils.noResultFound,
                    style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                          fontSize: width * 0.041,
                          color: ConstColor.white_Color,
                        ),
                  )),
                )
              : ListView.builder(
                  padding: EdgeInsets.only(bottom: height * 0.04),
                  itemCount: FinalListOfMyPastEvents.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                          setState(() {
                            objCreateEventNotifier.setEventData =
                                FinalListOfMyPastEvents[index];
                          });
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  EventDetailsScreen(
                                eventId: FinalListOfMyPastEvents[index].docId!,
                                hostId: FinalListOfMyPastEvents[index]
                                    .lstUser!
                                    .uid!,
                                isPastEvent: false,
                                isFromMyeventScreen: true,
                                ismyPastEvent: true,
                              ),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          ).then((value) async {
                            setState(() {});
                            await getmyPastEvent();
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(height * 0.015),
                            border: Border.all(color: Colors.blueGrey.shade900),
                          ),
                          margin: EdgeInsets.only(
                              top: height * 0.005,
                              bottom: height * 0.005,
                              left: width * 0.03,
                              right: width * 0.03),
                          padding: EdgeInsets.all(height * 0.01),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(height * 0.015),
                                child: CachedNetworkImage(
                                  imageUrl: FinalListOfMyPastEvents[index]
                                      .eventPhoto!,
                                  height: height * 0.13,
                                  width: height * 0.13,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        color: primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: width * 0.03),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        FinalListOfMyPastEvents[index]
                                            .eventname!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTheme.getTheme()
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(
                                              fontSize: width * 0.037,
                                              color: ConstColor.white_Color,
                                            ),
                                      ),

                                      ///-------------- image and  create by --------------

                                      Container(
                                        margin:
                                            EdgeInsets.only(top: height * 0.01),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Hosted by",
                                              style: AppTheme.getTheme()
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(
                                                      fontSize: width * 0.032,
                                                      color: ConstColor
                                                          .white_Color
                                                          .withOpacity(0.37)),
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    left: height * 0.005),
                                                child: Text(
                                                  "${FinalListOfMyPastEvents[index].lstUser!.firstName![0].toUpperCase()}${FinalListOfMyPastEvents[index].lstUser!.firstName!.substring(1).toLowerCase()}" +
                                                      " " +
                                                      "${FinalListOfMyPastEvents[index].lstUser!.lastName![0].toUpperCase()}${FinalListOfMyPastEvents[index].lstUser!.lastName!.substring(1).toLowerCase()}",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: AppTheme.getTheme()
                                                      .textTheme
                                                      .bodyText1!
                                                      .copyWith(
                                                          fontSize:
                                                              width * 0.035,
                                                          color: ConstColor
                                                              .white_Color),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      ///------------------------- event time-----------------
                                      Container(
                                        margin: EdgeInsets.only(
                                          top: width * 0.02,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              ConstantData.watch2,
                                              height: height * 0.015,
                                              color: ConstColor.white_Color,
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    left: width * 0.02),
                                                child: Text(
                                                  '${DateFormat(TextUtils.dateFormat).format(FinalListOfMyPastEvents[index].eventStartDate!)[0].toUpperCase()}${(DateFormat(TextUtils.dateFormat).format(FinalListOfMyPastEvents[index].eventStartDate!).substring(1, 4)).toLowerCase()}${DateFormat(TextUtils.dateFormat).format(FinalListOfMyPastEvents[index].eventStartDate!)[4].toUpperCase()}${(DateFormat(TextUtils.dateFormat).format(FinalListOfMyPastEvents[index].eventStartDate!).substring(5)).toLowerCase()}' +
                                                      DateFormat(' - h:mm aa')
                                                          .format(
                                                              FinalListOfMyPastEvents[
                                                                      index]
                                                                  .eventEndDate!)
                                                          .toLowerCase(),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: AppTheme.getTheme()
                                                      .textTheme
                                                      .bodyText1!
                                                      .copyWith(
                                                          decoration:
                                                              TextDecoration
                                                                  .none,
                                                          color: ConstColor
                                                              .white_Color,
                                                          fontSize:
                                                              width * 0.032),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      ///------------------------- event location--------------------

                                      Container(
                                        margin:
                                            EdgeInsets.only(top: height * 0.01),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              ConstantData.location2,
                                              height: height * 0.02,
                                              color: ConstColor.white_Color,
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    left: width * 0.02),
                                                child: Text(
                                                  FinalListOfMyPastEvents[index]
                                                      .location!,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: AppTheme.getTheme()
                                                      .textTheme
                                                      .bodyText1!
                                                      .copyWith(
                                                          height: 1.2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          decoration:
                                                              TextDecoration
                                                                  .none,
                                                          color: ConstColor
                                                              .white_Color,
                                                          fontSize:
                                                              width * 0.036),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ));
                  },
                ),
    );
  }
}
