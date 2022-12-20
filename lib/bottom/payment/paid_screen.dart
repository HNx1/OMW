import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constant/constants.dart';
import '../../constant/theme.dart';
import '../../notifier/payment_notifier.dart';
import '../../utils/colorUtils.dart';
import 'package:intl/intl.dart';

import '../../utils/textUtils.dart';

class PaidScreen extends StatefulWidget {
  const PaidScreen({Key? key}) : super(key: key);

  @override
  State<PaidScreen> createState() => _PaidScreenState();
}

class _PaidScreenState extends State<PaidScreen> {
  @override
  void initState() {
    var objPaymentNotifier =
        Provider.of<PaymentNotifier>(context, listen: false);
    objPaymentNotifier.getListOfPaidpayments(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final objPaymentNotifier = context.watch<PaymentNotifier>();
    return Container(
      margin: EdgeInsets.only(
          left: width * 0.01, right: width * 0.01, top: height * 0.01),
      child: Column(
        children: [
          ///---------- List OF paid Data ------------
          objPaymentNotifier.isLoading &&
                  objPaymentNotifier.lstOfPaidpayments.isEmpty
              ? Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                )
              : objPaymentNotifier.lstOfPaidpayments.isEmpty
                  ? Container(
                      margin: EdgeInsets.only(
                          top: AppBar().preferredSize.height * 2),
                      child: Center(
                        child: Text(
                          TextUtils.noResultFound,
                          style:
                              AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                                    fontSize: width * 0.041,
                                    color: ConstColor.white_Color,
                                  ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: objPaymentNotifier.lstOfPaidpayments.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.only(
                              top: height * 0.012, bottom: height * 0.012),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(height * 0.1),
                                  child: CachedNetworkImage(
                                    imageUrl: objPaymentNotifier
                                        .lstOfPaidpayments[index].paidUserProfile!,
                                    height: height * 0.058,
                                    width: height * 0.058,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(
                                      color: primaryColor,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  )),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(left: width * 0.03),
                                  child: RichText(
                                    text: TextSpan(
                                        text: "You",
                                        
                                        style: AppTheme.getTheme()
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(
                                                color: ConstColor.white_Color,
                                                height: 1.4,
                                                fontSize: width * 0.04),
                                        children: [
                                          TextSpan(text: " "),
                                          TextSpan(
                                            text: "have paid",
                                            style: AppTheme.getTheme()
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                    color:
                                                        ConstColor.white_Color,
                                                    height: 1.4,
                                                    fontSize: width * 0.036),
                                          ),
                                          TextSpan(text: " "),
                                          TextSpan(
                                            text: "£" +
                                                double.parse(objPaymentNotifier
                                                        .lstOfPaidpayments[
                                                            index]
                                                        .amount
                                                        .toString())
                                                    .toStringAsFixed(2) +
                                                " ",
                                            style: AppTheme.getTheme()
                                                .textTheme
                                                .bodyText2!
                                                .copyWith(
                                                    color:
                                                        ConstColor.primaryColor,
                                                    height: 1.4,
                                                    fontSize: width * 0.046),
                                          ),
                                          TextSpan(
                                            text: objPaymentNotifier
                                                .lstOfPaidpayments[index]
                                                .eventHostedBy,
                                            style: AppTheme.getTheme()
                                                .textTheme
                                                .bodyText2!
                                                .copyWith(
                                                    color:
                                                        ConstColor.white_Color,
                                                    height: 1.4,
                                                    fontSize: width * 0.04),
                                          ),
                                          TextSpan(text: " "),
                                          TextSpan(
                                            text: "for the event of ",
                                            style: AppTheme.getTheme()
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                    color:
                                                        ConstColor.white_Color,
                                                    height: 1.4,
                                                    fontSize: width * 0.036),
                                          ),
                                          TextSpan(
                                            text: objPaymentNotifier
                                                .lstOfPaidpayments[index]
                                                .eventName,
                                            style: AppTheme.getTheme()
                                                .textTheme
                                                .bodyText2!
                                                .copyWith(
                                                    color:
                                                        ConstColor.white_Color,
                                                    height: 1.4,
                                                    fontSize: width * 0.04),
                                          ),
                                          TextSpan(text: "\n"),
                                          TextSpan(
                                            text:
                                                '${DateFormat('EEE, MMM dd, hh:mm aa ').format(objPaymentNotifier.lstOfPaidpayments[index].paymentTime!)[0].toUpperCase()}${(DateFormat('EEE, MMM dd, hh:mm aa ').format(objPaymentNotifier.lstOfPaidpayments[index].paymentTime!).substring(1)).toLowerCase()}',
                                            style: AppTheme.getTheme()
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                    color: Color(0xffCECECE),
                                                    height: 1.4,
                                                    fontSize: width * 0.036),
                                          ),
                                        ]),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    )
        ],
      ),
    );
  }
}
