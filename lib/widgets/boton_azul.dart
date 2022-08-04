import 'package:flutter/material.dart';
class BotonAzul extends StatelessWidget {
  final Function() onPress;
  final String text;
  const BotonAzul({Key? key, required this.onPress, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return     ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 2,
              shape: StadiumBorder(),
              primary: Colors.blue
            ),
            onPressed: onPress,            
            child: Container(
              width: double.infinity,
              height: 55,
              child:  Center(
                child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 17),)
              ),
            )
            
          );
  }
}