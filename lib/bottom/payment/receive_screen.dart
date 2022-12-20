import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constant/constants.dart';
import '../../constant/theme.dart';
import '../../notifier/payment_notifier.dart';
import '../../utils/colorUtils.dart';
import '../../utils/textUtils.dart';
import 'package:intl/intl.dart';

class ReceiveScreen extends StatefulWidget {
  const ReceiveScreen({Key? key}) : super(key: key);

  @override
  State<ReceiveScreen> createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends State<ReceiveScreen> {
  @override
  void initState() {
    var objPaymentNotifier =
        Provider.of<PaymentNotifier>(context, listen: false);
    objPaymentNotifier.getListOfReceivedpayments(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final objPaymentNotifier = context.watch<PaymentNotifier>();
    return objPaymentNotifier.isLoading &&
            objPaymentNotifier.lstofOfReceivedpayments.isEmpty
        ? Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          )
        : objPaymentNotifier.lstofOfReceivedpayments.isEmpty
            ? Container(
                margin: EdgeInsets.only(top: AppBar().preferredSize.height * 2),
                child: Center(
                  child: Text(
                    TextUtils.noResultFound,
                    style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                          fontSize: width * 0.041,
                          color: ConstColor.white_Color,
                        ),
                  ),
                ),
              )
            : Container(
                margin: EdgeInsets.only(
                    left: width * 0.01,
                    right: width * 0.01,
                    top: height * 0.01),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: objPaymentNotifier.lstofOfReceivedpayments.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.only(
                          top: height * 0.012, bottom: height * 0.012),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(height * 0.1),
                                  child: CachedNetworkImage(
                                    imageUrl: objPaymentNotifier
                                        .lstofOfReceivedpayments[index]
                                        .receivedUserProfile!,
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
                            ],
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: width * 0.03),
                              child: RichText(
                                text: TextSpan(
                                    text: objPaymentNotifier
                                        .lstofOfReceivedpayments[index]
                                        .paymentBy,
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
                                        text: "has paid you ",
                                        style: AppTheme.getTheme()
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                                color: ConstColor.white_Color,
                                                height: 1.4,
                                                fontSize: width * 0.036),
                                      ),
                                      TextSpan(
                                        text: "£" +
                                            double.parse(objPaymentNotifier
                                                    .lstofOfReceivedpayments[
                                                        index]
                                                    .amount
                                                    .toString())
                                                .toStringAsFixed(2),
                                        style: AppTheme.getTheme()
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(
                                                color: ConstColor.primaryColor,
                                                height: 1.4,
                                                fontSize: width * 0.046),
                                      ),
                                      TextSpan(text: " "),
                                      TextSpan(
                                        text: "for the event of ",
                                        style: AppTheme.getTheme()
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                                color: ConstColor.white_Color,
                                                height: 1.4,
                                                fontSize: width * 0.036),
                                      ),
                                      TextSpan(text: " "),
                                      TextSpan(
                                        text: objPaymentNotifier
                                            .lstofOfReceivedpayments[index]
                                            .eventName,
                                        style: AppTheme.getTheme()
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(
                                                color: ConstColor.white_Color,
                                                height: 1.4,
                                                fontSize: width * 0.04),
                                      ),
                                      TextSpan(text: "\n"),
                                      TextSpan(
                                        text:
                                            '${DateFormat('EEE, MMM dd, hh:mm aa ').format(objPaymentNotifier.lstofOfReceivedpayments[index].paymentTime!)[0].toUpperCase()}${(DateFormat('EEE, MMM dd, hh:mm aa ').format(objPaymentNotifier.lstofOfReceivedpayments[index].paymentTime!).substring(1)).toLowerCase()}',
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
                ),
              );
  }
}
