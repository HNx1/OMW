import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class Message {
  String id;
  String message;
  String authorId;
  DateTime createdAt;
  DateTime? readAt;
  String? imageUrl;

  bool isGroup = false;
  String senderName;
  String senderProfile;
  bool isBlock = false;

  Message(
      {required this.id,
      required this.message,
      required this.authorId,
      required this.createdAt,
      this.readAt,
      this.imageUrl,
      required this.isGroup,
      required this.senderName,
      required this.senderProfile,
      this.isBlock = false});

  String get time => DateFormat('d/M/yy, h:mm a').format(DateTime.now());
  bool get fromMe => authorId == FirebaseAuth.instance.currentUser!.uid;
}
