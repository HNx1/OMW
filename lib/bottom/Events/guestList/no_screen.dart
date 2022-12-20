import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../constant/constants.dart';
import '../../../constant/theme.dart';
import '../../../model/user_model.dart';
import '../../../utils/colorUtils.dart';
import '../../../utils/textUtils.dart';
import '../../Profile/profile_screen.dart';

class NoScreen extends StatefulWidget {
  final List<UserModel> notGoingGuest;
  final bool isLoading;

  final String? currentUserId;
  const NoScreen({
    Key? key,
    required this.notGoingGuest,
    required this.isLoading,
    required this.currentUserId,
  }) : super(key: key);

  @override
  State<NoScreen> createState() => _NoScreenState();
}

class _NoScreenState extends State<NoScreen> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(
            left: width * 0.01, right: width * 0.01, top: height * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///---------- List OF Going's Data ------------
            widget.isLoading == true && widget.notGoingGuest.isEmpty
                ? Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  )
                : widget.notGoingGuest.isEmpty
                    ? Container(
                        margin: EdgeInsets.only(
                            top: AppBar().preferredSize.height * 2),
                        child: Center(
                            child: Text(
                          TextUtils.noResultFound,
                          style:
                              AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                                    fontSize: width * 0.041,
                                    color: ConstColor.white_Color,
                                  ),
                        )),
                      )
                    : Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.only(bottom: height * 0.02),
                          itemCount: widget.notGoingGuest.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileScreen(
                                                      fcmtoken: widget
                                                          .notGoingGuest[index]
                                                          .fcmToken!,
                                                      userId: widget
                                                          .notGoingGuest[index]
                                                          .uid!,
                                                      isOwnProfile: widget
                                                                  .notGoingGuest[
                                                                      index]
                                                                  .uid ==
                                                              widget
                                                                  .currentUserId
                                                          ? true
                                                          : false,
                                                      name: widget
                                                              .notGoingGuest[
                                                                  index]
                                                              .firstName! +
                                                          " " +
                                                          widget
                                                              .notGoingGuest[
                                                                  index]
                                                              .lastName!,
                                                      profile: widget
                                                          .notGoingGuest[index]
                                                          .userProfile!,
                                                    )));
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          height * 0.1),
                                                  child: CachedNetworkImage(
                                                    imageUrl: widget
                                                        .notGoingGuest[index]
                                                        .userProfile!,
                                                    height: height * 0.068,
                                                    width: height * 0.068,
                                                    fit: BoxFit.cover,
                                                    placeholder: (context,
                                                            url) =>
                                                        CircularProgressIndicator(
                                                      color: primaryColor,
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  )),
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
                                                          bottom:
                                                              height * 0.005),
                                                      child: Text(
                                                        widget
                                                                .notGoingGuest[
                                                                    index]
                                                                .firstName! +
                                                            " " +
                                                            widget
                                                                .notGoingGuest[
                                                                    index]
                                                                .lastName!,
                                                        style: AppTheme
                                                                .getTheme()
                                                            .textTheme
                                                            .bodyText2!
                                                            .copyWith(
                                                                color: ConstColor
                                                                    .white_Color,
                                                                height: 1.4,
                                                                fontSize:
                                                                    width *
                                                                        0.043),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    widget.notGoingGuest.last ==
                                            widget.notGoingGuest[index]
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
                              ],
                            );
                          },
                        ),
                      )
          ],
        ),
      ),
    );

    // Container(
    //   margin: EdgeInsets.only(
    //       left: width * 0.01, right: width * 0.01, top: height * 0.01),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       ///---------- List OF Going's Data ------------
    //       widget.isLoading == true && widget.notGoingGuest.isEmpty
    //           ? Center(
    //               child: CircularProgressIndicator(
    //                 color: primaryColor,
    //               ),
    //             )
    //           : widget.notGoingGuest.isEmpty
    //               ? Container(
    //                   margin: EdgeInsets.only(
    //                       top: AppBar().preferredSize.height * 2),
    //                   child: Center(
    //                       child: Text(
    //                     TextUtils.noResultFound,
    //                     style:
    //                         AppTheme.getTheme().textTheme.bodyText1!.copyWith(
    //                               fontSize: width * 0.041,
    //                               color: ConstColor.white_Color,
    //                             ),
    //                   )),
    //                 )
    //               : ListView.builder(
    //                   padding: EdgeInsets.only(bottom: height * 0.02),
    //                   itemCount: widget.notGoingGuest.length,
    //                   shrinkWrap: true,
    //                   physics: NeverScrollableScrollPhysics(),
    //                   itemBuilder: (BuildContext context, int index) {
    //                     return Column(
    //                       children: [
    //                         Column(
    //                           children: [
    //                             Row(
    //                               mainAxisAlignment:
    //                                   MainAxisAlignment.spaceBetween,
    //                               children: [
    //                                 Row(
    //                                   children: [
    //                                     ClipRRect(
    //                                         borderRadius: BorderRadius.circular(
    //                                             height * 0.1),
    //                                         child: CachedNetworkImage(
    //                                           imageUrl: widget
    //                                               .notGoingGuest[index]
    //                                               .userProfile!,
    //                                           height: height * 0.068,
    //                                           width: height * 0.068,
    //                                           fit: BoxFit.cover,
    //                                           placeholder: (context, url) =>
    //                                               CircularProgressIndicator(
    //                                             color: primaryColor,
    //                                           ),
    //                                           errorWidget:
    //                                               (context, url, error) =>
    //                                                   Icon(Icons.error),
    //                                         )),
    //                                     Container(
    //                                       margin: EdgeInsets.only(
    //                                           left: width * 0.06),
    //                                       child: Column(
    //                                         crossAxisAlignment:
    //                                             CrossAxisAlignment.start,
    //                                         children: [
    //                                           ///------------------name-------------
    //                                           Container(
    //                                             margin: EdgeInsets.only(
    //                                                 bottom: height * 0.005),
    //                                             child: Text(
    //                                               widget.notGoingGuest[index]
    //                                                       .firstName! +
    //                                                   " " +
    //                                                   widget
    //                                                       .notGoingGuest[index]
    //                                                       .lastName!,
    //                                               style: AppTheme.getTheme()
    //                                                   .textTheme
    //                                                   .bodyText2!
    //                                                   .copyWith(
    //                                                       color: ConstColor
    //                                                           .white_Color,
    //                                                       height: 1.4,
    //                                                       fontSize:
    //                                                           width * 0.043),
    //                                             ),
    //                                           ),
    //                                         ],
    //                                       ),
    //                                     )
    //                                   ],
    //                                 ),
    //                               ],
    //                             ),
    //                             widget.notGoingGuest.last ==
    //                                     widget.notGoingGuest[index]
    //                                 ? Container()
    //                                 : Container(
    //                                     margin: EdgeInsets.only(
    //                                         top: height * 0.022,
    //                                         bottom: height * 0.022),
    //                                     height: 1,
    //                                     width: width,
    //                                     color: ConstColor
    //                                         .term_condition_grey_color
    //                                         .withOpacity(0.6),
    //                                   )
    //                           ],
    //                         ),
    //                       ],
    //                     );
    //                   },
    //                 )
    //     ],
    //   ),
    // );
  }
}
