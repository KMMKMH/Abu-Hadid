import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Info extends StatefulWidget {

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {

  void launchURLNabatieh() async {
    final Uri url = Uri.parse('https://maps.app.goo.gl/Ujgkkkpp8FeJ2R7QA');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
  void launchURLBeirut() async {
    final Uri url = Uri.parse('https://maps.app.goo.gl/aTFsyBnDLTabqkqC9');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.grey[900],

        appBar: AppBar(
          title: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: [
                        Text(
                            'ABU HADID',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontFamily: 'Oswald',
                            )
                        ),
                      ],
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

      body: ListView(
        children: [
          Column(
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 110,
                      width: 75,
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/abuhadid.jpg'),
                      ),
                    ),
                    SizedBox(
                      width: 325,
                      child: Divider(
                        color: Colors.amber[200],
                      ),
                    ),
                    Text(
                      'ABOUT US',
                      style: TextStyle(
                          color: Colors.amber[200],
                        fontSize: 20,
                        fontFamily: 'Oswald'
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                      child: Text(
                          'Our company is one of the biggest retail brokerage firm in the Middle East. With over 2 decades of experience and commitment, we have brought our customers massive gain in the stock market business. For a fee as low as 50 dollars monthly, our customers get the best advice, price signals and alerts in all indices, metals and forex markets. In the brokerage field, we offer the lowest possible commissions.',
                        style: TextStyle(
                          color: Colors.amber[200],
                          fontFamily: 'Oswald',
                          fontSize: 12
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                      child: Text(
                          'شركتنا هي واحدة من أكبر الشركات في تجارة المؤشرات وأسهم المعادن في الشرق الأوسط. مع أكثر من عقدين من الخبرة والالتزام، حققنا لعملائنا مكاسب هائلة في أعمال أسواق الأسهم. مقابل رسوم منخفضة تصل إلى 50 دولارًا شهريًا، يحصل عملاؤنا على أفضل النصائح وإشارات الأسعار والتنبيهات في جميع المؤشرات والمعادن وأسواق الفوركس. وفي مجال الوساطة المالية، نقدم أقل العمولات الممكنة',
                        style: TextStyle(
                      color: Colors.amber[200],
                          fontFamily: 'Oswald',
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'CONTACT AND PAYMENT INFORMATION',
                      style: TextStyle(
                          color: Colors.amber[200],
                          fontSize: 18,
                          fontFamily: 'Oswald'
                      ),
                    ),
                    Text(
                      'معلومات التواصل و الدفع',
                      style: TextStyle(
                          color: Colors.amber[200],
                          fontSize: 16,
                          fontFamily: 'Oswald'
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Whish transfer :  00961 3 848 463",
                            style: TextStyle(
                                color: Colors.amber[200],
                                fontSize: 14,
                                fontFamily: 'Oswald'
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                              "Western union/OMT :  Ahmad Zainal Kadri  00961 71 124 300",
                            style: TextStyle(
                              color: Colors.amber[200],
                              fontSize: 14,
                              fontFamily: 'Oswald'
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                              "USDT Transfer TRC20 : TJ2nAyrRsHvqX9sr8St9wRdRLZWWMmqnM9",
                            style: TextStyle(
                              color: Colors.amber[200],
                              fontSize: 14,
                              fontFamily: 'Oswald'
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "PAY ID :  193748651",
                                    style: TextStyle(
                                      color: Colors.amber[200],
                                      fontSize: 14,
                                      fontFamily: 'Oswald'
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                      "PAY ID PHONE :  00961 70 052 274",
                                    style: TextStyle(
                                      color: Colors.amber[200],
                                      fontSize: 14,
                                      fontFamily: 'Oswald'
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Column(
                                children: [
                                  IconButton(
                                      onPressed: launchURLNabatieh,
                                      icon: Icon(
                                          Icons.location_on,
                                        color: Colors.red,
                                        size: 35,
                                      )
                                  ),
                                  Text(
                                    "Location Nabatieh",
                                    style: TextStyle(
                                        color: Colors.amber[200],
                                        fontSize: 10,
                                        fontFamily: 'Oswald'
                                    ),
                                  ),
                                ],
                              ),SizedBox(
                                width: 15,
                              ),
                              Column(
                                children: [
                                  IconButton(
                                      onPressed: launchURLBeirut,
                                      icon: Icon(
                                        Icons.location_on,
                                        color: Colors.red,
                                        size: 35,
                                      )
                                  ),
                                  Text(
                                    "Location Beirut",
                                    style: TextStyle(
                                        color: Colors.amber[200],
                                        fontSize: 10,
                                        fontFamily: 'Oswald'
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}