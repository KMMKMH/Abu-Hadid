import 'package:abu_hadid_app/pages/oilAnalysis.dart';
import 'package:flutter/material.dart';
import '../chat/chat_service.dart';
import '../classes/Socket.dart';
import '../classes/widgets.dart';

class OilSignal extends StatefulWidget {
  final Socket socket;
  const OilSignal({
    super.key,
    required this.socket,
  });

  @override
  State<OilSignal> createState() => _OilSignalState();
}

class _OilSignalState extends State<OilSignal> {

  final TextEditingController _resistancePointsController = TextEditingController();
  final TextEditingController _supportPointsController = TextEditingController();
  final List<String> list = <String>['ايجابي', 'سلبي'];

  String dropdownValue = 'ايجابي';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        shadowColor: Colors.white,
        backgroundColor: Colors.amber[200],
        title: Center(
          child: Text(
            'New Signal',
            style: TextStyle(
                color: Colors.grey[900],
                fontFamily: 'Oswald',
                fontSize: 30
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(11.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton(
                  value: dropdownValue,
                  style: const TextStyle(color: Colors.white),
                  dropdownColor: Colors.grey[900],
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  underline: Container(
                    height: 2,
                    color: Colors.amber[200],
                  ),
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  ': النفط',
                  style: TextStyle(
                      color: Colors.amber[200],
                      fontFamily: 'Oswald',
                      fontSize: 17
                  ),
                ),
              ],
            ),

            Text(
              ': نقاط الدعم',
              style: TextStyle(
                  color: Colors.amber[200],
                  fontFamily: 'Oswald',
                  fontSize: 17
              ),
            ),
            SizedBox(
              width: 20,
            ),
            _buildSignalInput(
                _supportPointsController,
                'ادخل نقاط الدعم',
                Icons.trending_up_outlined,
                TextInputType.text,
                TextInputAction.done
            ),

            Text(
              ': نقاط المقاومة',
              style: TextStyle(
                  color: Colors.amber[200],
                  fontFamily: 'Oswald',
                  fontSize: 17
              ),
            ),
            SizedBox(
              width: 20,
            ),
            _buildSignalInput(
                _resistancePointsController,
                'ادخل نقاط المقاومة',
                Icons.trending_down_outlined,
                TextInputType.text,
                TextInputAction.done
            ),

            Container(
              color: Colors.amber[200],
              height: 40,
              width: 200,
              child: TextButton(
                  onPressed: () {
                    if (_resistancePointsController.text.isNotEmpty && _supportPointsController.text.isNotEmpty) {
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) =>
                        OilAnalysis(
                          socket: widget.socket,
                          positivity: dropdownValue,
                          resistancePoints: _resistancePointsController.text,
                          supportPoints: _supportPointsController.text,
                        )));
                    }
                    else ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please fill all fields.')
                    )
                    );
                  },
                  child: Text(
                    '📰  ادخال التحليل اليومي',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[900]
                    ),
                  )
              ),
            ),

            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildSignalInput(TextEditingController controller, String text, IconData icon, TextInputType inputType, TextInputAction inputAction) {
    return Expanded(
        child: EnterTextField(
            text,
            icon,
            false,
            controller,
            Iconsize: 25,
            fontSize: 15,
            inputType: inputType,
            inputAction: inputAction
        )
    );
  }
}