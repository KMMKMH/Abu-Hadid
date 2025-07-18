import 'package:flutter/material.dart';


TextField EnterTextField(String text, IconData icon, bool isPassword, TextEditingController controller, {
  int? maxLines = null,
  TextInputAction? inputAction = TextInputAction.newline,
  TextInputType? inputType = TextInputType.multiline,
  double Iconsize = 40,
  double fontSize = 30
}) {
  return TextField(
    textInputAction: inputAction,
    keyboardType: inputType,
    maxLines: maxLines,
    controller: controller,
    obscureText: isPassword,
    enableSuggestions: false,
    autocorrect: false,
    cursorColor: Colors.black.withOpacity(0.5),
    decoration: InputDecoration(
      prefixIcon: Padding(
        padding: EdgeInsets.all(15),
        child: Icon(
          icon,
          color: Colors.black.withOpacity(0.5),
          size: Iconsize,
        ),
      ),
      labelText: text,
      labelStyle: TextStyle(
        fontFamily: 'Oswald',
        fontSize: fontSize,
        color: Colors.black.withOpacity(0.5),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none
        ),
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.8),
      floatingLabelBehavior: FloatingLabelBehavior.never,
    ),
  );
}

SizedBox ContinueButton(String text, Function onPressed) {
  return SizedBox(
    height: 70,
    child: TextButton(
      onPressed: () {
        onPressed();
      },
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.amber[200]),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 30,
            color: Colors.grey[900],
            fontFamily: 'Oswald'
        ),
      ),
    ),
  );
}

Row ErrorHandler (String text) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text(
        text,
        style: TextStyle(
          fontFamily: 'Oswald',
          color: Colors.red,
          fontSize: 20
        ),
      ),
    ]
  );
}

Widget InfoButton(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      IconButton(
        onPressed: () {
          Navigator.pushNamed(context, '/info');
        },
        icon: Icon(
          Icons.info_outline,
          color: Colors.amber[200],
          size: 35,
        ),
      ),
      Column(
        children: [
          Column(
            children: [
              Text(
                  'Press for payment methods',
                  style: TextStyle(
                    color: Colors.amber[200],
                    fontSize: 12,
                    fontFamily: 'Oswald',
                  )
              ),SizedBox(
                width: 20,
              ),
              Text(
                  'اضغط لمعرفة كيفية الدفع',
                  style: TextStyle(
                    color: Colors.amber[200],
                    fontSize: 12,
                    fontFamily: 'Oswald',
                  )
              ),
            ],
          ),
        ],
      ),
    ],
  );
}


Widget HomeInfoButton(BuildContext context) {
  return IconButton(
    onPressed: () {
      Navigator.pushNamed(context, '/info');
    },
    icon: Icon(
      Icons.info_outline,
      color: Colors.grey[900],
      size: 20,
    ),
  );
}


class LikeButton extends StatelessWidget {
  final bool isLiked;
  void Function()? onTap;
  LikeButton({super.key, required this.isLiked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Colors.red : Colors.grey,
      ),
    );
  }
}
