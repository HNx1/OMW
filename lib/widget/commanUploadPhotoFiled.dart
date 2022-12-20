import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../constant/constants.dart';
import '../constant/theme.dart';
import '../utils/colorUtils.dart';
import '../utils/textUtils.dart';

class UploadPhoto extends StatefulWidget {
  const UploadPhoto({Key? key}) : super(key: key);

  @override
  State<UploadPhoto> createState() => _UploadPhotoState();
}

class _UploadPhotoState extends State<UploadPhoto> {
  String imageUrl = "";
  File? imageFile;
  bool isProfileUploaded = false;

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
    return Column(
      children: [
        ///-----------------Photo ---------------
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              shape: RoundedRectangleBorder(
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
                            margin: EdgeInsets.all(height * 0.02),
                            child: Text(
                              'GALLERY',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        GestureDetector(
                          onTap: () {
                            _getFromCamera();
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: EdgeInsets.all(height * 0.02),
                            child: Text(
                              'CAMERA',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                      color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: EdgeInsets.all(height * 0.02),
                            child: Text(
                              'Cancel',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                      color: Theme.of(context).errorColor),
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
          child: Container(
            height: height * 0.075,
            margin: EdgeInsets.only(top: height * 0.026),
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.05,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(height * 0.1),
              border: Border.all(
                color: ConstColor.textFormFieldColor,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    imageFile == null ? TextUtils.UploadPhoto : imageUrl,
                    style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                        fontSize: width * 0.038,
                        color: ConstColor.white_Color,
                        fontWeight: FontWeight.w400),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Image.asset(
                  ConstantData.camera,
                  height: height * 0.036,
                  fit: BoxFit.cover,
                )
              ],
            ),
          ),
        ),
        imageUrl == "" && isProfileUploaded == true
            ? Container(
                margin:
                    EdgeInsets.only(top: height * 0.011, left: width * 0.055),
                child: Text(
                  TextUtils.SelectProfile,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: width * 0.036,
                        color: Colors.red,
                      ),
                ),
              )
            : Container(),
      ],
    );
  }
}
