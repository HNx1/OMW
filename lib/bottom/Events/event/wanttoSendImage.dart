import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:omw/constant/constants.dart';
import 'package:omw/utils/colorUtils.dart';

import '../../../notifier/chatting_notifier.dart';
import '../../../notifier/notication_notifier.dart';
import '../../../widget/scaffoldSnackbar.dart';


class WantSendImage extends StatefulWidget {
  final File? imageFile;
  final bool isImageOpen;
  final String? imageUrl;
  final String senderName;
  final String senderprofile;
  final String eventId;

  const WantSendImage(
      {Key? key,
      this.imageFile,
      required this.isImageOpen,
      required this.senderName,
      required this.senderprofile,
      this.imageUrl,
      required this.eventId})
      : super(key: key);

  @override
  State<WantSendImage> createState() => _WantSendImageState();
}

class _WantSendImageState extends State<WantSendImage> {
  bool isloader = false;
  @override
  void dispose() {
    (mounted);
    super.dispose();
  }

  void onSendMessage(
      String image, String eventId, String senderName, String senderProfile) {
    var objChattingNotifier =
        Provider.of<ChattingNotifier>(context, listen: false);
    objChattingNotifier.sendMessages(
        context, eventId, "", image, senderName, senderProfile);
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
                    onSendMessage(
                        imageUrl == "" ? "" : imageUrl,
                        widget.eventId,
                        widget.senderName,
                        widget.senderprofile);
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
                      ? Center(
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
