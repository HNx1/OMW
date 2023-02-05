import 'dart:io';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:omw/utils/textUtils.dart';
import 'package:omw/widget/validation.dart';
import 'package:provider/provider.dart';

import '../constant/constants.dart';
import '../constant/theme.dart';
import '../notifier/authenication_notifier.dart';
import '../notifier/changenotifier.dart';
import '../utils/colorUtils.dart';
import '../widget/commonButton.dart';
import '../widget/commonTextFromField.dart';
import 'package:intl/intl.dart';
import '../widget/routesFile.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({Key? key}) : super(key: key);

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  late PageController _pageController;
  List<String> images = [
    ConstantData.tutorial1,
    ConstantData.tutorial2,
    ConstantData.tutorial3,
    ConstantData.tutorial4,
    ConstantData.tutorial5,
    ConstantData.tutorial6,
  ];
  int activePage = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.7);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //--------------------Arrow back Icon------------------------------
      appBar: AppBar(
        backgroundColor: AppTheme.getTheme().scaffoldBackgroundColor,
        leading: Container(),
        title:
            //--------------------Profile ------------------------------
            Text(
          "How to use OMW",
          style: AppTheme.getTheme().textTheme.bodyText2!.copyWith(
              color: ConstColor.primaryColor,
              height: 1.4,
              fontSize: width * 0.052),
        ),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(left: width * 0.04, right: width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.only(
                      top: AppBar().preferredSize.height * 0.4,
                    ),
                    shrinkWrap: true,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: height * 0.75,
                        child: PageView.builder(
                            itemCount: images.length,
                            pageSnapping: true,
                            controller: _pageController,
                            onPageChanged: (page) {
                              setState(() {
                                activePage = page;
                              });
                            },
                            itemBuilder: (context, pagePosition) {
                              return Container(
                                margin: EdgeInsets.all(10),
                                child: Image.asset(images[pagePosition]),
                              );
                            }),
                      )
                    ],
                  ),
                ),

                ///--------------------------- save---------------
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, Routes.HOME);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: height * 0.02),
                    child: CommonButton(
                      name: "Return to App",
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
