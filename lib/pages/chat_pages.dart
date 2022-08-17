import 'dart:io';
import 'package:chat/pages/models/mensajes_response.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/widgets/chat_message.dart';

class ChatPage extends StatefulWidget {
   
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin{

  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  bool _estaEscrbiendo = false;
  List<ChatMessage> _messages = [];

  @override
  void initState() {
    
    super.initState();
    chatService   = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService   = Provider.of<AuthService>(context, listen: false);
    socketService.socket.on('mensaje-personal', _escucharMensaje);
    _cargarHistorial(chatService.usuarioPara.uid);
  }

  void _cargarHistorial(String usuarioID) async{
    List<Mensaje> chat = await chatService.getChat(usuarioID);
    final history = chat.map((m) => ChatMessage(
        texto: m.mensaje, 
        uid: m.de, 
        animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 0))..forward()
      ));

      setState(() {
        _messages.insertAll(0, history);
      });
  }

  void _escucharMensaje(dynamic payload) {
    
    if (payload['de'] != chatService.usuarioPara.uid &&
        payload['de'] != authService.usuario.uid) 
      return;
    
    ChatMessage message = ChatMessage(
      texto: payload['mensaje'], 
      uid: payload['de'], 
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 300) ));

      setState(() {
        _messages.insert(0, message);
      });

      message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    
    final usuarioPara = chatService.usuarioPara;
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      title: Column(
        children:  [
           CircleAvatar(
            backgroundColor: Colors.blue[100],
            maxRadius: 14,
            child:  Text(usuarioPara.nombre.substring(0,2), style: const TextStyle(fontSize: 12),),
          ), 
          const SizedBox(height: 3,), 
           Text(usuarioPara.nombre,  style: const TextStyle(color: Colors.black87,  fontSize: 12))
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
    final newMessage =  ChatMessage(
        texto: texto, 
        uid: authService.usuario.uid, 
        animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 400)),
      );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _estaEscrbiendo = false;
    });

    socketService.socket.emit('mensaje-personal', {
      'de' : authService.usuario.uid, 
      'para' :chatService.usuarioPara.uid,
      'mensaje' : texto
    });
  }

  @override
  void dispose() {
    
    //final socketService = Provider.of<SocketService>(context, listen : false);
    //socketService.disconnect();

    for(ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}