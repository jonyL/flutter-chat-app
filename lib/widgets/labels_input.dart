import 'package:flutter/material.dart';
class Labels extends StatelessWidget {
  final String ruta;
  final String text;
  final String textLink;

  const Labels({super.key, required this.ruta, required this.text, required this.textLink}); 

  @override
  Widget build(BuildContext context) {

    

    return Container(
      child: Column(
        children: [
            Text(text, style: const TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w300),),
           const SizedBox(height: 10), 
          GestureDetector(
            onTap: (){
              Navigator.pushReplacementNamed(context, ruta);
            },
            child: Text(textLink, style: TextStyle(color: Colors.blue[600], fontSize: 18, fontWeight: FontWeight.bold),)
          ),
        ],
      ),
    );
  }
}
