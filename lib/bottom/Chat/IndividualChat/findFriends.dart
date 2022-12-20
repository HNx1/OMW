import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:omw/notifier/AllChatingFunctions.dart';
import 'package:provider/provider.dart';

import 'package:omw/constant/constants.dart';
import 'package:omw/utils/colorUtils.dart';

import '../../../api/apiProvider.dart';
import '../../../constant/theme.dart';
import '../../../notifier/group_notifier.dart';
import '../../../utils/textUtils.dart';
import 'individual_chat_Room.dart';

class FindFriendPage extends StatefulWidget {
  final List<AllChat> chats;

  const FindFriendPage(this.chats, {Key? key}) : super(key: key);

  @override
  State<FindFriendPage> createState() => _FindFriendPageState();
}

class _FindFriendPageState extends State<FindFriendPage> {
  TextEditingController _searchController = TextEditingController();
  bool isLoading = true;
  @override
  void initState() {
    isloading();
    getAllContactList();
    super.initState();
  }

  isloading() {
    setState(() {
      lastDocument = null;
    });
  }

  getAllContactList() async {
    var objGroupNotifier = Provider.of<GroupNotifier>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    await objGroupNotifier.getData(context, "");
    objGroupNotifier.searchList = objGroupNotifier.selectedUserList;
    setState(() {
      isLoading = false;
    });
  }

  bool _IsSearching = false;
  String _searchText = "";

  _FindFriendPageState() {
    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
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
            _searchText = _searchController.text;
            _buildSearchList();
          },
        );
      }
    });
  }

  _buildSearchList() {
    var objGroupNotifier = Provider.of<GroupNotifier>(context, listen: false);
    if (_searchText.isEmpty) {
      return objGroupNotifier.searchList = objGroupNotifier.selectedUserList;
    } else {
      objGroupNotifier.searchList = objGroupNotifier.selectedUserList
          .where(
            (element) => element.firstName!.toLowerCase().contains(
                  _searchText.toLowerCase(),
                ),
          )
          .toList();
      print('${objGroupNotifier.searchList.length}');
      return objGroupNotifier.searchList;
    }
  }

  @override
  Widget build(BuildContext context) {
    final objGroupNotifier = context.watch<GroupNotifier>();
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: AppTheme.getTheme().scaffoldBackgroundColor,
        leadingWidth: height * 0.055,
        title:
            //--------------------omw ------------------------------

            Text(
          "Find Friends",
          style: AppTheme.getTheme().textTheme.subtitle1!.copyWith(
                color: ConstColor.white_Color,
                fontWeight: FontWeight.w700,
                fontSize: width * 0.045,
              ),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(left: width * 0.03, right: width * 0.03),
        child: Column(
          children: [
            ///-------------- Search Field---------------
            Container(
              margin: EdgeInsets.only(
                top: height * 0.014,
                bottom: height * 0.026,
              ),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.disabled,
                style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                      fontSize: width * 0.038,
                      color: ConstColor.white_Color,
                    ),
                controller: _searchController,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  errorStyle: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                        fontSize: width * 0.036,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(height * 0.1),
                    borderSide: BorderSide(
                      color: ConstColor.textFormFieldColor,
                    ),
                  ),
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
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(height * 0.1),
                    borderSide: BorderSide(
                      color: ConstColor.textFormFieldColor,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(height * 0.1),
                    borderSide: BorderSide(
                      color: ConstColor.textFormFieldColor,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(height * 0.1),
                    borderSide: BorderSide(
                      color: ConstColor.textFormFieldColor,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(height * 0.1),
                    borderSide: BorderSide(
                      color: ConstColor.textFormFieldColor,
                    ),
                  ),
                  hintText: TextUtils.Nameorphone,
                  hintStyle: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                        fontSize: width * 0.045,
                        color: Color(0xff6C6C6C),
                      ),
                ),
              ),
            ),

            Expanded(
                child: isLoading == true && objGroupNotifier.searchList.isEmpty
                    ? Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : objGroupNotifier.searchList.isEmpty
                        ? Container(
                            margin: EdgeInsets.only(
                                top: AppBar().preferredSize.height * 2),
                            child: Center(
                                child: Text(
                              "No Result found",
                              style: AppTheme.getTheme()
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                      color: ConstColor.white_Color,
                                      height: 1.4,
                                      fontSize: width * 0.043),
                            )),
                          )

                        ///------------------ List OF Contact Data-------------------
                        : Consumer<GroupNotifier>(
                            builder:
                                (BuildContext context, value, Widget? child) {
                              return NotificationListener<
                                  ScrollEndNotification>(
                                onNotification: (scrollEnd) {
                                  if (scrollEnd.metrics.atEdge &&
                                      scrollEnd.metrics.pixels > 0) {
                                    print("scrollEnd");
                                    getAllContactList();
                                  }
                                  return true;
                                },
                                child: Stack(
                                  children: [
                                    objGroupNotifier.isLoading
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              color: primaryColor,
                                            ),
                                          )
                                        : Container(),
                                    ListView.builder(
                                      padding: EdgeInsets.only(
                                        bottom: height * 0.02,
                                      ),
                                      itemCount:
                                          objGroupNotifier.searchList.length,
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            AllChat? chat = widget.chats
                                                .firstWhereOrNull((e) =>
                                                    e.friendId ==
                                                    objGroupNotifier
                                                        .searchList[index].uid);
                                            if (chat != null) {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          IndividualChatRoom(
                                                            chat: chat!,
                                                          )));
                                            } else {
                                              chat = AllChat(
                                              
                                                objGroupNotifier
                                                    .searchList[index].uid!,
                                                friendFCMToken: objGroupNotifier
                                                    .searchList[index].fcmToken,
                                                UserProfile: objGroupNotifier
                                                    .searchList[index]
                                                    .userProfile,
                                                friendUsername: objGroupNotifier
                                                        .searchList[index]
                                                        .firstName! +
                                                    " " +
                                                    objGroupNotifier
                                                        .searchList[index]
                                                        .lastName!,
                                                userPhone: objGroupNotifier
                                                    .searchList[index]
                                                    .phoneNumber!,
                                                isgroup: false,
                                                messages: [],
                                                
                                              );
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          IndividualChatRoom(
                                                              chat: chat!)));
                                            }
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        ///------------------- image--------------------
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      height *
                                                                          0.1),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl:
                                                                objGroupNotifier
                                                                    .searchList[
                                                                        index]
                                                                    .userProfile!,
                                                            height:
                                                                height * 0.06,
                                                            width:
                                                                height * 0.06,
                                                            fit: BoxFit.cover,
                                                            placeholder: (context,
                                                                    url) =>
                                                                CircularProgressIndicator(
                                                              color:
                                                                  primaryColor,
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Icon(Icons
                                                                        .error),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: width *
                                                                      0.06),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              ///------------------name-------------
                                                              Container(
                                                                margin: EdgeInsets.only(
                                                                    bottom:
                                                                        height *
                                                                            0.005),
                                                                child: Text(
                                                                  objGroupNotifier
                                                                          .searchList[
                                                                              index]
                                                                          .firstName! +
                                                                      " " +
                                                                      objGroupNotifier
                                                                          .searchList[
                                                                              index]
                                                                          .lastName!,
                                                                  style: AppTheme
                                                                          .getTheme()
                                                                      .textTheme
                                                                      .bodyText2!
                                                                      .copyWith(
                                                                          color: ConstColor
                                                                              .white_Color,
                                                                          height:
                                                                              1.4,
                                                                          fontSize:
                                                                              width * 0.043),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                objGroupNotifier
                                                            .searchList.last ==
                                                        objGroupNotifier
                                                            .searchList[index]
                                                    ? Container()
                                                    : Container(
                                                        margin: EdgeInsets.only(
                                                            top: height * 0.022,
                                                            bottom:
                                                                height * 0.022),
                                                        height: 1,
                                                        width: width,
                                                        color: ConstColor
                                                            .term_condition_grey_color
                                                            .withOpacity(0.6),
                                                      )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ))
          ],
        ),
      ),
    );
  }
}
