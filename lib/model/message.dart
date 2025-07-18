import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderUid;
  final String message;
  final String audioname;
  final Timestamp timestamp;
  final List<String> likes;
  final String imagename;

  Message({
    required this.senderUid,
    required this.message,
    required this.timestamp,
    required this.likes,
    required this.audioname,
    required this.imagename,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderUid': senderUid,
      'message': message,
      'timestamp': timestamp,
      'likes':[],
      'audioname': audioname,
      'imagename': imagename,
    };
  }
}

