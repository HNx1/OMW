import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:omw/api/apiProvider.dart';
import 'package:omw/notifier/group_notifier.dart';
import 'package:omw/widget/commonButton.dart';
import 'package:omw/widget/scaffoldSnackbar.dart';
import 'package:provider/provider.dart';

import '../../constant/constants.dart';
import '../../constant/theme.dart';
import '../../utils/colorUtils.dart';
import '../../utils/textUtils.dart';
import '../../widget/validation.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  var formKey = GlobalKey<FormState>();
  TextEditingController _groupNameController = TextEditingController();

  String imageUrl = "";
  File? imageFile;
  bool isLoaded = false;
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

  String url =
      "https://uploads-ssl.webflow.com/5b47649da0981485ce5ab6f8/5b6366f53a2f88dedeef8518_people%20icon%20navy.png";
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

  bool isRemove = false;

  List lstGroupUser = [];
  @override
  void initState() {
    getGropuName();
    super.initState();
  }

  getGropuName() {
    var objGroupNotifier = Provider.of<GroupNotifier>(context, listen: false);
    _groupNameController.text = objGroupNotifier.getGroupName == null ||
            objGroupNotifier.getGroupName == ""
        ? ""
        : objGroupNotifier.getGroupName;
  }

  @override
  Widget build(BuildContext context) {
    final objGroupNotifier = context.watch<GroupNotifier>();

    return Scaffold(
      //--------------------Arrow back Icon------------------------------
      appBar: AppBar(
        backgroundColor: AppTheme.getTheme().scaffoldBackgroundColor,
        leading: GestureDetector(
          onTap: () {
            objGroupNotifier.searchList.forEach((element) {
              element.isSelcetdForGroup = false;
            });
            objGroupNotifier.setGroupName = "";
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

            ///-------------------- Create Group ---------------------
            Text(
          TextUtils.CreateGroup,
          style: AppTheme.getTheme().textTheme.bodyText2!.copyWith(
              color: ConstColor.primaryColor,
              height: 1.4,
              fontSize: width * 0.052),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          isLoaded
              ? Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                )
              : Container(),
          Container(
            margin: EdgeInsets.only(
                left: width * 0.03, right: width * 0.03, bottom: height * 0.02),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(top: height * 0.023),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///-----------------group name Textfrom field---------------
                          TextFormField(
                            autovalidateMode: AutovalidateMode.disabled,
                            style: AppTheme.getTheme()
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                  fontSize: width * 0.043,
                                  color: ConstColor.white_Color,
                                ),
                            controller: _groupNameController,
                            decoration: InputDecoration(
                              errorStyle: AppTheme.getTheme()
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    fontSize: width * 0.036,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red,
                                  ),
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(height * 0.1),
                                borderSide: BorderSide(
                                  color: ConstColor.textFormFieldColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(height * 0.1),
                                borderSide: BorderSide(
                                  color: ConstColor.textFormFieldColor,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(height * 0.1),
                                borderSide: BorderSide(
                                  color: ConstColor.textFormFieldColor,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(height * 0.1),
                                borderSide: BorderSide(
                                  color: ConstColor.textFormFieldColor,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(height * 0.1),
                                borderSide: BorderSide(
                                  color: ConstColor.textFormFieldColor,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: width * 0.05,
                                  vertical: height * 0.026),
                              hintText: TextUtils.Entergroupname,
                              hintStyle: AppTheme.getTheme()
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    fontSize: width * 0.045,
                                    color: Color(0xff6C6C6C),
                                  ),
                            ),
                            validator: validateGropuName,
                            onChanged: (val) {
                              objGroupNotifier.setGroupName = val;
                            },
                          ),

                          ///---------------- Add Member -------------
                          Container(
                            margin: EdgeInsets.only(
                                top: height * 0.035, bottom: height * 0.02),
                            child: Text(
                              TextUtils.AddMember,
                              style: AppTheme.getTheme()
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                      fontSize: width * 0.038,
                                      color: ConstColor.white_Color,
                                      fontWeight: FontWeight.w400),
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                margin: EdgeInsets.only(
                                    right: width * 0.05, bottom: height * 0.01),
                                alignment: Alignment.topRight,
                                child: Text(
                                  TextUtils.ADD,
                                  style: TextStyle(color: primaryColor),
                                )),
                          ),
                          Container(
                              padding: EdgeInsets.only(
                                  top: height * 0.02,
                                  left: width * 0.035,
                                  right: width * 0.03,
                                  bottom: height * 0.02),
                              decoration: objGroupNotifier.wishListItems.isEmpty
                                  ? BoxDecoration()
                                  : BoxDecoration(
                                      border: Border.all(
                                        color: ConstColor.textFormFieldColor,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(height * 0.035),
                                    ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    objGroupNotifier.wishListItems.length,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(children: [
                                            ///------------------------- profile ----------------------------------

                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      height * 0.1),
                                              child: CachedNetworkImage(
                                                imageUrl: objGroupNotifier
                                                    .wishListItems[index]
                                                    .userProfile!,
                                                height: height * 0.045,
                                                width: height * 0.045,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    CircularProgressIndicator(
                                                  color: primaryColor,
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),

                                            ///------------------------- name ----------------------------------

                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: width * 0.03),
                                              child: Text(
                                                objGroupNotifier
                                                        .wishListItems[index]
                                                        .firstName! +
                                                    " " +
                                                    objGroupNotifier
                                                        .wishListItems[index]
                                                        .lastName!,
                                                style: AppTheme.getTheme()
                                                    .textTheme
                                                    .bodyText1!
                                                    .copyWith(
                                                        fontSize: width * 0.045,
                                                        color: ConstColor
                                                            .white_Color,
                                                        fontWeight:
                                                            FontWeight.w400),
                                              ),
                                            ),
                                          ]),
                                          GestureDetector(
                                              onTap: () {
                                                objGroupNotifier.removeItem(
                                                    objGroupNotifier
                                                        .wishListItems[index]
                                                        .firstName!);
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    TextUtils.REMOVE,
                                                    style: AppTheme.getTheme()
                                                        .textTheme
                                                        .bodyText1!
                                                        .copyWith(
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                            fontSize:
                                                                width * 0.035,
                                                            color: ConstColor
                                                                .primaryColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                      objGroupNotifier.wishListItems.last ==
                                              objGroupNotifier
                                                  .wishListItems[index]
                                          ? Container()
                                          : Container(
                                              margin: EdgeInsets.only(
                                                top: height * 0.022,
                                                bottom: height * 0.022,
                                              ),
                                              height: 1,
                                              width: width,
                                              color: ConstColor
                                                  .term_condition_grey_color
                                                  .withOpacity(0.6),
                                            )
                                    ],
                                  );
                                },
                              ))

                          ///------------ add image------------
                          ,
                          imageFile == null || imageFile == ""
                              ? Container(
                                  width: width,
                                  margin: EdgeInsets.only(top: height * 0.03),
                                  padding: EdgeInsets.only(
                                      top: height * 0.025,
                                      left: width * 0.035,
                                      right: width * 0.03,
                                      bottom: height * 0.025),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: ConstColor.textFormFieldColor,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(height * 0.035),
                                  ),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        ConstantData.gallery,
                                        height: height * 0.04,
                                      ),
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
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.all(
                                                                  height *
                                                                      0.02),
                                                          child: Text(
                                                            'GALLERY',
                                                            style: Theme.of(
                                                                    context)
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
                                                      Divider(
                                                        thickness: 2,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          _getFromCamera();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.all(
                                                                  height *
                                                                      0.02),
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
                                                      Divider(
                                                        thickness: 2,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.all(
                                                                  height *
                                                                      0.02),
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
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: height * 0.016,
                                              bottom: height * 0.016),
                                          child: Text(
                                            TextUtils.Click,
                                            style: AppTheme.getTheme()
                                                .textTheme
                                                .bodyText2!
                                                .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: width * 0.043,
                                                  color:
                                                      ConstColor.primaryColor,
                                                ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        TextUtils.JPEG,
                                        style: AppTheme.getTheme()
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                              fontSize: width * 0.043,
                                              color: Color(0xff6C6C6C),
                                            ),
                                      ),
                                    ],
                                  ))
                              : Container(
                                  height: height * 0.2,
                                  width: width,
                                  margin: EdgeInsets.only(top: height * 0.03),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: ConstColor.textFormFieldColor,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(height * 0.035),
                                  ),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(height * 0.035),
                                    child: Image.file(
                                      imageFile!,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final isValid = formKey.currentState!.validate();
                    if (isValid) {
                      if (objGroupNotifier.wishListItems.isEmpty) {
                        ScaffoldSnackbar.of(context)
                            .show("Please add atleast 1 member in group");
                      } else {
                        setState(() {
                          isLoaded = true;
                        });
                        objGroupNotifier.wishListItems.forEach((element) {
                          setState(() {
                            lstGroupUser.add(element.uid!);
                            print(lstGroupUser);
                          });
                        });
                        lstGroupUser
                            .add(FirebaseAuth.instance.currentUser!.uid);
                        var imgurl = imageUrl == "" ? url : imageUrl;
                        var myFile = File('');
                        File file = imageFile == null || imageFile == ""
                            ? myFile
                            : imageFile!;
                        await objGroupNotifier
                            .createGroup(
                          context,
                          _groupNameController.text,
                          imgurl,
                          lstGroupUser,
                          file,
                        )
                            .whenComplete(() async {
                          await ApiProvider().addConversition(
                            objGroupNotifier.objGroupModel.docID!,
                            lstGroupUser,
                          );
                          objGroupNotifier.searchList.forEach((element) {
                            element.isSelcetdForGroup = false;
                          });

                          objGroupNotifier.setGroupName = "";
                          setState(() {
                            isLoaded = false;
                          });
                          Navigator.pop(context);
                        });
                      }
                    }
                  },
                  child: CommonButton(
                    name: TextUtils.Create,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
