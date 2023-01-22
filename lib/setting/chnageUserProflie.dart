import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:omw/constant/theme.dart';
import 'package:provider/provider.dart';

import '../../../constant/constants.dart';
import '../../../utils/colorUtils.dart';
import '../../../utils/textUtils.dart';
import '../../../widget/commonButton.dart';
import '../notifier/authenication_notifier.dart';

class ChangeUserProfile extends StatefulWidget {
  const ChangeUserProfile({Key? key}) : super(key: key);

  @override
  State<ChangeUserProfile> createState() => _ChangeUserProfileState();
}

class _ChangeUserProfileState extends State<ChangeUserProfile> {
  @override
  void initState() {
    var objProviderNotifier =
        Provider.of<AuthenicationNotifier>(context, listen: false);
    objProviderNotifier.getUserDetail();
    super.initState();
  }

  bool isProfileUploaded = false;

  var formKey = GlobalKey<FormState>();
  String imageUrl = "";
  File? imageFile;
  String? uploadImage;
  updateProfilePic(File image) async {
    try {
      setState(() {
        isProfileUploaded = true;
      });
      var imageName = image.path.split('/').last;

      var snapshot =
          await FirebaseStorage.instance.ref().child(imageName).putFile(image);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        uploadImage = downloadUrl;
      });
      print(uploadImage);
      return downloadUrl.toString();
    } catch (e) {
      print(e);
      setState(() {
        isProfileUploaded = false;
      });
    } finally {
      setState(() {
        isProfileUploaded = false;
      });
    }
  }

  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        imageUrl = pickedFile.path;
      });
    }
  }

  _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        imageUrl = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final objProviderNotifier = context.watch<AuthenicationNotifier>();
    return Scaffold(
      //--------------------Arrow back Icon------------------------------
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

            ///--------------------Change Profile Pic  ---------------------
            Text(
          TextUtils.updateProfile,
          style: AppTheme.getTheme().textTheme.bodyText2!.copyWith(
              color: ConstColor.primaryColor,
              height: 1.4,
              fontSize: width * 0.052),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          isProfileUploaded == true ||
                  objProviderNotifier.objUsers == ""
              ? const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                )
              : Container(),
          Container(
            margin: EdgeInsets.only(
                top: height * 0.06,
                left: width * 0.03,
                right: width * 0.03,
                bottom: height * 0.02),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              ///-----------------Photo ---------------
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(height * 0.1),
                                      child: imageFile == null
                                          ? CachedNetworkImage(
                                              imageUrl: objProviderNotifier
                                                  .objUsers.userProfile!,
                                              height: height * 0.14,
                                              width: height * 0.14,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  const CircularProgressIndicator(
                                                color: primaryColor,
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            )
                                          : Image.file(
                                              imageFile!,
                                              height: height * 0.14,
                                              width: height * 0.14,
                                              fit: BoxFit.cover,
                                            )),
                                  Positioned(
                                    bottom: height * 0.006,
                                    child: GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                          ),
                                          context: context,
                                          builder: (context) {
                                            return Wrap(
                                              children: [
                                                Column(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        _getFromGallery();
                                                        Navigator.pop(context);
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets.all(
                                                            height * 0.02),
                                                        child: Text(
                                                          'GALLERY',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText2!
                                                                  .copyWith(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                  ),
                                                        ),
                                                      ),
                                                    ),
                                                    const Divider(
                                                      thickness: 2,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        _getFromCamera();
                                                        Navigator.pop(context);
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets.all(
                                                            height * 0.02),
                                                        child: Text(
                                                          'CAMERA',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyText2!
                                                              .copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                        ),
                                                      ),
                                                    ),
                                                    const Divider(
                                                      thickness: 2,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets.all(
                                                            height * 0.02),
                                                        child: Text(
                                                          'Cancel',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyText2!
                                                              .copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .errorColor),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: CircleAvatar(
                                        radius: 14,
                                        backgroundColor: ConstColor.black_Color,
                                        child: CircleAvatar(
                                          radius: 10,
                                          backgroundColor: primaryColor,
                                          child: Image.asset(
                                            ConstantData.camera,
                                            height: height * 0.02,
                                            width: height * 0.02,
                                            color: ConstColor.black_Color,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                ///------------ save name button------------
                Container(
                  margin: EdgeInsets.only(bottom: height * 0.04),
                  child: GestureDetector(
                      onTap: () async {
                        final isValid = formKey.currentState!.validate();

                        if (isValid) {
                          if (imageFile != null) {
                            await updateProfilePic(imageFile!);
                          }

                          await objProviderNotifier.updateProfileImage(
                              context,
                              imageUrl != ""
                                  ? uploadImage!
                                  : objProviderNotifier.objUsers.userProfile!);
                        }
                      },
                      child: const CommonButton(
                        name: TextUtils.Save,
                      )),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
