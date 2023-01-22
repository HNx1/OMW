import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../constant/constants.dart';
import '../../../constant/theme.dart';
import '../../../model/user_model.dart';
import '../../../utils/colorUtils.dart';
import '../../../utils/textUtils.dart';
import '../../Profile/profile_screen.dart';

class GoingScreen extends StatefulWidget {
  final List<UserModel> goingGuest;
  final bool isLoading;

  final String? currentUserId;
  const GoingScreen({
    Key? key,
    required this.goingGuest,
    required this.isLoading,
    required this.currentUserId,
  }) : super(key: key);

  @override
  State<GoingScreen> createState() => _GoingScreenState();
}

class _GoingScreenState extends State<GoingScreen> {
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
            widget.isLoading == true && widget.goingGuest.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  )
                : widget.goingGuest.isEmpty
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
                          itemCount: widget.goingGuest.length,
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
                                                          .goingGuest[index]
                                                          .fcmToken!,
                                                      userId: widget
                                                          .goingGuest[index]
                                                          .uid!,
                                                      isOwnProfile: widget
                                                                  .goingGuest[
                                                                      index]
                                                                  .uid ==
                                                              widget
                                                                  .currentUserId
                                                          ? true
                                                          : false,
                                                      name: "${widget
                                                              .goingGuest[index]
                                                              .firstName!} ${widget
                                                              .goingGuest[index]
                                                              .lastName!}",
                                                      profile: widget
                                                          .goingGuest[index]
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
                                                        .goingGuest[index]
                                                        .userProfile!,
                                                    height: height * 0.068,
                                                    width: height * 0.068,
                                                    fit: BoxFit.cover,
                                                    placeholder: (context,
                                                            url) =>
                                                        const CircularProgressIndicator(
                                                      color: primaryColor,
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            const Icon(Icons.error),
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
                                                        "${widget.goingGuest[index]
                                                                .firstName!} ${widget
                                                                .goingGuest[
                                                                    index]
                                                                .lastName!}",
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
                                    widget.goingGuest.last ==
                                            widget.goingGuest[index]
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
  }
}
