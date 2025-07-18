import 'package:abu_hadid_app/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      if (FirebaseAuth.instance.currentUser == null) {
        Navigator.pushReplacementNamed(context, '/login_uid');
      }
      else {
        try {
          FirebaseAuth.instance.currentUser!.reload();
        }catch (e) {
          FirebaseAuth.instance.signOut();
        }
        Future.delayed(Duration(seconds: 2), () async {
          if (FirebaseAuth.instance.currentUser != null) {
            final DocumentReference document = FirebaseFirestore.instance.collection("Users").doc('Activity');
            late dynamic data;
            data = await document.get();
            final _fire_base_messaging = FirebaseMessaging.instance;
            await _fire_base_messaging.requestPermission();
            String? fCMToken = await _fire_base_messaging.getToken();

            if (!data['users'].contains(FirebaseAuth.instance.currentUser!.uid)) {
              Navigator.pushReplacementNamed(context, '/login_uid');
            }else {
              if (data['tokens'].contains(fCMToken)) {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) =>
                    Home(
                      uid: FirebaseAuth.instance.currentUser!.uid,
                    )));
              } else {
                Navigator.pushReplacementNamed(context, '/login_uid');
              }
            }
          } else {
            Navigator.pushReplacementNamed(context, '/login_uid');
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(
            height: 300,
          ),
          SpinKitWave(
            color: Colors.amber,
          ),
          SizedBox(
            height: 50,
          ),
          Text(
            'TIME is MONEY',
            style: TextStyle(
              fontFamily: 'DancingScript',
              color: Colors.white,
              fontSize: 40,
            ),
          )
        ],
      )
    );
  }
}
