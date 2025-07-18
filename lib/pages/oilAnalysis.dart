import 'package:flutter/material.dart';
import '../chat/chat_service.dart';
import '../classes/Socket.dart';
import '../classes/widgets.dart';

class OilAnalysis extends StatefulWidget {
  final Socket socket;
  final String positivity;
  final String resistancePoints;
  final String supportPoints;
  const OilAnalysis({
    super.key,
    required this.socket,
    required this.positivity,
    required this.resistancePoints,
    required this.supportPoints,
  });

  @override
  State<OilAnalysis> createState() => _OilAnalysisState();
}

class _OilAnalysisState extends State<OilAnalysis> {

  final TextEditingController _AnalysisController = TextEditingController();
  final ChatService _chatService = ChatService();

  void sendSignal() async {
    if(_AnalysisController.text.isNotEmpty) {
      await _chatService.sendSignalToOil(
          widget.positivity,
          widget.resistancePoints,
          widget.supportPoints,
          _AnalysisController.text,
      );
      _AnalysisController.clear();
      Navigator.pop(context);

    }else ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please fill all fields.')
        )
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        shadowColor: Colors.white,
        backgroundColor: Colors.amber[200],
        title: Center(
          child: Text(
            'Analysis',
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

            Text(
              ': التحليل اليومي',
              style: TextStyle(
                  color: Colors.amber[200],
                  fontFamily: 'Oswald',
                  fontSize: 17
              ),
            ),
            SizedBox(
              width: 20,
              height: 20,
            ),
            _buildSignalInput(
                _AnalysisController,
                'ادخل التحليل اليومي',
                Icons.newspaper_outlined,
                TextInputType.multiline,
                TextInputAction.newline
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Add',
                  style: TextStyle(
                      color: Colors.amber[200],
                      fontFamily: 'Oswald',
                      fontSize: 17
                  ),
                ),

                FloatingActionButton(
                  onPressed: () {
                    sendSignal();
                    widget.socket.SendNotifi("Oil news");
                  },
                  mini: true,
                  child: Icon(
                    Icons.add,
                    color: Colors.grey[900],
                  ),
                  backgroundColor: Colors.amber[200],
                ),
              ],
            )
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