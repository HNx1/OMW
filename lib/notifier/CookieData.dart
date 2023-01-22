import 'package:flutter/material.dart';
import 'package:omw/model/cookie_model.dart';
import 'package:omw/model/termsAndConditionsModel.dart';
import 'package:omw/widget/scaffoldSnackbar.dart';

import '../api/apiProvider.dart';
import '../model/bugsAndReport_model.dart';
import '../model/privacyPolicy_model.dart';

class CookiesData extends ChangeNotifier {
  bool isLoading = false;
  var isConnected;
  PrivacyPolicyModel objPrivacyPolicy = PrivacyPolicyModel();

  getPrivacyPolicys(BuildContext context) async {
    try {
      isLoading = true;
      isConnected = await ApiProvider().checkConnection();
    } catch (e) {
      ScaffoldSnackbar.of(context).show(e.toString());
      isLoading = false;
    } finally {
      isLoading = false;
    }
    if (isConnected == true) {
      try {
        isLoading = true;
        objPrivacyPolicy = await ApiProvider().getPrivacyPolicy();
      } catch (e) {
        print(e);
        isLoading = false;
      } finally {
        isLoading = false;
      }
    } else {
      ScaffoldSnackbar.of(context).show("Turn on the data");
    }
    notifyListeners();
  }

  TermAndConditionModel objTermAndConditionModel = TermAndConditionModel();
  getConditions(BuildContext context) async {
    try {
      isLoading = true;
      isConnected = await ApiProvider().checkConnection();
    } catch (e) {
      ScaffoldSnackbar.of(context).show(e.toString());
      isLoading = false;
    } finally {
      isLoading = false;
    }
    if (isConnected == true) {
      try {
        objTermAndConditionModel = await ApiProvider().getTermsAndCondition();
      } catch (e) {
        print(e);
        isLoading = false;
      } finally {
        isLoading = false;
      }
    } else {
      ScaffoldSnackbar.of(context).show("Turn on the data");
    }
    notifyListeners();
  }

  CookieModel objCookieModel = CookieModel();
  getCookies(BuildContext context) async {
    try {
      isLoading = true;
      isConnected = await ApiProvider().checkConnection();
    } catch (e) {
      ScaffoldSnackbar.of(context).show(e.toString());
      isLoading = false;
    } finally {
      isLoading = false;
    }
    if (isConnected == true) {
      try {
        objCookieModel = await ApiProvider().getCookie();
      } catch (e) {
        print(e);
        isLoading = false;
      } finally {
        isLoading = false;
      }
    } else {
      ScaffoldSnackbar.of(context).show("Turn on the data");
    }
    notifyListeners();
  }

  BugsAndReportModel objBugsAndReportModel = BugsAndReportModel();
  getbugAndReports(BuildContext context) async {
    try {
      isLoading = true;
      isConnected = await ApiProvider().checkConnection();
    } catch (e) {
      ScaffoldSnackbar.of(context).show(e.toString());
      isLoading = false;
    } finally {
      isLoading = false;
    }
    if (isConnected == true) {
      try {
        objBugsAndReportModel = await ApiProvider().getBugAndReport();
      } catch (e) {
        print(e);
        isLoading = false;
      } finally {
        isLoading = false;
      }
    } else {
      ScaffoldSnackbar.of(context).show("Turn on the data");
    }
    notifyListeners();
  }

  updatePrivacyPolicy(
    BuildContext context,
    String docId,
    String description,
    String title,
  ) async {
    try {
      isLoading = true;
      isConnected = await ApiProvider().checkConnection();
    } catch (e) {
      ScaffoldSnackbar.of(context).show(e.toString());
      isLoading = false;
    } finally {
      isLoading = false;
    }
    if (isConnected == true) {
      try {
        await ApiProvider().updatePrivacyPolicy(docId, description, title);

        ScaffoldSnackbar.of(context).show("Updated successfully");
      } catch (e) {
        print(e);
        isLoading = false;
      } finally {
        isLoading = false;
      }
    } else {
      ScaffoldSnackbar.of(context).show("Turn on the data");
    }
    notifyListeners();
  }

  updateCookie(
    BuildContext context,
    String docId,
    String description,
    String title,
  ) async {
    try {
      isLoading = true;
      isConnected = await ApiProvider().checkConnection();
    } catch (e) {
      ScaffoldSnackbar.of(context).show(e.toString());
      isLoading = false;
    } finally {
      isLoading = false;
    }
    if (isConnected == true) {
      try {
        await ApiProvider().updateCookie(docId, description, title);

        ScaffoldSnackbar.of(context).show("Updated successfully");

        Navigator.pop(context);
      } catch (e) {
        print(e);
        isLoading = false;
      } finally {
        isLoading = false;
      }
    } else {
      ScaffoldSnackbar.of(context).show("Turn on the data");
    }
    notifyListeners();
  }

  updateTermsAndConditions(
    BuildContext context,
    String docId,
    String description,
    String title,
  ) async {
    try {
      isLoading = true;
      isConnected = await ApiProvider().checkConnection();
    } catch (e) {
      ScaffoldSnackbar.of(context).show(e.toString());
      isLoading = false;
    } finally {
      isLoading = false;
    }
    if (isConnected == true) {
      try {
        await ApiProvider().updateTermsAndConditions(docId, description, title);

        ScaffoldSnackbar.of(context).show("Updated successfully");

        Navigator.pop(context);
      } catch (e) {
        print(e);
        isLoading = false;
      } finally {
        isLoading = false;
      }
    } else {
      ScaffoldSnackbar.of(context).show("Turn on the data");
    }
    notifyListeners();
  }

  updateBugAndReport(
    BuildContext context,
    String docId,
    String description,
    String title,
  ) async {
    try {
      isLoading = true;
      isConnected = await ApiProvider().checkConnection();
    } catch (e) {
      ScaffoldSnackbar.of(context).show(e.toString());
      isLoading = false;
    } finally {
      isLoading = false;
    }
    if (isConnected == true) {
      try {
        await ApiProvider().updateBugAndReport(docId, description, title);

        ScaffoldSnackbar.of(context).show("Updated successfully");

        Navigator.pop(context);
      } catch (e) {
        print(e);
        isLoading = false;
      } finally {
        isLoading = false;
      }
    } else {
      ScaffoldSnackbar.of(context).show("Turn on the data");
    }
    notifyListeners();
  }
}
