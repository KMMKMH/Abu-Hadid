import 'package:cloud_firestore/cloud_firestore.dart';

class Signal {
  final String senderUid;
  final String positivity;
  final String supportPoints;
  final String resistancePoints;
  final String analysis;
  final Timestamp timestamp;
  final List<String> likes;


  Signal({
    required this.senderUid,
    required this.positivity,
    required this.supportPoints,
    required this.resistancePoints,
    required this.analysis,
    required this.timestamp,
    required this.likes,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderUid': senderUid,
      'positivity': positivity,
      'supportPoints': supportPoints,
      'resistancePoints': resistancePoints,
      'analysis': analysis,
      'timestamp': timestamp,
      'likes':[],
    };
  }
}
