import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constant/constants.dart';
import '../../../constant/theme.dart';
import '../../../utils/colorUtils.dart';
import '../../../utils/textUtils.dart';
import '../notifier/CookieData.dart';
import 'package:url_launcher/url_launcher.dart';

class BugReportScreen extends StatefulWidget {
  const BugReportScreen({Key? key}) : super(key: key);

  @override
  State<BugReportScreen> createState() => _BugReportScreenState();
}

class _BugReportScreenState extends State<BugReportScreen> {
  @override
  void initState() {
    var objbugReportProvider = Provider.of<CookiesData>(context, listen: false);
    objbugReportProvider.getbugAndReports(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final objbugReportProvider = context.watch<CookiesData>();
    return Scaffold(
      //--------------------Arrow back Icon------------------------------
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

            ///--------------------Bug Report text  ---------------------
            Text(
          TextUtils.bug,
          style: AppTheme.getTheme().textTheme.bodyText2!.copyWith(
              color: ConstColor.primaryColor,
              height: 1.4,
              fontSize: width * 0.052),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          objbugReportProvider.objBugsAndReportModel.description == null ||
                  objbugReportProvider.objBugsAndReportModel.description ==
                      "" ||
                  objbugReportProvider.objBugsAndReportModel.title == null ||
                  objbugReportProvider.objBugsAndReportModel.title == ""
              ? const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.only(
                    top: AppBar().preferredSize.height / 2,
                    left: width * 0.04,
                    right: width * 0.04,
                    bottom: height * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Found a bug or have a suggestion?",
                        style: AppTheme.getTheme()
                            .textTheme
                            .bodyText1!
                            .copyWith(
                                decoration: TextDecoration.none,
                                color: ConstColor.white_Color,
                                height: 1.5,
                                fontSize: width * 0.044),
                      ),
                      Row(children: [
                        Text(
                          "Please use our ",
                          style: AppTheme.getTheme()
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  decoration: TextDecoration.none,
                                  color: ConstColor.term_condition_grey_color,
                                  height: 1.5,
                                  fontSize: width * 0.044),
                        ),
                        GestureDetector(
                            onTap: () async {
                              var url = Uri(
                                scheme: 'https',
                                host: 'docs.google.com',
                                path:
                                    'forms/d/e/1FAIpQLSfZpEjm0c_OorWQ8VMFZIOSMbdSJBTh75tbd-DXyXH8Py7vtg/viewform',
                              );
                              if (await canLaunchUrl(url)) await launchUrl(url);
                            },
                            child: Text(
                              "Google Form",
                              style: AppTheme.getTheme()
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                      decoration: TextDecoration.underline,
                                      color: const Color(0xff2196f3),
                                      height: 1.5,
                                      fontSize: width * 0.044),
                            ))
                      ]),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget CommanData(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: height * 0.044, bottom: height * 0.01),
          child: Row(
            children: [
              Icon(
                Icons.circle,
                color: primaryColor,
                size: width * 0.03,
              ),
              Container(
                margin: EdgeInsets.only(left: width * 0.04),
                child: Text(
                  title,
                  style: AppTheme.getTheme().textTheme.bodyText2!.copyWith(
                      decoration: TextDecoration.none,
                      color: ConstColor.white_Color,
                      height: 1.5,
                      fontSize: width * 0.044),
                ),
              ),
            ],
          ),
        ),
        Text(
          description,
          style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
              decoration: TextDecoration.none,
              height: 1.5,
              color: ConstColor.term_condition_grey_color,
              fontSize: width * 0.044),
        ),
      ],
    );
  }
}
