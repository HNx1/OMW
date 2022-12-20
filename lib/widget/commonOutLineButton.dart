import 'package:flutter/material.dart';

import '../constant/constants.dart';
import '../constant/theme.dart';
import '../utils/colorUtils.dart';

class CommonOutLineButton extends StatelessWidget {
  final String name;
  const CommonOutLineButton({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: height * 0.027),
      padding: EdgeInsets.all(height * 0.017),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height * 0.1),
        border: Border.all(color: Colors.white),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              name,
              style: AppTheme.getTheme().textTheme.bodyText2!.copyWith(
                    color: ConstColor.white_Color,
                    fontSize: width * 0.055,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
