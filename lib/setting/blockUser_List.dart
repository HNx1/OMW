import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constant/constants.dart';
import '../../../constant/theme.dart';
import '../../../utils/colorUtils.dart';
import '../../../utils/textUtils.dart';
import '../notifier/chatting_notifier.dart';

class BlockUserList extends StatefulWidget {
  const BlockUserList({Key? key}) : super(key: key);

  @override
  State<BlockUserList> createState() => _BlockUserListState();
}

class _BlockUserListState extends State<BlockUserList> {
  TextEditingController _searchController = TextEditingController();

  bool _IsSearching = false;
  String _searchText = "";
  _BlockUserListState() {
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
    final objChattingNotifier =
        Provider.of<ChattingNotifier>(context, listen: false);
    if (_searchText.isEmpty) {
      return objChattingNotifier.searchList =
          objChattingNotifier.lstofAllBlockUser;
    } else {
      objChattingNotifier.searchList = objChattingNotifier.lstofAllBlockUser
          .where(
            (element) => element.UserName!.toLowerCase().contains(
                  _searchText.toLowerCase(),
                ),
          )
          .toList();
      print('${objChattingNotifier.searchList.length}');
      return objChattingNotifier.searchList;
    }
  }

  bool isLoading = true;
  getdata() async {
    setState(() {
      isLoading = true;
    });
    final objChattingNotifier =
        Provider.of<ChattingNotifier>(context, listen: false);
    await objChattingNotifier.getListOfBlockUsers(context);
    objChattingNotifier.searchList = objChattingNotifier.lstofAllBlockUser;
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final objChattingNotifier = context.watch<ChattingNotifier>();
    return Scaffold(
      ///---------------- Appbar---------------
      appBar: AppBar(
        backgroundColor: AppTheme.getTheme().scaffoldBackgroundColor,
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
        leadingWidth: width * 0.1,
        title:

            ///--------------------Change My name text  ---------------------
            Text(
          TextUtils.BlockUser,
          style: AppTheme.getTheme().textTheme.bodyText2!.copyWith(
              color: ConstColor.primaryColor,
              height: 1.4,
              fontSize: width * 0.052),
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
              child: isLoading == true && objChattingNotifier.searchList.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    )
                  : objChattingNotifier.searchList.isEmpty
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
                            ),
                          ),
                        )

                      ///------------------ List OF Contact Data-------------------
                      : ListView.builder(
                          padding: EdgeInsets.only(
                            bottom: height * 0.02,
                          ),
                          itemCount: objChattingNotifier.searchList.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              color: Colors.transparent,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          ///------------------- image--------------------
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                height * 0.1),
                                            child: Image.network(
                                              objChattingNotifier
                                                  .searchList[index]
                                                  .UserProfile!,
                                              height: height * 0.068,
                                              width: height * 0.068,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: width * 0.06),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ///------------------name-------------
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: height * 0.005),
                                                  child: Text(
                                                    objChattingNotifier
                                                        .searchList[index]
                                                        .UserName!,
                                                    style: AppTheme.getTheme()
                                                        .textTheme
                                                        .bodyText2!
                                                        .copyWith(
                                                            color: ConstColor
                                                                .white_Color,
                                                            height: 1.4,
                                                            fontSize:
                                                                width * 0.043),
                                                  ),
                                                ),

                                                ///-----------------conmtacts-------------
                                                Text(
                                                  objChattingNotifier
                                                      .searchList[index]
                                                      .UserPhone!,
                                                  style: AppTheme.getTheme()
                                                      .textTheme
                                                      .bodyText1!
                                                      .copyWith(
                                                          color:
                                                              Color(0xff6C6C6C),
                                                          height: 1.4,
                                                          fontSize:
                                                              width * 0.037),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  objChattingNotifier.searchList.last ==
                                          objChattingNotifier.searchList[index]
                                      ? Container()
                                      : Container(
                                          margin: EdgeInsets.only(
                                              top: height * 0.022,
                                              bottom: height * 0.022),
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
            )
          ],
        ),
      ),
    );
  }
}
