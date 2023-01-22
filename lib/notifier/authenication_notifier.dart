import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:omw/authentication/loginScreen.dart';
import 'package:omw/constant/constants.dart';
import 'package:omw/setting/change_myEmail_screen.dart';
import '../api/api_provider.dart';
import '../constant/theme.dart';
import '../model/user_model.dart';
import '../preference/preference.dart';
import '../utils/colorUtils.dart';
import '../widget/routesFile.dart';
import '../widget/scaffold_snackbar.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class AuthenicationNotifier extends ChangeNotifier {
  bool isLoading = false;
  bool isCurretPassword = true;
  bool isSignUp = false;
  Future signInWithEmailAndPassword(
      BuildContext context, String email, String password, String token) async {
    try {
      isLoading = true;
      await ApiProvider().checkConnection();
      isLoading = true;
      final User user = (await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      ))
          .user!;
      isCurretPassword = true;
      isSignUp = true;
      if (isupdateEmail == true) {
        await ApiProvider().updateEmailAddress(email);
        isupdateEmail = false;
      }
      await ApiProvider().updateToken(token);
    } catch (e) {
      isCurretPassword = false;
      isSignUp = false;
      isLoading = false;

      ScaffoldSnackbar.of(context).show("Incorrect username or password");
    } finally {
      isLoading = false;
    }
    notifyListeners();
  }

  bool? success;
  String userEmail = '';

  Future fireBaseSignUp(
      BuildContext context, String email, String password) async {
    try {
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

        final User? user = (await _auth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        ))
            .user;

        if (user != null) {
          success = true;
          userEmail = user.email ?? '';
          await FirebaseAuth.instance.currentUser!.sendEmailVerification();
          isSignUp = true;
        } else {
          success = false;
          isLoading = false;
        }
      } catch (e) {
        print(e);
        isSignUp = false;
        ScaffoldSnackbar.of(context).show(e.toString());

        Navigator.pushReplacementNamed(context, Routes.Login);

        isLoading = false;
      } finally {
        isLoading = false;
      }
    } else {
      ScaffoldSnackbar.of(context).show("Turn on the data and retry again");
    }

    notifyListeners();
  }

  UserModel objUsers = UserModel();
  getUserDetail() async {
    isLoading = true;
    User user = _auth.currentUser!;

    try {
      objUsers = await ApiProvider().getUserDetail(user.uid);
    } catch (e) {
      print(e);
      isLoading = false;
    } finally {
      isLoading = false;
    }
    notifyListeners();
  }

  Future<void> registeration({
    required BuildContext context,
    required String firstName,
    required String lastname,
    required String emailId,
    required String phoneNumber,
    required String imageUrl,
    required String birthdate,
    required File imageFile,
    required String role,
    required String fcmToken,
  }) async {
    bool isConnected = false;
    try {
      isLoading = true;
      isConnected = await ApiProvider().checkConnection();
    } catch (e) {
      ScaffoldSnackbar.of(context).show(e.toString());
      isLoading = false;
    } finally {
      isLoading = false;
    }
    if (isConnected) {
      try {
        isLoading = true;

        await ApiProvider().checkConnection();

        var imageName = imageFile.path.split('/').last;
        print(imageName);
        var snapshot = await FirebaseStorage.instance
            .ref()
            .child(imageName)
            .putFile(imageFile);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        imageUrl = downloadUrl;
        UserModel userModel = UserModel(
          firstName: firstName.trim(),
          lastName: lastname.trim(),
          emailId: emailId.trim(),
          phoneNumber: phoneNumber,
          userProfile: imageUrl.trim(),
          birthDate: birthdate.trim(),
          uid: _auth.currentUser!.uid,
          role: role,
          fcmToken: fcmToken,
        );

        if (await ApiProvider().isDuplicatePhoneNumber(phoneNumber)) {
          ScaffoldSnackbar.of(context)
              .show("Use another phone number.This is already registered");
        } else {
          await ApiProvider().AddUserData(userModel);

          PrefServices().setIsUserLoggedIn(true);
          var name = "${firstName.trim()} ${lastname.trim()}";
          PrefServices().setCurrentUserName(name);
          var currentUser = PrefServices().getCurrentUserName();
          print("currentUser==========>$currentUser");
          Navigator.pushReplacementNamed(context, Routes.HOME);
        }
      } catch (e) {
        print(e);
        ScaffoldSnackbar.of(context).show(e.toString());
        isLoading = false;
      } finally {
        isLoading = false;
      }
    } else {
      ScaffoldSnackbar.of(context).show("Turn on the data and retry again");
    }
    notifyListeners();
  }

  Future<void> resetPassword(BuildContext context, String email) async {
    try {
      isLoading = true;
      await ApiProvider().checkConnection();
      await _auth.sendPasswordResetEmail(
        email: email,
      );
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 15, 15, 15),
            title: const Text("Password Reset Email Sent"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    "We sent you an email to reset your password.\n\nPlease check spam folder if you can't find it.",
                    style: AppTheme.getTheme().textTheme.bodyText2!.copyWith(
                          fontSize: width * 0.037,
                          color: ConstColor.Text_grey_color,
                        ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Okay',
                  style: AppTheme.getTheme().textTheme.bodyText2!.copyWith(
                        fontSize: width * 0.037,
                        color: ConstColor.primaryColor,
                      ),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, Routes.Login);
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      isLoading = false;
      print(e);
      ScaffoldSnackbar.of(context).show("Invalid username");
    } finally {
      isLoading = false;
    }
  }

  Future signOut(
    BuildContext context,
  ) async {
    try {
      await ApiProvider().updateToken("");
      await _auth.signOut().whenComplete(() {
        // Navigator.pushReplacementNamed(context, Routes.Login);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
        PrefServices().clearData();
      });
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future deleteUser(
    BuildContext context,
  ) async {
    try {
      await ApiProvider().updateToken("");
      await _auth.currentUser?.delete();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
      PrefServices().clearData();
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  Future deleteEvent(
    BuildContext context,
  ) async {
    try {
      Navigator.pushReplacementNamed(context, Routes.HOME);
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  updateName(
    BuildContext context,
    String firstName,
    String lastName,
  ) async {
    isLoading = true;
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
      isLoading = true;
      try {
        await ApiProvider().updateFullaName(firstName, lastName);
        await getUserDetail();
      } catch (e) {
        print(e);
        isLoading = false;
      } finally {
        isLoading = false;
      }
    } else {
      ScaffoldSnackbar.of(context).show("Turn on the data and retry again");
    }
    notifyListeners();
  }

  updatePhoneNumber(
    BuildContext context,
    String phoneNumber,
  ) async {
    isLoading = true;

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
        await ApiProvider().updatePhoneNumber(phoneNumber);
        await getUserDetail();
        ScaffoldSnackbar.of(context).show("Updated successfully");
      } catch (e) {
        print(e);
        ScaffoldSnackbar.of(context).show(e.toString());
        isLoading = false;
      } finally {
        isLoading = false;
      }
    } else {
      ScaffoldSnackbar.of(context).show("Turn on the data and retry again");
    }
    notifyListeners();
  }

  updateProfileImage(
    BuildContext context,
    String profile,
  ) async {
    isLoading = true;
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
        await ApiProvider().updateProfile(profile);
        await getUserDetail();
        ScaffoldSnackbar.of(context).show("Updated successfully");
      } catch (e) {
        print(e);
        isLoading = false;
      } finally {
        isLoading = false;
      }
    } else {
      ScaffoldSnackbar.of(context).show("Turn on the data and retry again");
    }
    notifyListeners();
  }

  Future updatePassword(BuildContext context, String newPassword) async {
    try {
      await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
      ScaffoldSnackbar.of(context)
          .show("You can now sign in with your new password");

      return true;
    } catch (e) {
      print(e);
      ScaffoldSnackbar.of(context).show(
        e.toString(),
      );

      return false;
    }
  }

  Future isOldpasswordVerify(BuildContext context, String enterPassword) async {
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
        var email = FirebaseAuth.instance.currentUser!.email;
        AuthCredential auth = EmailAuthProvider.credential(
            email: email!, password: enterPassword);
        UserCredential a = await FirebaseAuth.instance.currentUser!
            .reauthenticateWithCredential(auth);

        return true;
      } catch (e) {
        return false;
      }
    } else {
      ScaffoldSnackbar.of(context).show("Turn on the data and retry again");
    }
  }

  var isConnected;
  Future updateEmail(
    BuildContext context,
    String email,
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
        isLoading = true;
        await FirebaseAuth.instance.currentUser!
            .verifyBeforeUpdateEmail(email)
            .whenComplete(() async {
          await signOut(context);
        });
      } catch (e) {
        print(e);
        ScaffoldSnackbar.of(context).show(e.toString());
        isLoading = false;
      } finally {
        isLoading = false;
      }
    } else {
      ScaffoldSnackbar.of(context).show("Turn on the data and retry again");
    }
    notifyListeners();
  }
}
