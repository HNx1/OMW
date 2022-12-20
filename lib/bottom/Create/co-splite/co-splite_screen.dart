import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:omw/api/apiProvider.dart';
import 'package:omw/constant/constants.dart';
import 'package:omw/notifier/payment_notifier.dart';
import 'package:provider/provider.dart';

import '../../../constant/theme.dart';
import '../../../notifier/authenication_notifier.dart';
import '../../../notifier/event_notifier.dart';
import '../../../notifier/notication_notifier.dart';
import '../../../utils/colorUtils.dart';
import '../../../utils/textUtils.dart';

class CoSpliteScreeen extends StatefulWidget {
  const CoSpliteScreeen({
    Key? key,
  }) : super(key: key);

  @override
  State<CoSpliteScreeen> createState() => _CoSpliteScreeenState();
}

class _CoSpliteScreeenState extends State<CoSpliteScreeen> {
  @override
  void initState() {
    var objProviderNotifier =
        Provider.of<AuthenicationNotifier>(context, listen: false);
    objProviderNotifier.getUserDetail();

    super.initState();
  }

  Map<String, dynamic>? paymentIntentData;
  @override
  Widget build(BuildContext context) {
    final objCreateEventNotifier = context.watch<CreateEventNotifier>();
    final objPaymentNotifier = context.watch<PaymentNotifier>();
    final objNotificationNotifier = context.watch<NotificationNotifier>();
    final objProviderNotifier = context.watch<AuthenicationNotifier>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // key: _scaffoldKey,

      ///---------------- apbar----------------------
      appBar: AppBar(
        backgroundColor: AppTheme.getTheme().scaffoldBackgroundColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: ConstColor.primaryColor,
            size: width * 0.06,
          ),
        ),
        leadingWidth: width * 0.1,
        title:

            ///-------------------- Omw Text ---------------------
            Image.asset(
          ConstantData.logo,
          height: height * 0.12,
          width: height * 0.12,
          fit: BoxFit.contain,
        ),
        //     Text(
        //   TextUtils.Omw,
        //   style: AppTheme.getTheme().textTheme.subtitle1!.copyWith(
        //         color: primaryColor,
        //         fontWeight: FontWeight.w700,
        //         fontSize: width * 0.09,
        //       ),
        // ),
        centerTitle: true,
      ),

      body: Container(
        margin: EdgeInsets.only(
            left: width * 0.03, right: width * 0.03, top: height * 0.02),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: height * 0.043,
                  bottom: height * 0.043,
                  left: width * 0.11,
                  right: width * 0.11),
              margin: EdgeInsets.only(
                top: height * 0.01,
              ),
              decoration: BoxDecoration(
                color: Color(0xff080808),
                borderRadius: BorderRadius.circular(height * 0.02),
                border: Border.all(
                  color: Color(0xff252525),
                ),
              ),
              child: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: objCreateEventNotifier
                              .getEventData.lstUser!.firstName! +
                          " " +
                          objCreateEventNotifier
                              .getEventData.lstUser!.lastName!,
                      style: AppTheme.getTheme().textTheme.bodyText2!.copyWith(
                            color: ConstColor.primaryColor,
                            fontSize: width * 0.046,
                          ),
                      children: [
                        TextSpan(
                          text: TextUtils.suggested,
                          style:
                              AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                                    color: ConstColor.white_Color,
                                    fontWeight: FontWeight.w500,
                                    fontSize: width * 0.046,
                                  ),
                        ),
                        TextSpan(
                          text: "£",
                          style:
                              AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                                    color: ConstColor.primaryColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: width * 0.066,
                                  ),
                        ),
                        TextSpan(
                          text: double.parse(objCreateEventNotifier
                                  .getEventData.costAmount
                                  .toString())
                              .toStringAsFixed(2),
                          style:
                              AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                                    color: ConstColor.primaryColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: width * 0.046,
                                  ),
                        ),
                        TextSpan(
                          text: " towards the cost of the event.",
                          style:
                              AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                                    color: ConstColor.white_Color,
                                    height: 1.4,
                                    fontWeight: FontWeight.w500,
                                    fontSize: width * 0.046,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: height * 0.05, bottom: height * 0.007),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "  You have to paid",
                        style:
                            AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                                  color: ConstColor.white_Color,
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                  fontSize: width * 0.046,
                                ),
                        children: [
                          TextSpan(
                            text: " £ " +
                                double.parse(objCreateEventNotifier
                                        .getEventData.costAmount
                                        .toString())
                                    .toStringAsFixed(2) +
                                " ",
                            style: AppTheme.getTheme()
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                  color: ConstColor.primaryColor,
                                  height: 1.4,
                                  fontSize: width * 0.046,
                                ),
                          ),
                          TextSpan(
                            text: "to the host for this event.",
                            style: AppTheme.getTheme()
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                  color: ConstColor.white_Color,
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                  fontSize: width * 0.046,
                                ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => UsePaypal(
                      sandboxMode: true,
                      clientId:
                          "AT-a84qDs6FcJR61DbJ7QfLW-TdpSJ7KM7eL78RPbrmg_7V3Y2ARforX_-xiqz3YTWqMzVWgLeYC3eZt",
                      secretKey:
                          "EGbHaNLaONjlbUd87nhaprGSZ1MQN1OE7xdLz4PaaKnqwkQiW5R4S1Ac8Clw-NADoGbnIOK6-w9KahbH",
                      returnURL: "https://samplesite.com/return",
                      cancelURL: "https://samplesite.com/cancel",
                      transactions: [
                        {
                          "amount": {
                            "total": double.parse(objCreateEventNotifier
                                    .getEventData.costAmount
                                    .toString())
                                .toStringAsFixed(2),
                            "currency": "GBP",
                            "details": {
                              "subtotal": double.parse(objCreateEventNotifier
                                      .getEventData.costAmount
                                      .toString())
                                  .toStringAsFixed(2),
                              "shipping": '0',
                              "shipping_discount": 0
                            }
                          },
                          "description": "The payment transaction description.",
                          "item_list": {
                            "items": [
                              {
                                "name": "Co-hosting ammount of the event",
                                "quantity": 1,
                                "price": double.parse(objCreateEventNotifier
                                        .getEventData.costAmount
                                        .toString())
                                    .toStringAsFixed(2),
                                "currency": "GBP"
                              }
                            ],
                          }
                        }
                      ],
                      note: "Contact us for any questions about your payment",
                      onSuccess: (Map params) {
                        print("onSuccess: $params");

                        setState(() {});
                        objPaymentNotifier
                            .doPayment(
                          context,
                          objCreateEventNotifier
                                  .getEventData.lstUser!.firstName! +
                              " " +
                              objCreateEventNotifier
                                  .getEventData.lstUser!.lastName!,
                          objCreateEventNotifier.getEventData.docId!,
                          objCreateEventNotifier.getEventData.eventname!,
                          objProviderNotifier.objUsers.firstName! +
                              " " +
                              objProviderNotifier.objUsers.lastName!,
                          objCreateEventNotifier.getEventData.costAmount,
                          "paypal",
                          objCreateEventNotifier
                              .getEventData.lstUser!.userProfile!,
                          objProviderNotifier.objUsers.userProfile!,
                          objCreateEventNotifier.getEventData.lstUser!.uid!,
                        )
                            .whenComplete(() async {
                          await objNotificationNotifier.sendPushNotification(
                              context,
                              objCreateEventNotifier
                                  .getEventData.lstUser!.fcmToken!,
                              "transfer money",
                              "${objProviderNotifier.objUsers.firstName! + " " + objProviderNotifier.objUsers.lastName!} has paid you £${objCreateEventNotifier.getEventData.costAmount} for hosting event ",
                              "money transaction",
                              "",
                              "",
                              "");
                          objNotificationNotifier.pushNotification(
                              context: context,
                              title: "transfer money",
                              description:
                                  "${objProviderNotifier.objUsers.firstName! + " " + objProviderNotifier.objUsers.lastName!} has paid you £${objCreateEventNotifier.getEventData.costAmount} for hosting event ",
                              userId: objCreateEventNotifier
                                  .getEventData.lstUser!.uid,
                              type: "money transaction",
                              typeOfData: [
                                {
                                  "NotificationSendBy":
                                      "${objProviderNotifier.objUsers.firstName! + " " + objProviderNotifier.objUsers.lastName!}",
                                  "eventId":
                                      objCreateEventNotifier.EventData.docId!
                                }
                              ]);
                        });
                      },
                      onError: (error) {
                        print("onError: $error");
                      },
                      onCancel: (params) {
                        print('cancelled: $params');
                      }),
                ));
              },
              child: Container(
                alignment: Alignment.center,
                height: height * 0.08,
                margin:
                    EdgeInsets.only(top: height * 0.12, bottom: height * 0.02),
                width: width / 1.3,
                padding: EdgeInsets.only(right: width * 0.04),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(height * 0.01),
                  border: Border.all(
                    color: Color(0xffD4D4D4).withOpacity(0.41),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      ConstantData.paypal,
                      height: height * 0.08,
                      width: height * 0.08,
                      fit: BoxFit.fill,
                    ),
                    Text(
                      TextUtils.paypal,
                      style: AppTheme.getTheme().textTheme.subtitle1!.copyWith(
                            color: ConstColor.white_Color,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                            fontSize: width * 0.056,
                          ),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                await makePayment(objCreateEventNotifier, objProviderNotifier,
                    objPaymentNotifier, objNotificationNotifier);
              },
              child: Container(
                alignment: Alignment.center,
                width: width / 1.3,
                height: height * 0.08,
                padding:
                    EdgeInsets.only(left: width * 0.02, right: width * 0.02),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(height * 0.01),
                  border: Border.all(
                    color: Color(0xffD4D4D4).withOpacity(0.41),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      ConstantData.card,
                      height: height * 0.05,
                      width: height * 0.05,
                      color: primaryColor,
                      fit: BoxFit.fill,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: width * 0.03),
                      child: Text(
                        TextUtils.credit_debit,
                        style:
                            AppTheme.getTheme().textTheme.subtitle1!.copyWith(
                                  color: ConstColor.white_Color,
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                  fontSize: width * 0.056,
                                ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> makePayment(
    CreateEventNotifier objCreateEventNotifier,
    AuthenicationNotifier objProviderNotifier,
    PaymentNotifier objPaymentNotifier,
    NotificationNotifier objNotificationNotifier,
  ) async {
    try {
      paymentIntentData = await ApiProvider().createPaymentIntent(
          objCreateEventNotifier.getEventData.costAmount, 'GBP');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentData!['client_secret'],
        // applePay: true,
        // googlePay: true,
        // testEnv: true,
        merchantDisplayName:
            objCreateEventNotifier.getEventData.lstUser!.firstName! +
                " " +
                objCreateEventNotifier.getEventData.lstUser!.lastName!,
      ))
          .then((value) {
        displayPaymentSheet(objCreateEventNotifier, objProviderNotifier,
            objPaymentNotifier, objNotificationNotifier);
      });
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet(
      CreateEventNotifier objCreateEventNotifier,
      AuthenicationNotifier objProviderNotifier,
      PaymentNotifier objPaymentNotifier,
      NotificationNotifier objNotificationNotifier) async {
    try {
      await Stripe.instance
          .presentPaymentSheet(
              parameters: PresentPaymentSheetParameters(
        clientSecret: paymentIntentData!['client_secret'],
        confirmPayment: true,
      ))
          .then((newValue) async {
        print('payment intent' + paymentIntentData!['id'].toString());
        print(
            'payment intent' + paymentIntentData!['client_secret'].toString());
        print('payment intent' + paymentIntentData!['amount'].toString());
        print('payment intent' + paymentIntentData.toString());

        await objPaymentNotifier
            .doPayment(
          context,
          objCreateEventNotifier.getEventData.lstUser!.firstName! +
              " " +
              objCreateEventNotifier.getEventData.lstUser!.lastName!,
          objCreateEventNotifier.getEventData.docId!,
          objCreateEventNotifier.getEventData.eventname!,
          objProviderNotifier.objUsers.firstName! +
              " " +
              objProviderNotifier.objUsers.lastName!,
          objCreateEventNotifier.getEventData.costAmount,
          "Stripe",
          objCreateEventNotifier.getEventData.lstUser!.userProfile!,
          objProviderNotifier.objUsers.userProfile!,
          objCreateEventNotifier.getEventData.lstUser!.uid!,
        )
            .whenComplete(() async {
          await objNotificationNotifier.sendPushNotification(
              context,
              objCreateEventNotifier.getEventData.lstUser!.fcmToken!,
              "transfer money",
              "${objProviderNotifier.objUsers.firstName! + " " + objProviderNotifier.objUsers.lastName!} has paid you £${objCreateEventNotifier.getEventData.costAmount} for hosting event ",
              "money transaction",
              "",
              "",
              "");
          objNotificationNotifier.pushNotification(
              context: context,
              title: "transfer money",
              description:
                  "${objProviderNotifier.objUsers.firstName! + " " + objProviderNotifier.objUsers.lastName!} has paid you £${objCreateEventNotifier.getEventData.costAmount} for hosting event ",
              userId: objCreateEventNotifier.getEventData.lstUser!.uid,
              type: "money transaction",
              typeOfData: [
                {
                  "NotificationSendBy":
                      "${objProviderNotifier.objUsers.firstName! + " " + objProviderNotifier.objUsers.lastName!}",
                  "eventId": objCreateEventNotifier.EventData.docId!
                }
              ]);
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("paid successfully")));
        paymentIntentData = null;
      }).onError((error, stackTrace) {
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }
}
