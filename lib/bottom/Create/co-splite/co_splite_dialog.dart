import 'package:flutter/material.dart';
import 'package:omw/widget/commonTextFromField.dart';
import 'package:provider/provider.dart';

import '../../../constant/constants.dart';
import '../../../constant/theme.dart';
import '../../../notifier/changenotifier.dart';
import '../../../utils/colorUtils.dart';
import '../../../widget/validation.dart';

class CoSpliteDialog extends StatefulWidget {
  const CoSpliteDialog({Key? key}) : super(key: key);

  @override
  State<CoSpliteDialog> createState() => _CoSpliteDialogState();
}

class _CoSpliteDialogState extends State<CoSpliteDialog> {
  final TextEditingController _enterAmountController = TextEditingController();
  var popupKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final objProviderNotifier = context.watch<ProviderNotifier>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: const Color.fromARGB(255, 15, 15, 15),
          margin: EdgeInsets.only(
              left: width * 0.03, right: width * 0.03, top: height * 0.02),
          child: AlertDialog(
            backgroundColor: const Color.fromARGB(255, 15, 15, 15),
            alignment: Alignment.topCenter,
            insetPadding: EdgeInsets.zero,
            actionsPadding:
                EdgeInsets.only(right: width * 0.03, bottom: height * 0.005),
            scrollable: true,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            contentPadding: const EdgeInsets.only(top: 10.0),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: width * 0.05,
                      right: width * 0.03,
                      top: height * 0.012),
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        margin: EdgeInsets.only(left: width * 0.03),
                        child: Text(
                          "Co-Split Amount",
                          style: AppTheme.getTheme()
                              .textTheme
                              .bodyText2!
                              .copyWith(
                                  color: ConstColor.white_Color,
                                  height: 1.4,
                                  fontSize: width * 0.048),
                        ),
                      )),
                      GestureDetector(
                          onTap: () {
                            _enterAmountController.clear();
                            Navigator.pop(context);
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          child: const Icon(Icons.clear))
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: height * 0.022, bottom: height * 0.01),
                  height: 1,
                  width: width,
                  color: const Color.fromARGB(255, 187, 171, 171).withOpacity(0.2),
                ),
                Form(
                  key: popupKey,
                  child: Container(
                      width: width,
                      margin: EdgeInsets.only(
                        left: width * 0.04,
                        right: width * 0.05,
                      ),
                      child: CommonTextFromField(
                         textCapitalization: TextCapitalization.none,
                        inputType: TextInputType.number,
                        txt: "Enter Amount",
                        controller: _enterAmountController,
                        validator: validateAmount,
                      )),
                ),
              ],
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(
                    top: height * 0.01,
                    bottom: height * 0.01,
                  ),
                  child: Text(
                    "Cancel",
                    style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                        color: ConstColor.primaryColor,
                        height: 1.4,
                        fontSize: width * 0.046),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: width * 0.04),
                child: GestureDetector(
                  onTap: () {
                    final isValid = popupKey.currentState!.validate();

                    if (isValid) {
                      setState(() {
                        objProviderNotifier.setamount =
                            double.parse(_enterAmountController.text)
                                .toDouble();
                      });
                      print(objProviderNotifier.getamount);
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      top: height * 0.01,
                      bottom: height * 0.01,
                    ),
                    child: Text(
                      "Okay",
                      style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                          color: ConstColor.white_Color,
                          height: 1.4,
                          fontSize: width * 0.046),
                    ),
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
