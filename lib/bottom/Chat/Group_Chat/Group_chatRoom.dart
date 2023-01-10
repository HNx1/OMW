import 'package:flutter/material.dart';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:omw/bottom/Chat/deleteChatDialog.dart';
import 'package:omw/bottom/Chat/imageSend_screen.dart';
import 'package:omw/constant/constants.dart';
import 'package:omw/utils/colorUtils.dart';
import 'package:omw/widget/scaffoldSnackbar.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';

import '../../../constant/theme.dart';

import '../../../notifier/AllChatingFunctions.dart';
import '../../../notifier/authenication_notifier.dart';
import '../../../notifier/notication_notifier.dart';
import '../../../utils/textUtils.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class GropChatPage extends StatefulWidget {
  final AllChat chat;
  final List<AllChat> groupChats;

  GropChatPage({Key? key, required this.chat, required this.groupChats})
      : super(key: key);

  @override
  State<GropChatPage> createState() => _GropChatPageState();
}

class _GropChatPageState extends State<GropChatPage> {
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    widget.chat.markAsRead().then((value) {
      if (mounted) {
        setState(() {});
      }
    });
    var objProviderNotifier =
        Provider.of<AuthenicationNotifier>(context, listen: false);
    await objProviderNotifier.getUserDetail();
    widget.chat.isOpen = true;
  }

  bool emojiShowing = false;

  _onEmojiSelected(Emoji emoji) {
    messageController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: messageController.text.length));
  }

  _onBackspacePressed() {
    messageController
      ..text = messageController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: messageController.text.length));
  }

  String imageUrl = "";
  File? imageFile;

  _getFromGallery() async {
    var objProviderNotifier =
        Provider.of<AuthenicationNotifier>(context, listen: false);
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        imageUrl = pickedFile.path;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => IsImageSending(
                    senderName:
                        '${objProviderNotifier.objUsers.firstName! + " " + objProviderNotifier.objUsers.lastName!}',
                    senderprofile: objProviderNotifier.objUsers.userProfile!,
                    imageFile: imageFile!,
                    chat: widget.chat,
                    isImageOpen: false,
                  ))).then((value) {
        setState(() {
          imageUrl = "";
        });
        Navigator.pop(context);
      });
    }
  }

  _getFromCamera() async {
    var objProviderNotifier =
        Provider.of<AuthenicationNotifier>(context, listen: false);
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        imageUrl = pickedFile.path;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => IsImageSending(
                    senderName:
                        '${objProviderNotifier.objUsers.firstName! + " " + objProviderNotifier.objUsers.lastName!}',
                    senderprofile: objProviderNotifier.objUsers.userProfile!,
                    imageFile: imageFile!,
                    chat: widget.chat,
                    isImageOpen: false,
                  ))).then((value) {
        setState(() {
          imageUrl = "";
        });
        Navigator.pop(context);
      });
    }
  }

  @override
  void dispose() {
    widget.chat.isOpen = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final objNotificationNotifier = context.watch<NotificationNotifier>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: height * 0.1,
        backgroundColor: ConstColor.black_Color,
        leading: Container(),
        leadingWidth: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ///---------------- Back Arrow----------
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: ConstColor.primaryColor,
                size: width * 0.06,
              ),
            ),
            Stack(
              alignment: Alignment.topRight,
              children: [
                ///-------------- profile image------------------

                ClipRRect(
                    borderRadius: BorderRadius.circular(height * 0.1),
                    child: widget.chat.UserProfile == null
                        ? Image.asset(
                            ConstantData.addContact,
                            height: height * 0.055,
                            color: Colors.white,
                            fit: BoxFit.cover,
                          )
                        : CachedNetworkImage(
                            imageUrl: widget.chat.UserProfile!,
                            height: height * 0.052,
                            width: height * 0.052,
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

            ///--------------- user name------------------
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  left: height * 0.02,
                ),
                child: Text(
                  widget.chat.friendUsername!,
                  style: AppTheme.getTheme().textTheme.bodyText2!.copyWith(
                        color: ConstColor.primaryColor,
                        overflow: TextOverflow.ellipsis,
                        height: 1.4,
                        fontSize: width * 0.051,
                      ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(height * 0.01)),
              onSelected: (item) async {
                await widget.chat
                    .leaveGroup(widget.chat.conversationId!)
                    .then((value) {
                  widget.groupChats.removeWhere((element) =>
                      element.conversationId == widget.chat.conversationId!);
                  Navigator.pop(context);
                });
              },
              itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      height: height * 0.06,
                      padding: EdgeInsets.zero,
                      value: 1,
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                left: width * 0.02, right: width * 0.02),
                            child: Icon(
                              Icons.block_flipped,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            child: Text(
                              "leave Group",
                              style: AppTheme.getTheme()
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                      color: ConstColor.black_Color,
                                      height: 1.4,
                                      fontSize: width * 0.043),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
        ],
      ),
      body: Column(
        children: [
          widget.chat.messages == null || widget.chat.messages!.isEmpty
              ? Expanded(
                  child: Container(
                    margin:
                        EdgeInsets.only(top: AppBar().preferredSize.height * 2),
                    child: Center(
                      child: Text(
                        "",
                        style:
                            AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                                  fontSize: width * 0.041,
                                  color: ConstColor.white_Color,
                                ),
                      ),
                    ),
                  ),
                )
              : Expanded(
                  child: SingleChildScrollView(
                    reverse: true,
                    child: chatListView(),
                  ),
                ),
          chatKeybord(objNotificationNotifier)
        ],
      ),
    );
  }

  Widget chatListView() {
    var objProviderNotifier =
        Provider.of<AuthenicationNotifier>(context, listen: false);
    return ValueListenableBuilder(
      valueListenable: widget.chat.notifier,
      builder: (context, _, __) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                    left: height * 0.02,
                    right: height * 0.02,
                    bottom: height * 0.01),
                itemCount: widget.chat.messages!.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    crossAxisAlignment: widget.chat.messages![index].authorId ==
                            _auth.currentUser!.uid
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      widget.chat.messages![index].authorId !=
                              _auth.currentUser!.uid
                          ? Stack(
                              alignment: Alignment.topLeft,
                              children: [
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(height * 0.1),
                                  child: widget.chat.messages![index]
                                                  .senderProfile ==
                                              null ||
                                          widget.chat.messages![index]
                                                  .senderProfile ==
                                              ""
                                      ? CircularProgressIndicator(
                                          color: primaryColor,
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: widget.chat.messages![index]
                                              .senderProfile,
                                          height: height * 0.052,
                                          width: height * 0.052,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(
                                            color: primaryColor,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                ),
                                widget.chat.messages![index].imageUrl != "" &&
                                        widget.chat.messages![index].imageUrl !=
                                            null
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: height * 0.01,
                                                right: height * 0.01,
                                                bottom: height * 0.01,
                                                top: height * 0.01),
                                            margin: EdgeInsets.only(
                                                left: width * 0.14),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(10.0),
                                                  topRight:
                                                      Radius.circular(10.0),
                                                  bottomRight:
                                                      Radius.circular(10.0),
                                                ),
                                                border: Border.all(
                                                    width: 2,
                                                    color: ConstColor
                                                        .textFormFieldColor)),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  widget.chat.messages![index]
                                                      .senderName,
                                                  style: AppTheme.getTheme()
                                                      .textTheme
                                                      .bodyText1!
                                                      .copyWith(
                                                          color: ConstColor
                                                              .primaryColor,
                                                          height: 1.4,
                                                          fontSize:
                                                              width * 0.036),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                IsImageSending(
                                                                  senderName:
                                                                      '${objProviderNotifier.objUsers.firstName! + " " + objProviderNotifier.objUsers.lastName!}',
                                                                  senderprofile:
                                                                      objProviderNotifier
                                                                          .objUsers
                                                                          .userProfile!,
                                                                  isImageOpen:
                                                                      true,
                                                                  imageUrl: widget
                                                                      .chat
                                                                      .messages![
                                                                          index]
                                                                      .imageUrl!,
                                                                )));
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            FocusNode());
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                      top: height * 0.01,
                                                    ),
                                                    child: Image.network(
                                                      widget
                                                          .chat
                                                          .messages![index]
                                                          .imageUrl!,
                                                      width: height * 0.15,
                                                      height: height * 0.15,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                              left: width * 0.14,
                                              top: height * 0.01,
                                            ),
                                            padding: EdgeInsets.zero,
                                            child: Text(
                                              widget.chat.messages![index]
                                                          .createdAt.day ==
                                                      DateTime.now().day
                                                  ? DateFormat('h:mm aa')
                                                      .format(widget
                                                          .chat
                                                          .messages![index]
                                                          .createdAt)
                                                      .toLowerCase()
                                                  : DateFormat(
                                                          'dd/M/yyyy h:mm aa')
                                                      .format(widget
                                                          .chat
                                                          .messages![index]
                                                          .createdAt)
                                                      .toLowerCase(),
                                              style: AppTheme.getTheme()
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(
                                                      color: ConstColor
                                                          .primaryColor,
                                                      height: 1.4,
                                                      fontSize: width * 0.032),
                                            ),
                                          )
                                        ],
                                      )
                                    : Container(
                                        margin:
                                            EdgeInsets.only(left: width * 0.14),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                top: height * 0.02,
                                                right: width * 0.25,
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: width * 0.02,
                                              ),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10.0),
                                                    topRight:
                                                        Radius.circular(10.0),
                                                    bottomRight:
                                                        Radius.circular(10.0),
                                                  ),
                                                  border: Border.all(
                                                      color: ConstColor
                                                          .textFormFieldColor)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    widget.chat.messages![index]
                                                        .senderName,
                                                    style: AppTheme.getTheme()
                                                        .textTheme
                                                        .bodyText1!
                                                        .copyWith(
                                                            color: ConstColor
                                                                .primaryColor,
                                                            height: 1.4,
                                                            fontSize:
                                                                width * 0.036),
                                                  ),
                                                  Text(
                                                    widget.chat.messages![index]
                                                        .message,
                                                    style: AppTheme.getTheme()
                                                        .textTheme
                                                        .bodyText1!
                                                        .copyWith(
                                                            color: ConstColor
                                                                .white_Color,
                                                            height: 1.4,
                                                            fontSize:
                                                                width * 0.036),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.zero,
                                              margin: EdgeInsets.only(
                                                top: height * 0.01,
                                              ),
                                              child: Text(
                                                widget.chat.messages![index]
                                                            .createdAt.day ==
                                                        DateTime.now().day
                                                    ? DateFormat('h:mm aa')
                                                        .format(widget
                                                            .chat
                                                            .messages![index]
                                                            .createdAt)
                                                        .toLowerCase()
                                                    : DateFormat(
                                                            'dd/M/yyyy h:mm aa')
                                                        .format(widget
                                                            .chat
                                                            .messages![index]
                                                            .createdAt)
                                                        .toLowerCase(),
                                                style: AppTheme.getTheme()
                                                    .textTheme
                                                    .bodyText1!
                                                    .copyWith(
                                                        color: ConstColor
                                                            .primaryColor,
                                                        height: 1.4,
                                                        fontSize:
                                                            width * 0.032),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                widget.chat.messages![index].imageUrl != "" &&
                                        widget.chat.messages![index].imageUrl !=
                                            null
                                    ? GestureDetector(
                                        onLongPress: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return DeleteChatMessage(
                                                chat: widget.chat,
                                                messages: widget
                                                    .chat.messages![index],
                                              );
                                            },
                                          ).then((value) {
                                            setState(() {});
                                          });
                                        },
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      IsImageSending(
                                                        senderName:
                                                            '${objProviderNotifier.objUsers.firstName! + " " + objProviderNotifier.objUsers.lastName!}',
                                                        senderprofile:
                                                            objProviderNotifier
                                                                .objUsers
                                                                .userProfile!,
                                                        chat: widget.chat,
                                                        isImageOpen: true,
                                                        imageUrl: widget
                                                            .chat
                                                            .messages![index]
                                                            .imageUrl!,
                                                      )));
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                            top: height * 0.015,
                                          ),
                                          child: Image.network(
                                            widget.chat.messages![index]
                                                .imageUrl!,
                                            width: height * 0.15,
                                            height: height * 0.15,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                        onLongPress: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return DeleteChatMessage(
                                                chat: widget.chat,
                                                messages: widget
                                                    .chat.messages![index],
                                              );
                                            },
                                          ).then((value) {
                                            setState(() {});
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                            top: height * 0.015,
                                            left: width * 0.4,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: width * 0.03,
                                            vertical: height * 0.02,
                                          ),
                                          decoration: const BoxDecoration(
                                            color: primaryColor,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.0),
                                              topRight: Radius.circular(10.0),
                                              bottomLeft: Radius.circular(10.0),
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                widget.chat.messages![index]
                                                    .message,
                                                style: AppTheme.getTheme()
                                                    .textTheme
                                                    .bodyText1!
                                                    .copyWith(
                                                        color: Colors.black,
                                                        fontSize: width * 0.039,
                                                        fontWeight:
                                                            FontWeight.w600),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                Container(
                                  padding: EdgeInsets.zero,
                                  margin: EdgeInsets.only(
                                      top: height * 0.01, left: height * 0.04),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        widget.chat.messages![index].createdAt
                                                    .day ==
                                                DateTime.now().day
                                            ? DateFormat('h:mm aa')
                                                .format(widget.chat
                                                    .messages![index].createdAt)
                                                .toLowerCase()
                                            : DateFormat('dd/M/yyyy h:mm aa')
                                                .format(widget.chat
                                                    .messages![index].createdAt)
                                                .toLowerCase(),
                                        style: AppTheme.getTheme()
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                                color: ConstColor.primaryColor,
                                                height: 1.4,
                                                fontSize: width * 0.032),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.only(left: width * 0.02),
                                        child: Image.asset(
                                          ConstantData.doubleClick,
                                          height: height * 0.023,
                                          width: height * 0.023,
                                          color: widget.chat.messages![index]
                                                      .readAt ==
                                                  null
                                              ? ConstColor.white_Color
                                              : primaryColor,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget chatKeybord(NotificationNotifier objNotificationNotifier) {
    var objProviderNotifier =
        Provider.of<AuthenicationNotifier>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
            padding: EdgeInsets.only(
                left: width * 0.03,
                right: width * 0.03,
                top: height * 0.03,
                bottom: height * 0.03),
            color: Color(0xff0E0E0E),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    onTap: () {
                      setState(() {
                        emojiShowing = false;
                      });
                    },
                    onFieldSubmitted: (val) {
                      setState(() {
                        emojiShowing = false;
                      });
                    },
                    controller: messageController,
                    style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
                          fontSize: width * 0.041,
                          color: ConstColor.white_Color,
                        ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(height * 0.1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(height * 0.1),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(height * 0.1),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(height * 0.1),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(height * 0.1),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: width * 0.02, vertical: height * 0.01),
                      prefixIcon: Container(
                        margin: EdgeInsets.all(height * 0.015),
                        child: GestureDetector(
                          onTap: () {
                            setState(
                              () {
                                emojiShowing = !emojiShowing;
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              },
                            );
                          },
                          child: Image.asset(
                            ConstantData.emojismile,
                            height: height * 0.01,
                            width: height * 0.01,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      suffixIcon: Container(
                        margin: EdgeInsets.all(height * 0.017),
                        child: GestureDetector(
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (BuildContext context) {
                                return _buildAttachMentPopupDialog();
                              },
                            );
                          },
                          child: Image.asset(
                            ConstantData.attach,
                            height: height * 0.007,
                            width: height * 0.007,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      hintText: TextUtils.type,
                      fillColor: Color(0xff999999).withOpacity(0.2),
                      filled: true,
                      hintStyle: AppTheme.getTheme()
                          .textTheme
                          .bodyText1!
                          .copyWith(
                              fontSize: width * 0.04, color: Color(0xff888888)),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (messageController.text.trim() != "") {
                      await objNotificationNotifier.checkConnection();
                      if (objNotificationNotifier.isConnected == true) {
                        await widget.chat
                            .sendMessage(
                          messageController.text,
                          true,
                          "",
                          widget.chat.Member!,
                          "${objProviderNotifier.objUsers.firstName! + " " + objProviderNotifier.objUsers.lastName!}",
                          objProviderNotifier.objUsers.userProfile!,
                          false,
                        )
                            .whenComplete(() {
                          // setState(() {});
                          // setState(() {});
                        });

                        setState(() {
                          messageController.clear();
                        });
                      } else {
                        ScaffoldSnackbar.of(context)
                            .show("Turn on the data and retry again");
                      }
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: width * 0.03),
                    child: CircleAvatar(
                      radius: height * 0.025,
                      backgroundColor: primaryColor,
                      child: Image.asset(
                        ConstantData.send,
                        width: height * 0.03,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              ],
            )),
        emojiShowing
            ? Offstage(
                offstage: !emojiShowing,
                child: SizedBox(
                  height: 250,
                  child: EmojiPicker(
                    onEmojiSelected: (Category? category, Emoji emoji) {
                      _onEmojiSelected(
                        emoji,
                      );
                    },
                    onBackspacePressed: _onBackspacePressed,
                    config: Config(
                      columns: 7,
                      emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                      verticalSpacing: 0,
                      horizontalSpacing: 0,
                      initCategory: Category.RECENT,
                      bgColor: AppTheme.getTheme().backgroundColor,
                      indicatorColor: Colors.blue,
                      iconColor: Colors.grey,
                      iconColorSelected: Colors.blue,
                      backspaceColor: Colors.blue,
                      skinToneDialogBgColor:
                          AppTheme.getTheme().backgroundColor,
                      skinToneIndicatorColor: Colors.grey,
                      enableSkinTones: true,
                      showRecentsTab: true,
                      recentsLimit: 28,
                      tabIndicatorAnimDuration: kTabScrollDuration,
                      categoryIcons: const CategoryIcons(),
                      buttonMode: ButtonMode.MATERIAL,
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  Widget _buildAttachMentPopupDialog() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.only(left: width * 0.03, right: width * 0.03),
          color: Color(0xff0E0E0E),
          height: height * 0.2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  _getFromCamera();
                  //  Navigator.pop(context);
                },
                child: commanButton(
                  ConstantData.camera,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _getFromGallery();
                  // Navigator.pop(context);
                },
                child: commanButton(
                  ConstantData.gallery,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget commanButton(String image) {
    return Container(
      margin: EdgeInsets.only(left: width * 0.03, right: width * 0.03),
      child: CircleAvatar(
        radius: height * 0.05,
        backgroundColor: primaryColor,
        child: Image.asset(
          image,
          color: ConstColor.black_Color,
          height: height * 0.043,
        ),
      ),
    );
  }
}
