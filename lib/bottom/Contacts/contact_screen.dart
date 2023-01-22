import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:omw/bottom/Contacts/add_popup.dart';
import 'package:omw/notifier/group_notifier.dart';
import 'package:omw/widget/commonButton.dart';
import 'package:omw/widget/scaffold_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../api/api_provider.dart';
import '../../constant/constants.dart';
import '../../constant/theme.dart';
import '../../utils/colorUtils.dart';
import '../Profile/drawer.dart';
import '../Profile/profile_screen.dart';
import 'createGroup_screen.dart';
import '../../model/user_model.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

bool isLoading = true;

class _ContactScreenState extends State<ContactScreen> {
  final TextEditingController _searchController = TextEditingController();
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

  List<UserModel> contactsList = [];
  List<UserModel> searchList = [];

  getAllContactList() async {
    var objGroupNotifier = Provider.of<GroupNotifier>(context, listen: false);

    setState(() {
      isLoading = true;
    });
    await objGroupNotifier.getData(context, "");
    contactsList = objGroupNotifier.selectedUserList.toList();
    contactsList.sort((a, b) => a.lastName!.compareTo(b.lastName!));
    searchList = contactsList;
    print('Contacts list length ===> ${contactsList.length}');

    setState(() {
      isLoading = false;
    });
  }

  String _searchText = "";
  _ContactScreenState() {
    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        if (mounted) {
          setState(
            () {
              _searchText = "";
              _buildSearchList();
            },
          );
        }
      } else {
        if (mounted) {
          setState(
            () {
              _searchText = _searchController.text;
              _buildSearchList();
            },
          );
        }
      }
    });
  }

  _buildSearchList() {
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
  }

  @override
  Widget build(BuildContext context) {
    final objGroupNotifier = context.watch<GroupNotifier>();
    return Column(
      children: [
        ///---------------- Appbar---------------
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
          title:
              //--------------------omw ------------------------------
              Image.asset(
            ConstantData.logo,
            height: height * 0.12,
            width: height * 0.12,
            fit: BoxFit.contain,
          ),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return _buildAddPopupDialog();
                    });
              },
              child: objGroupNotifier.wishListItems.isNotEmpty
                  ? Container()
                  : Container(
                      margin: EdgeInsets.only(right: width * 0.05),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.add_circle_outline_sharp,
                        color: primaryColor,
                      )),
            ),
          ],
        ),

        Expanded(
          child: Container(
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
                    textCapitalization: TextCapitalization.words,
                    autovalidateMode: AutovalidateMode.disabled,
                    style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                          fontSize: width * 0.045,
                          color: ConstColor.white_Color,
                        ),
                    controller: _searchController,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      errorStyle:
                          AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                                fontSize: width * 0.045,
                                fontWeight: FontWeight.w500,
                                color: Colors.red,
                              ),
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(height * 0.1),
                        borderSide: const BorderSide(
                          color: ConstColor.textFormFieldColor,
                        ),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _searchController.clear();
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
                      hintText: "Search for a contact",
                      hintStyle:
                          AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                                fontSize: width * 0.045,
                                color: const Color(0xff6C6C6C),
                              ),
                    ),
                  ),
                ),

                Expanded(
                    child: isLoading == true && searchList.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : searchList.isEmpty
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
                                builder: (BuildContext context, value,
                                    Widget? child) {
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
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: primaryColor,
                                                ),
                                              )
                                            : Container(),
                                        ListView.builder(
                                          cacheExtent: 9999,
                                          padding: EdgeInsets.only(
                                            bottom: height * 0.02,
                                          ),
                                          itemCount: searchList.length,
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return GestureDetector(
                                              onTap: () {
                                                searchList[index]
                                                        .isSelcetdForGroup =
                                                    searchList[index]
                                                        .isSelcetdForGroup;
                                                if (searchList[index]
                                                        .isSelcetdForGroup ==
                                                    true) {
                                                  objGroupNotifier.addItem(
                                                      searchList[index]
                                                          .firstName!);
                                                } else {
                                                  objGroupNotifier.removeItem(
                                                      searchList[index]
                                                          .firstName!);
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
                                                            GestureDetector(
                                                              behavior:
                                                                  HitTestBehavior
                                                                      .translucent,
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            ProfileScreen(
                                                                              fcmtoken: searchList[index].fcmToken!,
                                                                              userId: searchList[index].uid!,
                                                                              isOwnProfile: false,
                                                                              name: "${searchList[index].firstName!} ${searchList[index].lastName!}",
                                                                              profile: searchList[index].userProfile!,
                                                                            )));
                                                              },
                                                              child: Row(
                                                                  children: [
                                                                    ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(height *
                                                                              0.1),
                                                                      child:
                                                                          CachedNetworkImage(
                                                                        cacheManager:
                                                                            CacheManager(Config(
                                                                          "omw",
                                                                          stalePeriod:
                                                                              const Duration(days: 7),
                                                                          //one week cache period
                                                                        )),
                                                                        imageUrl:
                                                                            searchList[index].userProfile!,
                                                                        height: height *
                                                                            0.06,
                                                                        width: height *
                                                                            0.06,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        placeholder:
                                                                            (context, url) =>
                                                                                const CircularProgressIndicator(
                                                                          color:
                                                                              primaryColor,
                                                                        ),
                                                                        errorWidget: (context, url, error) => Icon(
                                                                            Icons
                                                                                .error,
                                                                            size:
                                                                                height * 0.06),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                          left: width *
                                                                              0.06),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          ///------------------name-------------
                                                                          Container(
                                                                            margin:
                                                                                EdgeInsets.only(bottom: height * 0.005),
                                                                            child:
                                                                                Text(
                                                                              "${searchList[index].firstName!} ${searchList[index].lastName!}",
                                                                              style: AppTheme.getTheme().textTheme.bodyText2!.copyWith(color: ConstColor.white_Color, height: 1.4, fontSize: width * 0.043),
                                                                            ),
                                                                          ),

                                                                          ///-----------------conmtacts-------------
                                                                          // Text(
                                                                          //   searchList[index].phoneNumber!,
                                                                          //   style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                                                                          //       color: Color(0xff6C6C6C),
                                                                          //       height: 1.4,
                                                                          //       fontSize: width * 0.037),
                                                                          // )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ]),
                                                            ),
                                                          ],
                                                        ),
                                                        searchList[index]
                                                                    .isSelcetdForGroup ==
                                                                true
                                                            ? const Icon(
                                                                Icons.check)
                                                            : Container(),
                                                      ],
                                                    ),
                                                    searchList.last ==
                                                            searchList[index]
                                                        ? Container()
                                                        : Container(
                                                            margin: EdgeInsets.only(
                                                                top: height *
                                                                    0.022,
                                                                bottom: height *
                                                                    0.022),
                                                            height: 1,
                                                            width: width,
                                                            color: ConstColor
                                                                .term_condition_grey_color
                                                                .withOpacity(
                                                                    0.6),
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
        ),
        objGroupNotifier.wishListItems.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  objGroupNotifier.wishListItems.isNotEmpty
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) =>
                                  const CreateGroupScreen()))).whenComplete(() {
                          if (mounted) {
                            setState(() {});
                          }
                        })
                      : ScaffoldSnackbar.of(context)
                          .show("Please select member for group");
                },
                child: Container(
                  margin: EdgeInsets.only(
                      left: width * 0.03,
                      right: width * 0.03,
                      bottom: height * 0.02),
                  child: const CommonButton(name: "Create Group"),
                ),
              )
            : Container()
      ],
    );
  }

  Widget _buildAddPopupDialog() {
    return const AddpopupDialog();
  }

  _openDrawer() {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 0),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return const CommonDrawer();
      },
    );
  }
}
