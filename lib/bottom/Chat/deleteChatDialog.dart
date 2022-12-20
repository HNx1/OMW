import 'package:flutter/material.dart';
import 'package:omw/constant/constants.dart';
import 'package:omw/constant/theme.dart';
import 'package:omw/notifier/AllChatingFunctions.dart';

import '../../model/chatMessage_model.dart';
import '../../utils/colorUtils.dart';

class DeleteChatMessage extends StatefulWidget {
  final Message messages;
  final AllChat chat;
  const DeleteChatMessage(
      {Key? key, required this.messages, required this.chat})
      : super(key: key);

  @override
  State<DeleteChatMessage> createState() => _DeleteChatMessageState();
}

class _DeleteChatMessageState extends State<DeleteChatMessage> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 15, 15, 15),
      title: Container(
        margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02),
        child: Text(
          "Unsend message To ${widget.chat.friendUsername}?",
          style: AppTheme.getTheme().textTheme.bodyText1!.copyWith(
              color: ConstColor.white_Color,
              height: 1.4,
              fontSize: width * 0.043),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Text(
            "CANCEL",
            style: AppTheme.getTheme().textTheme.bodyText2!.copyWith(
                color: ConstColor.primaryColor,
                height: 1.4,
                fontSize: width * 0.04),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02),
          child: GestureDetector(
            onTap: () async {
              await widget.chat
                  .deleteMessage(widget.messages.id)
                  .whenComplete(() {
                Navigator.pop(context);
              });
              setState(() {});
            },
            child: Text(
              "DELETE",
              style: AppTheme.getTheme().textTheme.bodyText2!.copyWith(
                  color: ConstColor.primaryColor,
                  height: 1.4,
                  fontSize: width * 0.04),
            ),
          ),
        ),
      ],
    );
  }
}
