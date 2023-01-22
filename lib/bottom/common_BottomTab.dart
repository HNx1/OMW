import 'package:flutter/material.dart';

import '../constant/constants.dart';
import '../constant/theme.dart';
import '../main.dart';
import '../utils/colorUtils.dart';

bool isFromEventScreen = false;

class PersistanceBottomTab extends StatefulWidget {
  final int index;
  final int lastIndex;

  final Function onSuccess;
  const PersistanceBottomTab(
      {Key? key,
      required this.index,
      required this.onSuccess,
      required this.lastIndex})
      : super(key: key);

  @override
  State<PersistanceBottomTab> createState() => _PersistanceBottomTabState();
}

class _PersistanceBottomTabState extends State<PersistanceBottomTab> {
  int currentIndex = 0;
  @override
  void initState() {
    currentIndex = widget.lastIndex;
    super.initState();
  }

// ConstColor.textFormFieldColor
  @override
  Widget build(BuildContext context) {
    num heightScalar = 0.043;
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 4,
          color: ConstColor.black_Color,
          child: Container(
            decoration: BoxDecoration(
              color: ConstColor.black_Color,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(height * 0.015),
                topRight: Radius.circular(height * 0.015),
              ),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 0.7,
                  spreadRadius: 0.7,
                  color: ConstColor.textFormFieldColor,
                ),
              ],
            ),
            height: height * 0.08,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ///------- Events -------------
                GestureDetector(
                  onTap: () {
                    // if (currentIndex != 1) {
                    //   setState(() {
                    //     currentIndex = 1;
                    //     widget.onSuccess(currentIndex);
                    //   });
                    // }
                    setState(() {
                      currentIndex = 1;
                      widget.onSuccess(currentIndex);
                    });
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        Image.asset(
                          ConstantData.menu,
                          height: height * heightScalar,
                          fit: BoxFit.cover,
                          color: widget.lastIndex == 1
                              ? primaryColor
                              : ConstColor.white_Color,
                        ),
                        // Container(
                        //   margin: EdgeInsets.only(
                        //     left: height * 0.03,
                        //   ),
                        //   color: Colors.white,
                        //   height: height * 0.1,
                        //   width: 1,
                        // ),
                      ],
                    ),
                  ),
                ),

                ///------- Contact -------------

                GestureDetector(
                  onTap: () {
                    // if (currentIndex != 2) {

                    // }
                    setState(() {
                      currentIndex = 2;
                      widget.onSuccess(currentIndex);
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: width * 0.05),
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        Image.asset(
                          ConstantData.contact,
                          height: height * heightScalar,
                          fit: BoxFit.cover,
                          color: widget.lastIndex == 2
                              ? primaryColor
                              : ConstColor.white_Color,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(),

                ///------- Notification -------------
                GestureDetector(
                  onTap: () {
                    // if (currentIndex != 3) {
                    //   setState(() {
                    //     currentIndex = 3;
                    //     widget.onSuccess(currentIndex);
                    //   });
                    // }
                    setState(() {
                      currentIndex = 3;
                      widget.onSuccess(currentIndex);
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: width * 0.05),
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Image.asset(
                              ConstantData.notifiaction,
                              height: height * heightScalar,
                              fit: BoxFit.cover,
                              color: widget.lastIndex == 3
                                  ? primaryColor
                                  : ConstColor.white_Color,
                            ),
                            ValueListenableBuilder(
                              builder:
                                  (BuildContext context, value, Widget? child) {
                                return Positioned(
                                  top: height * 0.002,
                                  child: value == 0
                                      ? Container()
                                      : CircleAvatar(
                                          radius: 6,
                                          backgroundColor: Colors.black,
                                          child: CircleAvatar(
                                            radius: 4.7,
                                            backgroundColor: const Color.fromARGB(
                                                255, 255, 21, 21),
                                            child: Center(
                                                child: Text(
                                              value.toString(),
                                              style: AppTheme.getTheme()
                                                  .textTheme
                                                  .bodyText2!
                                                  .copyWith(
                                                      color: ConstColor
                                                          .white_Color,
                                                      fontSize: width * 0.022),
                                              textAlign: TextAlign.center,
                                            )),
                                          ),
                                        ),
                                );
                              },
                              valueListenable: notificationCounterValueNotifer,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                ///------- Chat -------------
                GestureDetector(
                  onTap: () {
                    // if (currentIndex != 4) {
                    //   setState(() {
                    //     currentIndex = 4;
                    //     widget.onSuccess(currentIndex);
                    //   });
                    // }
                    setState(() {
                      currentIndex = 4;
                      widget.onSuccess(currentIndex);
                    });
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        // Container(
                        //   margin: EdgeInsets.only(
                        //     right: height * 0.03,
                        //   ),
                        //   color: Colors.white,
                        //   height: height * 0.1,
                        //   width: 1,
                        // ),
                        Image.asset(
                          ConstantData.message,
                          height: height * heightScalar,
                          fit: BoxFit.cover,
                          color: widget.lastIndex == 4
                              ? primaryColor
                              : ConstColor.white_Color,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: Colors.transparent,
          child: FloatingActionButton(
            backgroundColor: primaryColor,
            onPressed: () {
              if (currentIndex != 0 && widget.lastIndex != 0) {
                setState(
                  () {
                    currentIndex = 0;
                    widget.onSuccess(currentIndex);
                  },
                );
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  ConstantData.add,
                  height: height * heightScalar * 0.9,
                  fit: BoxFit.cover,
                  color: ConstColor.black_Color,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
