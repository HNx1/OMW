import 'package:flutter/material.dart';
import 'package:omw/bottom/payment/paid_screen.dart';
import 'package:omw/bottom/payment/receive_screen.dart';

import '../../constant/constants.dart';
import '../../constant/theme.dart';
import '../../utils/colorUtils.dart';
import '../../utils/textUtils.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBar(
            backgroundColor: AppTheme.getTheme().scaffoldBackgroundColor,
            leading: Container(
              margin: EdgeInsets.only(left: width * 0.03),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: ConstColor.primaryColor,
                  size: width * 0.06,
                ),
              ),
            ),
            leadingWidth: width * 0.1,
            title:

                ///-------------------- Notification Text   ---------------------
                Text(
              TextUtils.Payment,
              style: AppTheme.getTheme().textTheme.bodyText2!.copyWith(
                  color: ConstColor.primaryColor,
                  height: 1.4,
                  fontSize: width * 0.052),
            ),
            centerTitle: true,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                top: height * 0.018,
                left: width * 0.03,
                right: width * 0.03,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///---------------- Selection-----------
                  Container(
                    margin: EdgeInsets.only(bottom: height * 0.02),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(height * 0.1),
                      border: Border.all(
                        color: ConstColor.textFormFieldColor,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ///---------------- Paid ------------------------
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                index = 0;
                              });
                            },
                            child: Container(
                              width: width * 0.29,
                              margin: EdgeInsets.all(height * 0.006),
                              padding: EdgeInsets.all(height * 0.014),
                              decoration: BoxDecoration(
                                color: index != 0
                                    ? Colors.transparent
                                    : primaryColor,
                                borderRadius:
                                    BorderRadius.circular(height * 0.1),
                              ),
                              child: Center(
                                child: Text(
                                  TextUtils.paid,
                                  style: AppTheme.getTheme()
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                          decoration: TextDecoration.none,
                                          color: index != 0
                                              ? Color(0xffA5A5A5)
                                              : ConstColor.black_Color,
                                          fontSize: width * 0.043,
                                          fontWeight: index != 0
                                              ? FontWeight.normal
                                              : FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                        ),

                        ///---------------- Receive --------------------
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                index = 1;
                              });
                            },
                            child: Container(
                              width: width * 0.29,
                              margin: EdgeInsets.all(height * 0.006),
                              padding: EdgeInsets.all(height * 0.014),
                              decoration: BoxDecoration(
                                color: index != 1
                                    ? Colors.transparent
                                    : primaryColor,
                                borderRadius:
                                    BorderRadius.circular(height * 0.1),
                              ),
                              child: Center(
                                child: Text(
                                  TextUtils.Receive,
                                  style: AppTheme.getTheme()
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(
                                          decoration: TextDecoration.none,
                                          color: index != 1
                                              ? Color(0xffA5A5A5)
                                              : ConstColor.black_Color,
                                          fontSize: width * 0.043,
                                          fontWeight: index != 1
                                              ? FontWeight.normal
                                              : FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                          padding: EdgeInsets.only(
                              bottom: height * 0.02, top: height * 0.005),
                          child: index == 0 ? PaidScreen() : ReceiveScreen()))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
