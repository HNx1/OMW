import 'package:flutter/material.dart';

import '../constant/constants.dart';
import '../constant/theme.dart';
import '../utils/colorUtils.dart';

class ErrorButton extends StatefulWidget {
  final String name;
  const ErrorButton({Key? key, required this.name}) : super(key: key);

  @override
  _ErrorButtonState createState() => _ErrorButtonState();
}

class _ErrorButtonState extends State<ErrorButton> {
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
          color: const Color.fromARGB(255, 214, 41, 29)),
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
