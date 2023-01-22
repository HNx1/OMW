import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:omw/constant/constants.dart';
import 'package:omw/utils/colorUtils.dart';

import '../../../../constant/theme.dart';
import '../../../../model/user_model.dart';
import '../../../../utils/textUtils.dart';

class Myevent_No_screen extends StatefulWidget {
  final List<UserModel> notGoingGuest;
  final bool isLoading;
  const Myevent_No_screen(
      {Key? key, required this.notGoingGuest, required this.isLoading})
      : super(key: key);

  @override
  State<Myevent_No_screen> createState() => _Myevent_No_screenState();
}

class _Myevent_No_screenState extends State<Myevent_No_screen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: width * 0.01, right: width * 0.01, top: height * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///---------- List OF Going's Data ------------
          widget.isLoading == true && widget.notGoingGuest.isEmpty
              ? const Center(
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
                  : ListView.builder(
                      padding: EdgeInsets.only(bottom: height * 0.02),
                      itemCount: widget.notGoingGuest.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                height * 0.1),
                                            child: CachedNetworkImage(
                                              imageUrl: widget
                                                  .notGoingGuest[index]
                                                  .userProfile!,
                                              height: height * 0.068,
                                              width: height * 0.068,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
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
                                                    bottom: height * 0.005),
                                                child: Text(
                                                  "${widget.notGoingGuest[index]
                                                          .firstName!} ${widget
                                                          .notGoingGuest[index]
                                                          .lastName!}",
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

                                              
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                   
                                  ],
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
                    )
        ],
      ),
    );
  }
}
