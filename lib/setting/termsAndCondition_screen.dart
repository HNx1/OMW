import 'package:flutter/material.dart';
import 'package:omw/widget/routesFile.dart';
import 'package:provider/provider.dart';

import '../../../../constant/constants.dart';
import '../../../../constant/theme.dart';
import '../../../../utils/colorUtils.dart';
import '../../../../utils/textUtils.dart';
import '../notifier/CookieData.dart';

class TermsAndCondition extends StatefulWidget {
  final bool isfromWelcome;
  const TermsAndCondition({Key? key, required this.isfromWelcome})
      : super(key: key);

  @override
  State<TermsAndCondition> createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends State<TermsAndCondition> {
  @override
  void initState() {
    var objTermAndConditionProvider =
        Provider.of<CookiesData>(context, listen: false);
    objTermAndConditionProvider.getConditions(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final objTermAndConditionProvider = context.watch<CookiesData>();
    return Scaffold(
      //--------------------Arrow back Icon------------------------------
      appBar: AppBar(
        backgroundColor: AppTheme.getTheme().scaffoldBackgroundColor,
        leading: GestureDetector(
          onTap: () {
            widget.isfromWelcome == false
                ? Navigator.pop(context)
                : Navigator.pushReplacementNamed(context, Routes.Welcome);
          },
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: ConstColor.primaryColor,
            size: width * 0.06,
          ),
        ),
        leadingWidth: width * 0.1,
        title:

            ///-------------------- Terms And Condtions text  ---------------------
            Text(
          TextUtils.Terms,
          style: AppTheme.getTheme().textTheme.bodyText2!.copyWith(
              color: ConstColor.primaryColor,
              height: 1.4,
              fontSize: width * 0.052),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          objTermAndConditionProvider.objTermAndConditionModel.description ==
                      null ||
                  objTermAndConditionProvider
                          .objTermAndConditionModel.description ==
                      "" ||
                  objTermAndConditionProvider.objTermAndConditionModel.title ==
                      null ||
                  objTermAndConditionProvider.objTermAndConditionModel.title ==
                      ""
              ? Center(
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
                        objTermAndConditionProvider
                            .objTermAndConditionModel.title!,
                        style: AppTheme.getTheme()
                            .textTheme
                            .bodyText1!
                            .copyWith(
                                decoration: TextDecoration.none,
                                color: ConstColor.white_Color,
                                height: 1.5,
                                fontSize: width * 0.044),
                      ),
                      Text(
                        objTermAndConditionProvider
                            .objTermAndConditionModel.description!,
                        style: AppTheme.getTheme()
                            .textTheme
                            .bodyText1!
                            .copyWith(
                                decoration: TextDecoration.none,
                                height: 1.5,
                                color: ConstColor.term_condition_grey_color,
                                fontSize: width * 0.044),
                      ),

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
