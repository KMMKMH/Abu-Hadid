import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:abu_hadid_app/classes//widgets.dart';
import 'package:abu_hadid_app/pages/home.dart';
import 'package:abu_hadid_app/classes/widgets.dart' as widgets;
import 'package:url_launcher/url_launcher.dart';

class LoginUid extends StatefulWidget {
  @override
  State<LoginUid> createState() => _LoginUidState();
}

class _LoginUidState extends State<LoginUid> {

  TextEditingController _accountTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _crmTextController = TextEditingController();

  void launchCRM() async {
    final Uri url = Uri.parse('https://my.oxshare.com/register?referral=8811');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[900],
      body: ListView(
        children: [
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  widgets.InfoButton(context),
                  SizedBox(
                    height: 10,
                  ),
                  Icon(
                    Icons.account_circle,
                    color: Colors.amber[200],
                    size: 85,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                      width: 350,
                      child: EnterTextField(
                          'Enter e-mail',
                          Icons.account_circle,
                          false,
                          _accountTextController,
                          maxLines: 1,
                        inputAction: null,
                        inputType: null,
                      )
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                      width: 350,
                      child: EnterTextField(
                          'Enter password',
                          Icons.lock,
                          true,
                          _passwordTextController,
                        maxLines: 1,
                        inputAction: null,
                        inputType: null,
                      )
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ContinueButton('Verify', () async {

                    if (_accountTextController.text == '') {
                      FocusScope.of(context).unfocus();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Enter e-mail'),
                        ),
                      );
                    }
                    if (_passwordTextController.text == '') {
                        FocusScope.of(context).unfocus();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Enter password'),
                          ),
                        );
                    } else {
                      final DocumentReference document = FirebaseFirestore.instance.collection("Users").doc('Activity');
                      late dynamic data;
                      data = await document.get();
                      final _fire_base_messaging = FirebaseMessaging.instance;
                      await _fire_base_messaging.requestPermission();
                      String? fCMToken = await _fire_base_messaging.getToken();

                      FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: _accountTextController.text,
                          password: _passwordTextController.text).then((
                          value) async {
                        if (value != null) {
                          if (!data['users'].contains(FirebaseAuth.instance.currentUser!.uid)) {
                            FirebaseFirestore.instance.collection('Users').doc('Activity').update({
                              'users': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
                            });
                            FirebaseFirestore.instance.collection('Users').doc('Activity').update({
                              'tokens': FieldValue.arrayUnion([fCMToken]),
                            });
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.grey[900],
                                    title: Text(
                                      "Customer Relationship Management (CRM)",
                                      style: TextStyle(
                                          fontFamily: 'Oswald',
                                          color: Colors.amber[200],
                                          fontSize: 28
                                      ),
                                    ),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Text(
                                            "You are required to register into the OXshare CRM before proceeding. When done, please enter the E-mail address in the space below",
                                            style: TextStyle(
                                                fontFamily: 'Oswald',
                                                color: Colors.amber[200],
                                                fontSize: 15
                                            ),
                                          ),
                                          Text(
                                            "يجب عليك تسجيل الدخول في إدارة علاقات العملاء الخاص بنا قبل المتابعة. عند الانتهاء، يرجى إدخال عنوان البريد الإلكتروني في المساحة أدناه",
                                            style: TextStyle(
                                              fontFamily: 'Oswald',
                                              color: Colors.amber[200],
                                              fontSize: 15,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                          TextButton(
                                              onPressed: launchCRM,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Press for CRM registration link',
                                                    style: TextStyle(
                                                        fontFamily: 'Oswald',
                                                        color: Colors.blue,
                                                        fontSize: 15
                                                    ),
                                                  ),
                                                  Text(
                                                    'اضغط للحصول على رابط التسجيل',
                                                    style: TextStyle(
                                                        fontFamily: 'Oswald',
                                                        color: Colors.blue,
                                                        fontSize: 15
                                                    ),
                                                  ),
                                                ],
                                              )
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          widgets.EnterTextField("E-mail", Icons.account_circle_outlined, false, _crmTextController)
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text(
                                          "Continue",
                                          style: TextStyle(
                                              fontFamily: 'Oswald',
                                              color: Colors.amber[200],
                                              fontSize: 15
                                          ),
                                        ),
                                        onPressed: () {
                                          if (_crmTextController.text.isEmpty) {
                                            FocusScope.of(context).unfocus();
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Please fill in the empty space with your CRM E-mail.'),
                                              ),
                                            );
                                          }
                                          else if (!_crmTextController.text.contains('@')) {
                                            FocusScope.of(context).unfocus();
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Please enter a valid E-mail address.'),
                                              ),
                                            );
                                          }
                                          else if (!_crmTextController.text.contains('.')) {
                                            FocusScope.of(context).unfocus();
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Please enter a valid E-mail address.'),
                                              ),
                                            );
                                          }
                                          else {
                                            Future.delayed(Duration(seconds: 1), ()
                                            {
                                              Navigator.push(
                                                  context, MaterialPageRoute(
                                                  builder: (context) =>
                                                      Home(
                                                        uid: FirebaseAuth
                                                            .instance
                                                            .currentUser!.uid,
                                                      )));
                                            });
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                });
                          } else {
                            if (!data['tokens'].contains(fCMToken)) {
                              FocusScope.of(context).unfocus();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('User already in use'),
                                ),
                              );
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.grey[900],
                                      title: Text(
                                        "Customer Relationship Management (CRM)",
                                        style: TextStyle(
                                            fontFamily: 'Oswald',
                                            color: Colors.amber[200],
                                            fontSize: 28
                                        ),
                                      ),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Text(
                                              "You are required to register into the OXshare CRM before proceeding. When done, please enter the E-mail address in the space below",
                                              style: TextStyle(
                                                  fontFamily: 'Oswald',
                                                  color: Colors.amber[200],
                                                  fontSize: 15
                                              ),
                                            ),
                                            Text(
                                              "يجب عليك تسجيل الدخول في إدارة علاقات العملاء الخاص بنا قبل المتابعة. عند الانتهاء، يرجى إدخال عنوان البريد الإلكتروني في المساحة أدناه",
                                              style: TextStyle(
                                                  fontFamily: 'Oswald',
                                                  color: Colors.amber[200],
                                                  fontSize: 15,
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                            TextButton(
                                                onPressed: launchCRM,
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'Press for CRM registration link',
                                                      style: TextStyle(
                                                          fontFamily: 'Oswald',
                                                          color: Colors.blue,
                                                          fontSize: 15
                                                      ),
                                                    ),
                                                    Text(
                                                      'اضغط للحصول على رابط التسجيل',
                                                      style: TextStyle(
                                                          fontFamily: 'Oswald',
                                                          color: Colors.blue,
                                                          fontSize: 15
                                                      ),
                                                    ),
                                                  ],
                                                )
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            widgets.EnterTextField("E-mail", Icons.account_circle_outlined, false, _crmTextController)
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Text(
                                            "Continue",
                                            style: TextStyle(
                                              fontFamily: 'Oswald',
                                              color: Colors.amber[200],
                                              fontSize: 15
                                            ),
                                          ),
                                          onPressed: () {
                                            if (_crmTextController.text.isEmpty) {
                                              FocusScope.of(context).unfocus();
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Please fill in the empty space with your CRM E-mail.'),
                                                ),
                                              );
                                            }
                                            else if (!_crmTextController.text.contains('@')) {
                                              FocusScope.of(context).unfocus();
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Please enter a valid E-mail address.'),
                                                ),
                                              );
                                            }
                                            else if (!_crmTextController.text.contains('.')) {
                                              FocusScope.of(context).unfocus();
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Please enter a valid E-mail address.'),
                                                ),
                                              );
                                            }
                                            else {
                                              Future.delayed(Duration(seconds: 1), ()
                                              {
                                                Navigator.push(
                                                    context, MaterialPageRoute(
                                                    builder: (context) =>
                                                        Home(
                                                          uid: FirebaseAuth
                                                              .instance
                                                              .currentUser!.uid,
                                                        )));
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            }
                          }
                        }
                      }).onError((error, stackTrace) {
                        FocusScope.of(context).unfocus();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Payment due'),
                          ),
                        );
                      });
                    }
                  }),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                      'DISCLAIMER',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20
                    ),
                  ),
                  Text(
                    'تحذير',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 16
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'By using this app, you accept all of our terms and conditions. Abu Hadid does not account for any liability for any financial loss these markets could incur due to mismanagement, high risk appetite or economic and financial data release by different countries. Trading in the forex and indices market could be very lucrative. However, this trading could be equally highly risky and may involve a lot of financial loss. Only trade what you can afford to lose.',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.7,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          'باستخدام هذا التطبيق، فإنك توافق على جميع الشروط والأحكام الخاصة بنا. لا يتحمل أبو حديد أي مسؤولية عن أي خسارة مالية يمكن أن تتكبدها في هذه الأسواق بسبب سوء الإدارة أو ارتفاع الرغبة في المخاطر أو نشر البيانات الاقتصادية والمالية من قبل بلدان مختلفة. يمكن أن يكون التداول في سوق الفوركس والمؤشرات مربحًا للغاية. ومع ذلك، فإن هذا التداول يمكن أن يكون بنفس القدر من المخاطر وقد ينطوي على الكثير من الخسائر المالية. تداول فقط بما يمكنك تحمل خسارته',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.7,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}