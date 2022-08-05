import 'dart:io';

import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
   
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin{

  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _estaEscrbiendo = false;
  List<ChatMessage> _messages = [
   
  ];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      title: Column(
        children:  [
           CircleAvatar(
            backgroundColor: Colors.blue[100],
            maxRadius: 14,
            child: const Text('Te', style: TextStyle(fontSize: 12),),
          ), 
          const SizedBox(height: 3,), 
          const Text('Iancillo Palacios',  style: TextStyle(color: Colors.black87,  fontSize: 12))
        ],
      ),
      centerTitle: true,
      elevation: 1,
      ),
      
      body: Container(  
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (_, int i) => _messages[i],
                reverse: true,
              ),
            ), 
            const Divider(height: 1,),
            //TODO:Caja de texto
            Container( 
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      ),
      
    );
  }

  Widget _inputChat(){
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSummit,
                onChanged: (String texto){
                  setState(() {
                    texto.trim().length > 0
                       ? _estaEscrbiendo = true
                       :_estaEscrbiendo = false;
                    
                  });
                },
                decoration: const InputDecoration.collapsed(
                  hintText: 'Enviar mensaje'
                ),
                focusNode: _focusNode,
              )
            ), 

            //Botón de enviar
            Container(
              margin: const EdgeInsets.symmetric(horizontal : 4.0) ,
              child: Platform.isIOS
              ?CupertinoButton(onPressed: _estaEscrbiendo 
                    ? () => _handleSummit(_textController.text.trim())
                    : null, child: const Text('Enviar')
              )
              : Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: IconTheme(
                  data: IconThemeData(color:  Colors.blue[400]),
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: const Icon(Icons.send,),
                    onPressed: _estaEscrbiendo 
                    ? () => _handleSummit(_textController.text.trim())
                    : null
                  ),
                ),
              )
            )
          ],
        ),
      )
    );
  }

  _handleSummit(String texto){

    if(texto.isEmpty) return;
    
    _textController.clear();
    _focusNode.requestFocus();
    final newMessage =  ChatMessage(texto: texto, uid: '123', animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 400)),);
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _estaEscrbiendo = false;
    });
  }

  @override
  void dispose() {
    //TODO:Off del socket

    for(ChatMessage message in _messages) {
      message.animationController.dispose();
    }

    super.dispose();
  }
}