import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../constant/constants.dart';
import '../../../../constant/theme.dart';
import '../../../../model/user_model.dart';
import '../../../../utils/colorUtils.dart';
import '../../../../utils/textUtils.dart';

class Myevent_Maybe_Screen extends StatefulWidget {
  final List<UserModel> maybeGuest;
  final bool isLoading;
  const Myevent_Maybe_Screen(
      {Key? key, required this.maybeGuest, required this.isLoading})
      : super(key: key);

  @override
  State<Myevent_Maybe_Screen> createState() => _Myevent_Maybe_ScreenState();
}

class _Myevent_Maybe_ScreenState extends State<Myevent_Maybe_Screen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: width * 0.01, right: width * 0.01, top: height * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///---------- List OF Going's Data ------------
          widget.isLoading == true && widget.maybeGuest.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                )
              : widget.maybeGuest.isEmpty
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
                      itemCount: widget.maybeGuest.length,
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
                                              imageUrl: widget.maybeGuest[index]
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
                                                  "${widget.maybeGuest[index]
                                                          .firstName!} ${widget.maybeGuest[index]
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
                                widget.maybeGuest.last ==
                                        widget.maybeGuest[index]
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
