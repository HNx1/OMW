import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:omw/constant/constants.dart';
import 'package:omw/model/createEvent_model.dart';
import 'package:omw/utils/textUtils.dart';
import 'package:provider/provider.dart';

import '../../../api/apiProvider.dart';
import '../../../constant/theme.dart';
import '../../../notifier/event_notifier.dart';
import '../../../preference/preference.dart';
import '../../../utils/colorUtils.dart';
import 'eventDetails_screen.dart';

class SearchEvent extends StatefulWidget {
  const SearchEvent({Key? key}) : super(key: key);

  @override
  State<SearchEvent> createState() => _SearchEventState();
}

class _SearchEventState extends State<SearchEvent> {
  @override
  void initState() {
    isloading();
    getListOfEvents();
    super.initState();
  }

  isloading() {
    var objCreateEventNotifier =
        Provider.of<CreateEventNotifier>(context, listen: false);
    setState(() {
      lastDocumentOfSearchEvent = null;
    });
    objCreateEventNotifier.lstofAllEvents = [];
  }

  String currentuser = "";
  final TextEditingController _searchEvent = TextEditingController();

  List<CreateEventModel> searchList = [];

  getListOfEvents() async {
    currentuser = PrefServices().getCurrentUserName();
    var objCreateEventNotifier =
        Provider.of<CreateEventNotifier>(context, listen: false);
    if (mounted) {
      setState(() {
        objCreateEventNotifier.isLoading = true;
      });
    }
    await objCreateEventNotifier.getAllEvent(
      context,
    );
    setState(() {
      searchList = objCreateEventNotifier.lstofAllEvents;
    });
    if (mounted) {
      setState(() {
        objCreateEventNotifier.isLoading = false;
      });
    }
  }

  bool _IsSearching = false;
  String _searchText = "";
  _SearchEventState() {
    _searchEvent.addListener(() {
      if (_searchEvent.text.isEmpty) {
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
            _searchText = _searchEvent.text;
            _buildSearchList();
          },
        );
      }
    });
  }

  _buildSearchList() {
    var objCreateEventNotifier =
        Provider.of<CreateEventNotifier>(context, listen: false);
    if (_searchText.isEmpty) {
      return searchList = objCreateEventNotifier.lstofAllEvents;
    } else {
      searchList = objCreateEventNotifier.lstofAllEvents
          .where(
            (element) => element.eventname!.toLowerCase().contains(
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
    final objCreateEventNotifier = context.watch<CreateEventNotifier>();
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: height * 0.1,
          elevation: 0,
          backgroundColor: AppTheme.getTheme().backgroundColor,

          ///------------------- back Arrow ------------------------

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
          leadingWidth: height * 0.055,

          ///------------------------ OMW title-------------------------
          title: Container(
            child: TextFormField(
              autovalidateMode: AutovalidateMode.disabled,
              style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                    fontSize: width * 0.041,
                    color: ConstColor.white_Color,
                  ),
              controller: _searchEvent,
              decoration: InputDecoration(
                prefixIcon: Container(
                  margin: EdgeInsets.only(
                      left: height * 0.02,
                      right: height * 0.02,
                      bottom: height * 0.002),
                  child: Image.asset(
                    ConstantData.search,
                    width: height * 0.025,
                    height: height * 0.025,
                    fit: BoxFit.contain,
                  ),
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _searchEvent.clear();
                    });
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      left: height * 0.02,
                      right: height * 0.02,
                    ),
                    child: Image.asset(
                      ConstantData.close,
                      width: height * 0.03,
                      height: height * 0.03,
                      color: Colors.white,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                border: InputBorder.none,
                errorStyle: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                      fontSize: width * 0.036,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(height * 0.1),
                  borderSide: const BorderSide(
                    color: ConstColor.textFormFieldColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(height * 0.1),
                  borderSide: const BorderSide(
                    color: ConstColor.textFormFieldColor,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(height * 0.1),
                  borderSide: const BorderSide(
                    color: ConstColor.textFormFieldColor,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(height * 0.1),
                  borderSide: const BorderSide(
                    color: ConstColor.textFormFieldColor,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(height * 0.1),
                  borderSide: const BorderSide(
                    color: ConstColor.textFormFieldColor,
                  ),
                ),
                isDense: true,
                hintText: TextUtils.Searchevents,
                hintStyle: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                      fontSize: width * 0.041,
                      color: ConstColor.white_Color,
                    ),
              ),
            ),
          ),
        ),
        body: objCreateEventNotifier.isLoading == true && searchList.isEmpty
            ? const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              )
            : searchList.isEmpty
                ? Container(
                    margin:
                        EdgeInsets.only(top: AppBar().preferredSize.height * 2),
                    child: Center(
                        child: Text(
                      "No Events Found",
                      style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                            fontSize: width * 0.041,
                            color: ConstColor.white_Color,
                          ),
                    )),
                  )
                : Consumer<CreateEventNotifier>(
                    builder: (BuildContext context, value, Widget? child) {
                      return NotificationListener<ScrollEndNotification>(
                        onNotification: (scrollEnd) {
                          if (scrollEnd.metrics.atEdge &&
                              scrollEnd.metrics.pixels > 0) {
                            print("scrollEnd");
                            getListOfEvents();
                          }
                          return true;
                        },
                        child: Stack(
                          children: [
                            objCreateEventNotifier.isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: primaryColor,
                                    ),
                                  )
                                : Container(),
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: searchList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      objCreateEventNotifier.setEventData =
                                          searchList[index];
                                    });
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (context, animation1, animation2) =>
                                                EventDetailsScreen(
                                          eventId: searchList[index].docId!,
                                          hostId:
                                              searchList[index].lstUser!.uid!,
                                          isPastEvent: searchList[index]
                                                      .eventEndDate!
                                                      .millisecondsSinceEpoch >
                                                  DateTime.now()
                                                      .toUtc()
                                                      .millisecondsSinceEpoch
                                              ? false
                                              : true,
                                          isFromMyeventScreen: false,
                                          ismyPastEvent: false,
                                        ),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration:
                                            Duration.zero,
                                      ),
                                    ).whenComplete(() async {
                                      setState(() {});
                                      await objCreateEventNotifier
                                          .getAllEvent(context);
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        color: Colors.transparent,
                                        margin: EdgeInsets.only(
                                            top: height * 0.017,
                                            bottom: height * 0.017,
                                            left: width * 0.03,
                                            right: width * 0.03),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      height * 0.1),
                                              child: CachedNetworkImage(
                                                imageUrl: searchList[index]
                                                    .eventPhoto!,
                                                height: height * 0.06,
                                                width: height * 0.06,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator(
                                                  color: primaryColor,
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    left: width * 0.05),
                                                child: Text(
                                                  searchList[index].eventname!,
                                                  style: AppTheme.getTheme()
                                                      .textTheme
                                                      .bodyText2!
                                                      .copyWith(
                                                        color: ConstColor
                                                            .white_Color,
                                                        fontSize: width * 0.042,
                                                      ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      searchList.last == searchList[index]
                                          ? Container()
                                          : Container(
                                              margin: EdgeInsets.only(
                                                  top: height * 0.01,
                                                  bottom: height * 0.01),
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
                          ],
                        ),
                      );
                    },
                  ));
  }
}
