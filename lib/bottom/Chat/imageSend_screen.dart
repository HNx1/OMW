import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:omw/constant/constants.dart';
import 'package:omw/utils/colorUtils.dart';

import '../../notifier/AllChatingFunctions.dart';
import '../../notifier/notication_notifier.dart';
import '../../widget/scaffold_snackbar.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class IsImageSending extends StatefulWidget {
  final File? imageFile;
  final AllChat? chat;
  final bool isImageOpen;
  final String? imageUrl;
  final String senderName;
  final String senderprofile;

  const IsImageSending({
    Key? key,
    this.imageFile,
    this.chat,
    required this.isImageOpen,
    required this.senderName,
    required this.senderprofile,
    this.imageUrl,
  }) : super(key: key);

  @override
  State<IsImageSending> createState() => _IsImageSendingState();
}

class _IsImageSendingState extends State<IsImageSending> {
  bool isloader = false;
  @override
  void dispose() {
    (mounted);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final objNotificationNotifier = context.watch<NotificationNotifier>();

    return widget.isImageOpen == true
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: ConstColor.black_Color,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(height * 0.02),
                    child: Image.network(
                      widget.imageUrl!,
                      height: height * 0.7,
                      width: width,
                      fit: BoxFit.fill,
                    ),
                  )
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: ConstColor.black_Color,
            ),
            floatingActionButton: FloatingActionButton(
              heroTag: "btn2",
              backgroundColor: primaryColor,
              child: Icon(
                Icons.send,
                size: width * 0.09,
              ),
              onPressed: () async {
                await objNotificationNotifier.checkConnection();
                if (objNotificationNotifier.isConnected == true) {
                  if (widget.imageFile != null && widget.imageFile != "") {
                    setState(() {
                      isloader = true;
                    });
                    var imageName = widget.imageFile!.path.split('/').last;
                    print(imageName);
                    var snapshot = await FirebaseStorage.instance
                        .ref()
                        .child(imageName)
                        .putFile(widget.imageFile!);
                    var downloadUrl = await snapshot.ref.getDownloadURL();
                    String imageUrl = downloadUrl;
                    await widget.chat!
                        .sendMessage(
                            "",
                            false,
                            imageUrl == "" ? "" : imageUrl,
                            [widget.chat!.friendId, _auth.currentUser!.uid],
                            widget.senderName,
                            widget.senderprofile,
                            false)
                        .whenComplete(() {
                      setState(() {
                        isloader = false;
                      });
                    });
                    Navigator.pop(context);
                  }
                } else {
                  ScaffoldSnackbar.of(context)
                      .show("Turn on the data and retry again");
                }
              },
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.only(top: height * 0.02),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.all(height * 0.02),
                    child: Image.file(
                      widget.imageFile!,
                      height: height * 0.7,
                      width: width,
                      fit: BoxFit.fill,
                    ),
                  ),
                  isloader == true
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          );
  }
}
