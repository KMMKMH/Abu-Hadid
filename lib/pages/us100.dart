import 'package:abu_hadid_app/chat/chat_service.dart';
import 'package:abu_hadid_app/pages/us100Signal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:abu_hadid_app/classes/Socket.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class US100 extends StatefulWidget {
  final bool admin;
  final Socket socket;
  const US100({
    super.key,
    required this.admin,
    required this.socket,
  });

  @override
  State<US100> createState() => _US100State();
}

class _US100State extends State<US100> {

  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        shadowColor: Colors.white,
        backgroundColor: Colors.amber[200],
        title: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 80, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.attach_money,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                    Text(
                        'US100',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontFamily: 'Oswald',
                        )
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildSignalList(),
          ),
          _buildSignalsAdder(widget.admin),
          SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }

  Widget _buildSignalList() {
    return StreamBuilder(stream: _chatService.getSignalsFromUS100(), builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text(
          'Error${snapshot.error}',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        )
        );
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: const SpinKitPouringHourGlass(color: Colors.green)
        );
      }

      return ListView(
        children: snapshot.data!.docs.map((document) => _buildSignalItem(document)).toList(),
      );
    }
    );
  }

  Widget _buildSignalItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Card(
          color: Colors.amber[200],
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                child: Center(
                  child: Text(
                    data['senderUid'],
                    style: TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        'الناسداك : ${data['positivity']}',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'نقاط الدعم : ${data['supportPoints']}',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'نقاط المقاومة : ${data['resistancePoints']}',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        """
: التحليل اليومي
   
${data['analysis']}
                      """,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        if (widget.admin) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  TextButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                      },
                                      child: Text(
                                          'Cancel'
                                      )
                                  ),

                                  TextButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance.collection('signal_room').doc('us100_room').collection('signals').doc(document.id).delete();
                                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                      },
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(
                                            color: Colors.red
                                        ),
                                      )
                                  ),
                                ],
                              )
                              )
                          );
                        }else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('You have no permission'))
                          );
                        };
                      },
                      icon: Icon(
                        Icons.delete,
                      )
                  ),
                ],
              )
            ],
          )
      ),
    );
  }

  Widget _buildSignalsAdder(bool admin) {
    return FloatingActionButton(
      onPressed: () {
        if (admin) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => US100Signal(
            socket: widget.socket,
          )));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('You have no permission'))
          );
        }
      },
      backgroundColor: Colors.amber[200],
      child: Icon(
        Icons.add,
        color: Colors.grey[900],
      ),
    );
  }

}