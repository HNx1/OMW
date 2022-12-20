import 'package:flutter/material.dart';

import '../constant/constants.dart';
import '../constant/theme.dart';
import '../utils/colorUtils.dart';

class CommonButton extends StatefulWidget {
  final String name;
  const CommonButton({Key? key, required this.name}) : super(key: key);

  @override
  _CommonButtonState createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(
        top: height * 0.030,
      ),
      padding: EdgeInsets.all(height * 0.019),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height * 0.1),
        color: ConstColor.primaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ------------ Text View-----------
          Expanded(
            child: Center(
              child: Text(
                widget.name,
                style: AppTheme.getTheme().textTheme.bodyText2!.copyWith(
                      fontSize: width * 0.055,
                      color: ConstColor.black_Color,
                    ),
              ),
            ),  
          ),
        ],
      ),
    );
  }
}
