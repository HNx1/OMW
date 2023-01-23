import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:omw/bottom/Events/event/wanttoSendImage.dart';

import 'package:omw/constant/theme.dart';
import 'package:omw/model/groupMessage_model.dart';
import 'package:provider/provider.dart';

import '../../../constant/constants.dart';
import '../../../notifier/authenication_notifier.dart';
import '../../../notifier/chatting_notifier.dart';
import '../../../notifier/event_notifier.dart';
import '../../../utils/colorUtils.dart';
import 'package:intl/intl.dart';

import '../../../utils/textUtils.dart';
import '../../../widget/scaffold_snackbar.dart';

class EventChatPage extends StatefulWidget {
  @override
  State<EventChatPage> createState() => _EventChatPageState();
}

class _EventChatPageState extends State<EventChatPage> {
  final TextEditingController _message = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  bool emojiShowing = false;

  _onEmojiSelected(Emoji emoji) {
    _message
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
        TextPosition(offset: _message.text.length),
      );
  }

  _onBackspacePressed() {
    _message
      ..text = _message.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _message.text.length));
  }

  String imageUrl = "";
  File? imageFile;

  _getFromGallery() async {
    var objCreateEventNotifier =
        Provider.of<CreateEventNotifier>(context, listen: false);
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
              builder: (context) => WantSendImage(
                    imageFile: imageFile!,
                    isImageOpen: false,
                    senderName:
                        "${objProviderNotifier.objUsers.firstName!} ${objProviderNotifier.objUsers.lastName!}",
                    senderprofile: objProviderNotifier.objUsers.userProfile!,
                    eventId: objCreateEventNotifier.EventData.docId!,
                  ))).then((value) {
        setState(() {
          imageUrl = "";
        });
        Navigator.pop(context);
      });
    }
  }

  _getFromCamera() async {
    var objCreateEventNotifier =
        Provider.of<CreateEventNotifier>(context, listen: false);
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
              builder: (context) => WantSendImage(
                    imageFile: imageFile!,
                    isImageOpen: false,
                    senderName:
                        "${objProviderNotifier.objUsers.firstName!} ${objProviderNotifier.objUsers.lastName!}",
                    senderprofile: objProviderNotifier.objUsers.userProfile!,
                    eventId: objCreateEventNotifier.EventData.docId!,
                  ))).then((value) {
        setState(() {
          imageUrl = "";
        });
        Navigator.pop(context);
      });
    }
  }

  @override
  void initState() {
    getuserData();

    super.initState();
  }

  getuserData() async {
    var objProviderNotifier =
        Provider.of<AuthenicationNotifier>(context, listen: false);

    await objProviderNotifier.getUserDetail();
  }

  Future<void> onSendMessage(String content, String eventId, String senderName,
      String senderProfile) async {
    var objChattingNotifier =
        Provider.of<ChattingNotifier>(context, listen: false);
    if (content.trim().isNotEmpty) {
      _message.clear();
      await objChattingNotifier.sendMessages(
          context, eventId, content, "", senderName, senderProfile);
    }
  }

  @override
  Widget build(BuildContext context) {
    var objChattingNotifier = context.watch<ChattingNotifier>();
    var objCreateEventNotifier = context.watch<CreateEventNotifier>();
    var objProviderNotifier = context.watch<AuthenicationNotifier>();

    return Scaffold(
      appBar: AppBar(
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
                    child: CachedNetworkImage(
                      imageUrl: objCreateEventNotifier.getEventData.eventPhoto!,
                      height: height * 0.052,
                      width: height * 0.052,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(
                        color: primaryColor,
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    )),
              ],
            ),

            ///--------------- user name------------------
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: height * 0.02),
                child: Text(
                  objCreateEventNotifier.getEventData.eventname!,
                  style: AppTheme.getTheme().textTheme.bodyText2!.copyWith(
                      color: ConstColor.primaryColor,
                      overflow: TextOverflow.ellipsis,
                      height: 1.4,
                      fontSize: width * 0.051),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: chatListView(objChattingNotifier, objCreateEventNotifier,
                  objProviderNotifier),
            ),
          ),
          chatKeybord(objChattingNotifier, objCreateEventNotifier)
        ],
      ),
    );
  }

  List<QueryDocumentSnapshot> listMessage = [];
  Widget chatListView(
      ChattingNotifier objChattingNotifier,
      CreateEventNotifier objCreateEventNotifier,
      AuthenicationNotifier objProviderNotifier) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: StreamBuilder(
        stream: objChattingNotifier
            .getChatStream(objCreateEventNotifier.EventData.docId!),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            listMessage = snapshot.data!.docs;
            if (listMessage.isNotEmpty) {
              return ListView.builder(
                padding: EdgeInsets.only(
                    left: height * 0.02,
                    right: height * 0.02,
                    bottom: height * 0.01),
                itemCount: listMessage.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  GroupMessageModel messageChat =
                      GroupMessageModel.parseSnapshot(
                          snapshot.data!.docs[index]);
                  return Column(
                    crossAxisAlignment:
                        messageChat.authorId == _auth.currentUser!.uid
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                    children: [
                      messageChat.authorId != _auth.currentUser!.uid
                          ? Stack(
                              alignment: Alignment.topLeft,
                              children: [
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(height * 0.1),
                                  child: messageChat.senderProfile == null ||
                                          messageChat.senderProfile == ""
                                      ? const CircularProgressIndicator(
                                          color: primaryColor,
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: messageChat.senderProfile!,
                                          height: height * 0.052,
                                          width: height * 0.052,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(
                                            color: primaryColor,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                ),
                                messageChat.imageUrl != "" &&
                                        messageChat.imageUrl != null
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
                                                borderRadius:
                                                    const BorderRadius.only(
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
                                                  messageChat.senderName!,
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
                                                                WantSendImage(
                                                                  senderName:
                                                                      "${objProviderNotifier.objUsers.firstName!} ${objProviderNotifier.objUsers.lastName!}",
                                                                  senderprofile:
                                                                      objProviderNotifier
                                                                          .objUsers
                                                                          .userProfile!,
                                                                  isImageOpen:
                                                                      true,
                                                                  imageUrl:
                                                                      messageChat
                                                                          .imageUrl!,
                                                                  eventId: objCreateEventNotifier
                                                                      .EventData
                                                                      .docId!,
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
                                                      messageChat.imageUrl!,
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
                                              messageChat.createdAt!.day ==
                                                      DateTime.now().day
                                                  ? DateFormat('h:mm aa')
                                                      .format(messageChat
                                                          .createdAt!)
                                                      .toLowerCase()
                                                  : DateFormat(
                                                          'dd/M/yyyy h:mm aa')
                                                      .format(messageChat
                                                          .createdAt!)
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
                                                      const BorderRadius.only(
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
                                                    messageChat.senderName!,
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
                                                    messageChat.message!,
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
                                                messageChat.createdAt!.day ==
                                                        DateTime.now().day
                                                    ? DateFormat('h:mm aa')
                                                        .format(messageChat
                                                            .createdAt!)
                                                        .toLowerCase()
                                                    : DateFormat(
                                                            'dd/M/yyyy h:mm aa')
                                                        .format(messageChat
                                                            .createdAt!)
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
                                messageChat.imageUrl != "" &&
                                        messageChat.imageUrl != null
                                    ? GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      WantSendImage(
                                                        senderName:
                                                            "${objProviderNotifier.objUsers.firstName!} ${objProviderNotifier.objUsers.lastName!}",
                                                        senderprofile:
                                                            objProviderNotifier
                                                                .objUsers
                                                                .userProfile!,
                                                        eventId:
                                                            objCreateEventNotifier
                                                                .EventData
                                                                .docId!,
                                                        isImageOpen: true,
                                                        imageUrl: messageChat
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
                                            messageChat.imageUrl!,
                                            width: height * 0.15,
                                            height: height * 0.15,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      )
                                    : Container(
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
                                              messageChat.message!,
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
                                Container(
                                  padding: EdgeInsets.zero,
                                  margin: EdgeInsets.only(
                                      top: height * 0.01, left: height * 0.04),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        messageChat.createdAt!.day ==
                                                DateTime.now().day
                                            ? DateFormat('h:mm aa')
                                                .format(messageChat.createdAt!)
                                                .toLowerCase()
                                            : DateFormat('dd/M/yyyy h:mm aa')
                                                .format(messageChat.createdAt!)
                                                .toLowerCase(),
                                        style: AppTheme.getTheme()
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                                color: ConstColor.primaryColor,
                                                height: 1.4,
                                                fontSize: width * 0.032),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                    ],
                  );
                },
              );
            } else {
              return const Center(child: Text("No message here yet..."));
            }
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget chatKeybord(ChattingNotifier objChattingNotifier,
      CreateEventNotifier objCreateEventNotifier) {
    var objProviderNotifier =
        Provider.of<AuthenicationNotifier>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
                padding: EdgeInsets.only(
                    left: width * 0.03,
                    right: width * 0.03,
                    top: height * 0.03,
                    bottom: height * 0.03),
                color: const Color(0xff0E0E0E),
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
                        controller: _message,
                        style:
                            AppTheme.getTheme().textTheme.bodyText1!.copyWith(
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
                              horizontal: width * 0.02,
                              vertical: height * 0.01),
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
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
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
                          fillColor: const Color(0xff999999).withOpacity(0.2),
                          filled: true,
                          hintStyle: AppTheme.getTheme()
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  fontSize: width * 0.04,
                                  color: const Color(0xff888888)),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (_message.text != "") {
                          onSendMessage(
                              _message.text,
                              objCreateEventNotifier.EventData.docId!,
                              "${objProviderNotifier.objUsers.firstName!} ${objProviderNotifier.objUsers.lastName!}",
                              objProviderNotifier.objUsers.userProfile!);
                        } else {
                          ScaffoldSnackbar.of(context)
                              .show("Turn on the data and retry again");
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
            isLoading
                ? const CircularProgressIndicator(
                    color: primaryColor,
                  )
                : Container(),
          ],
        ),
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
          color: const Color(0xff0E0E0E),
          height: height * 0.2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  _getFromCamera();
                },
                child: commanButton(
                  ConstantData.camera,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _getFromGallery();
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
