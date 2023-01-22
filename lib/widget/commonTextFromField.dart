import 'package:flutter/material.dart';

import '../constant/constants.dart';
import '../constant/theme.dart';
import '../utils/colorUtils.dart';

class CommonTextFromField extends StatefulWidget {
  final String txt;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final bool obsecure;
  final TextInputType? inputType;
  final TextCapitalization textCapitalization;
  const CommonTextFromField(
      {Key? key,
      required this.txt,
      required this.controller,
      this.validator,
      this.obsecure = false,
      this.inputType,
      this.onChanged,
      required this.textCapitalization})
      : super(key: key);

  @override
  _CommonTextFromFieldState createState() => _CommonTextFromFieldState();
}

class _CommonTextFromFieldState extends State<CommonTextFromField> {
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(top: height * 0.026),
      child: TextFormField(
        textCapitalization: widget.textCapitalization,
        autovalidateMode: AutovalidateMode.disabled,
        style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
              fontSize: width * 0.041,
              color: ConstColor.white_Color,
            ),
        keyboardType: widget.inputType,
        obscureText: widget.obsecure,
        controller: widget.controller,
        decoration: InputDecoration(
          errorMaxLines: 2,
          border: InputBorder.none,
          errorStyle: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                fontSize: width * 0.036,
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(height * 0.1),
            borderSide: const BorderSide(
              color: ConstColor.textFormFieldColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(height * 0.1),
            borderSide: const BorderSide(
              color: ConstColor.textFormFieldColor,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(height * 0.1),
            borderSide: const BorderSide(
              color: ConstColor.textFormFieldColor,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(height * 0.1),
            borderSide: const BorderSide(
              color: ConstColor.textFormFieldColor,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(height * 0.1),
            borderSide: const BorderSide(
              color: ConstColor.textFormFieldColor,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
              horizontal: width * 0.05, vertical: height * 0.028),
          hintText: widget.txt,
          hintStyle: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                fontSize: width * 0.041,
                color: ConstColor.white_Color,
              ),
        ),
        validator: widget.validator,
        onChanged: widget.onChanged,
      ),
    );
  }
}
