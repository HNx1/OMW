import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:omw/constant/theme.dart';
import 'package:omw/utils/textUtils.dart';
import 'package:provider/provider.dart';

import '../api/apiProvider.dart';
import '../constant/constants.dart';
import '../notifier/authenication_notifier.dart';
import '../notifier/event_notifier.dart';
import '../preference/preference.dart';
import '../widget/routesFile.dart';
import '../widget/scaffold_snackbar.dart';

class Spalsh extends StatefulWidget {
  const Spalsh({Key? key}) : super(key: key);

  @override
  _SpalshState createState() => _SpalshState();
}

class _SpalshState extends State<Spalsh> {
  late final FirebaseMessaging _messaging;
  String token = "";

  ChechConnection() async {
    var objCreateEventNotifier =
        Provider.of<CreateEventNotifier>(context, listen: false);
    await objCreateEventNotifier.checkConnection();
    if (objCreateEventNotifier.isConnected == true) {
      Future.delayed(Duration(seconds: 1)).then((value) {
        _messaging = FirebaseMessaging.instance;
        getToken();
      });
    } else {
      ScaffoldSnackbar.of(context).show("Turn on the data and retry again");
    }
  }

  getToken() async {
    await _messaging.getToken().then((value) {
      print("========================== >Token :-$value");
      setState(() {
        token = value!;
      });
    });
    await login();
  }

  String currentuser = "";
  login() async {
    var objProviderNotifier =
        Provider.of<AuthenicationNotifier>(context, listen: false);

    try {
      await objProviderNotifier.getUserDetail();
      PrefServices().setCurrentUserName(
          objProviderNotifier.objUsers.firstName! +
              " " +
              objProviderNotifier.objUsers.lastName!);
      currentuser = await PrefServices().getCurrentUserName();

      if (PrefServices().getIsUserLoggedIn() &&
          objProviderNotifier.objUsers != '' &&
          objProviderNotifier.objUsers.role == "user") {
        await ApiProvider().updateToken(token);
        // currentuser = await PrefServices().getCurrentUserName();
        Navigator.pushReplacementNamed(context, Routes.HOME);
      } else if (PrefServices().getIsUserLoggedIn() &&
          objProviderNotifier.objUsers != '' &&
          objProviderNotifier.objUsers.role == "admin") {
        await ApiProvider().updateToken(token);
        // currentuser = await PrefServices().getCurrentUserName();
        Navigator.pushReplacementNamed(context, Routes.Admin);
      } else {
        Navigator.pushReplacementNamed(context, Routes.Welcome);
      }
    } catch (e) {
      print(e);
      Navigator.pushReplacementNamed(context, Routes.Welcome);
    }
  }

  @override
  void didChangeDependencies() {
    ChechConnection();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppTheme.getTheme().scaffoldBackgroundColor,
      body: Center(
          child: Image.asset(
        ConstantData.logo,
        height: height * 0.22,
        width: height * 0.22,
        fit: BoxFit.contain,
      )
          // child: Text(
          //   TextUtils.Omw,
          //   style: AppTheme.getTheme().textTheme.subtitle1!.copyWith(
          //         color: primaryColor,
          //         fontWeight: FontWeight.w700,
          //         fontSize: width * 0.14,
          //       ),
          //   textAlign: TextAlign.center,
          // ),
          ),
    );
  }
}
