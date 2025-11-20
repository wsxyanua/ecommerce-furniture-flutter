import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final void Function() onPressed;
  final String name;
  MyButton({required this.name, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: double.infinity,
      child: ElevatedButton(
        child: Text(
          name,
          style: TextStyle(color: Colors.white),
        ),
        // style: ButtonStyle(
        //   backgroundColor: Color(0xff746bc9),
        // ),
        style: ElevatedButton.styleFrom(
          primary: Colors.black, // Background color
        ),
        onPressed: onPressed,
      ),
    );
  }
}
