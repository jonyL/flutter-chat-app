import 'package:chat/global/environment.dart';
import 'package:chat/pages/models/usuarios.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../pages/models/mensajes_response.dart';

class ChatService with ChangeNotifier {
 late Usuario usuarioPara;

 Future<List<Mensaje>> getChat( String usuarioId) async{
  final resp = await http.get(Uri.parse('${Environment.apiUrl}/mensajes/$usuarioId'), 
  headers: {
    'Content-Type' : 'application/json',
    'x-token' : await AuthService.getToken() ?? ''
  }
  
  );

  final mensajesResp = mensajesResponseFromJson(resp.body);
  return mensajesResp.mensajes;
 }
}