import 'package:flutter/material.dart';

import '../../../constant/constants.dart';
import '../../../constant/theme.dart';
import '../../../utils/colorUtils.dart';

class ConfirmationDialog extends StatefulWidget {
  final int index;
  const ConfirmationDialog({Key? key, required this.index}) : super(key: key);

  @override
  State<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {


  int indexs = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(left: width * 0.04, right: width * 0.04),
          padding: EdgeInsets.only(
              top: height * 0.02,
              left: width * 0.036,
              right: width * 0.036,
              bottom: height * 0.01),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height * 0.016),
            color: const Color.fromARGB(255, 15, 15, 15),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      ///------------------- Selection--------------------
                      Container(
                        margin: EdgeInsets.only(left: width * 0.03),
                        child: Text(
                          "Change your Response?",
                          style: AppTheme.getTheme()
                              .textTheme
                              .bodyText2!
                              .copyWith(
                                  color: ConstColor.white_Color,
                                  height: 1.4,
                                  fontSize: width * 0.052),
                        ),
                      )
                    ],
                  ),

                  ///------------------- Close Icon--------------------
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      ConstantData.close,
                      color: Colors.white,
                      height: height * 0.03,
                      width: height * 0.03,
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),

              ///------------------- Divider --------------------
              Container(
                margin:
                    EdgeInsets.only(top: height * 0.022, bottom: height * 0.01),
                height: 1,
                width: width,
                color: const Color.fromARGB(255, 187, 171, 171).withOpacity(0.2),
              ),

              ///------------------- Message David--------------------
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.index;
                  });
                  Navigator.pop(context, widget.index);
                },
                child: Container(
                  margin: EdgeInsets.only(
                    top: height * 0.01,
                    bottom: height * 0.01,
                  ),
                  child: Text(
                    "Yes",
                    style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                        color: ConstColor.white_Color,
                        height: 1.4,
                        fontSize: width * 0.046),
                  ),
                ),
              ),

              ///------------------- Mail David--------------------
              GestureDetector(
                onTap: () {
                  setState(() {
                    indexs = widget.index;
                  });
                  Navigator.pop(context, indexs);
                },
                child: Container(
                  margin: EdgeInsets.only(
                    top: height * 0.01,
                    bottom: height * 0.01,
                  ),
                  child: Text(
                    "No",
                    style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                        color: ConstColor.white_Color,
                        height: 1.4,
                        fontSize: width * 0.046),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
