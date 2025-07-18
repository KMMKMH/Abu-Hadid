import 'package:abu_hadid_app/classes/widgets.dart';
import 'package:abu_hadid_app/pages/oil.dart';
import 'package:abu_hadid_app/pages/us100.dart';
import 'package:abu_hadid_app/pages/us30.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:abu_hadid_app/pages/gold.dart';
import 'package:abu_hadid_app/classes/Socket.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:abu_hadid_app/chat/chat_service.dart';

import '../api/firebase_api.dart';
import 'chat.dart';

class Home extends StatefulWidget {
  final String uid;
  const Home({
    super.key,
    required this.uid,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final ChatService _chatService = ChatService();

  final Socket socket = Socket();
  final FirebaseApi API = FirebaseApi();

  void initNotify() async {
    socket.InitSocket();
    await API.initNotifications();
    API.Subscribe();
  }

  void launchURLForex() async {
    final Uri url = Uri.parse('https://www.forexfactory.com/news');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  void initState() {
    super.initState();
    print(widget.uid);
    initNotify();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],

        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: 42,
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/abuhadid.jpg'),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                        'ABU HADID',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontFamily: 'Oswald',
                        )
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Text(
                                'Press for payment methods',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 9,
                                  fontFamily: 'Oswald',
                                )
                            ),SizedBox(
                              width: 10,
                            ),
                            Text(
                                'اضغط لمعرفة كيفية الدفع',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 9,
                                  fontFamily: 'Oswald',
                                )
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 35,
                          height: 35,
                            child: HomeInfoButton(context)
                        ),
                      ],
                    ),
                    TextButton(
                        onPressed: () async {
                          final DocumentReference document = FirebaseFirestore.instance.collection("Users").doc('Activity');
                          late dynamic data;
                          data = await document.get();
                          final _fire_base_messaging = FirebaseMessaging.instance;
                          await _fire_base_messaging.requestPermission();
                          String? fCMToken = await _fire_base_messaging.getToken();

                          FirebaseFirestore.instance.collection('Users').doc('Activity').update({
                            'users': FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]),
                          });
                          FirebaseFirestore.instance.collection('Users').doc('Activity').update({
                            'tokens': FieldValue.arrayRemove([fCMToken]),
                          });
                          Navigator.pushReplacementNamed(context, '/login_uid');
                        },
                        child: Text(
                          'Log Out',
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.red
                          ),
                        )
                    ),
                  ],
                ),
              ),
            ],
          ),
          shadowColor: Colors.white,

          centerTitle: true,

          backgroundColor: Colors.amber[200],

        ),

        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                          TextButton(
                              onPressed: () async {
                                final DocumentReference document = FirebaseFirestore.instance.collection("Admins").doc('admins');
                                late dynamic data;
                                data = await document.get();
                                try {
                                  FirebaseAuth.instance.currentUser!.reload();
                                }catch (e) {
                                  FirebaseAuth.instance.signOut();
                                }
                                if (FirebaseAuth.instance.currentUser != null) {
                                  if (data['admins'].contains(widget.uid)) {
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (context) =>
                                        Gold(
                                          admin: true,
                                          socket: socket,
                                        )));
                                  } else {
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (context) =>
                                        Gold(
                                          admin: false,
                                          socket: socket,
                                        )));
                                  }
                                } else {
                                  Navigator.pushReplacementNamed(context, '/login_uid');
                                }
                              },
                              child: Image.asset('assets/Gold_png.jpg')
                          ),
                          Text(
                            'GOLD',
                            style: TextStyle(
                              fontFamily: 'Oswald',
                              fontSize: 13.5,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'الذهب',
                            style: TextStyle(
                              fontFamily: 'Oswald',
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                          TextButton(
                              onPressed: () async {
                                final DocumentReference document = FirebaseFirestore.instance.collection("Admins").doc('admins');
                                late dynamic data;
                                data = await document.get();
                                try {
                                  FirebaseAuth.instance.currentUser!.reload();
                                }catch (e) {
                                  FirebaseAuth.instance.signOut();
                                }
                                if (FirebaseAuth.instance.currentUser != null) {
                                  if (data['admins'].contains(widget.uid)) {
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (context) =>
                                        Oil(
                                          admin: true,
                                          socket: socket,
                                        )));
                                  } else {
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (context) =>
                                        Oil(
                                          admin: false,
                                          socket: socket,
                                        )));
                                  }
                                } else {
                                  Navigator.pushReplacementNamed(context, '/login_uid');
                                }
                              },
                              child: Image.asset('assets/Oil_png.png')
                          ),
                          Text(
                            'OIL',
                            style: TextStyle(
                              fontFamily: 'Oswald',
                              fontSize: 13.5,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'النفط',
                            style: TextStyle(
                              fontFamily: 'Oswald',
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          TextButton(
                              onPressed: () async {
                                final DocumentReference document = FirebaseFirestore.instance.collection("Admins").doc('admins');
                                late dynamic data;
                                data = await document.get();
                                try {
                                  FirebaseAuth.instance.currentUser!.reload();
                                }catch (e) {
                                  FirebaseAuth.instance.signOut();
                                }
                                if (FirebaseAuth.instance.currentUser != null) {
                                  if (data['admins'].contains(widget.uid)) {
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (context) =>
                                        US30(
                                          admin: true,
                                          socket: socket,
                                        )));
                                  } else {
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (context) =>
                                        US30(
                                          admin: false,
                                          socket: socket,
                                        )));
                                  }
                                } else {
                                  Navigator.pushReplacementNamed(context, '/login_uid');
                                }
                              },
                              child: Image.asset('assets/NewDow.jpg')
                          ),
                          Text(
                            'DOWJONES',
                            style: TextStyle(
                              fontFamily: 'Oswald',
                              fontSize: 13.5,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'الداوجونز',
                            style: TextStyle(
                              fontFamily: 'Oswald',
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Column(
                        children: <Widget>[
                          TextButton(
                              onPressed: () async {
                                final DocumentReference document = FirebaseFirestore.instance.collection("Admins").doc('admins');
                                late dynamic data;
                                data = await document.get();
                                try {
                                  FirebaseAuth.instance.currentUser!.reload();
                                }catch (e) {
                                  FirebaseAuth.instance.signOut();
                                }
                                if (FirebaseAuth.instance.currentUser != null) {
                                  if (data['admins'].contains(widget.uid)) {
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (context) =>
                                        US100(
                                          admin: true,
                                          socket: socket,
                                        )));
                                  } else {
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (context) =>
                                        US100(
                                          admin: false,
                                          socket: socket,
                                        )));
                                  }
                                } else {
                                  Navigator.pushReplacementNamed(context, '/login_uid');
                                }
                              },
                              child: Image.asset('assets/NewNas.jpg')
                          ),
                          Text(
                            'NASDAQ',
                            style: TextStyle(
                              fontFamily: 'Oswald',
                              fontSize: 13.5,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'الناسداك',
                            style: TextStyle(
                              fontFamily: 'Oswald',
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 150,
                    height: 160,
                    child: Column(
                      children: <Widget>[
                        TextButton(
                            onPressed: () {
                              try {
                                FirebaseAuth.instance.currentUser!.reload();
                              }catch (e) {
                                FirebaseAuth.instance.signOut();
                              }
                              if (FirebaseAuth.instance.currentUser != null) {
                                launchURLForex();
                              } else {
                                Navigator.pushReplacementNamed(context, '/login_uid');
                              }
                            },
                            child: Icon(
                                Icons.warning_amber_outlined,
                              size: 90,
                              color: Colors.red,
                            )
                        ),
                        Text(
                          'ECONOMIC NEWS',
                          style: TextStyle(
                            fontFamily: 'Oswald',
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'أخبار اقتصادية',
                          style: TextStyle(
                            fontFamily: 'Oswald',
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 320,
                child: Divider(
                  color: Colors.amber[200],
                )
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    color: Colors.amber[200],
                    child: TextButton(
                        onPressed: () async {
                          final DocumentReference document = FirebaseFirestore.instance.collection("Admins").doc('admins');
                          late dynamic data;
                          data = await document.get();
                          try {
                            FirebaseAuth.instance.currentUser!.reload();
                          }catch (e) {
                            FirebaseAuth.instance.signOut();
                          }
                            if (FirebaseAuth.instance.currentUser != null) {
                              if (data['AdminCheck']) {
                                if (data['admins'].contains(widget.uid)) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>
                                          Chat(
                                            admin: true,
                                            socket: socket,
                                          )));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>
                                          Chat(
                                            admin: false,
                                            socket: socket,
                                          )));
                                }
                              }
                              else {
                                if (data['admins'].contains(widget.uid)) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>
                                          Chat(
                                            admin: true,
                                            socket: socket,
                                          )));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>
                                          Chat(
                                            admin: false,
                                            socket: socket,
                                          )));
                                }
                              }
                            } else {
                              Navigator.pushReplacementNamed(context, '/login_uid');
                            }
                        },
                        child: Text(
                            'CHAT',
                          style: TextStyle(
                            fontFamily: 'Oswald',
                            fontSize: 20,
                            color: Colors.grey[900]
                          ),
                        )
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    child: TextButton(
                        onPressed: () async {
                          final DocumentReference document = FirebaseFirestore.instance.collection("Admins").doc('admins');
                          late dynamic data;
                          data = await document.get();
                          try {
                            FirebaseAuth.instance.currentUser!.reload();
                          }catch (e) {
                            FirebaseAuth.instance.signOut();
                          }
                          if (data['admins'].contains(widget.uid)) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.grey[900],
                                  title: Text(
                                    "Are you sure?",
                                    style: TextStyle(
                                        fontFamily: 'Oswald',
                                        color: Colors.amber[200],
                                        fontSize: 28
                                    ),
                                  ),
                                  content: Text(
                                    "Are you Sure you want to clear all data? This will clear all data for ever.",
                                    style: TextStyle(
                                        fontFamily: 'Oswald',
                                        color: Colors.amber[200],
                                        fontSize: 15
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text(
                                        "No",
                                        style: TextStyle(
                                          fontFamily: 'Oswald',
                                          color: Colors.red,
                                        ),
                                      ),
                                      onPressed:  () {
                                        Navigator.of(context, rootNavigator: true).pop(true);
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        "Yes",
                                        style: TextStyle(
                                          fontFamily: 'Oswald',
                                          color: Colors.green,
                                        ),
                                      ),
                                      onPressed: () {
                                        _chatService.ClearData();
                                        print('Data Cleared');
                                        Navigator.of(context, rootNavigator: true).pop(true);
                                      },
                                    ),
                                  ],
                                );
                              });
                          }
                          else {
                            FocusScope.of(context).unfocus();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You have no permission')));
                          }
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.delete,
                              color: Colors.amber[200],
                            ),
                            Text(
                              'Clear all data',
                              style: TextStyle(
                                  fontFamily: 'Oswald',
                                  fontSize: 10,
                                  color: Colors.amber[200]
                              ),
                            ),
                          ],
                        )
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ]
        )
    );
  }
}
